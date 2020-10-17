Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B3C29136B
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 20:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437954AbgJQSIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 14:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411020AbgJQSIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 14:08:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C34C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 11:08:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w11so2905058pll.8
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 11:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IhiUAGPFccgT84hkHtg1P5B8ysxy88O7ld/L5sT1oAk=;
        b=PZ+w+6MBlRiOY/9e6oe/fdVlYVCTUWwtTk7qedIHBphMZHiprhjYktM6bIbsuw7CeZ
         6UUwA3mkkGSPVN3kSUyufljFB4QDu+wxKImtis+rVJU29t6hLUYb2H4Qnf1a67oW7ste
         BSPl8Lmlk+VePM5/jNIG/WtWbcSrcxo89gLMm4iShH8n8JUBGQKw8lPmvOF2C5582+s+
         AczS17NRgSrXwZgfzrlU2D0Q/vU3ELIvzFaJDPMQOWAuHJRiJfpeXnqUy+xaiGtKPbph
         dSVBj33h+9WvJKPGKCxJV12VW3P4Sz4RmC7UdU/0ibfF/2naRrRBbnhzHsK96eMZ7Jqn
         PwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IhiUAGPFccgT84hkHtg1P5B8ysxy88O7ld/L5sT1oAk=;
        b=tTGNTF6+DwJM+oLHmALFVCNw8l2df6q6yTbK0aS+D0PgIMbEjWH10fF9QFrA3M3wrl
         GOhwDlRSnQ/k6iux4wP4daTU6ctIvLebhY5xC7zmNtQeXe8Uw9ifPnT8P2DefIa0uqFt
         3+qKx/IkO267nuzh8PGRVDZQtfy7OuDgIjX/wt6E7sIXoKL2l96T7oIkNhEG0kH3MmUP
         Ij0Nl0k1TipmRskGTsVXIWNtmwigSVOzmMd36FyQs6HjPANgQfITGQhiSQmpwHajDWPp
         u+DWXzaPq61AVI3XvgGVRCIJM6QK7VYbPaNy11RpjthNQgHUxLkFW+7SJjGYTvZZTe0y
         DxZw==
X-Gm-Message-State: AOAM533yGeqdbbue7gR29r4xOZ2o4bdC+6usVdt5MkCPr2eWx053lNl9
        CceEntuwsD1TqsKEk7d/OO2ni/M5Mz/oeQ==
X-Google-Smtp-Source: ABdhPJy9Y0I5VCyaJizmz4atEgfqgikl/qwqYqGiPVH+ul3gb01felVrMy/1QRLImx6EbC/G1JPoww==
X-Received: by 2002:a17:90b:3649:: with SMTP id nh9mr9883816pjb.123.1602958123988;
        Sat, 17 Oct 2020 11:08:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q66sm6535205pfc.109.2020.10.17.11.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 11:08:43 -0700 (PDT)
Message-ID: <5f8b332b.1c69fb81.77d11.deaf@mx.google.com>
Date:   Sat, 17 Oct 2020 11:08:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.152-16-g2fac1e5e3bc9
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 151 runs,
 3 regressions (v4.19.152-16-g2fac1e5e3bc9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 151 runs, 3 regressions (v4.19.152-16-g2fa=
c1e5e3bc9)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =

hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig  |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.152-16-g2fac1e5e3bc9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.152-16-g2fac1e5e3bc9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2fac1e5e3bc95b5cf4536eb7d0a43b9209b6ce2d =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8af8b7662a24e1284ff3ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-16-g2fac1e5e3bc9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-16-g2fac1e5e3bc9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8af8b7662a24e1284ff=
3f0
      failing since 123 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8af77087a0b571c44ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-16-g2fac1e5e3bc9/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-16-g2fac1e5e3bc9/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8af77087a0b571=
c44ff3e4
      new failure (last pass: v4.19.151-22-g5f066e3d5e44)
      1 lines

    2020-10-17 13:51:52.564000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-17 13:51:52.564000  (user:khilman) is already connected
    2020-10-17 13:52:08.351000  =00
    2020-10-17 13:52:08.351000  =

    2020-10-17 13:52:08.351000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-17 13:52:08.351000  =

    2020-10-17 13:52:08.352000  DRAM:  948 MiB
    2020-10-17 13:52:08.367000  RPI 3 Model B (0xa02082)
    2020-10-17 13:52:08.455000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-17 13:52:08.487000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig  |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8af71bc9d71d0e304ff3f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-16-g2fac1e5e3bc9/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-16-g2fac1e5e3bc9/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8af71bc9d71d0e304ff=
3f5
      failing since 88 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
