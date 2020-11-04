Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405652A5D25
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 04:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgKDDg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 22:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgKDDg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 22:36:58 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108DCC061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 19:36:58 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o3so15353118pgr.11
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 19:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QoueTbnlbThk8PAdy3iFz7GnbQWJYuX5AHqZC2lbzfk=;
        b=UWdMXAZyvQVska6jQBsZMXbv9b5rj5LNejJ0I6gOcRK3JJnBUwI9h4fDEcvZUQHcVu
         MIwmgTm9tWHjjbKrQtaFRK/eq8GUYNS5HwUe56MaDG2bd0OnZvA9xbf7Y/Ln0QqXrw7M
         lJpUV5lUm4E2XKocpNXiwJa2xxMpV45d9Bfi/PzQIt3nHNFAAtP2BbtBsjRJTsgOH4JY
         u7VhgGpE4bx7OAvwl4hQY8M6YdsLaEoAJnQYl6i9t43WD8oX3F+e2KTbVp7z53J1WhAE
         VNoxRBNzthzdZ+4VEnLpW6RWFD9uR5ODd+TXhCGEb+640AOdGcBT3fdHYvUm0wwgBiya
         AzeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QoueTbnlbThk8PAdy3iFz7GnbQWJYuX5AHqZC2lbzfk=;
        b=Uhyk1zLDVBF6hmtZ4Jc/EeDTOvHGHeBsNOOeCdve8yS2EnBk3XRny/MGencVjL7PGq
         /rfGqxxXzRrfUExHtQg1qYQtqxrbanJFv9AXL03hBOVYI2ZguXUbPkrI3FBF+y9vKDhv
         JeCgnK03KZeV/XLCMMkW7C6F3B2URmU+z6VQW7Qb4z52Ib63hgdTmHUQQPcq1tnSl8JY
         S6yvcyZavf12sa4yIudY9RUI8cJdDid/kcl42S0oyVr1Cnks5QAUlIwLRf5dkZBikx2R
         qG7RBQ4o7MUnVjBX4wGNDILpCF4r3ksWW80pftSoXGwWet67bNiSP5rMX+OCWvU5BRcS
         /6NQ==
X-Gm-Message-State: AOAM530D+D5IWwF/9EqFb6MWE93SPOBUfkLE7kOYIu4KEmQi4m+FwF52
        x99yza1Dxdj7GxpG4TvALrOeZoQbfkHaQg==
X-Google-Smtp-Source: ABdhPJx7iRrTGjqiezPC6ikbiW38e5fhW8TteqU4nIrtOLBz4zFK0t7c9v12gRSWn2y/AGLf37VWYA==
X-Received: by 2002:a63:f40a:: with SMTP id g10mr19750452pgi.66.1604461017078;
        Tue, 03 Nov 2020 19:36:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm547151pjj.37.2020.11.03.19.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:36:56 -0800 (PST)
Message-ID: <5fa221d8.1c69fb81.886a6.23c4@mx.google.com>
Date:   Tue, 03 Nov 2020 19:36:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-215-g1b513bf28609
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 192 runs,
 3 regressions (v5.4.74-215-g1b513bf28609)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 192 runs, 3 regressions (v5.4.74-215-g1b513=
bf28609)

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
el/v5.4.74-215-g1b513bf28609/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.74-215-g1b513bf28609
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b513bf286096f9c66fc386cdc5e038980db8863 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1eed4ca07872faffb5313

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74-=
215-g1b513bf28609/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74-=
215-g1b513bf28609/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1eed4ca07872faffb5=
314
        failing since 206 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1ec6eef5bcbe8e0fb5334

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74-=
215-g1b513bf28609/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74-=
215-g1b513bf28609/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa1ec6eef5bcbe8=
e0fb5339
        failing since 2 days (last pass: v5.4.73-49-gbf5ca41e70cb, first fa=
il: v5.4.74)
        1 lines

    2020-11-03 23:46:54.489000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-03 23:46:54.489000+00:00  (user:khilman) is already connected
    2020-11-03 23:47:10.238000+00:00  =00
    2020-11-03 23:47:10.239000+00:00  =

    2020-11-03 23:47:10.239000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-03 23:47:10.239000+00:00  =

    2020-11-03 23:47:10.239000+00:00  DRAM:  948 MiB
    2020-11-03 23:47:10.254000+00:00  RPI 3 Model B (0xa02082)
    2020-11-03 23:47:10.342000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-03 23:47:10.373000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (377 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1f0755de9639e03fb5320

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74-=
215-g1b513bf28609/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.74-=
215-g1b513bf28609/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f0755de9639e03fb5=
321
        failing since 7 days (last pass: v5.4.72-55-g7fa6d77807db, first fa=
il: v5.4.72-409-gab6643bad070) =

 =20
