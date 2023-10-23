<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <title>СЕРВЕРЫ :: ДСК-СТОЛИЦА</title>
</head>
<body>

    <main class="main">
        <div class="container">

            <section class="header">
                <div class="header__title">СЕРВЕРЫ :: ДСК-Столица</div>
            </section>

            <section class="servers">
                <?php
                    $file_path = '../server_status.txt';

                    $prev = '';

                    while(true){
                        $s = file_get_contents($file_path);
                        if ($s != $prev){
                            echo $s;
                        }
                        sleep(5);
                    }

                ?>
            </section>

        </div>
    </main>
    
</body>
</html>