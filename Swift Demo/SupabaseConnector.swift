
import PowerSync
import Auth
import Supabase
import Foundation

final class SupabaseConnector: PowerSyncBackendConnectorProtocol {
    let client: SupabaseClient = .init(
        supabaseURL: URL(string: "https://herrcokrmtfwrudwkdhg.supabase.co")!,
        supabaseKey: "sb_publishable_eWTU62qEJ7zAMZ_wnboc2Q_-TGqyjXe",
    )
    
    func fetchCredentials() async throws -> PowerSync.PowerSyncCredentials? {
        let session = try await getSession()
        
        return PowerSyncCredentials(
            endpoint: "https://68b893a672d76488dd97fbce.powersync.journeyapps.com",
            token: session.accessToken
        )
    }
    
    func uploadData(database: any PowerSync.PowerSyncDatabaseProtocol) async throws {
        /// This will be implemented later
    }
    
    private func getSession() async throws -> Session {
        // Use an existing session if present, or signing anonymously
        guard let session = try? await client.auth.session else {
            return try await client.auth.signInAnonymously()
        }
        return session
    }

}
