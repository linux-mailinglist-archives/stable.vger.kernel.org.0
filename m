Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3672CA950
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 18:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgLARJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 12:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgLARJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 12:09:29 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF53C0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 09:08:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id k5so1480401plt.6
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 09:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rv2qj3XMVnooibPJOvk3tgggiIzpe2ANd5uDzwNb21c=;
        b=GwsJAMGp9P3iAjJLGqZCXYIW+EguQVSW2dnwRWFwRX+YN51trgqnE9eej2jjR8ni7/
         DA+5NXcRi8TsjYe0ptY6BhZTX03YbP464T7CbRImHchfDzgwV/gFEugeJohkHXSqVu/A
         Q+cWmi581fsu/UyxGF9vfFmCb57DUjqngyjW70JFaTCpc1hV0mKy0Ebze4z0a5iolZGn
         VdLFesizvj4GluUXN7j/7MRQoiSwqOMPm5uKdVCCZtYsu5L1Fal0jRopPytiEX7PVEF9
         9q99UhUqTFoUePK8fYBAWse1aiT1oh3/nP9EQoDaRci13YYDlX/AJvXaKXCitEPAhAaV
         8zvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rv2qj3XMVnooibPJOvk3tgggiIzpe2ANd5uDzwNb21c=;
        b=oUI2IrCvEgU4VuziB1PsazsiW/AuWC24HIccyNUgAFievRQEF6T/0nOyS6i8mYizGr
         BbDqPHIadxxTmnfXyKJlmTaqkJgU4yuX+Fhi9fhJ04mzhhzoNYvJvw1BkT5HdOabEcfu
         oimII9h5kGAiYW/GjZ/trSxTnXKIyqmpfMxpsK73J05oXzJdIFgj9XtgsSxpG0oedzn1
         IzG7/LMSySC/J9lVBVS+sggKkJM/khd/S2bktuzjepZv7BQcrC2gDGorTM8x5lKPFE8c
         agZmYiXbIsyiuCOvcKrrFxlSxjpJ/v6dTwexlaACeciOfBV7qdZIu24L5atcpItOtvzp
         MMHQ==
X-Gm-Message-State: AOAM530SGYkBPshDL3Z1s9Bm1DcAEIXcFlcftMvinKTH5FrTZ1Tj3c+W
        A6zNyQ43Ac5Xqw87QTIpRWo9qaIrrfEP0w==
X-Google-Smtp-Source: ABdhPJxpSfLKHtLrOzqDOFL+aKvFJ90iycROozb+Ixs1WGwXtZT4Mh5d0NZE8f9ox1mtjLgQiUbtcw==
X-Received: by 2002:a17:902:6b4a:b029:d8:d13d:14f with SMTP id g10-20020a1709026b4ab02900d8d13d014fmr3683624plt.24.1606842527606;
        Tue, 01 Dec 2020 09:08:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm335036pfd.107.2020.12.01.09.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 09:08:46 -0800 (PST)
Message-ID: <5fc6789e.1c69fb81.ad003.0ae8@mx.google.com>
Date:   Tue, 01 Dec 2020 09:08:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-99-g89a0528bfd8df
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 152 runs,
 5 regressions (v5.4.80-99-g89a0528bfd8df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 152 runs, 5 regressions (v5.4.80-99-g89a052=
8bfd8df)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.80-99-g89a0528bfd8df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.80-99-g89a0528bfd8df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89a0528bfd8df49c50fda873ffb8cfeea5a2898b =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc63f5eaba086a52cc94cd5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fc63f5eaba086a5=
2cc94cd8
        new failure (last pass: v5.4.80)
        1 lines

    2020-12-01 13:02:00.078000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-12-01 13:02:00.078000+00:00  (user:khilman) is already connected
    2020-12-01 13:02:17.638000+00:00  =00=00=00=00=00=00=00=00=00=00
    2020-12-01 13:02:17.638000+00:00  =

    2020-12-01 13:02:17.638000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-12-01 13:02:17.639000+00:00  =

    2020-12-01 13:02:17.639000+00:00  DRAM:  948 MiB
    2020-12-01 13:02:17.654000+00:00  RPI 3 Model B (0xa02082)
    2020-12-01 13:02:17.741000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-12-01 13:02:17.773000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (377 line(s) more)  =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc64701695f674141c94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc64701695f674141c94=
ce1
        failing since 11 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6446ae45a62d109c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc6446ae45a62d109c94=
cba
        failing since 16 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc644695a443c3cb3c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc644695a443c3cb3c94=
cba
        failing since 16 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6446c5e49c387d1c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.80-=
99-g89a0528bfd8df/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc6446c5e49c387d1c94=
cbf
        failing since 16 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
