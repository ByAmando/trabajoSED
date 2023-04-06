# trabajoSED
Diseño en VHDL de un motor por pasos de un satélite

#Antirebotes
El módulo antirebotes se encarga de prevenir los rebotes en los pulsadores. Utiliza un algoritmo basado en temporizadores para garantizar que las pulsaciones se registren correctamente.

#**Divisor de frecuencia**
El módulo divisor_frecuencia es responsable de dividir la frecuencia de una señal de entrada. Se utiliza principalmente para reducir la velocidad de los motores y otros dispositivos que necesitan una frecuencia de entrada más baja que la señal original.

#**FIFO**
El módulo fifo es una cola de datos que se utiliza para gestionar los datos que se van a escribir o leer en un dispositivo. Se utiliza para garantizar que los datos se escriban y se lean en el orden correcto.

#**Gestión de escritura**
El módulo gestion_escribir se encarga de gestionar la escritura de datos en un dispositivo. Utiliza un protocolo de comunicación específico para garantizar que los datos se escriban correctamente.

#**Gestión de lectura**
El módulo gestion_lectura se encarga de gestionar la lectura de datos de un dispositivo. Utiliza un protocolo de comunicación específico para garantizar que los datos se lean correctamente.

#**Motor**
El módulo motor se encarga de controlar la velocidad y la dirección de los motores. Utiliza un sistema de retroalimentación para garantizar que los motores se muevan en la dirección y a la velocidad correctas.

#**Sistema**
El módulo sistema es el componente principal del proyecto. Se encarga de coordinar y controlar todos los demás módulos. Utiliza un sistema de eventos para garantizar que todos los módulos se ejecuten en el orden correcto.
