Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940E0689EB8
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 17:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjBCQAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 11:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjBCP77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 10:59:59 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4AB9EE2
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 07:59:49 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s8so1810698pgg.11
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 07:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bu/L5F3UpiB5A4pd70+SwATdVym6WG0udLWguABnbZs=;
        b=vQBeQDY4zIX1Pdsux+eVD9VNN8xCTPjC8PuH44T2vWnQ0Oq21LWdtt55xGsoxXCZgg
         ySY/g+QILd+PGiK6m3H2OqlFLZTvFZUYKyNF+aRUsa6TzwbUX7Xk/CHqlUIMexBXXCjk
         9+8IKY9rDaVKzojP43nCyKdPr6p57zfUMClgYa6LXi1rW2UYesbPza9cFocrjbTLy+am
         SxxppQ38umWUEgry+IoHtHYs0r4AiFf9d1riO1TajFBkwgrhvBkLIekGpiVQbmCYKQwM
         C53ks0D66cAF4GBR15daVOmggHUnBKWdlyeu5N5hucZoIzBhzDQ4pyduldsOlCHRJ0+7
         ZobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bu/L5F3UpiB5A4pd70+SwATdVym6WG0udLWguABnbZs=;
        b=oVzD/pqWRFfI0yBhkmnItxbJu+b5qCPT0Syb/MZ2VnJP56cgjSx6U+/I6pAJCGRRGd
         i8AzNpJNGBlQcSmzQmnvOeDEDUS8H9ITJPm3V9CspZvmpCtDv0I55YBJ2cXJE2m9Q82d
         8/3U8z8Crw/C3oD7Kd1RHk/FjKYYOgEvf5UijSMFLaKERMYLlAIT4b7URekVF6Vye8yj
         +YZq9PywRUwg3oDy/tJP1DIpwJT97WcXp4MrdVIEMpnNzQCKsLe/VQniDRuTxSxU3a0z
         5NYxrZrKEooRHGRJYxjR3CJYq3dBbTExdK3xJBE0rIulidkQC4s4d4dFyRagwoiBNyL+
         2tsQ==
X-Gm-Message-State: AO0yUKWfevU3n/d78xf1vf7WMjuvFFL/1FE187umBAdn1XYLUXJa+UOe
        h9Pokr/8aCobMULg1G0oShMXCRh8zwrr+ysM2r/kHw==
X-Google-Smtp-Source: AK7set/nHE3gSNz7Obfz6AFIDHV27h8Z64rufFLWEevm7C4zPu7FsXZsYRZvLpGhxPmRqLTY8MfBsQ==
X-Received: by 2002:a05:6a00:88f:b0:592:5276:95df with SMTP id q15-20020a056a00088f00b00592527695dfmr11949127pfj.2.1675439988161;
        Fri, 03 Feb 2023 07:59:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 68-20020a620647000000b00574e84ed847sm1955772pfg.24.2023.02.03.07.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:59:47 -0800 (PST)
Message-ID: <63dd2f73.620a0220.8f39f.3829@mx.google.com>
Date:   Fri, 03 Feb 2023 07:59:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.230-135-gf094cca7f934
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 152 runs,
 26 regressions (v5.4.230-135-gf094cca7f934)
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

stable-rc/linux-5.4.y baseline: 152 runs, 26 regressions (v5.4.230-135-gf09=
4cca7f934)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =

cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | multi_v5_=
defconfig         | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.230-135-gf094cca7f934/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.230-135-gf094cca7f934
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f094cca7f934dd6b1c62254251d145087d40c30b =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfebbefd150a20f915eec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfebbefd150a20f915ef1
        failing since 17 days (last pass: v5.4.226, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-02-03T12:31:39.048175  <8>[   23.880767] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281450_1.5.2.4.1>
    2023-02-03T12:31:39.156088  / # #
    2023-02-03T12:31:39.257549  export SHELL=3D/bin/sh
    2023-02-03T12:31:39.257990  #
    2023-02-03T12:31:39.359206  / # export SHELL=3D/bin/sh. /lava-3281450/e=
nvironment
    2023-02-03T12:31:39.359555  =

    2023-02-03T12:31:39.460789  / # . /lava-3281450/environment/lava-328145=
0/bin/lava-test-runner /lava-3281450/1
    2023-02-03T12:31:39.461302  =

    2023-02-03T12:31:39.466032  / # /lava-3281450/bin/lava-test-runner /lav=
a-3281450/1
    2023-02-03T12:31:39.558025  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe3dff471ddb2e915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfe3dff471ddb2e915ecb
        failing since 17 days (last pass: v5.4.226, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-02-03T12:29:37.813004  <8>[   23.856964] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281432_1.5.2.4.1>
    2023-02-03T12:29:37.920978  / # #
    2023-02-03T12:29:38.022900  export SHELL=3D/bin/sh
    2023-02-03T12:29:38.023590  #
    2023-02-03T12:29:38.125611  / # export SHELL=3D/bin/sh. /lava-3281432/e=
nvironment
    2023-02-03T12:29:38.126234  =

    2023-02-03T12:29:38.228124  / # . /lava-3281432/environment/lava-328143=
2/bin/lava-test-runner /lava-3281432/1
    2023-02-03T12:29:38.228944  =

    2023-02-03T12:29:38.233582  / # /lava-3281432/bin/lava-test-runner /lav=
a-3281432/1
    2023-02-03T12:29:38.340479  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfec287b3a36078915f4e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfec287b3a36078915f53
        failing since 17 days (last pass: v5.4.226-68-g8c05f5e0777d, first =
fail: v5.4.228-659-gb3b34c474ec7)

    2023-02-03T12:31:47.147959  <8>[    9.843109] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281460_1.5.2.4.1>
    2023-02-03T12:31:47.256460  / # #
    2023-02-03T12:31:47.358049  export SHELL=3D/bin/sh
    2023-02-03T12:31:47.358437  #
    2023-02-03T12:31:47.459570  / # export SHELL=3D/bin/sh. /lava-3281460/e=
nvironment
    2023-02-03T12:31:47.460317  =

    2023-02-03T12:31:47.562044  / # . /lava-3281460/environment/lava-328146=
0/bin/lava-test-runner /lava-3281460/1
    2023-02-03T12:31:47.563672  =

    2023-02-03T12:31:47.568415  / # /lava-3281460/bin/lava-test-runner /lav=
a-3281460/1
    2023-02-03T12:31:47.651466  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | multi_v5_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfcbc1571e7859b915ec6

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfcbc1571e7859b915ecb
        failing since 17 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-02-03T12:23:07.189379  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 3281353_1.5.=
2.4.1>
    2023-02-03T12:23:07.297077  / # #
    2023-02-03T12:23:07.399527  export SHELL=3D/bin/sh
    2023-02-03T12:23:07.399982  #
    2023-02-03T12:23:07.501129  / # export SHELL=3D/bin/sh. /lava-3281353/e=
nvironment
    2023-02-03T12:23:07.501661  =

    2023-02-03T12:23:07.603319  / # . /lava-3281353/environment/lava-328135=
3/bin/lava-test-runner /lava-3281353/1
    2023-02-03T12:23:07.603949  =

    2023-02-03T12:23:07.619792  / # /lava-3281353/bin/lava-test-runner /lav=
a-3281353/1
    2023-02-03T12:23:07.860842  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfbf5d6167a24ac915ec7

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63dcfbf5d6167a24=
ac915ed0
        failing since 107 days (last pass: v5.4.219, first fail: v5.4.219-2=
67-g4a976f825745)
        3 lines

    2023-02-03T12:19:44.078662  / # =

    2023-02-03T12:19:44.079622  =

    2023-02-03T12:19:46.142532  / # #
    2023-02-03T12:19:46.143196  #
    2023-02-03T12:19:48.155468  / # export SHELL=3D/bin/sh
    2023-02-03T12:19:48.155927  export SHELL=3D/bin/sh
    2023-02-03T12:19:50.171132  / # . /lava-3281324/environment
    2023-02-03T12:19:50.171829  . /lava-3281324/environment
    2023-02-03T12:19:52.187234  / # /lava-3281324/bin/lava-test-runner /lav=
a-3281324/0
    2023-02-03T12:19:52.189574  /lava-3281324/bin/lava-test-runner /lava-32=
81324/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe86939d4b3993915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe86939d4b3993915=
ed3
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcff478de291825f915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcff478de291825f915=
ed8
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe9a1eb216982c915f38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe9a1eb216982c915=
f39
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd00010d838373c5915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dd00010d838373c5915=
ebd
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe849270172fba915eef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe849270172fba915=
ef0
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcff457da832a11b915efa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcff457da832a11b915=
efb
        failing since 269 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe9916bee7fe6e915ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe9916bee7fe6e915=
eea
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd0000b3abab0556915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dd0000b3abab0556915=
eba
        failing since 269 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe803c8cd61ed7915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe803c8cd61ed7915=
ebc
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcff48a40d172659915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcff48a40d172659915=
ed3
        failing since 269 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe5b21ad765802915efc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe5b21ad765802915=
efd
        failing since 269 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd00020d838373c5915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dd00020d838373c5915=
ec0
        failing since 269 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe82939d4b3993915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe82939d4b3993915=
ecc
        failing since 164 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-390-g1cece69eaa88) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcff44a40d172659915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcff44a40d172659915=
ecc
        failing since 269 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe98ef1fc9108e915f25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfe98ef1fc9108e915=
f26
        failing since 164 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-390-g1cece69eaa88) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcffc4d853d021e5915f86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcffc4d853d021e5915=
