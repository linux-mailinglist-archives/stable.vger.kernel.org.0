Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C442A20CD
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 19:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgKASqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 13:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgKASqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 13:46:52 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1726C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 10:46:51 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r186so8887540pgr.0
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 10:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=raPPFzpwTcFqfGLNZt+NUb5B0DnNHpANBBy3Ud8/wz0=;
        b=T0u7aTRzSVYQPfCvZ5Nmgt19U8ZfhbD8eZd01WvT2hoRld3XRZBr/eE6qBymtjyU7p
         AyTe/jw5RAk4OEXPkjWNsGZ+jbTFCk2tlxqMMs1VDy9+QvIb/kv7hxYFcQRZKW/8myKO
         xTA1yo4rtxbPdEwvc0NMj4YUMIWdvPT8yaTDQOdcp81xnqcyFmi78Q5T+MvYWzoE9Asd
         7VHvc0Fk9kobIk5bCQsD4Cu8lNh5GtnTVBKn3lwC8DLuzPfYiUcd6ZBik/VZz43LBcVi
         5J026NDbVZFDpx50KeN7kZXSodKjTo5grajBnYIQeFWHEOizMAGYZgebFdEN3k6T3LB7
         tzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=raPPFzpwTcFqfGLNZt+NUb5B0DnNHpANBBy3Ud8/wz0=;
        b=AtvNUjOKQyaw5K3QYkoxaqq2HyJgX468cFr2A3zRWMSEA0XT90t3MKaRRZcRbx57j8
         r+GhbjcOZIb55pkHPZm7yFo7qPKKcvyRddKlU8AgoBNBBNevmvcnn+Ktfw6uBfUW6VI3
         XXgoHhgIe1GOLqnM2lSX/7VfpRk/zbJP89DgNfNsM3uUS6NcbYPMhQcWIHUjeJi3xgwB
         EMk9ZEh+s0B2k5sRdn5RF2IFjfjPWANbGhyAD9JKx+paEtBHD7Ue6nNe23mdHETYtHjD
         ZRoTZALfPLlolFFhOlGGV+Af+arT84PU0utlyIO0Creigyc4yN9gHqiduZaVcUyBREkI
         2EmQ==
X-Gm-Message-State: AOAM532dhHCntEeveqqNhk/Md2ebJHmCW7u+8truFBEu8mNSk6wqBrWx
        eh/JRR/ns/FYy3r4xE0dUcrg3YHIE4EPoA==
X-Google-Smtp-Source: ABdhPJx7El8MWyjfP4UBUxi/DHXDnqgU/enVm6xGSH0VFOfQYn2wJTFNtNEm/26Vflbkc/2hSUYrUg==
X-Received: by 2002:a63:c43:: with SMTP id 3mr10857971pgm.222.1604256410773;
        Sun, 01 Nov 2020 10:46:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t30sm4510026pfg.99.2020.11.01.10.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 10:46:49 -0800 (PST)
Message-ID: <5f9f0299.1c69fb81.7a80f.cfc2@mx.google.com>
Date:   Sun, 01 Nov 2020 10:46:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 212 runs, 3 regressions (v5.4.74)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 212 runs, 3 regressions (v5.4.74)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.74/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.74
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b300b28b78145b832f1112d77035111e35112cec =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ece79ece97a582a3fe8d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ece79ece97a582a3fe=
8d4
        failing since 203 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ecd01cf372e2f643fe807

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9ecd01cf372e2f=
643fe80c
        new failure (last pass: v5.4.73-49-gbf5ca41e70cb)
        2 lines

    2020-11-01 14:56:01.401000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-01 14:56:01.401000+00:00  (user:khilman) is already connected
    2020-11-01 14:56:17.245000+00:00  =00
    2020-11-01 14:56:17.245000+00:00  =

    2020-11-01 14:56:17.245000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-01 14:56:17.245000+00:00  =

    2020-11-01 14:56:17.245000+00:00  DRAM:  948 MiB
    2020-11-01 14:56:17.261000+00:00  RPI 3 Model B (0xa02082)
    2020-11-01 14:56:17.349000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-01 14:56:17.381000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ed2859482642fb43fe7dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ed2859482642fb43fe=
7dd
        failing since 4 days (last pass: v5.4.72-55-g7fa6d77807db, first fa=
il: v5.4.72-409-gab6643bad070) =

 =20
