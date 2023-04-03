Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58216D4E1F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDCQjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjDCQjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:39:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985342D7C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:39:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so33189955pjt.2
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 09:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680539947;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PQYmIAOm4Dg0ORTg/9yvxof/2Rcm+9k10llt2X91mEI=;
        b=lXpW6AP6NMmEXwNWutwBRetq2GeujlaTC0tfZ063BDXzxSjjqPphLpRgeFm09Y4umV
         4It5CIdo43K8K09GrGKtrVYQ1Y23CqzmZsvRUT4nr1LR4y6Qzhboc0s8EPLmBCNO/7J8
         axHwHLzabpcyoVHXN332Me07Uj3iedpbL4GJlR1H+lWMJCDkf3o2ufRL534jtNHdTtJ2
         chmQRUxBmcdsRsL6WGa3d6zxcgA2N/EKyJ6EASshfege+svO3pG1uiPfZjJmc8VrYlL/
         ra+tBHL0Q9uKaM5BazHBCayRSCnAoBYQkZIBEU6jW/sDgIs2K4UHyhQ6WGPGF9bNcgPK
         sCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539947;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PQYmIAOm4Dg0ORTg/9yvxof/2Rcm+9k10llt2X91mEI=;
        b=kZJakGGUBDUbYRNTC6TIoYbrXKE88V7SvbZFHGlbPGmoDug9YVQ7w7++h7A9iVrOh9
         qGh/u8SYA+Ez8wb3tO8+FI0Zqt99TNAwv4UvWEPEhT2fIuqPHsk48RbvUEAF0CFHPfaW
         7R6jHV0XAdTWpC/R08fF5HYDhydf0RISWrcTdlrQc1hJ8m48OeEdaxCa4LC2l+htFoAy
         fZvhlDvcZdtQFIGVM/69JNT0Hbv1HUu2fqUYCBVfeE2N2ih8vkIlTeH5xb97WTUlFdc1
         +A5TTuzO5J2GUt6BSznd9JSB9HR5ayfj1NYvd3WaOPLxSZZ+TTU/jGzyUpFe+QKyTB2f
         VBgg==
X-Gm-Message-State: AAQBX9fHjGgxuD+FwuS5Irb0kFbn8XDHWn6o4mqys/N1vU5FqG0Z2xnP
        M9KxTVi/CAK+VbJnUbVH2k+xiyB5ZHlzjvtmDaDhJw==
X-Google-Smtp-Source: AKy350YSdvAeeVS+Iz0BGb4Fjjhnk/VfT0Or5eP1GVZSHbv7areHLvW3A00NDr0O/nBiCUDrfucL0w==
X-Received: by 2002:a17:902:d709:b0:1a2:1f8b:4ba8 with SMTP id w9-20020a170902d70900b001a21f8b4ba8mr29376951ply.60.1680539946683;
        Mon, 03 Apr 2023 09:39:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o18-20020a635d52000000b005136d5a2b26sm6016195pgm.60.2023.04.03.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:39:06 -0700 (PDT)
