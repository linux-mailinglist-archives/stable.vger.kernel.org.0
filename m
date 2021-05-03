Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A191371329
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 11:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhECJsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 05:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhECJsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 05:48:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D0C06174A
        for <stable@vger.kernel.org>; Mon,  3 May 2021 02:47:46 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c17so3756454pfn.6
        for <stable@vger.kernel.org>; Mon, 03 May 2021 02:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fjjrV9mzyAx8AiGT8y+Dp9OOfmxEQUjht3R3hRSXleI=;
        b=yEQf8zPnAt6+U2VqWPMoOd669ia0vQLF4eJPvhTBtpldO3k/+qmiSty+a7V3Yu69Gz
         Cf61EaJpCpI6ZG6b0RLS21GGGfBa+FLnMUhp1xbeN0J+vpEyzFSFG0j1HlzB3RDaY3+c
         gHnlS17KqrWU7BcQ0F2qhNCnF05J8u4hBKU6BXh07iFE46ZwlWqam9d9X3Tpa2Xw4V7g
         AhT78Jig7YShO9+TGZIsoShJolZKFgxxcWlxp2SY4yw7HQDDTxKH7srZ0uHWHKlOJraU
         OfP57z5pDW/GZXZYOhBeIP41QZRW2FtY0GTwKWLJgrgIgOTbMDb3XgBCgS8ikQDpCWUz
         XFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fjjrV9mzyAx8AiGT8y+Dp9OOfmxEQUjht3R3hRSXleI=;
        b=b5SKnYoQzbVzpQoOB+ltvo0fzzi/aUTh+GSHO18oTFEF0bnMgxbodgjDh7UYVhgw2n
         lkRrRqV3h518lLOBwNQiPWxva7n1jkG3U1TVikiueSKl0e2QuxdCHeygTLcZilxhNm6k
         SAQ03h+U7Kledk7yxouW0CA8p0RhX2zY8cZOmZ/SjP1eCsNGPZHdT0dAeqqcmRofjN6s
         I0EOIzsb/iynvvA2YKfK97dAH9L0u6/Zmg65O8kDisYekZqdiaeFn1oRcJpPXo3hOLIg
         Bk4aUzIr9nCcRcmc4tjkk6HPLe5UoDVv0DR1o57jUi4s4DnfIR9MDAYrDMeaaMQUrUrP
         tEtA==
X-Gm-Message-State: AOAM532gPdfx55UTJQgPMDLNLZZGTwowJIeyyfP4J5Pxa4oOzJwtDLvG
        5K550TiL5eyj5dgw4SVrKwrLPbxnqCoG9vlZ
X-Google-Smtp-Source: ABdhPJw4SW9KGnyvwxxu5PJ3RA2IcLiUm1BQA3HzinXLa3MjMjMTiEXKyiFKJDpZtbM/qQF4RoAYKQ==
X-Received: by 2002:aa7:87d9:0:b029:28e:af66:d71d with SMTP id i25-20020aa787d90000b029028eaf66d71dmr1944645pfo.28.1620035266036;
        Mon, 03 May 2021 02:47:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w124sm8439983pfb.73.2021.05.03.02.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 02:47:45 -0700 (PDT)
Message-ID: <608fc6c1.1c69fb81.a8654.6f6b@mx.google.com>
Date:   Mon, 03 May 2021 02:47:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.232
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 149 runs, 13 regressions (v4.14.232)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 149 runs, 13 regressions (v4.14.232)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 6          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.232/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.232
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d7d1c0ab3eb7c8d8f63a126535018007823b207 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/608987aae816ecb8279b7797

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608987aae816ecb8279b7=
798
        failing since 393 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6089b8cbd42c29b3c89b77c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089b8cbd42c29b3c89b7=
7c1
        failing since 34 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60898341441b624b809b77a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60898341441b624b809b7=
7a9
        failing since 165 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608983394d010a2bb49b77aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608983394d010a2bb49b7=
7ab
        failing since 165 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60898347f24e85df5e9b77b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60898347f24e85df5e9b7=
7b5
        failing since 165 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6089b6b8efc0e8a5699b77aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089b6b8efc0e8a5699b7=
7ab
        failing since 165 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608a98b99f3c4b7d939b77ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608a98b99f3c4b7d939b7=
7ac
        failing since 165 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 6          =


  Details:     https://kernelci.org/test/plan/id/608b3b3ad38a39fcb29b7799

  Results:     59 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-i2c-tunnel-driver-present: https://kernelci.org=
/test/case/id/608b3b3ad38a39fcb29b779f
        new failure (last pass: v4.14.231-50-g3ac46322bf509)

    2021-04-29 23:03:13.399000+00:00  [   15.239038] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-i2c-tunnel-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-i2c-tunnel-probed: https://kernelci.org/test/ca=
se/id/608b3b3ad38a39fcb29b77a0
        new failure (last pass: v4.14.231-50-g3ac46322bf509)

    2021-04-29 23:03:14.440000+00:00  [   16.279339] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-i2c-tunnel-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-driver-present: https://kernelci.org/test/=
case/id/608b3b3ad38a39fcb29b77a1
        new failure (last pass: v4.14.231-50-g3ac46322bf509)

    2021-04-29 23:03:15.478000+00:00  [   17.318580] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-keyb-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
608b3b3ad38a39fcb29b77a2
        new failure (last pass: v4.14.231-50-g3ac46322bf509)

    2021-04-29 23:03:16.531000+00:00  [   18.372311] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/608b3b3ad38a39fc=
b29b77de
        new failure (last pass: v4.14.231-50-g3ac46322bf509)
        1 lines

    2021-04-29 23:02:32.953000+00:00  [Enter `^Ec?' for help]
    2021-04-29 23:02:39.974000+00:00  =EF=BF=BD
    2021-04-29 23:02:39.975000+00:00  =

    2021-04-29 23:02:39.975000+00:00  coreboot-7d042db9 Mon Oct 22 20:40:09=
 UTC 2018 bootblock starting...
    2021-04-29 23:02:39.976000+00:00  Exception handlers installed.
    2021-04-29 23:02:39.985000+00:00  Configuring PLL at ff760030 with NF =
=3D 99, NR =3D 2 and NO =3D 2 (VCO =3D 1188000KHz, output =3D 594000KHz)
    2021-04-29 23:02:39.998000+00:00  Configuring PLL at ff760020 with NF =
=3D 32, NR =3D 1 and NO =3D 2 (VCO =3D 768000KHz, output =3D 384000KHz)
    2021-04-29 23:02:39.998000+00:00  Translation table is @ ff700000
    2021-04-29 23:02:40.010000+00:00  Mapping address range [0x00000000:0x0=
0000000) as uncached
    2021-04-29 23:02:40.011000+00:00  Creating new subtable @ff720800 for [=
0xff700000:0xff800000) =

    ... (841 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/608b3b3ad38a39f=
cb29b77e0
        new failure (last pass: v4.14.231-50-g3ac46322bf509)
        37 lines

    2021-04-29 23:03:09.460000+00:00  kern [   11.287753] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D37>
    2021-04-29 23:03:09.461000+00:00   :emerg : Process udevd (pid: 108, st=
ack limit =3D 0xc348a220)   =

 =20
