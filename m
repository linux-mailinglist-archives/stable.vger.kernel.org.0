Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0AB2BC5E6
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 14:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKVNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 08:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbgKVNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 08:54:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E1DC0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 05:54:44 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id t8so12370810pfg.8
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 05:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1AqyG8IgCE5C2lj2BYbM7ypC+0Telw10McJlGyKCQWc=;
        b=XakWNbxD3795JL7rhzswGe16h3POsuK1mBobqbJ2KNoM26HWwCLaXGWeG2iPtPoco6
         Gj3hAKDMHI7hPtSmDzCN3xOGjMXOFsiRSIe4GC/VxNa1U4/bKqMibxRI0wOcNJ0IXLv+
         dZ8FL3Tly8YwN696mkIddYfEEsF/cW6EXB5y6cQjpdEjFLoVkOp5PWwhcqzcxalGsyA6
         RjP0iJ+buaNy0nrubw/kTYS0IppxLilz3I26P7qxyBSo7lavE0p41RvMDMbLwITCgdw0
         f00yTRxBDDAwvA+v9WLvXzXEluuaHVCCFFVPh62fZTEYwJ/o5ZK2537CqE/FhUQJEX3b
         OosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1AqyG8IgCE5C2lj2BYbM7ypC+0Telw10McJlGyKCQWc=;
        b=d2F4KUQulH2VjpmIdawos2EEmJLUJ010xbd7HTzKvQJir7XIh1g1LzuZEb0qM9JOjS
         sRX7i8Li56zgFldWa1x2OG5LgyKljkvQepYhOKVo21gdCgg4PVLKmE2D0TyyY3V4G+4E
         t+xWt1KDQt4kow8TtZnXZK1rh0VLquietjMT/OF7YGQdurZLp7s1gJ+1HCqSl9GlKb3g
         LfIr2whSQvcTATZItAs+RPVuCnO+Xecl6XDqcZ/tuBwoK/84J7mDx1dGRIoriFOluwTD
         xvmYB/8lihqojyD6Zo7Don3Qf9JtfWX+d4V6uHgxy/peqI1VoPxX+tsO645sNOwXQkoS
         G9Pw==
X-Gm-Message-State: AOAM532p+/wT1FdGEjUfcfEUyg82+cLfkK7QLCR5u1ywDeidEoEX1Kr4
        JMpNOvUenmW2/OgHTzCKoL+kZc5ib+TPPg==
X-Google-Smtp-Source: ABdhPJwvcuLHtt+3SIm6F7yQys9HKNPcqSYKu3cGAXFu0D3INHAhjz/0bNjFeNXKQeZrINnFmTfYhg==
X-Received: by 2002:a63:4d5c:: with SMTP id n28mr23949242pgl.88.1606053283898;
        Sun, 22 Nov 2020 05:54:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l190sm9046371pfl.205.2020.11.22.05.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 05:54:43 -0800 (PST)
Message-ID: <5fba6da3.1c69fb81.35da7.3723@mx.google.com>
Date:   Sun, 22 Nov 2020 05:54:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 176 runs, 6 regressions (v4.19.159)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 176 runs, 6 regressions (v4.19.159)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.159/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.159
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      76bda503e6406539b1ad5adefe69d3df439ee97f =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba35046279287fafd8d938

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fba35046279287f=
afd8d93b
        new failure (last pass: v4.19.158)
        1 lines

    2020-11-22 09:51:14.573000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-22 09:51:14.573000+00:00  (user:khilman) is already connected
    2020-11-22 09:51:30.449000+00:00  =00
    2020-11-22 09:51:30.450000+00:00  =

    2020-11-22 09:51:30.450000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-22 09:51:30.450000+00:00  =

    2020-11-22 09:51:30.450000+00:00  DRAM:  948 MiB
    2020-11-22 09:51:30.465000+00:00  RPI 3 Model B (0xa02082)
    2020-11-22 09:51:30.554000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-22 09:51:30.585000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3a91b2e779a718d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3a91b2e779a718d8d=
908
        failing since 3 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3aa7edf23f554ad8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3aa7edf23f554ad8d=
911
        failing since 3 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3aa0edf23f554ad8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3aa0edf23f554ad8d=
90d
        failing since 3 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3a43c214d41957d8d923

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3a43c214d41957d8d=
924
        failing since 3 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba3a60c832794a16d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.159/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba3a60c832794a16d8d=
8fe
        failing since 3 days (last pass: v4.19.157, first fail: v4.19.158) =

 =20
