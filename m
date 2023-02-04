Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709DD68AC50
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 21:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjBDUsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 15:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBDUst (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 15:48:49 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0055F1D93B
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 12:48:46 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g9so5958470pfk.13
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 12:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xcAoscqQaYHbQdvaX5GM2QPKp3VJicRxJC2Y0Ljl4vI=;
        b=QfKG9LoyTuHAdBlp713VfmH61i9qQZyEEJq6ccxWbDx8GMREI3vAdGkFgEFcKhsE9G
         rrK7sfIjThcPPM6nu4TJ6qqM+ngK7MOPW9hKNO/VLAgY2c1mTahbxZwCDPGw0g98UOJp
         TpqJBKZOYbWCE7EwphMKe2EzdBhN+PdjQYWmWSsDC2Atia3LKT3HCWymoJUoyPHOghen
         eoLliFf3LTYWpcF+nXuun9wlBdIjziVWmS7pFj9DY/X7JHNYhYNzg7GGCYFBu94lw994
         TtqQK15PSPaR+vlxoHy0Kvq/2lnpC8bDpDAhf2uotLO0X+FU2CN5EC9JWhayJMV7XbUp
         hGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xcAoscqQaYHbQdvaX5GM2QPKp3VJicRxJC2Y0Ljl4vI=;
        b=Hg7eawlkiRiLcObwwyKzuUsZuXElNZyotro0O1oGgDCtyy9M3onVyJ5dbD9avplEot
         4SoQErjMAwhmWjcOSyct1ptQjw3jB4FbkUstH9EF8/bbWxAQwlHRqG7WAlVX1oXUUK/2
         odf0NauNRfiH5QCpyvI3Dw7yAqkzSgc6C4zzIJqaTpQ1bAZ04MhfoCzMohkbt5v21IaP
         sF3aAh24BDb2jJen7GUR2qUCIgUit9nVwbrEdCaGkoLJjkLrcIEMD2oeVkpHy8AODBA8
         dtGO7m9VT96bGH++85pMrnuguhh74rb9ngVG2tCqw+vXaDmG2nm0PMzVP+X97VqU6fve
         Ojjw==
X-Gm-Message-State: AO0yUKW5kcXYmRq0sSlA5tjuY22St6bLRa6oPtxDkjKbl0buS/UgGcfM
        DkODf6FDY4cI5VKrrVoteNaNSP543fbp9cfOeXhwGg==
X-Google-Smtp-Source: AK7set9a19EBp96+MHTgUkArNMAN9dadkHcNaHS1sLIJ1fIPwM5WD0eXGjpGWj+VnjiAxZV2Mlv0pQ==
X-Received: by 2002:a62:14d5:0:b0:593:ebc7:a6d2 with SMTP id 204-20020a6214d5000000b00593ebc7a6d2mr13699429pfu.21.1675543726266;
        Sat, 04 Feb 2023 12:48:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5-20020a056a00150500b005941a05fabesm4263065pfu.142.2023.02.04.12.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 12:48:45 -0800 (PST)
Message-ID: <63dec4ad.050a0220.74d4e.72e2@mx.google.com>
Date:   Sat, 04 Feb 2023 12:48:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.91-21-gd8296a906e7a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 164 runs,
 7 regressions (v5.15.91-21-gd8296a906e7a)
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

stable-rc/linux-5.15.y baseline: 164 runs, 7 regressions (v5.15.91-21-gd829=
6a906e7a)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained  | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.91-21-gd8296a906e7a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.91-21-gd8296a906e7a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8296a906e7af4fd1bcca8025c3f5e9ae834e54e =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained  | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63de9220fbae9cb468915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63de9220fbae9cb468915=
eda
        new failure (last pass: v5.15.90) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63de8f4b0691117af1915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63de8f4b0691117af1915=
eba
        failing since 268 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63de9101f1f74825eb915eed

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de9101f1f74825eb915ef2
        failing since 18 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-04T17:08:05.803913  <8>[    9.970175] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288808_1.5.2.4.1>
    2023-02-04T17:08:05.910259  / # #
    2023-02-04T17:08:06.011713  export SHELL=3D/bin/sh
    2023-02-04T17:08:06.012063  #
    2023-02-04T17:08:06.113062  / # export SHELL=3D/bin/sh. /lava-3288808/e=
nvironment
    2023-02-04T17:08:06.113399  =

    2023-02-04T17:08:06.214523  / # . /lava-3288808/environment/lava-328880=
8/bin/lava-test-runner /lava-3288808/1
    2023-02-04T17:08:06.215010  =

    2023-02-04T17:08:06.219712  / # /lava-3288808/bin/lava-test-runner /lav=
a-3288808/1
    2023-02-04T17:08:06.300774  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63de9131a4e8235026915f2d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de9131a4e8235026915f32
        failing since 5 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first =
fail: v5.15.90-205-g5605d15db022)

    2023-02-04T17:08:41.735699  + set +x
    2023-02-04T17:08:41.735865  [    9.391146] <LAVA_SIGNAL_ENDRUN 0_dmesg =
