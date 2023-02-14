Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF88695527
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 01:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBNAFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 19:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBNAFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 19:05:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC7FE38A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 16:05:32 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so13892477pjp.0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 16:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=N8Op3UVp6MIg5keF3xEEVdYV9TNYJgHc/XArnqa4/Xk=;
        b=rnm4vABXurspKfaU+DuKMYIAbQ4evCmQrnEtuAu6voaOzDIuXvoGiOtwNDsy5cQURN
         KjPRZctrdMvPgr0FPUhWQK8DNWEDcPmo9uupGV77PyeMGoctdIpvfajZDv2afhVa06WR
         63uxNJaAUoKivzHqkH/CwjGR6t2fTmwxmrN06McRitZB0zHv1gFIiaLKhg/wGW7uZ6qf
         YZlEfPrCTUrGDu604Rgx4napbc8943VSPHzu9D/78U4bcMxXAeqdpBAFlAUDHLcNm+tA
         NfB0g+NwswJNBfHvfNX6QBIuAylGblHIIy0Z+9F6kBn7Esf3O5GGyKIpDVLDntu/33lY
         QvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Op3UVp6MIg5keF3xEEVdYV9TNYJgHc/XArnqa4/Xk=;
        b=at98QxRtdCjEZr2wL2cjNvFsiNptC9A0Fqbaxx1S0ZCtTFAfI8fEuT3Q+AlvVx2TrY
         Zy1/HnWVUYy4hOSPAfQUEj9+hcqRB6H2NLt9B9f8HjORC+U2ozNNdzFZn89GMYvfIrPs
         89gGAw5LWE3MNiJbew6jwuHgE9Br2tmY3xQq1IbMVZAaK0Y6ggQSCKPzMLgw1dCQZarB
         oia//UP/ZHBrSR49Jp6k3FmmDCat5xTOFsBIQWEy7ttkfTjBIAHyGvnC0QU2UOIziczN
         vUlFCZu6nDyFVLqP/HKR5KmKgm3oe8SKGtljAka+e5XcOTGje9+Ok0UfNAWdxLVMPuiZ
         7mbg==
X-Gm-Message-State: AO0yUKXWPDSAK06p8IwxRQSKtSQY3WjOxUJYhQKOXCCMYRov/dVSu1ND
        qQie9AGMMNclD8eeJVQWDMQmQrXcoDgh7M8mOYM=
X-Google-Smtp-Source: AK7set9ntonYiKRHQviriPdfnMyAxAkw5czPp3vy/VHskvo7mQc6wO/nE+AhbUgR3wNZMaQImVoIbQ==
X-Received: by 2002:a17:90b:3804:b0:230:a195:b8ac with SMTP id mq4-20020a17090b380400b00230a195b8acmr418191pjb.7.1676333131159;
        Mon, 13 Feb 2023 16:05:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090ad39000b0022c9eddaf9dsm2835475pju.0.2023.02.13.16.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 16:05:30 -0800 (PST)
Message-ID: <63ead04a.170a0220.2a406.4d8a@mx.google.com>
Date:   Mon, 13 Feb 2023 16:05:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-67-g85c6595a0daa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 169 runs,
 17 regressions (v5.15.93-67-g85c6595a0daa)
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

stable-rc/queue/5.15 baseline: 169 runs, 17 regressions (v5.15.93-67-g85c65=
95a0daa)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
at91-sama5d4_xplained  | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =

cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

tegra124-nyan-big      | arm    | lab-collabora   | gcc-10   | tegra_defcon=
fig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-67-g85c6595a0daa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-67-g85c6595a0daa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85c6595a0daa373ec3961fe6cad5251cc423deef =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
at91-sama5d4_xplained  | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea977ef481c8a20c8c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea977ef481c8a20c8c8=
63e
        new failure (last pass: v5.15.91-20-gcb49f24ce02b) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9974c3352cac2d8c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9974c3352cac2d8c8=
633
        failing since 10 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea969888c7169ad78c8673

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ea969888c7169ad78c867c
        failing since 27 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-13T19:59:08.519078  + set +x<8>[    9.929887] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3333361_1.5.2.4.1>
    2023-02-13T19:59:08.519639  =

    2023-02-13T19:59:08.629435  / # #
    2023-02-13T19:59:08.732536  export SHELL=3D/bin/sh
    2023-02-13T19:59:08.733451  #
    2023-02-13T19:59:08.835560  / # export SHELL=3D/bin/sh. /lava-3333361/e=
nvironment
    2023-02-13T19:59:08.836497  =

    2023-02-13T19:59:08.938522  / # . /lava-3333361/environment/lava-333336=
1/bin/lava-test-runner /lava-3333361/1
    2023-02-13T19:59:08.940378  =

    2023-02-13T19:59:08.940867  / # /lava-3333361/bin/lava-test-runner /lav=
a-3333361/1<3>[   10.353663] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea965e3892fcf50b8c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ea965e3892fcf50b8c8641
        failing since 17 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-13T19:58:00.552256  + set +x
    2023-02-13T19:58:00.552470  [    9.336444] <LAVA_SIGNAL_ENDRUN 0_dmesg =
904805_1.5.2.3.1>
    2023-02-13T19:58:00.660396  / # #
    2023-02-13T19:58:00.761987  export SHELL=3D/bin/sh
    2023-02-13T19:58:00.762471  #
    2023-02-13T19:58:00.863684  / # export SHELL=3D/bin/sh. /lava-904805/en=
vironment
    2023-02-13T19:58:00.864219  =

    2023-02-13T19:58:00.968371  / # . /lava-904805/environment/lava-904805/=
bin/lava-test-runner /lava-904805/1
    2023-02-13T19:58:00.969112  =

    2023-02-13T19:58:00.971746  / # /lava-904805/bin/lava-test-runner /lava=
-904805/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9869760cd9fc0a8c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9869760cd9fc0a8c8=
677
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea99c42d39e1d3da8c8669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea99c42d39e1d3da8c8=
66a
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9891c894641b888c8707

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9891c894641b888c8=
708
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9ee6b235e166d68c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9ee6b235e166d68c8=
655
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea99ec29333b729e8c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea99ec29333b729e8c8=
639
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63eaa11d562428a8d88c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63eaa11d562428a8d88c8=
642
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9ebc0e9623215c8c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9ebc0e9623215c8c8=
650
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea987ec894641b888c869b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea987ec894641b888c8=
69c
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9ee7b235e166d68c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9ee7b235e166d68c8=
65b
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea99c5832ece966a8c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea99c5832ece966a8c8=
649
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63eaa13153ae5012618c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63eaa13153ae5012618c8=
64b
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea9ed3d6f4f84a1b8c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea9ed3d6f4f84a1b8c8=
659
        new failure (last pass: v5.15.93-48-g91b0616b8246) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
tegra124-nyan-big      | arm    | lab-collabora   | gcc-10   | tegra_defcon=
fig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63ea97f5e235d49e9c8c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
67-g85c6595a0daa/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ea97f5e235d49e9c8c8=
651
        new failure (last pass: v5.15.93-43-g62691dabb900) =

 =20
