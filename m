Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157176A9B4B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCCQBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 11:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCCQBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 11:01:54 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C8610437
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 08:01:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a2so3145419plm.4
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 08:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677859311;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=L3pHb5NYzDhDC3DL4wCN/+591lxA8YVS0mVasDq7Pj0=;
        b=h9UOqMqInpvno9hynwADMYs51psIGO9ZsgMkWxM99MQLUHdN5Z6dyyc0Ng3X4YZJO0
         9fLFF/vbQTJDiEAvDROAGZDXE8I244m2rLOArKgMAWZv06f2OvRywXaTUDPrvoD3dleF
         doPy8bHxhL13TuL7fq4oBPUlq8iuuXjkrKSIIcol40nCK0RUUrM8C9hGZFdPtAhXa+6C
         hrpZbFgIHdtWMYzaCo/T7JZOY/c3Upx7nOmNHIJY9HYM/AykhhvCsv3RrFdSGuV9gBBV
         se+kpERajOnxDpV5YOMvj3fnBkcy9fnBSE/KnB7CA4niU+z1f5VyBg0TMlQcQ7XtYfku
         g19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677859311;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L3pHb5NYzDhDC3DL4wCN/+591lxA8YVS0mVasDq7Pj0=;
        b=Y+V0Sgu+5NJS49+M62xZRWikDPArGeFOwxNEzWy/4ttBbiUE3ef4savYENMhNCfuyF
         TdxOzttb4iLiIDA50q0EIBw41WkXf35JF8ycY6HZIyHeFcZHhi00G/MxShWMACiW4iR8
         TiCGJUp95RNcYC4LyxOahJFEKEALYzxwi5ooPpimRLIhPkYKDWoVqBE/aQruKecftZyM
         exsb1ffWMnQmXGwN96EuJFNTcxy2mpTs8FSL+dNoL3vj86fHj9y5UckBX6I2Tp9u19Cj
         qN0ypPjD6q4QBvWuGnBocszQtPdt+9xkr/tA+r+FX4m0UJH2GcmBaomXZ7eMu9D6xsoo
         kQ+w==
X-Gm-Message-State: AO0yUKX5bQHl99uwY9k/Ue42qHRboMv47fXfyb1HwFQq2I2ZUbo024Rw
        kQTwRnHBqlAgfLVtYsC6lfEjntQLj23omQKC92og1g==
X-Google-Smtp-Source: AK7set8STTOG1j1SzHQGVyTH7tcu4CjNHmYiSgH+ACDnNpqBe/Uc0JrN1wWjx7zyzJoTka62+20LAw==
X-Received: by 2002:a17:902:f7cb:b0:19c:ba57:a869 with SMTP id h11-20020a170902f7cb00b0019cba57a869mr2190886plw.13.1677859310836;
        Fri, 03 Mar 2023 08:01:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jz6-20020a170903430600b0019ab3308554sm1692948plb.85.2023.03.03.08.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 08:01:50 -0800 (PST)
