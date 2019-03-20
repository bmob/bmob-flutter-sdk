package cn.bmob.data;

import android.content.Context;
import android.os.Bundle;
import android.widget.Toast;

import cn.bmob.data.util.InstallationUtils;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * @author zhangchaozhou
 */
public class MainActivity extends FlutterActivity {

    /**
     * TODO 1、新增、删除或修改原生方法的时候，需要重启应用才能使得flutter正常调用原生方法，否则会因为缓存问题导致调用失败。
     */
    private Context mContext;
    private static final String GET_INSTALLATION_ID = "getInstallationId";
    private static final String TOAST = "showToast";
    private String CHANNEL = "bmob.plugin";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        GeneratedPluginRegistrant.registerWith(this);


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                String method = call.method;
                switch (method) {
                    //获取installation id
                    case GET_INSTALLATION_ID:
                        String installationId = InstallationUtils.getInstallationId(mContext);
                        result.success(installationId);
                        break;
                    //弹出 toast
                    case TOAST:
                        String msg = call.argument("msg");
                        Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            }
        });
    }


}
