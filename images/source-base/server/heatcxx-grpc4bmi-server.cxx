#include "bmi_heat.hxx"
#include "bmi_grpc_server.h"


int main(int argc, char *argv[])
{
    printf("BmiHeat C++ grpc4bmi server\n");

    BmiHeat* model = new BmiHeat();

    {
        std::string model_name;
        model_name = model->GetComponentName();
        printf("%s\n", model_name.c_str());
    }

    run_bmi_server(model, argc, argv);

    delete model;
    return 0;
}