Message-ID: <640219ee.170a0220.ef48e.366a@mx.google.com>
Date:   Fri, 03 Mar 2023 08:01:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.97
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 249 runs, 16 regressions (v5.15.97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 249 runs, 16 regressions (v5.15.97)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
am57xx-beagle-x15      | arm    | lab-linaro-lkft | gcc-10   | multi_v7_def=
config+kselftest | 1          =

cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

fsl-lx2160a-rdb        | arm64  | lab-nxp         | gcc-10   | defconfig   =
                 | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

mt8173-elm-hana        | arm64  | lab-collabora   | gcc-10   | defconfig+ar=
m...ok+kselftest | 1          =

qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.97/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bf7123dd26a00e222221696efb95b14c2875607c =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
am57xx-beagle-x15      | arm    | lab-linaro-lkft | gcc-10   | multi_v7_def=
config+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/6401ea03c7f44ef5c68c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig+kselftest
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig+kselftest/gcc-10/lab-linaro-lkft/baseline-am57xx-beag=
le-x15.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig+kselftest/gcc-10/lab-linaro-lkft/baseline-am57xx-beag=
le-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401ea03c7f44ef5c68c8=
638
        failing since 8 days (last pass: v5.15.94, first fail: v5.15.95) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e84769394b55ef8c86e4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401e84769394b55ef8c86ed
        failing since 43 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-03-03T12:29:26.957513  + set +x<8>[   10.037815] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3381068_1.5.2.4.1>
    2023-03-03T12:29:26.957809  =

    2023-03-03T12:29:27.064626  / # #
    2023-03-03T12:29:27.166232  export SHELL=3D/bin/sh
    2023-03-03T12:29:27.166643  #
    2023-03-03T12:29:27.267881  / # export SHELL=3D/bin/sh. /lava-3381068/e=
nvironment
    2023-03-03T12:29:27.268321  =

    2023-03-03T12:29:27.369707  / # . /lava-3381068/environment/lava-338106=
8/bin/lava-test-runner /lava-3381068/1
    2023-03-03T12:29:27.370241  =

    2023-03-03T12:29:27.370382  / # /lava-3381068/bin/lava-test-runner /lav=
a-3381068/1<3>[   10.433981] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
fsl-lx2160a-rdb        | arm64  | lab-nxp         | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e8e8ec292ef34b8c867f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401e8e8ec292ef34b8c8686
        new failure (last pass: v5.15.79)

    2023-03-03T12:32:05.711711  [   14.492860] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1163224_1.5.2.4.1>
    2023-03-03T12:32:05.817306  / # #
    2023-03-03T12:32:05.918979  export SHELL=3D/bin/sh
    2023-03-03T12:32:05.919537  #
    2023-03-03T12:32:06.020928  / # export SHELL=3D/bin/sh. /lava-1163224/e=
nvironment
    2023-03-03T12:32:06.021439  =

    2023-03-03T12:32:06.122834  / # . /lava-1163224/environment/lava-116322=
4/bin/lava-test-runner /lava-1163224/1
    2023-03-03T12:32:06.123592  =

    2023-03-03T12:32:06.125476  / # /lava-1163224/bin/lava-test-runner /lav=
a-1163224/1
    2023-03-03T12:32:06.143288  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e8aa876b8328c68c8652

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401e8aa876b8328c68c865b
        failing since 30 days (last pass: v5.15.81, first fail: v5.15.91)

    2023-03-03T12:31:13.855281  + set +x
    2023-03-03T12:31:13.855458  [    9.428414] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914039_1.5.2.3.1>
    2023-03-03T12:31:13.963162  / # #
    2023-03-03T12:31:14.064755  export SHELL=3D/bin/sh
    2023-03-03T12:31:14.065208  #
    2023-03-03T12:31:14.171146  / # export SHELL=3D/bin/sh. /lava-914039/en=
vironment
    2023-03-03T12:31:14.172639  =

    2023-03-03T12:31:14.274596  / # . /lava-914039/environment/lava-914039/=
bin/lava-test-runner /lava-914039/1
    2023-03-03T12:31:14.275271  =

    2023-03-03T12:31:14.277691  / # /lava-914039/bin/lava-test-runner /lava=
-914039/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e90dba678ba9458c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401e90dba678ba9458c8638
        new failure (last pass: v5.15.79)

    2023-03-03T12:32:51.827476  + set +x
    2023-03-03T12:32:51.827677  [   18.535874] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914040_1.5.2.3.1>
    2023-03-03T12:32:51.936044  / # #
    2023-03-03T12:32:52.037535  export SHELL=3D/bin/sh
    2023-03-03T12:32:52.037884  #
    2023-03-03T12:32:52.139104  / # export SHELL=3D/bin/sh. /lava-914040/en=
vironment
    2023-03-03T12:32:52.139502  =

    2023-03-03T12:32:52.241016  / # . /lava-914040/environment/lava-914040/=
bin/lava-test-runner /lava-914040/1
    2023-03-03T12:32:52.241565  =

    2023-03-03T12:32:52.245353  / # /lava-914040/bin/lava-test-runner /lava=
-914040/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
mt8173-elm-hana        | arm64  | lab-collabora   | gcc-10   | defconfig+ar=
m...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e77a550123245b8c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e77a550123245b8c8=
643
        failing since 38 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e95c88c9cf532e8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/i=
386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/i=
386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e95c88c9cf532e8c8=
637
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e9ee4cfc0696f68c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/i=
386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/i=
386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e9ee4cfc0696f68c8=
630
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e610138664e6ec8c8661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e610138664e6ec8c8=
662
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e69d8dd68e268d8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e69d8dd68e268d8c8=
630
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e62d912ad3b7748c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e62d912ad3b7748c8=
642
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e73130ea0dd0568c865b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e73130ea0dd0568c8=
65c
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e60f524104ef608c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e60f524104ef608c8=
632
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e69bfd317607bf8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e69bfd317607bf8c8=
630
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e61994e0595ec48c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e61994e0595ec48c8=
63d
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6401e71e30ea0dd0568c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.97/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401e71e30ea0dd0568c8=
63e
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =20
