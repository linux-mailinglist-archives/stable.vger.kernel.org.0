Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2832912A1
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 17:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438250AbgJQP3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 11:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391902AbgJQP3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 11:29:09 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3299C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 08:29:08 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y1so2788247plp.6
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 08:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31v1GtKAsZDteog+Sy1RdW31BHcDSCJGEBqwy7Ym01k=;
        b=MJOQNylN9lB8G1m1aPh6/5JDH5hdGD+HJxz2rmLdzWjYLJYWgejLq8kqIx0AkvUTYx
         u3c/aU7GO8auA/ofvmlXGiU4hAB3FyenhSdMJNdcVzkreioMD6Wyp2KT3UR/f5eoyRqe
         C3Y+xX+DwJUDwlO/L19RJnnbXKICB9AslaWsPQkl9IgGv6BtxSuM+WUFkRkXslKC0Qb0
         yECIv5eWCqmWTgSZEGMC9pcpY/eALYV8pGs3jZZ7QG6RNMvXUxyM9mocIbUkfkhdhcWf
         tfC7vMMXoO6Ki73NSPgqC4yHzJc0K235zPkXre4x8BQjt3G1TCOxsKSK8mPFx0QlhKa6
         dYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31v1GtKAsZDteog+Sy1RdW31BHcDSCJGEBqwy7Ym01k=;
        b=HEjr2x/4O95oF5CHrADjbIB1HtUwikPV1BNe81BajCKxouz4SeZ7AFg9U+Mxb81YdA
         NiVzn+eBb3H/KJzzv/gCXLYpRqtvyCJCNQiKSWxL4881sHMC97ADuEmEp6Fo8Ehh6wj3
         /j1M8Q10oGH3oXX7YigP0ADWyBLGoNwZSj/OqDiPFNlqpvEPs7I7iP8TCvE3UVthrXjO
         8xVQyuq71K+NOYShqqIDFh9WfoLNUeOfNIQeLHPoBBmyBNasUjVUEk5I0exxVmHmTFzE
         a1ZRWQ4pWSfPfzrHfrF93fTp0fCRG5o6vnTD+/MGO9lz6GGD7NaMnZ+obY/685c1gceB
         Y0ig==
X-Gm-Message-State: AOAM530P6UsuvZOdpJyQI5pHlgQdM8me2BdEGskk+hH6hwT3vrR4nmny
        DMqFZZmTfK37JAK8fs6RgT9ZVDVnSYhxxg==
X-Google-Smtp-Source: ABdhPJwMX/9Ny91kD1cBIAJ2hnEWR/S9DwEpHB6oarlwHlscf/UWOgxkD9xjx7pC5V+jA8MZ2cTUTA==
X-Received: by 2002:a17:902:74c4:b029:d5:c724:7850 with SMTP id f4-20020a17090274c4b02900d5c7247850mr7935044plt.45.1602948548131;
        Sat, 17 Oct 2020 08:29:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jy19sm6648012pjb.9.2020.10.17.08.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 08:29:07 -0700 (PDT)
Message-ID: <5f8b0dc3.1c69fb81.1a08f.e1c7@mx.google.com>
Date:   Sat, 17 Oct 2020 08:29:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.152
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 180 runs, 2 regressions (v4.19.152)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 180 runs, 2 regressions (v4.19.152)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =

hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.152/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.152
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ad326970d25cc85128cd22d62398751ad072efff =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8ad107107eb4a31d4ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.152/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.152/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8ad107107eb4a3=
1d4ff3e4
      failing since 2 days (last pass: v4.19.150, first fail: v4.19.151)
      1 lines

    2020-10-17 11:08:10.782000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-17 11:08:10.782000  (user:khilman) is already connected
    2020-10-17 11:08:25.852000  =00
    2020-10-17 11:08:25.853000  =

    2020-10-17 11:08:25.868000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-17 11:08:25.868000  =

    2020-10-17 11:08:25.868000  DRAM:  948 MiB
    2020-10-17 11:08:25.900000  RPI 3 Model B (0xa02082)
    2020-10-17 11:08:25.976000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-17 11:08:26.008000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8ad3fd86697c57424ff410

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.152/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.152/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8ad3fd86697c57424ff=
411
      failing since 93 days (last pass: v4.19.124, first fail: v4.19.133)  =
=20
