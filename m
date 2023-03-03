Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED16F6AA107
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjCCVW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjCCVWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:22:25 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E215113D0
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 13:22:22 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i10so4102569plr.9
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 13:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677878542;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=67v6GjXMwmJpsZtw7JRAUletxl9w0FZYgdEYYxT6ApI=;
        b=U6Ih+cXTSLO6aJd/MA77bcMEZT/fr2vDsH+mjPeCiNDUMHGTbose+cGGKYuKy2WVtW
         nC5qJ/gQz8zrZjkOq+dHYEueBlDZVbqXnoRKqiw84GQD7JrDfVhBUpDkbiw4RiKlqWRN
         ZRR8CLqBJVVQkMiVBpiRzRsD1djBRlKSOolsf5l8qRlcQzKbxMiJRuMi+kgj8MC/UHb7
         6yAc+fp39JhcWLRlAMPbZ3yURRG9q5Dj/WhFeRfYOzZHr3GR6fKrWZkP68kbqCy5+mzC
         eYLJyPWxe7XoEsmkQwSWuLwmIaZg6o4byhIAlQeS4x06xAtF1N5o2iB6/H8LdgRJOn1w
         S7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677878542;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67v6GjXMwmJpsZtw7JRAUletxl9w0FZYgdEYYxT6ApI=;
        b=37tqvCmXgaM889hfR47qQUocQzvcI1OPum6HHdAD/F3mLxfyurDNoroY6HsTehnXKf
         qYrpIffLR2s1d8EVptwyEDyo3ST1jKwOR5M+IpBX+yJNTmQdweUFWhCro867r4Huvdr+
         gklct6fU/8rfB6w0AxjnuSkYlnMzMNavxH1oMhZm9gGaTcW8HHR0saYQTbSPq0ZxzNbe
         3G9qTeQ73UPnSgJ9+ZEnNbmSogMADvuY5YVeO9PVwooRslCjg2xVN+sFfQGJw2Hwt24/
         8Rm6IGQlb2xZ4Lt/OO3tkx/H72/kVZVZ7olz578Z1j3Es/25WHul8iOsOKLA5mxla4CV
         pjhA==
X-Gm-Message-State: AO0yUKWZpP8V4md/ivgJOpshOZcEqG/TCj8coes4GEWgrlS5V8uYj1N3
        txaNayDxupfC7vRG9PMLhlTcmPE3Iy4kO5U9Am4EPNlw
X-Google-Smtp-Source: AK7set+A8hkcpsyRZdQ1CbQ8vRU6mie4tIDiEU23xuun03InDdmltwtD8niMZyk8PbOOLZwuUwB5bw==
X-Received: by 2002:a05:6a21:3396:b0:cb:b92c:b46e with SMTP id yy22-20020a056a21339600b000cbb92cb46emr2849109pzb.9.1677878541600;
        Fri, 03 Mar 2023 13:22:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1-20020aa78d01000000b005d663989ccfsm2004596pfe.200.2023.03.03.13.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:22:21 -0800 (PST)
Message-ID: <6402650d.a70a0220.927e5.4cae@mx.google.com>
Date:   Fri, 03 Mar 2023 13:22:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.98
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 247 runs, 16 regressions (v5.15.98)
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

stable/linux-5.15.y baseline: 247 runs, 16 regressions (v5.15.98)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

fsl-lx2160a-rdb        | arm64  | lab-nxp         | gcc-10   | defconfig   =
                 | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
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

qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
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
/v5.15.98/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d9b4a0c83a2d405dd85bf32d672686146b9bedff =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/6402329cde84e51f188c8646

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402329cde84e51f188c864f
        failing since 43 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-03-03T17:46:36.640243  + set +x<8>[   10.053776] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3382243_1.5.2.4.1>
    2023-03-03T17:46:36.641019  =

    2023-03-03T17:46:36.755426  / # #
    2023-03-03T17:46:36.858404  export SHELL=3D/bin/sh
    2023-03-03T17:46:36.859368  #
    2023-03-03T17:46:36.961546  / # export SHELL=3D/bin/sh. /lava-3382243/e=
