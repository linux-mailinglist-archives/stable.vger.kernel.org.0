Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A852E2F19
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 21:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgLZUo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 15:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLZUo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Dec 2020 15:44:56 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBECDC0613C1
        for <stable@vger.kernel.org>; Sat, 26 Dec 2020 12:44:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id v19so4977410pgj.12
        for <stable@vger.kernel.org>; Sat, 26 Dec 2020 12:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eGOUzukQnHUbLbhTjRwivLa4VuT820xnjQti6DTC3Gk=;
        b=qCKivsQYid+bsAdxAWem7vTb7IS+DyKGzqGuZduwnf8PjvJguHrNe6zAJOveLBDx7s
         UrNClQ4fSfge34qtBjHsyofW+yygeaxKhM2MMbKAcZBrXaDY96SD601RKkRze1ZxoYgL
         eQBNi1M/fQ82PfaIWPGgeUZyevFBRbORCkQ3zNOfF2XY8hE5px5lSe1dH9UfGEVkp6xH
         MZ8T+nNMp7X5nzP0r5hvj6azg2CdbiydXCsAFdCdy91cidqJspwbpt65o5ZI/F1dbH4f
         w77otMj0lbfkr5pKoZb6CIwD//P1ii6F8fUy4CojOsFP2DwqTWGmU1JHbutHSPL+z+FS
         UBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eGOUzukQnHUbLbhTjRwivLa4VuT820xnjQti6DTC3Gk=;
        b=i07V8GHcYpa0+pq5kLzdPudjFtXIkbUg5Tn0sfuZm6+TlVsBS/jZuEBuRfMHtKj8UK
         me3NVO3g+QrRRXD/oUFAFlr5ZGktR2LqPGe1Zc06tdFb5n60yaRj9hjrpgv3991ZqMZI
         L6laqmbCV69WZFjG/by8BKqye10K58KmzpxBiWGiTUyDqfbIIwDGWWt95URfA42N/s5E
         6Lyfcg4gYot0PRnHQ9F7NmQ22UWDHi+vntD5fW0sjnGfSDwmRBKBypEO4v0IX9DZ7Bhx
         a/rKRQq1ntWOtdLD62vVPRPd31SC80ZSz+q8EutuPv/WUyzPrBXFnbgDkkzWA9uP+qy6
         he9w==
X-Gm-Message-State: AOAM531xX+9BlqyfUiS0xaI7y4LEnH74Xxm+ubOZGfpc5SRUrIywY+CB
        RS06la0phQyJPdC7wIkz139b4ZMPnoPQ0Q==
X-Google-Smtp-Source: ABdhPJyphwtsJ/wDKfa2ElkyauCc9wF90TyH9FPJTuiIs61egbu8+Hu3B/zHLe7p9Aye0teRjemKGw==
X-Received: by 2002:a63:101e:: with SMTP id f30mr38138923pgl.95.1609015454942;
        Sat, 26 Dec 2020 12:44:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gp17sm8573461pjb.0.2020.12.26.12.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 12:44:14 -0800 (PST)
Message-ID: <5fe7a09e.1c69fb81.1fa2a.74c3@mx.google.com>
Date:   Sat, 26 Dec 2020 12:44:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-64-gd1d766b4bd93
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 142 runs,
 8 regressions (v4.14.212-64-gd1d766b4bd93)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 142 runs, 8 regressions (v4.14.212-64-gd1d76=
6b4bd93)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
fsl-ls2088a-rdb            | arm64 | lab-nxp       | gcc-8    | defconfig  =
         | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxm-q200             | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-64-gd1d766b4bd93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-64-gd1d766b4bd93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1d766b4bd938346c08816ba59293b498e6168f0 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
fsl-ls2088a-rdb            | arm64 | lab-nxp       | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe770b81b0aaf2c91c94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe770b81b0aaf2c91c94=
cc2
        new failure (last pass: v4.14.212-64-gcedad771847f) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe76f18abe3809888c94d10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe76f18abe3809888c94=
d11
        new failure (last pass: v4.14.212-64-gcedad771847f) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxm-q200             | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe77755fb3e1d7dbec94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe77755fb3e1d7dbec94=
cbb
        failing since 18 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe76dcbdbe240647fc94cb9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe76dcbdbe2406=
47fc94cbe
        failing since 2 days (last pass: v4.14.212-63-g127b6f13142d, first =
fail: v4.14.212-64-g95f3ecbc0c1f)
        2 lines

    2020-12-26 17:07:19.263000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2020-12-26 17:07:19.276000+00:00  [   20.790222] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe76dccd36ca68f0cc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe76dccd36ca68f0cc94=
cba
        failing since 42 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe76de487c3554dcbc94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe76de487c3554dcbc94=
cc1
        failing since 42 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe76dd7dbe240647fc94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe76dd7dbe240647fc94=
cd4
        failing since 42 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe76da4e99329fe67c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gd1d766b4bd93/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe76da4e99329fe67c94=
cc7
        failing since 42 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
