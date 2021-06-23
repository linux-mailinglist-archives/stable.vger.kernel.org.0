Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8401C3B1FDF
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWRyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 13:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWRyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 13:54:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A36C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 10:52:28 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a2so2398577pgi.6
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W8ABT0jwYjltx+zIbrQDOR9iSIqbxqm1ZJMI4psESXE=;
        b=uixDtMxN9crkjBZK0aTaF9bENZF2Feb++t/6rTWEcO8QnxfiFJXu9gZdPVlhnnedwO
         BPfC9iZ1OxfQf923KvbrO+3+Z0ghmeFGZ+RJODA8C46+UeJR7HnSa3/6+tbaF4wA5YDe
         I8PcGStBngEjeN/akFcadYV3Cmrd8IdGPR6Knnk51V7PmBsa4cuqbdNXitTmp9DxnJ6i
         9WCGYZUpqH+j+IFq8uClcsfyCwN5aB2/N22pnkoC8qzP3PHUqXpjVS4231S+BTmCzf5Y
         IZEmklbj4kvxa1Pof4zEJHMlIGQPctrQZoeHwSZkAv3Fyo/Yrn+h10mQ8TzCnIVHhPvm
         mk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W8ABT0jwYjltx+zIbrQDOR9iSIqbxqm1ZJMI4psESXE=;
        b=ujFFEEng8uUaJDU+uHSuaAr/6FxPhRqp+VRa6EZNqSy4uQK42momfb1ZctfJecmOyS
         1uPzdo3sGEiUJyVZQNP6ZUJf3ad2FAoAfsIwyVl+DHcOZOk6cPGxixvzNQTB4WjZFiJT
         hxoXwHzJ/Hx8tsAO/mwcvJcYpRcn0dzaIHtlsO+UK3J43hJ+KMCseAyD0XfLJ2CqyBZt
         c+0DqL39rL44FbaB6zapSGhyAEGvkN9TJpn/c9vl3e7CIX220Cye3vgo/AQuQ+h9wwcC
         rDREs+SlPOZC1zrKA381hKTWG2hGOFo6bCg9Yl9RGFvZI6iEEYKylyBeoGpm2JkFizzR
         odog==
X-Gm-Message-State: AOAM530QatjhIKhMe2evi1ikkhrC9Xc1yp6UUoJcIA7ylQXs5v8emoqG
        p4EUALXTTXAFuCzrqX3YaRhuclptRRULLBBH
X-Google-Smtp-Source: ABdhPJwSFaVNKhtxVANRsG8aByKNA1OIItPNPvYvpMUtPYfqSZGwg/C6OGQHvkUgPaTztCKbbPadXA==
X-Received: by 2002:a65:6914:: with SMTP id s20mr620161pgq.420.1624470747281;
        Wed, 23 Jun 2021 10:52:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y190sm506053pfc.85.2021.06.23.10.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 10:52:26 -0700 (PDT)
Message-ID: <60d374da.1c69fb81.3c2ae.197a@mx.google.com>
Date:   Wed, 23 Jun 2021 10:52:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 184 runs, 4 regressions (v5.10.46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 184 runs, 4 regressions (v5.10.46)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre | gcc-8    | defconfig          |=
 1          =

bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig  |=
 1          =

beaglebone-black   | arm   | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig          |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.46/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3de043c6851d7c604e0cabdf8e2aca7797952aa9 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d33d0dadc76515af413266

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60d33d0dadc76515=
af413269
        new failure (last pass: v5.10.44)
        2 lines

    2021-06-23T13:53:58.984645  / # =

    2021-06-23T13:53:58.995185  =

    2021-06-23T13:53:59.098516  / # #
    2021-06-23T13:53:59.106928  #
    2021-06-23T13:54:00.366718  / # export SHELL=3D/bin/sh
    2021-06-23T13:54:00.377211  export SHELL=3D/bin/sh
    2021-06-23T13:54:01.999298  / # . /lava-479370/environment
    2021-06-23T13:54:02.014932  . /lava-479370/environment
    2021-06-23T13:54:04.962432  / # /lava-479370/bin/lava-test-runner /lava=
-479370/0
    2021-06-23T13:54:04.973736  /lava[   30.026277] hwmon hwmon1: Undervolt=
age detected! =

    ... (11 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d33ffe21135406df41328d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d33ffe21135406df413=
28e
        new failure (last pass: v5.10.43) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
beaglebone-black   | arm   | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d342378ca4f70a644132fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d342378ca4f70a64413=
2fc
        new failure (last pass: v5.10.44) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d33e48e9a453d9f141327a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.46/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d33e48e9a453d9f1413=
27b
        failing since 25 days (last pass: v5.10.40, first fail: v5.10.41) =

 =20
