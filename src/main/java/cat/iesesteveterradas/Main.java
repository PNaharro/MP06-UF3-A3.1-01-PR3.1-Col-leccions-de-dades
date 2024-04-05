package cat.iesesteveterradas;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.basex.api.client.ClientSession;
import org.basex.core.BaseXException;
import org.basex.core.cmd.Open;
import org.basex.core.cmd.XQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws IOException {
        // Initialize connection details
        String host = "127.0.0.1";
        int port = 1984;
        String username = "admin"; // Default username
        String password = "admin"; // Default passwordz

        // Establish a connection to the BaseX server
        try (ClientSession session = new ClientSession(host, port, username, password)) {
            logger.info("Connected to BaseX server.");

            File inputDir = new File("./data/input");
            File outputDir = new File("./data/output");
            
            if (!outputDir.exists()) {
                outputDir.mkdirs();
            }
            logger.info("directorios ok");
            File[] queryFiles = inputDir.listFiles((dir, name) -> name.endsWith(".xq"));
            
            for (File queryFile : queryFiles) {
                logger.info(queryFile.toString());
            }
    
            if (queryFiles != null) {
                logger.info("queryFiles ok");
                for (File queryFile : queryFiles) {
                    session.execute(new Open("Posts"));
                    String query = readQueryFromFile(queryFile);

                    // Execute the query
                    String result = session.execute(new XQuery(query));
                    logger.info("Query Result:");
                    logger.info(result);

                    // Save the result to a file
                    String outputFileName = queryFile.getName().replace(".xquery", ".xml");
                    saveResultToFile(result, outputDir, outputFileName);

                    logger.info("Query result saved to file: {}", outputFileName);

                    logger.info("-----------------------------------------------");

                    // Cierra la sesión después de cada consulta

                }
            }
            session.close();
        } catch (BaseXException e) {
            logger.error("Error connecting or executing the query: " + e.getMessage());
        } catch (IOException e) {
            logger.error(e.getMessage());
        }
    }

    private static String readQueryFromFile(File file) throws IOException {
        StringBuilder query = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                query.append(line).append("\n");
            }
        }
        return query.toString();
    }

    private static void saveResultToFile(String result, File outputDir, String filename) throws IOException {
        File outputFile = new File(outputDir, filename);
        try (FileWriter writer = new FileWriter(outputFile)) {
            writer.write(result);
        }
    }
}