Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB2B24EF64
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 21:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgHWTNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 15:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgHWTND (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 15:13:03 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2032C061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 12:13:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v16so3175899plo.1
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 12:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BTzbxZ7FgSIaAV6SngXweY/9pKsxv9vftUR98NlLq2I=;
        b=JC2DW4TEYOJWZwCa4Lndwzpzj0PVhlaXbJ/qsVBi8uWjpeksnxz95jKGmWAqk8rb3h
         FblpgMfWxi2bjd6XWoIwQSqf3AQz5MiODH5C/7kC8taplOZrs+2VsMLKCcgCe+P/KgIh
         eh3O5Y3pQGEtWhC2pdhiAG7Gwlx5aOwOV4gcz5Ty2WGyny2TzqKKuI+9GOYywMQ6ceuL
         E5WidUVtdblWguwxgmvw2PPqVAuAdGr3Kflpwse0YaL0UBnbH5vUD7Zwqo+QtrdYFAZd
         DuscSpBtgnA3MKtvbY/H42N4Td/91UB4GQ98VpEd9s8Km/Zr0of7eloBeyzoUu5LA5bJ
         N7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BTzbxZ7FgSIaAV6SngXweY/9pKsxv9vftUR98NlLq2I=;
        b=HvB9IBNmP+ORyraz8Z2pWCmbwalst+qyLElj3Vzdf7WOyNZIiW3wDxSZc2Jaxm2y+r
         ltnVK+C8t+9YFtv82h2g913SIjIxepUqOiVjSi3kOKl65usDOf1WAdRf+fGFxfkG0eAd
         JTLBF7j/RGL61jloj4MdrvGtd2p3Bemhn6TJuvsmOhmp6byj704U0hlgFXHm+mS/4bGq
         ygA8L/QBKBJKRHqXPKXo3WqN9A126VfLRnGu+xMaGZYlQDvyypjKWfOlxI7iF4+WT9Js
         NX+bN9xwY0PjsbAvLu2AX7lu4mDhEo2Rt2jCXabGhQOsKbr7Qp88OFjzGZjOG3UgybKM
         4v6w==
X-Gm-Message-State: AOAM530539blJgztA7CRiuNkQwrx27wpj8cu1j74YizACLIbTKcayVUS
        rFqN8/1dDGjzmSWIKdOvX32msxf2MG5W4Q==
X-Google-Smtp-Source: ABdhPJyMPHwLS+lFOAp06MFrVECBMz1fuzWbk7Kofr/Jnf2GokCEPsyI9g0D1EKvBzh+FtB5Ext0sg==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr1543078plc.70.1598209980800;
        Sun, 23 Aug 2020 12:13:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b78sm9078598pfb.144.2020.08.23.12.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 12:13:00 -0700 (PDT)
Message-ID: <5f42bfbc.1c69fb81.3f089.d3f5@mx.google.com>
Date:   Sun, 23 Aug 2020 12:13:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.17-28-gafe48ff97f9b
Subject: stable-rc/linux-5.7.y baseline: 173 runs,
 3 regressions (v5.7.17-28-gafe48ff97f9b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 173 runs, 3 regressions (v5.7.17-28-gafe48f=
f97f9b)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
 | 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
 | 3/4    =

exynos5422-odroidxu3  | arm   | lab-collabora | gcc-8    | exynos_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.17-28-gafe48ff97f9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.17-28-gafe48ff97f9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afe48ff97f9bc86e17c4c8ee887eceba61d0620d =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f42891e2ae87ef87f9fb435

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
28-gafe48ff97f9b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
28-gafe48ff97f9b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f42891e2ae87ef87f9fb=
436
      failing since 38 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
 | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f4284339a583013a99fb444

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
28-gafe48ff97f9b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
28-gafe48ff97f9b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f4284339a583013=
a99fb448
      new failure (last pass: v5.7.17)
      2 lines

    2020-08-23 14:56:35.591000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-08-23 14:56:35.591000  (user:khilman) is already connected
    2020-08-23 14:56:51.155000  =00
    2020-08-23 14:56:51.155000  =

    2020-08-23 14:56:51.155000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-08-23 14:56:51.156000  =

    2020-08-23 14:56:51.156000  DRAM:  948 MiB
    2020-08-23 14:56:51.171000  RPI 3 Model B (0xa02082)
    2020-08-23 14:56:51.259000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-08-23 14:56:51.290000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (385 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
exynos5422-odroidxu3  | arm   | lab-collabora | gcc-8    | exynos_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4293e0612319fe999fb43b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
28-gafe48ff97f9b/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos54=
22-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
28-gafe48ff97f9b/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos54=
22-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4293e0612319fe999fb=
43c
      failing since 3 days (last pass: v5.7.16-99-gc5aad81e7f2d, first fail=
: v5.7.16-205-g7366707e7e99)  =20
