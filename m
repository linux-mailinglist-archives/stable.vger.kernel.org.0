Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4957B6A9E3A
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 19:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjCCSN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 13:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCCSNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 13:13:54 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D410274
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 10:13:51 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n6so3614283plf.5
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 10:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677867231;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eOrL6lLcoxDc6JslxcnO4lyL77SW7YWsUc020a6cwkU=;
        b=c0HGp1OtOtXHepXb4+3RAeGJcqvgdYqRKuvMcri28aSRsdsjFOgNblOsS2CSc7T1Ax
         HKzANlTN/aN/w2iHEw2ciaDnII/d6rKcRwnZswMFA9YGoUxFzbRy48LSvciLQOpeOZYp
         hZCopGMLcQpzac6tqdy+Vh9/LBILQ0qAhMTtlLmZDRPB73pEnm0egmOFh+2gpxVET8Ld
         dmyttHBIWDlIZ9Szdv9QVNyEZcBS+hEH3luE8ZhkttAUw3CLwcjnDkQjk0A0Z/N54vd/
         amEGz35JvKb7MawXxquMle9IhAvnt9pkJbVDyXcZtxKlYK7Iz4gZKKF6QvMCceOev+Ds
         RAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677867231;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOrL6lLcoxDc6JslxcnO4lyL77SW7YWsUc020a6cwkU=;
        b=m66ThSd7TrA4tdkhQ8GmIo1SP8dMxdyqXrrRJjCFUjH86+4+8bfQHiztpUiHr5/Mqf
         SH5JJ3479ysec8C9gO9P5/69vimUG+ZHBgqLCbotOYkCvDqljaXG3+3OmcpTu/sncwgA
         G33x8KzrigaQxiB50Wb5KxI5gLhuFc9MMspR1p+UBWKtL67zEOIsCmunWnj2r+7V0Jqf
         QwSgbn5hJo+OftnDXKdddZ84KN7a1oVo/9SstFdcPeLCcvB+m2XwrJEKevqqpe0y9kr0
         Jaijfn8i16c00H4kAqV/PBCIMU/s9B8M04H76gPgUyVwUFql9+rKGEnJnO6hpzTiSI8n
         A3bQ==
X-Gm-Message-State: AO0yUKW+8L8G3++330cJsG237W/0hruwV/W6q1QBm5DH/fllMskgz7tq
        U+W0YJaRY4/5/xZCxbRHBcMW6WUeHWzqW3lEgRA=
X-Google-Smtp-Source: AK7set8quIPbc0Qh1Ib40of0w5+1HNn8PxjGz9AliwmuC7ilRPx2Th5uQedWywqBW5yBiebeG/NybA==
X-Received: by 2002:a05:6a20:6f57:b0:cc:b662:9e7c with SMTP id gu23-20020a056a206f5700b000ccb6629e7cmr2441027pzb.46.1677867230139;
        Fri, 03 Mar 2023 10:13:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o25-20020a635d59000000b004fbd021bad6sm1881200pgm.38.2023.03.03.10.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 10:13:49 -0800 (PST)
Message-ID: <640238dd.630a0220.b7845.3de6@mx.google.com>
Date:   Fri, 03 Mar 2023 10:13:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.96-23-gdbe0dd3a4505
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 171 runs,
 14 regressions (v5.15.96-23-gdbe0dd3a4505)
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

stable-rc/queue/5.15 baseline: 171 runs, 14 regressions (v5.15.96-23-gdbe0d=
d3a4505)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =

cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
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

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.96-23-gdbe0dd3a4505/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.96-23-gdbe0dd3a4505
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbe0dd3a4505a1c08b36ba08951d647180914b45 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640208442b68058bf78c869a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640208442b68058bf78c8=
69b
        failing since 28 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/640203d432d819c9108c8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640203d432d819c9108c8639
        failing since 45 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-03T14:27:15.753754  <8>[    9.880541] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3381590_1.5.2.4.1>
    2023-03-03T14:27:15.862305  / # #
    2023-03-03T14:27:15.963923  export SHELL=3D/bin/sh
    2023-03-03T14:27:15.964410  #
    2023-03-03T14:27:16.065638  / # export SHELL=3D/bin/sh. /lava-3381590/e=
nvironment
    2023-03-03T14:27:16.066058  =

    2023-03-03T14:27:16.167860  / # . /lava-3381590/environment/lava-338159=
0/bin/lava-test-runner /lava-3381590/1
    2023-03-03T14:27:16.168512  <3>[   10.194089] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-03-03T14:27:16.168706  =

    2023-03-03T14:27:16.172667  / # /lava-3381590/bin/lava-test-runner /lav=
a-3381590/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/6402046877d4293cd88c8682

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402046877d4293cd88c868b
        failing since 35 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-03-03T14:29:53.580108  + set +x
    2023-03-03T14:29:53.580267  [    9.399370] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914251_1.5.2.3.1>
    2023-03-03T14:29:53.687402  / # #
    2023-03-03T14:29:53.789061  export SHELL=3D/bin/sh
    2023-03-03T14:29:53.789656  #
    2023-03-03T14:29:53.890982  / # export SHELL=3D/bin/sh. /lava-914251/en=
vironment
    2023-03-03T14:29:53.891527  =

    2023-03-03T14:29:53.992896  / # . /lava-914251/environment/lava-914251/=
bin/lava-test-runner /lava-914251/1
    2023-03-03T14:29:53.993599  =

    2023-03-03T14:29:53.995746  / # /lava-914251/bin/lava-test-runner /lava=
-914251/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/6402051c9337baabbb8c8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402051c9337baabbb8c8639
        new failure (last pass: v5.15.79-167-gdc4538c14814)

    2023-03-03T14:32:48.497630  + set +x
    2023-03-03T14:32:48.497801  [   18.534429] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914254_1.5.2.3.1>
    2023-03-03T14:32:48.606131  / # #
    2023-03-03T14:32:48.707626  export SHELL=3D/bin/sh
    2023-03-03T14:32:48.708144  #
    2023-03-03T14:32:48.809422  / # export SHELL=3D/bin/sh. /lava-914254/en=
vironment
    2023-03-03T14:32:48.809972  =

    2023-03-03T14:32:48.911217  / # . /lava-914254/environment/lava-914254/=
bin/lava-test-runner /lava-914254/1
    2023-03-03T14:32:48.911977  =

    2023-03-03T14:32:48.916854  / # /lava-914254/bin/lava-test-runner /lava=
-914254/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/6402082a2b68058bf78c867d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6402082a2b68058bf78c8=
67e
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/64020d43eac34e6ae38c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64020d43eac34e6ae38c8=
632
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6402058209c0e9cba38c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6402058209c0e9cba38c8=
63e
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640206856305e66dba8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640206856305e66dba8c8=
631
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64020aec88b2c712dd8c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64020aec88b2c712dd8c8=
652
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64020c7b4b290ae4138c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64020c7b4b290ae4138c8=
64c
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640205817e767813b98c86a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640205817e767813b98c8=
6aa
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640206866305e66dba8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640206866305e66dba8c8=
637
        failing since 6 days (last pass: v5.15.95-33-gc82275c7e6c8, first f=
ail: v5.15.95-37-gda3256d1340e) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64020aeb88b2c712dd8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64020aeb88b2c712dd8c8=
641
        failing since 17 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64020ca36cdb5c7f1e8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
23-gdbe0dd3a4505/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64020ca36cdb5c7f1e8c8=
647
        failing since 6 days (last pass: v5.15.95-33-gc82275c7e6c8, first f=
ail: v5.15.95-37-gda3256d1340e) =

 =20
