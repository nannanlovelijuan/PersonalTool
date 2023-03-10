import ru.yandex.clickhouse.ClickHouseConnectionImpl;
import ru.yandex.clickhouse.ClickHouseDataSource;
import ru.yandex.clickhouse.settings.ClickHouseProperties;

import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {

        try {
            System.out.println(getConn("1"));
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public static ClickHouseConnectionImpl getConn(String brandId) throws SQLException {

        String jdbcUrl = "jdbc:clickhouse://192.168.12.46:8082/ezp_crm";
        ClickHouseProperties properties = new ClickHouseProperties();
        properties.setUser("");
        properties.setPassword("");
        properties.setKeepAliveTimeout(10000);
        properties.setEzrCkToken("6295e8594ddd4518bbee685b6de7df9a");
        properties.setApacheBufferSize(2 * 1024 * 1024); // 10M,默认64kb
        properties.setBufferSize(2 * 1024 * 1024);
        properties.setMaxCompressBufferSize(2 * 1024 * 1024);
        properties.setMaxTotal(100000);//10 万条
        //properties.setDatabase("ezp_crm");
        ClickHouseConnectionImpl connection = null;
        properties.setEzrBrandId(brandId);
        ClickHouseDataSource dataSource = new ClickHouseDataSource(jdbcUrl, properties);
        connection = (ClickHouseConnectionImpl) dataSource.getConnection();
//            map.put(brandId, connection);

        return connection;
    }
}