nvironment
    2023-03-03T17:46:36.962972  =

    2023-03-03T17:46:36.963613  / # . /lava-3382243/environment<3>[   10.35=
3746] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-03T17:46:37.065816  /lava-3382243/bin/lava-test-runner /lava-33=
82243/1
    2023-03-03T17:46:37.067439   =

    ... (13 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
fsl-lx2160a-rdb        | arm64  | lab-nxp         | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/640233511f7d3023e38c864b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640233511f7d3023e38c8652
        failing since 0 day (last pass: v5.15.79, first fail: v5.15.97)

    2023-03-03T17:48:51.046065  [    9.924424] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1163544_1.5.2.4.1>
    2023-03-03T17:48:51.149621  / # #
    2023-03-03T17:48:51.250773  export SHELL=3D/bin/sh
    2023-03-03T17:48:51.251165  #
    2023-03-03T17:48:51.352179  / # export SHELL=3D/bin/sh. /lava-1163544/e=
nvironment
    2023-03-03T17:48:51.352434  =

    2023-03-03T17:48:51.453458  / # . /lava-1163544/environment/lava-116354=
4/bin/lava-test-runner /lava-1163544/1
    2023-03-03T17:48:51.453961  =

    2023-03-03T17:48:51.455734  / # /lava-1163544/bin/lava-test-runner /lav=
a-1163544/1
    2023-03-03T17:48:51.473403  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/64023274f9818acb7a8c865b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64023274f9818acb7a8c8664
        failing since 30 days (last pass: v5.15.81, first fail: v5.15.91)

    2023-03-03T17:46:02.404887  + set +x
    2023-03-03T17:46:02.405050  [    9.391932] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914579_1.5.2.3.1>
    2023-03-03T17:46:02.512708  / # #
    2023-03-03T17:46:02.614369  export SHELL=3D/bin/sh
    2023-03-03T17:46:02.614947  #
    2023-03-03T17:46:02.716229  / # export SHELL=3D/bin/sh. /lava-914579/en=
vironment
    2023-03-03T17:46:02.716864  =

    2023-03-03T17:46:02.818217  / # . /lava-914579/environment/lava-914579/=
bin/lava-test-runner /lava-914579/1
    2023-03-03T17:46:02.819096  =

    2023-03-03T17:46:02.821239  / # /lava-914579/bin/lava-test-runner /lava=
-914579/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
mt8173-elm-hana        | arm64  | lab-collabora   | gcc-10   | defconfig+ar=
m...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640236344bf9062c468c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640236344bf9062c468c8=
65d
        failing since 38 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/64022db0739e8085a58c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/i=
386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/i=
386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64022db0739e8085a58c8=
651
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/64022fe59c6a99a1878c86d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/i=
386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/i=
386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64022fe59c6a99a1878c8=
6d1
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64022e14e9dcf2f0268c86a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64022e14e9dcf2f0268c8=
6a8
        failing since 6 days (last pass: v5.15.93, first fail: v5.15.96) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640230ad8a197227f28c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640230ad8a197227f28c8=
631
        failing since 16 days (last pass: v5.15.92, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640230210cae12e6958c8688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640230210cae12e6958c8=
689
        failing since 6 days (last pass: v5.15.93, first fail: v5.15.96) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640231c5f7108b46928c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640231c5f7108b46928c8=
640
        failing since 16 days (last pass: v5.15.92, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64022e0045bb5cc73d8c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64022e0045bb5cc73d8c8=
63c
        failing since 6 days (last pass: v5.15.93, first fail: v5.15.96) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640230a99092fefa108c8671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640230a99092fefa108c8=
672
        failing since 16 days (last pass: v5.15.92, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64022e1545bb5cc73d8c866f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64022e1545bb5cc73d8c8=
670
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640230bd811439d8278c86ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640230bd811439d8278c8=
6ef
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640230354f1505daa08c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640230354f1505daa08c8=
646
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640231b16df0e667fb8c8673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.98/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640231b16df0e667fb8c8=
674
        failing since 16 days (last pass: v5.15.93, first fail: v5.15.94) =

 =20