898316_1.5.2.3.1>
    2023-02-04T17:08:41.843095  / # #
    2023-02-04T17:08:41.945321  export SHELL=3D/bin/sh
    2023-02-04T17:08:41.945767  #
    2023-02-04T17:08:42.046916  / # export SHELL=3D/bin/sh. /lava-898316/en=
vironment
    2023-02-04T17:08:42.047302  =

    2023-02-04T17:08:42.148502  / # . /lava-898316/environment/lava-898316/=
bin/lava-test-runner /lava-898316/1
    2023-02-04T17:08:42.149158  =

    2023-02-04T17:08:42.151878  / # /lava-898316/bin/lava-test-runner /lava=
-898316/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63de90d02da417bb4c915f70

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm3=
2mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm3=
2mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de90d02da417bb4c915f75
        new failure (last pass: v5.15.59)

    2023-02-04T17:07:19.870884  <8>[   11.630287] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288803_1.5.2.4.1>
    2023-02-04T17:07:19.976905  / # #
    2023-02-04T17:07:20.078651  export SHELL=3D/bin/sh
    2023-02-04T17:07:20.079428  #
    2023-02-04T17:07:20.181122  / # export SHELL=3D/bin/sh. /lava-3288803/e=
nvironment
    2023-02-04T17:07:20.181877  =

    2023-02-04T17:07:20.283606  / # . /lava-3288803/environment/lava-328880=
3/bin/lava-test-runner /lava-3288803/1
    2023-02-04T17:07:20.284678  =

    2023-02-04T17:07:20.289061  / # /lava-3288803/bin/lava-test-runner /lav=
a-3288803/1
    2023-02-04T17:07:20.355953  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63de92ae073217f2be915eee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de92ae073217f2be915ef3
        failing since 18 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-04T17:15:09.650548  + set +x
    2023-02-04T17:15:09.654551  <8>[   16.074079] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288852_1.5.2.4.1>
    2023-02-04T17:15:09.776022  / # #
    2023-02-04T17:15:09.881973  export SHELL=3D/bin/sh
    2023-02-04T17:15:09.883628  #
    2023-02-04T17:15:09.987121  / # export SHELL=3D/bin/sh. /lava-3288852/e=
nvironment
    2023-02-04T17:15:09.988692  =

    2023-02-04T17:15:10.092328  / # . /lava-3288852/environment/lava-328885=
2/bin/lava-test-runner /lava-3288852/1
    2023-02-04T17:15:10.095247  =

    2023-02-04T17:15:10.097806  / # /lava-3288852/bin/lava-test-runner /lav=
a-3288852/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63de9261d48f60f7f2915f0b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-21-gd8296a906e7a/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de9261d48f60f7f2915f10
        failing since 18 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-04T17:13:56.201189  + set +x
    2023-02-04T17:13:56.205234  <8>[   16.077265] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 251838_1.5.2.4.1>
    2023-02-04T17:13:56.318483  / # #
    2023-02-04T17:13:56.422279  export SHELL=3D/bin/sh
    2023-02-04T17:13:56.423134  #
    2023-02-04T17:13:56.525746  / # export SHELL=3D/bin/sh. /lava-251838/en=
vironment
    2023-02-04T17:13:56.526607  =

    2023-02-04T17:13:56.629166  / # . /lava-251838/environment/lava-251838/=
bin/lava-test-runner /lava-251838/1
    2023-02-04T17:13:56.630677  =

    2023-02-04T17:13:56.634499  / # /lava-251838/bin/lava-test-runner /lava=
-251838/1 =

    ... (12 line(s) more)  =

 =20
