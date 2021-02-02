Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D573F30CC5D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbhBBTxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbhBBTvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 14:51:50 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536D2C061788
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 11:51:35 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o16so15599692pgg.5
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 11:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q61LegwSjDFUxhdqhvntuyszxDZZzD9PKQubcmz2SQk=;
        b=dOYg8UyFdVoCHL5ybZuFaJrf9RU921VvSNhl7MkkxnYkJXJHyh1nP2gnNx8YxYNssp
         YK7Z6EG+AZLBfDtUlzjKnafCHl7ThEZI0ZHlFEp5hTWyNXADob/dH5Ik+kdzhvMGfshG
         0QWwdpkqv9ZWUlnmevsAWmTNfy/29ykgQj8JBFqA5503ZM7FtmYPhCABxJ2xyT5erC6m
         8KLjUCvXyaUnhX+0jtrBUlz0wVI6KbOGMcBkGEwuVZmwUY+Dp6brxC1ZrfegapSyFO1A
         hczxSrmXsLFZJxtpyzVQ0R1aj3h6dis0zy7GyHQsGznOw8sD6ePcDmWUz+HR1PD5vOIQ
         GKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q61LegwSjDFUxhdqhvntuyszxDZZzD9PKQubcmz2SQk=;
        b=O5zjGcfddl29G1N8uBunZzAvjn3bHpwOz2oWIOwj209jJr+nPnEBjC1sKeH1cGv0lV
         /+nerTUjonwCT6uKvn0a5rhgOjggcD7josZcuixjqLA8uh4FlelhN+mo8Hjbw9s42WHj
         YilqYi+IUGITl8hw6xh+cdT2CdUcC0EJiDUpDzotzCz4wc2u4t3eCyJ1yqTL//bHN/wZ
         jLMX5AZH89gS9PgWbwy+emyGArTXPPNcBbvZmkm4ShMhEfJt4XlhfEptR2BW37VmBtzn
         GqMbcQMAvJzbQ87nDUS1//d6rROTghmcPqmIC+n2XpkJhb0HYpzwsKZN1h+n8SZZMLae
         s8NQ==
X-Gm-Message-State: AOAM53041oopL6lWvqdlQo5cLYHB2RDM58+Im1jeM3mNvvAhbjOuiQvV
        j/Iaeeublpk+dL7ije1mbkeCO0BMDE3zdA==
X-Google-Smtp-Source: ABdhPJwP3xQzRtCWBpbXpwqJo1ilvW/ZAZZC2uAhFdyverteEAGGXJSmrgi8hx7VgRSJBE8GdC99lQ==
X-Received: by 2002:a63:7f09:: with SMTP id a9mr23187626pgd.63.1612295494388;
        Tue, 02 Feb 2021 11:51:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r194sm22757311pfr.168.2021.02.02.11.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:51:33 -0800 (PST)
Message-ID: <6019ad45.1c69fb81.8857e.53ab@mx.google.com>
Date:   Tue, 02 Feb 2021 11:51:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.218-31-g17dd434cff6b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 138 runs,
 13 regressions (v4.14.218-31-g17dd434cff6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 138 runs, 13 regressions (v4.14.218-31-g17=
dd434cff6b)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
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

qemu_i386-uefi       | i386  | lab-collabora   | gcc-8    | i386_defconfig =
     | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 6          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.218-31-g17dd434cff6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.218-31-g17dd434cff6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17dd434cff6bcaf79221b1a890a9df7ea23a3bd7 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/601979239845a138a43abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601979239845a138a43ab=
e63
        failing since 308 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019720f4171ff7aa13abe71

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019720f4171ff7aa13ab=
e72
        failing since 80 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019720dea04ed6d1e3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019720dea04ed6d1e3ab=
e63
        failing since 80 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60197217ea04ed6d1e3abe76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60197217ea04ed6d1e3ab=
e77
        failing since 80 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601971c796e58096ef3abe75

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601971c796e58096ef3ab=
e76
        failing since 80 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019acbeb4572b8ff33abe78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019acbeb4572b8ff33ab=
e79
        failing since 80 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_i386-uefi       | i386  | lab-collabora   | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/601974553965892f523abe8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601974553965892f523ab=
e8d
        new failure (last pass: v4.14.218-17-g14278d4b38e29) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 6          =


  Details:     https://kernelci.org/test/plan/id/60197b3d88163bb9f93abe97

  Results:     59 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-31-g17dd434cff6b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-i2c-tunnel-driver-present: https://kernelci.org=
/test/case/id/60197b3d88163bb9f93abe9d
        new failure (last pass: v4.14.218-6-gd4c2cced9de43)

    2021-02-02 16:17:56.864000+00:00  [   14.305680] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-i2c-tunnel-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-i2c-tunnel-probed: https://kernelci.org/test/ca=
se/id/60197b3d88163bb9f93abe9e
        new failure (last pass: v4.14.218-6-gd4c2cced9de43)

    2021-02-02 16:17:57.904000+00:00  [   15.346163] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-i2c-tunnel-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-driver-present: https://kernelci.org/test/=
case/id/60197b3d88163bb9f93abe9f
        new failure (last pass: v4.14.218-6-gd4c2cced9de43)

    2021-02-02 16:17:58.943000+00:00  [   16.384805] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-keyb-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
60197b3d88163bb9f93abea0
        new failure (last pass: v4.14.218-6-gd4c2cced9de43)

    2021-02-02 16:17:59.976000+00:00  [   17.419126] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60197b3e88163bb9=
f93abedc
        new failure (last pass: v4.14.218-6-gd4c2cced9de43)
        1 lines

    2021-02-02 16:17:17.857000+00:00  [Enter `^Ec?' for help]
    2021-02-02 16:17:29.081000+00:00  =EF=BF=BD
    2021-02-02 16:17:29.081000+00:00  =

    2021-02-02 16:17:29.081000+00:00  coreboot-7d042db9 Mon Oct 22 20:40:09=
 UTC 2018 bootblock starting...
    2021-02-02 16:17:29.082000+00:00  Exception handlers installed.
    2021-02-02 16:17:29.092000+00:00  Configuring PLL at ff760030 with NF =
=3D 99, NR =3D 2 and NO =3D 2 (VCO =3D 1188000KHz, output =3D 594000KHz)
    2021-02-02 16:17:29.105000+00:00  Configuring PLL at ff760020 with NF =
=3D 32, NR =3D 1 and NO =3D 2 (VCO =3D 768000KHz, output =3D 384000KHz)
    2021-02-02 16:17:29.105000+00:00  Translation table is @ ff700000
    2021-02-02 16:17:29.118000+00:00  Mapping address range [0x00000000:0x0=
0000000) as uncached
    2021-02-02 16:17:29.118000+00:00  Creating new subtable @ff720800 for [=
0xff700000:0xff800000) =

    ... (845 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60197b3e88163bb=
9f93abede
        new failure (last pass: v4.14.218-6-gd4c2cced9de43)
        37 lines

    2021-02-02 16:17:52.913000+00:00  kern [   10.351676] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D37>   =

 =20
