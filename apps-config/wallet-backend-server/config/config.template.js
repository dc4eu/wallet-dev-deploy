exports.config = {
	url: "http://localhost:8002",
	port: "8002",
	appSecret: "öoisuhdhayuhgwyugus",
	ssl: "false",
	db: {
		host: "wallet-backend-db",
		port: "3306",
		username: "wallet",
		password: "wallet",
		dbname: "wallet"
	},
	walletClientUrl: "http://localhost:3000/cb",
	webauthn: {
		attestation: "direct",
		origin: "http://localhost:3000",
		rp: {
			id: "localhost",
			name: "wwWallet demo",
		},
	},
	alg: "EdDSA",
	notifications: {
		enabled: false,
		serviceAccount: "firebaseConfig.json"
	}
}