f87
        failing since 269 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfdf1f96eeaa5dc915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfdf1f96eeaa5dc915=
ec7
        failing since 164 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-390-g1cece69eaa88) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfdb039c7bb4b04915f36

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfdb039c7bb4b04915f3b
        failing since 16 days (last pass: v5.4.226-68-g97ed976894df, first =
fail: v5.4.228-659-gb3b34c474ec7)

    2023-02-03T12:27:09.754153  <8>[   16.734414] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281399_1.5.2.4.1>
    2023-02-03T12:27:09.875106  / # #
    2023-02-03T12:27:09.981493  export SHELL=3D/bin/sh
    2023-02-03T12:27:09.983474  #
    2023-02-03T12:27:10.087503  / # export SHELL=3D/bin/sh. /lava-3281399/e=
nvironment
    2023-02-03T12:27:10.089527  =

    2023-02-03T12:27:10.193578  / # . /lava-3281399/environment/lava-328139=
9/bin/lava-test-runner /lava-3281399/1
    2023-02-03T12:27:10.196871  =

    2023-02-03T12:27:10.199785  / # /lava-3281399/bin/lava-test-runner /lav=
a-3281399/1
    2023-02-03T12:27:10.232150  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe6c9270172fba915eba

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfe6c9270172fba915ebf
        failing since 16 days (last pass: v5.4.226-68-g97ed976894df, first =
fail: v5.4.228-659-gb3b34c474ec7)

    2023-02-03T12:30:22.792200  <8>[   16.681380] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 244240_1.5.2.4.1>
    2023-02-03T12:30:22.899907  / # #
    2023-02-03T12:30:23.001916  export SHELL=3D/bin/sh
    2023-02-03T12:30:23.002508  #
    2023-02-03T12:30:23.104054  / # export SHELL=3D/bin/sh. /lava-244240/en=
vironment
    2023-02-03T12:30:23.104639  =

    2023-02-03T12:30:23.206142  / # . /lava-244240/environment/lava-244240/=
bin/lava-test-runner /lava-244240/1
    2023-02-03T12:30:23.207069  =

    2023-02-03T12:30:23.210017  / # /lava-244240/bin/lava-test-runner /lava=
-244240/1
    2023-02-03T12:30:23.243495  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfe89939d4b3993915ed5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfe89939d4b3993915eda
        failing since 17 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-02-03T12:30:23.436196  / # #
    2023-02-03T12:30:23.537920  export SHELL=3D/bin/sh
    2023-02-03T12:30:23.538278  #
    2023-02-03T12:30:23.639573  / # export SHELL=3D/bin/sh. /lava-3281448/e=
nvironment
    2023-02-03T12:30:23.639941  =

    2023-02-03T12:30:23.741362  / # . /lava-3281448/environment/lava-328144=
8/bin/lava-test-runner /lava-3281448/1
    2023-02-03T12:30:23.742056  =

    2023-02-03T12:30:23.748824  / # /lava-3281448/bin/lava-test-runner /lav=
a-3281448/1
    2023-02-03T12:30:23.835680  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-03T12:30:23.835967  + cd /lava-3281448/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfc14e8e48eef80915f71

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
-135-gf094cca7f934/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfc14e8e48eef80915f76
        failing since 17 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-02-03T12:20:26.217378  / # #
    2023-02-03T12:20:26.319220  export SHELL=3D/bin/sh
    2023-02-03T12:20:26.319630  #
    2023-02-03T12:20:26.420979  / # export SHELL=3D/bin/sh. /lava-3281337/e=
nvironment
    2023-02-03T12:20:26.421362  =

    2023-02-03T12:20:26.522654  / # . /lava-3281337/environment/lava-328133=
7/bin/lava-test-runner /lava-3281337/1
    2023-02-03T12:20:26.523312  =

    2023-02-03T12:20:26.528271  / # /lava-3281337/bin/lava-test-runner /lav=
a-3281337/1
    2023-02-03T12:20:26.608213  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-03T12:20:26.608756  + cd /lava-3281337/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
