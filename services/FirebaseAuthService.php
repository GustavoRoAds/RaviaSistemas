<?php
class FirebaseAuthService
{
    private string $apiKey;

    public function __construct(string $apiKey)
    {
        $this->apiKey = $apiKey;
    }

    // Confere e-mail e senha no Firebase
    public function login(string $email, string $senha): array
    {
        $url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key='
             . $this->apiKey;

        return $this->enviar($url, 'application/json', json_encode([
            'email'             => $email,
            'password'          => $senha,
            'returnSecureToken' => true,
        ]));
    }

    // Troca o refreshToken por um idToken novo
    public function renovar(string $refreshToken): array
    {
        $url = 'https://securetoken.googleapis.com/v1/token?key=' . $this->apiKey;

        return $this->enviar($url, 'application/x-www-form-urlencoded', http_build_query([
            'grant_type'    => 'refresh_token',
            'refresh_token' => $refreshToken,
        ]));
    }

    private function enviar(string $url, string $contentType, string $corpo): array
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_POST           => true,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER     => ['Content-Type: ' . $contentType],
            CURLOPT_POSTFIELDS     => $corpo,
        ]);

        $resposta = curl_exec($ch);
        $status   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $erroCurl = curl_error($ch);
        curl_close($ch);

        if ($resposta === false) {
            return ['ok' => false, 'erro' => 'Falha de conexão: ' . $erroCurl];
        }

        $dados = json_decode($resposta, true);

        if ($status !== 200) {
            // ex.: INVALID_LOGIN_CREDENTIALS, USER_DISABLED, TOKEN_EXPIRED
            return ['ok' => false, 'erro' => $dados['error']['message'] ?? 'Erro desconhecido'];
        }

        return ['ok' => true, 'dados' => $dados];
    }
}