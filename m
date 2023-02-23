Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5106A1184
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 21:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjBWUxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 15:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBWUxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 15:53:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011954C32
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 12:52:56 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i10so5622289plr.9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 12:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LWtsxrbCmbkPO9VIpU7R3L7RTd+dV3THhXSkC0hLUbs=;
        b=j9MB/C1EOhB4XXoAASfLGXFN1n7bGEw3iAMvhaKfojwIYWz9tYDxgw4cduFzJnqGWq
         MAbpf+PPTi2HO6GadgR7p9xNfrt3KGde3gCosan+6CLOd3fW3oBSwDMxJjlCfXFy+rzH
         RZJbZ3ezMq4F17yC5QP6gjleoFhGgOkhKckPBGvByFHihCnWJL2qclKyy/cnFtShwysH
         dJEUFHp7Va7nG3y8EI3ewBoRRBf3wxcJkRS37xmDbUOE/RvrbyDhNboAUGt8TS1N+FP5
         V+6DcGE1ZLikIodIraBsS16UInn+NGcjAmdSrVHBvKjGuGaSkIkng8mtM1Kck3Af2WDH
         +ztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LWtsxrbCmbkPO9VIpU7R3L7RTd+dV3THhXSkC0hLUbs=;
        b=3o65Wbr9g4h6p1CNrxuCB0yuE824joe6jSIKZdb3zo5qrxCJV+Yi47sH+Cj3ChDQ2N
         eoJNCqAG38oklbVxsZ/K18kG/Fn7sobsoJz0stD7uGp6RLET992KO5c47CT1Ruk2d+JV
         bZNxfecSvwkTZ50gnAMxsG3BVZxiFR+aeJfy/yJtPAcfYUMNH7JMuS+na3JDyu7toeWZ
         jCZ/NNomt/dqiiJj1jQRkslnHlS+Eiog5kFPMIScFZgA/1/djjgQ0EByu1Z0p9IA+Xxr
         XUBpJLUnB1MAf8BUmlzemGC5RQyH3jYBizdGAxmX8ClrdYQWPGYC7nbXpGrd4VTSPCBM
         Pjcw==
X-Gm-Message-State: AO0yUKWsQh8VD33SQHyjSY6xldxZwyteJD4JCkilF9RWbnEVdklq/REL
        JCXZyjklzk6aJX95Y/ddGh12VDYm/3uxpdd46kOXiQ==
X-Google-Smtp-Source: AK7set87UGeHjz6rLq7jg+/EqLxAGqyQm03ITBGLImm5XidMc6f1fXhsU0hbf7EnCqrtpKOFurrSfw==
X-Received: by 2002:a17:902:c950:b0:19a:b44b:cca6 with SMTP id i16-20020a170902c95000b0019ab44bcca6mr15874037pla.24.1677185576055;
        Thu, 23 Feb 2023 12:52:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iw15-20020a170903044f00b001992fc0a8eesm1915063plb.174.2023.02.23.12.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 12:52:55 -0800 (PST)
Message-ID: <63f7d227.170a0220.2a1e4.3928@mx.google.com>
Date:   Thu, 23 Feb 2023 12:52:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.169-26-g0059daab31fd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 13 regressions (v5.10.169-26-g0059daab31fd)
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

stable-rc/queue/5.10 baseline: 146 runs, 13 regressions (v5.10.169-26-g0059=
daab31fd)

Regressions Summary
-------------------

platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
beaglebone-black             | arm    | lab-broonie  | gcc-10   | omap2plus=
_defconfig          | 1          =

qemu_i386-uefi               | i386   | lab-baylibre | gcc-10   | i386_defc=
onfig               | 1          =

qemu_i386-uefi               | i386   | lab-broonie  | gcc-10   | i386_defc=
onfig               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe   | gcc-10   | defconfig=
                    | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre | gcc-10   | multi_v7_=
defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.169-26-g0059daab31fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.169-26-g0059daab31fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0059daab31fd127c02e43dcb6d888c8fee7b7eda =



Test Regressions
---------------- =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
beaglebone-black             | arm    | lab-broonie  | gcc-10   | omap2plus=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79dffae74cfb1888c8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f79dffae74cfb1888c863e
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701)

    2023-02-23T17:10:07.272567  + set +x
    2023-02-23T17:10:07.275481  <8>[   19.930532] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 62897_1.5.2.4.1>
    2023-02-23T17:10:07.384970  / # #
    2023-02-23T17:10:07.488201  export SHELL=3D/bin/sh
    2023-02-23T17:10:07.489007  #
    2023-02-23T17:10:07.591364  / # export SHELL=3D/bin/sh. /lava-62897/env=
ironment
    2023-02-23T17:10:07.592113  =

    2023-02-23T17:10:07.694570  / # . /lava-62897/environment/lava-62897/bi=
n/lava-test-runner /lava-62897/1
    2023-02-23T17:10:07.695705  =

    2023-02-23T17:10:07.700225  / # /lava-62897/bin/lava-test-runner /lava-=
62897/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre | gcc-10   | i386_defc=
onfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79d30eab3ecf5268c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79d30eab3ecf5268c8=
636
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_i386-uefi               | i386   | lab-broonie  | gcc-10   | i386_defc=
onfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79eb0a37920706e8c86a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79eb0a37920706e8c8=
6a4
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79dd1c87cec7a238c868d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79dd1c87cec7a238c8=
68e
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79dfa50a655c9da8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79dfa50a655c9da8c8=
630
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79ed82aab1bbe7d8c8693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79ed82aab1bbe7d8c8=
694
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7a00567187c14bb8c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7a00567187c14bb8c8=
657
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79dd3c87cec7a238c8690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79dd3c87cec7a238c8=
691
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79de41f7d765f328c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79de41f7d765f328c8=
644
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79eecb8365b88d28c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79eecb8365b88d28c8=
63a
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f79ff00d6d608e2b8c869d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f79ff00d6d608e2b8c8=
69e
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe   | gcc-10   | defconfig=
                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7a0b587c09429418c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7a0b587c09429418c8=
636
        failing since 2 days (last pass: v5.10.168-57-g1d942bb50824, first =
fail: v5.10.168-57-g5608a96537e5) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre | gcc-10   | multi_v7_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7a00767187c14bb8c866f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-26-g0059daab31fd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f7a00767187c14bb8c8678
        failing since 21 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-02-23T17:18:41.270992  + set +x
    2023-02-23T17:18:41.274242  <8>[    7.492585] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3369015_1.5.2.4.1>
    2023-02-23T17:18:41.379325  / # #
    2023-02-23T17:18:41.481142  export SHELL=3D/bin/sh
    2023-02-23T17:18:41.481516  #
    2023-02-23T17:18:41.582836  / # export SHELL=3D/bin/sh. /lava-3369015/e=
nvironment
    2023-02-23T17:18:41.583233  =

    2023-02-23T17:18:41.684540  / # . /lava-3369015/environment/lava-336901=
5/bin/lava-test-runner /lava-3369015/1
    2023-02-23T17:18:41.685235  =

    2023-02-23T17:18:41.689091  / # /lava-3369015/bin/lava-test-runner /lav=
a-3369015/1 =

    ... (12 line(s) more)  =

 =20
