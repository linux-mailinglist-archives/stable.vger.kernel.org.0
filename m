Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A29B68DE2B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 17:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjBGQqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 11:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjBGQqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 11:46:49 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8344C1D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 08:46:46 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id u75so4234132pgc.10
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 08:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bRlHlnan6mLJbk3b1B2LamC10b4czt7f2F+juzTS+iU=;
        b=45hvFEf23QhSgGisQBHkPnQBPpNC62/hn1IXCtyah4pw0Dk53Aas01ADGP3s7J8j1h
         h32tgZAURnkpwsLGzK1Yi0ABQYLkHLOEMG7qFyaSb9LQ43LBsZAWtuqaPZhRvgVTKhfL
         ciI+S4wVVY9LbMmzg0jtRElkXIz3gX1iMcG/0JZt/3s5WVUPxombeoU9/q+PxkRWDl0u
         ZnhswYylohgy0rGDpIdB+/BFrrSMR0zY4GCqb1WnbQvDcJCjwiTXws4qOFz8qqcLpBKS
         Fn81U7me0A696sAmRoeBEmrpEx8MBts02HYk/WnGTPiYpF+G1zJpHleyyDzUrDC3vnCx
         pyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bRlHlnan6mLJbk3b1B2LamC10b4czt7f2F+juzTS+iU=;
        b=BDW7AW75W7heAXfBc68LDCc0mp8Mdy4TyOebqufhCx8m7EDD0x2fo1zcfU7tidPUM1
         Go18qcCHtLCnUvl07etym15EFLK7PVzzpIej3DAKoHpdl/RrUGCb/cQTL9bEL80CrGAF
         AhPYme7Z/qU6IcHcERS62ZzTyp7ZzepB0AtwMdgYdP1DV1d6kU77Fay6uEhnWr16tBlv
         IeNPyI433o94+QKBQ27AOPHxsfOZ1obucsGEjFeD3vsuFIOAnQPar064ECpQpfFxV/Ma
         EhtuuT7H1M3Oz8vioCj+f62Z8ILOfUP6WCbRgOhtnCQTqfX+SlbSf3EvgmLeMsP/BJYT
         GXBA==
X-Gm-Message-State: AO0yUKUdf7WveAUP2ssmgfI8uz7VzEE6u7JHMGeDAv+IIJOfCCXwvcFj
        X7O6tywwVxWNDCimnu0VuUAMhuAKWPY5UIF5095j+Q==
X-Google-Smtp-Source: AK7set9X5Wjxaa+AXXUx2fwDss+q9qP34rOB41T60iMvdrbQZlBCG5OskquhDSjhLyxp0opo+uIHKg==
X-Received: by 2002:a62:6457:0:b0:591:3d20:3827 with SMTP id y84-20020a626457000000b005913d203827mr3737844pfb.21.1675788406024;
        Tue, 07 Feb 2023 08:46:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z21-20020aa785d5000000b0058dbb5c5038sm1073860pfn.182.2023.02.07.08.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 08:46:45 -0800 (PST)
Message-ID: <63e28075.a70a0220.f1dc5.1f46@mx.google.com>
Date:   Tue, 07 Feb 2023 08:46:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.91-130-gbdb0253e989d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 165 runs,
 5 regressions (v5.15.91-130-gbdb0253e989d)
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

stable-rc/linux-5.15.y baseline: 165 runs, 5 regressions (v5.15.91-130-gbdb=
0253e989d)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.91-130-gbdb0253e989d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.91-130-gbdb0253e989d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bdb0253e989d29fbc4fcb2d2863036eb1154d4ba =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63e24eb9c5825510518c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e24eb9c5825510518c8=
638
        failing since 270 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e24cb645073adc0b8c8651

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e24cb645073adc0b8c865a
        failing since 21 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-07T13:05:33.608808  + set +x<8>[    9.957978] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3301563_1.5.2.4.1>
    2023-02-07T13:05:33.609049  =

    2023-02-07T13:05:33.715760  / # #
    2023-02-07T13:05:33.817225  export SHELL=3D/bin/sh
    2023-02-07T13:05:33.817580  #
    2023-02-07T13:05:33.918722  / # export SHELL=3D/bin/sh. /lava-3301563/e=
nvironment
    2023-02-07T13:05:33.919085  =

    2023-02-07T13:05:34.020050  / # . /lava-3301563/environment/lava-330156=
3/bin/lava-test-runner /lava-3301563/1
    2023-02-07T13:05:34.020599  =

    2023-02-07T13:05:34.020738  / # /lava-3301563/bin/lava-test-runner /lav=
a-3301563/1<3>[   10.353785] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e24c6b4270bf40498c8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e24c6b4270bf40498c8659
        failing since 7 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first =
fail: v5.15.90-205-g5605d15db022)

    2023-02-07T13:04:25.814091  + set +x
    2023-02-07T13:04:25.814279  [    9.377071] <LAVA_SIGNAL_ENDRUN 0_dmesg =
900129_1.5.2.3.1>
    2023-02-07T13:04:25.922452  / # #
    2023-02-07T13:04:26.024448  export SHELL=3D/bin/sh
    2023-02-07T13:04:26.025074  #
    2023-02-07T13:04:26.126389  / # export SHELL=3D/bin/sh. /lava-900129/en=
vironment
    2023-02-07T13:04:26.127116  =

    2023-02-07T13:04:26.228690  / # . /lava-900129/environment/lava-900129/=
bin/lava-test-runner /lava-900129/1
    2023-02-07T13:04:26.229495  =

    2023-02-07T13:04:26.232156  / # /lava-900129/bin/lava-test-runner /lava=
-900129/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63e250424c9f7489818c86b6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e250424c9f7489818c86bf
        failing since 21 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-07T13:20:40.565120  + set +x
    2023-02-07T13:20:40.568474  <8>[   16.116531] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3301683_1.5.2.4.1>
    2023-02-07T13:20:40.689956  / # #
    2023-02-07T13:20:40.795884  export SHELL=3D/bin/sh
    2023-02-07T13:20:40.797475  #
    2023-02-07T13:20:40.901081  / # export SHELL=3D/bin/sh. /lava-3301683/e=
nvironment
    2023-02-07T13:20:40.902678  =

    2023-02-07T13:20:41.006770  / # . /lava-3301683/environment/lava-330168=
3/bin/lava-test-runner /lava-3301683/1
    2023-02-07T13:20:41.012661  =

    2023-02-07T13:20:41.015244  / # /lava-3301683/bin/lava-test-runner /lav=
a-3301683/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2501a838e335bc28c864b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-130-gbdb0253e989d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e2501a838e335bc28c8654
        failing since 21 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-07T13:20:11.991098  + set +x
    2023-02-07T13:20:11.994996  <8>[   15.995347] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 268783_1.5.2.4.1>
    2023-02-07T13:20:12.105696  / # #
    2023-02-07T13:20:12.208346  export SHELL=3D/bin/sh
    2023-02-07T13:20:12.209278  #
    2023-02-07T13:20:12.310687  / # export SHELL=3D/bin/sh. /lava-268783/en=
vironment
    2023-02-07T13:20:12.311303  =

    2023-02-07T13:20:12.412973  / # . /lava-268783/environment/lava-268783/=
bin/lava-test-runner /lava-268783/1
    2023-02-07T13:20:12.413692  =

    2023-02-07T13:20:12.417839  / # /lava-268783/bin/lava-test-runner /lava=
-268783/1 =

    ... (12 line(s) more)  =

 =20
