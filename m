Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E7C34B9EE
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 23:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhC0W3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 18:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhC0W2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 18:28:46 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C5DC0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 15:28:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id ay2so2615279plb.3
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 15:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UlLAmpDGdutif95FklWVAhTDgJD8Zedv87rcf/MKkbY=;
        b=uU2zEua4ZGpP519Q9v5KumJcJd+ytYTz+q7e94UltVayVhALn4n+Efo2ADViqXjYRt
         zlBujCS4/0WO/VmeO5QpGy9dFM271dbCbyfNH8SCjWWoxypnlS3vPOGz6jRg54EoG3Sh
         AdkC1xjJw6wc3/aRLHnMAoRT+W4Lk9FjjecKENlplh3h+4/EIHhCfpcgIlQtnE4cKayy
         Ii8Djth/OOcNeyikWJwWVoXxyqnWzeGDP+IG/Kn8Oc3IbJDSrDC+6El/NHmjMLcM9CG7
         92rNkfV416GYzg/t6Zxmd0QdEZo948mWUZeazXjZSQwTELFKqxN6SsHTPzUTFCxnepw7
         xJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UlLAmpDGdutif95FklWVAhTDgJD8Zedv87rcf/MKkbY=;
        b=pQTE4jzitmr72MsXrLFzToEgNe4ChWczMH6iuQunLlOgJ294NiCdHNM/BVFYVMlbWN
         f2o1FfRWcWKoBSwaUM5yXENPNI4kZ7bowAc8N3IFPUyfGfomlkX7NikYOzFyOZgiNvZn
         lRsgim/7jcWK2U9V5+DLLHLrTCu5G+5WqMbd9M8LZdcqQi4ZDBYQ9EWQX16T1EItnVkE
         uKUYZaHSKDk8GxpaPNpDFAKUcFlt9VZZI/fuUt5JEEdntXgeIhIDKT+tiuDaF453D02L
         aJLvThBNOkX3BopQPEsIAfidT8GNQEBvLuKuhbJnQB9bbf9vkrb42P0TiW3SsG0FI93U
         bMBw==
X-Gm-Message-State: AOAM531VTW1AAMUfXkn2wLvQC9FfNI6FGhSwmJcRdWO5Do4kSfUiQyLY
        fMg86fNPoyt6uzoSTGz2zP4bf6D1lcrpQg==
X-Google-Smtp-Source: ABdhPJxgk7tqeomF0ZDlEiRVC280XIxcZkD0yS6g0a9mka73oI0dMuTaH9XGRm+Zu13QiVRFiOpRPg==
X-Received: by 2002:a17:90a:8913:: with SMTP id u19mr19929008pjn.59.1616884125700;
        Sat, 27 Mar 2021 15:28:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2sm11992484pgf.93.2021.03.27.15.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 15:28:45 -0700 (PDT)
Message-ID: <605fb19d.1c69fb81.6260e.d9f9@mx.google.com>
Date:   Sat, 27 Mar 2021 15:28:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-33-ga28c71697fc5a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 132 runs,
 7 regressions (v4.19.183-33-ga28c71697fc5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 132 runs, 7 regressions (v4.19.183-33-ga28=
c71697fc5a)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.183-33-ga28c71697fc5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.183-33-ga28c71697fc5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a28c71697fc5a68a07fa87c1b5917bf04913a1ec =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =


  Details:     https://kernelci.org/test/plan/id/605f78e6190b50d835af02ae

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/605f78e6190b50d=
835af02b4
        new failure (last pass: v4.19.183)
        7 lines

    2021-03-27 18:26:35.260000+00:00  kern  :alert :   ESR =3D 0x86000004
    2021-03-27 18:26:35.260000+00:00  kern  :alert :   Exception class =3D =
IABT (current EL), IL =3D 32 bits
    2021-03-27 18:26:35.260000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-03-27 18:26:35.260000+00:00  kern  :alert :   EA =3D 0, S1P<8>[   =
45.288217] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D3>
    2021-03-27 18:26:35.260000+00:00  TW =3D 0
    2021-03-27 18:26:35.260000+00:00  kern<8>[   45.297070] <LAVA_SIGNAL_EN=
DRUN 0_dmesg 40868_1.5.2.4.1>
    2021-03-27 18:26:35.260000+00:00    :alert : [ffdf000008a146a8] address=
 between user and kernel address ranges   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605f78e6190b50d=
835af02b5
        new failure (last pass: v4.19.183)
        3 lines =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f79ffe01a83f288af0326

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605f79ffe01a83f=
288af032d
        failing since 4 days (last pass: v4.19.182, first fail: v4.19.182-4=
4-g155590e98805)
        2 lines

    2021-03-27 18:31:22.960000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/99
    2021-03-27 18:31:22.969000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-27 18:31:22.988000+00:00  <8>[   22.686279] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f763e43c47ec4e5af02b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f763e43c47ec4e5af0=
2b5
        failing since 129 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f7630fb4e2d029caf02c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f7630fb4e2d029caf0=
2c9
        failing since 129 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f75ccf56315ba4baf02d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f75ccf56315ba4baf0=
2d2
        failing since 129 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605fb031beb1a7af0eaf02b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
83-33-ga28c71697fc5a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605fb031beb1a7af0eaf0=
2b3
        failing since 129 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