Message-ID: <642b012a.630a0220.2faca.b1cd@mx.google.com>
Date:   Mon, 03 Apr 2023 09:39:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-90-g2aa39169cd26
Subject: stable-rc/linux-5.15.y baseline: 115 runs,
 9 regressions (v5.15.105-90-g2aa39169cd26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 115 runs, 9 regressions (v5.15.105-90-g2aa=
39169cd26)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-90-g2aa39169cd26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-90-g2aa39169cd26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2aa39169cd26a00c921a1bb4a7aac4d939fe94fe =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642acce01298d9608f62f791

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642acce01298d9608f62f796
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:41.373254  <8>[   10.891147] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850371_1.4.2.3.1>

    2023-04-03T12:55:41.376854  + set +x

    2023-04-03T12:55:41.481636  / # #

    2023-04-03T12:55:41.582831  export SHELL=3D/bin/sh

    2023-04-03T12:55:41.583050  #

    2023-04-03T12:55:41.683941  / # export SHELL=3D/bin/sh. /lava-9850371/e=
nvironment

    2023-04-03T12:55:41.684153  =


    2023-04-03T12:55:41.785062  / # . /lava-9850371/environment/lava-985037=
1/bin/lava-test-runner /lava-9850371/1

    2023-04-03T12:55:41.785379  =


    2023-04-03T12:55:41.790677  / # /lava-9850371/bin/lava-test-runner /lav=
a-9850371/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accd9b9aee1733c62f76f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accd9b9aee1733c62f774
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:38.603163  + set<8>[   11.775213] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9850446_1.4.2.3.1>

    2023-04-03T12:55:38.603250   +x

    2023-04-03T12:55:38.708244  / # #

    2023-04-03T12:55:38.809230  export SHELL=3D/bin/sh

    2023-04-03T12:55:38.809443  #

    2023-04-03T12:55:38.910358  / # export SHELL=3D/bin/sh. /lava-9850446/e=
nvironment

    2023-04-03T12:55:38.910542  =


    2023-04-03T12:55:39.011457  / # . /lava-9850446/environment/lava-985044=
6/bin/lava-test-runner /lava-9850446/1

    2023-04-03T12:55:39.011829  =


    2023-04-03T12:55:39.016444  / # /lava-9850446/bin/lava-test-runner /lav=
a-9850446/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accd3b7929ccb8062f783

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accd3b7929ccb8062f788
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:27.770525  <8>[   10.739344] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850438_1.4.2.3.1>

    2023-04-03T12:55:27.773618  + set +x

    2023-04-03T12:55:27.875567  =


    2023-04-03T12:55:27.976430  / # #export SHELL=3D/bin/sh

    2023-04-03T12:55:27.976649  =


    2023-04-03T12:55:28.077582  / # export SHELL=3D/bin/sh. /lava-9850438/e=
nvironment

    2023-04-03T12:55:28.077807  =


    2023-04-03T12:55:28.178747  / # . /lava-9850438/environment/lava-985043=
8/bin/lava-test-runner /lava-9850438/1

    2023-04-03T12:55:28.179083  =


    2023-04-03T12:55:28.184111  / # /lava-9850438/bin/lava-test-runner /lav=
a-9850438/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad12a0b70e97fbc62f7d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642ad12a0b70e97fbc62f=
7da
        failing since 325 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ace1f715bfb5aac62f76d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ace1f715bfb5aac62f772
        failing since 76 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-03T13:01:02.854219  <8>[    9.996826] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3467643_1.5.2.4.1>
    2023-04-03T13:01:02.964089  / # #
    2023-04-03T13:01:03.067644  export SHELL=3D/bin/sh
    2023-04-03T13:01:03.068702  #
    2023-04-03T13:01:03.170796  / # export SHELL=3D/bin/sh. /lava-3467643/e=
nvironment
    2023-04-03T13:01:03.171768  =

    2023-04-03T13:01:03.273970  / # . /lava-3467643/environment/lava-346764=
3/bin/lava-test-runner /lava-3467643/1
    2023-04-03T13:01:03.275843  =

    2023-04-03T13:01:03.276451  / # <3>[   10.353253] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-03T13:01:03.280381  /lava-3467643/bin/lava-test-runner /lava-34=
67643/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accc13a1f00233962f7b2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accc13a1f00233962f7b7
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:17.326432  + set +x

    2023-04-03T12:55:17.332808  <8>[    9.995105] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850363_1.4.2.3.1>

    2023-04-03T12:55:17.437036  / # #

    2023-04-03T12:55:17.538067  export SHELL=3D/bin/sh

    2023-04-03T12:55:17.538304  #

    2023-04-03T12:55:17.639257  / # export SHELL=3D/bin/sh. /lava-9850363/e=
nvironment

    2023-04-03T12:55:17.639449  =


    2023-04-03T12:55:17.740353  / # . /lava-9850363/environment/lava-985036=
3/bin/lava-test-runner /lava-9850363/1

    2023-04-03T12:55:17.740659  =


    2023-04-03T12:55:17.745260  / # /lava-9850363/bin/lava-test-runner /lav=
a-9850363/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accc23a1f00233962f7c9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accc23a1f00233962f7ce
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:15.956018  <8>[   10.645531] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850433_1.4.2.3.1>

    2023-04-03T12:55:15.959338  + set +x

    2023-04-03T12:55:16.065210  #

    2023-04-03T12:55:16.168197  / # #export SHELL=3D/bin/sh

    2023-04-03T12:55:16.168883  =


    2023-04-03T12:55:16.270484  / # export SHELL=3D/bin/sh. /lava-9850433/e=
nvironment

    2023-04-03T12:55:16.270687  =


    2023-04-03T12:55:16.371518  / # . /lava-9850433/environment/lava-985043=
3/bin/lava-test-runner /lava-9850433/1

    2023-04-03T12:55:16.371800  =


    2023-04-03T12:55:16.377150  / # /lava-9850433/bin/lava-test-runner /lav=
a-9850433/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642acce0b7264a411162f7b9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642acce0b7264a411162f7be
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:41.894518  + set<8>[   11.343863] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9850329_1.4.2.3.1>

    2023-04-03T12:55:41.894611   +x

    2023-04-03T12:55:41.999008  / # #

    2023-04-03T12:55:42.099994  export SHELL=3D/bin/sh

    2023-04-03T12:55:42.100189  #

    2023-04-03T12:55:42.201071  / # export SHELL=3D/bin/sh. /lava-9850329/e=
nvironment

    2023-04-03T12:55:42.201269  =


    2023-04-03T12:55:42.302163  / # . /lava-9850329/environment/lava-985032=
9/bin/lava-test-runner /lava-9850329/1

    2023-04-03T12:55:42.302459  =


    2023-04-03T12:55:42.306844  / # /lava-9850329/bin/lava-test-runner /lav=
a-9850329/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accd5645d8beec162f7b2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-90-g2aa39169cd26/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accd5645d8beec162f7b7
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.104-1=
47-gea115396267e)

    2023-04-03T12:55:27.415209  <8>[    8.728561] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850367_1.4.2.3.1>

    2023-04-03T12:55:27.519796  / # #

    2023-04-03T12:55:27.620915  export SHELL=3D/bin/sh

    2023-04-03T12:55:27.621169  #

    2023-04-03T12:55:27.722081  / # export SHELL=3D/bin/sh. /lava-9850367/e=
nvironment

    2023-04-03T12:55:27.722317  =


    2023-04-03T12:55:27.823112  / # . /lava-9850367/environment/lava-985036=
7/bin/lava-test-runner /lava-9850367/1

    2023-04-03T12:55:27.823451  =


    2023-04-03T12:55:27.828161  / # /lava-9850367/bin/lava-test-runner /lav=
a-9850367/1

    2023-04-03T12:55:27.833777  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
