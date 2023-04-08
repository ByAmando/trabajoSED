# trabajoSED
Diseño en VHDL de un motor por pasos de un satélite
Instrucciones de ejecucion de los testBench al final

#**Antirebotes**
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
El módulo motor se encarga de controlar las veces que vamos a repetir el ciclo de estados dado y la dirección de los motores. 

#**Sistema**
El módulo sistema es el componente principal del proyecto. Se encarga de coordinar y controlar todos los demás módulos.



**INSTRUCCIONES TESTBENCH**
-1.Poner cada tets bench con su fichero correspondiente en el modulo correspondiente.
-2.Abrir un workspace.
3)Añadir el test bench a ese workspace, click izq y add files
4)Click en COMPILE ALL
5)Luego te vas a simulate y seleccionas SELECT TOP LEVEL
6)De todas las opciones tienes que coger el que tiene el nombre de la entidad vacia de tu fichero testBench y que tiene un simbolito "e" en rojo.
7)Le das de nuevo a simulate y a Restart
8)Te vas a la practica 1 y ahi sale como añadir las formas de onda y blabla que ya me cansé de explicar.
