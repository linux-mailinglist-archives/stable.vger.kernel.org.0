Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90EA2CC8B3
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 22:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgLBVLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 16:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgLBVLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 16:11:08 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2349CC0613D6
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 13:10:28 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id s21so2024150pfu.13
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 13:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vWTy8i+FpRFEvPwy0tR7SgLlx+XMM+TkS+y4ELAkd88=;
        b=hx3iZ4Sac3sviGuul3pQZNFBIkfDB6F0femNTd4mLNPr1wJ7FzNXxMfeUAe/m57Dm4
         Hqdh8Z4+Hsnpe4yoS5X4l6GrMURMJE11PacpKs+ssZltep9ZZxsVRs+a8KsJbonsnvbR
         iYtG1o1S4QTnXWvL5P242dslPYQVtYX/wHDT3gLDxqGBYd17IvctcEm3uxiPVLuFqLP/
         uvJFDxDTXW2cRlo3Iexsy9NyD3TrR87wCjzEUzKCaeS3XPblfgj/NWOsRpB2updyk+ts
         rgrdshRFNwXALWpx2wMl+/C5qgcc2XJ+WJJWinM6JXIYNgNxIqwGZzQ6YCQ8d4jPBvCO
         YvvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vWTy8i+FpRFEvPwy0tR7SgLlx+XMM+TkS+y4ELAkd88=;
        b=npIPfqZBRzuDJvl9f9KwdkTPPINW2SbzgZ0RbwXSiD3DDOyqNVy5IIpzph17rkPqoo
         z+zFqD+F/8AIM6A7W/E19FZUxDV2QtTPrtF4faTV4jCkk5Azq8LVjX3yTVO9zxHQ5Ynb
         76tB8HPXF6Gjz+mJrcieYS2l7+9fqUjg34tVQIu7nvMfZnK59Y9BTYvYcq6Ig/38hPc1
         OIHXIcEwg+LpXHPM+pNDqjhccLBkalTQlthZ3ypa1o4tXmyocoxwYsvYpBucqfGJRgvC
         EMm2Zacei6fsGwx7GN3igu47z1BGh/lvTQjVdFVlSjPsUq9Jb9WPKowDTLC33PWJBmSY
         GW5Q==
X-Gm-Message-State: AOAM532l66EFn43WDaFk5wRFW32LoXorM4hBIGgPXRL6dZvODnt3neCX
        5wCLCIK3hf6L6kAOfxidtY3TtGnuCt/MWQ==
X-Google-Smtp-Source: ABdhPJzalo81C5IjFKJ5tkiuCxEcVLTJtIeBq8f0BE3KAEcfVZqM6B5SjU9GbKOcFp2F7iX4sTOVew==
X-Received: by 2002:a63:1764:: with SMTP id 36mr117765pgx.177.1606943427160;
        Wed, 02 Dec 2020 13:10:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v63sm10452pfb.217.2020.12.02.13.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:10:26 -0800 (PST)
Message-ID: <5fc802c2.1c69fb81.38971.010a@mx.google.com>
Date:   Wed, 02 Dec 2020 13:10:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.247-4-ga92d60286ae0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 115 runs,
 11 regressions (v4.4.247-4-ga92d60286ae0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 115 runs, 11 regressions (v4.4.247-4-ga92d602=
86ae0)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.247-4-ga92d60286ae0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.247-4-ga92d60286ae0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a92d60286ae07c7ab66489baeb8e904999b946ab =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d1c37f581682ffc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-c=
ubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-c=
ubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d1c37f581682ffc94=
cc4
        new failure (last pass: v4.4.246-23-g70e42e8a6e823) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d142fefe91417fc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d142fefe91417fc94=
cc4
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d2b8a722f6b428c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d2b8a722f6b428c94=
cba
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d15f0847e0efb4c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d15f0847e0efb4c94=
cbe
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d85bec6b7e991cc94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d85bec6b7e991cc94=
cd4
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d14cfefe91417fc94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d14cfefe91417fc94=
cd0
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d12a9d48f9ffbec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d12a9d48f9ffbec94=
cba
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d17cee7b951beec94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d17cee7b951beec94=
cbe
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d1455f7a46d4adc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d1455f7a46d4adc94=
cba
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d6917c34cee262c94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d6917c34cee262c94=
ce7
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7d14b5f7a46d4adc94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-ga92d60286ae0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7d14b5f7a46d4adc94=
cbf
        failing since 18 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =20
