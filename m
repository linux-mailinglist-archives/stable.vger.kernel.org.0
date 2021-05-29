Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E803394E6F
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 00:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhE2W7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 18:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhE2W7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 18:59:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388D1C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 15:57:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 29so5394768pgu.11
        for <stable@vger.kernel.org>; Sat, 29 May 2021 15:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UXR1iIQh1TIlWB2AAw9H12BqyjTsFzTo04Vw9sb2sW4=;
        b=dlYDHY4vkzztFAhwfhJgvaFRpascr6K3azR1AFWD6tIYMqtae43uPYzDN7uXnVOvrr
         WqTII8RpAH3nI6sBB2cm/8BvzfoOSTpAlmMfUhQAGHCCzjD0DwQLhSd3Mi3VZoHR3Cuj
         pdQNN+G8q5DWzx1NSYsNUtYbnVIBQFtZbOCYteVga5QfRuwuyqNeRBmVTqP2Uv1s2jAE
         G7J/rOdcTII5hBNaA3HwnhShLpE2IuHP5ep9xUDbVVonY52wdLf30UnRLVAmfpz585nR
         2nQXAtqjixo4oW8KGPglL7qS9H2JDHHP/ch1l6hXYIXcGnQjLhvIyOJokVlFeSjf/GJ/
         lW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UXR1iIQh1TIlWB2AAw9H12BqyjTsFzTo04Vw9sb2sW4=;
        b=B3RXbLq9VdvSOfcH751JIl0GWwsQfmT0jM+vfJc/jQqVA4y6yF/8bePdXLPGig9By/
         g9K5rVOnxb+gZBGLC9n2tgChhXKc+LrpwjRwfpDBV4ttc67iHL/w0nBxM5VFvULwGbyj
         ir51wKjUC+rGOH/rTlF0q6OZPukDXCJAUHeGttgPFvXU6N6EUchiZHmVO5fRkTQ13V3G
         pThED2gFnxL5bsyGzIv0RpGxPCh8LvCzRgapea4JVbeYMTel1sZ3pbNJlsQC9R3dIkUG
         DWFkM5aSPlQcYIBthq5dh3G6iVYecra6AFaHPZKZfI2XZRf2QH4XYo5I8DozjPhEX+sF
         vidg==
X-Gm-Message-State: AOAM531lHSW2cVn8th25o/kD+K5Os8Yd2AOWya2CJT3zJPtJgtztFugh
        9tzPFuHhwUOHjGhhHfweAn20w97Tb51H6PVP
X-Google-Smtp-Source: ABdhPJxseAvNwYHWLGzlbZhUAHlUvwHfHFBLQn+PeQCW8OvzpEV0BeeuXtO883EVenHjUQdu8sSutg==
X-Received: by 2002:a63:7056:: with SMTP id a22mr15904155pgn.292.1622329072589;
        Sat, 29 May 2021 15:57:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f139sm1941027pfa.38.2021.05.29.15.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 15:57:52 -0700 (PDT)
Message-ID: <60b2c6f0.1c69fb81.a797a.527d@mx.google.com>
Date:   Sat, 29 May 2021 15:57:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-69-gd4f1b01eb53c
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 181 runs,
 3 regressions (v5.12.7-69-gd4f1b01eb53c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 181 runs, 3 regressions (v5.12.7-69-gd4f1b01=
eb53c)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
bcm2837-rpi-3-b     | arm64 | lab-baylibre | gcc-8    | defconfig          =
| 1          =

beaglebone-black    | arm   | lab-cip      | gcc-8    | multi_v7_defconfig =
| 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig          =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-69-gd4f1b01eb53c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-69-gd4f1b01eb53c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4f1b01eb53c20ea927bb62fa0d48d6641f387fb =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
bcm2837-rpi-3-b     | arm64 | lab-baylibre | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60b28ebd55a0ac2642b3afa1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
9-gd4f1b01eb53c/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
9-gd4f1b01eb53c/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60b28ebd55a0ac26=
42b3afa6
        new failure (last pass: v5.12.7-68-g0c053f223af4)
        1 lines

    2021-05-29 18:55:48.937000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-05-29 18:55:48.937000+00:00  (user:khilman) is already connected
    2021-05-29 18:56:04.541000+00:00  =00
    2021-05-29 18:56:04.541000+00:00  =

    2021-05-29 18:56:04.541000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-05-29 18:56:04.542000+00:00  =

    2021-05-29 18:56:04.542000+00:00  DRAM:  948 MiB
    2021-05-29 18:56:04.556000+00:00  RPI 3 Model B (0xa02082)
    2021-05-29 18:56:04.644000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-05-29 18:56:04.676000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (384 line(s) more)  =

 =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
beaglebone-black    | arm   | lab-cip      | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60b2921a0bd498c258b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
9-gd4f1b01eb53c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-bl=
ack.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
9-gd4f1b01eb53c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-bl=
ack.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b2921a0bd498c258b3a=
fa7
        new failure (last pass: v5.12.7-68-g0c053f223af4) =

 =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60b28f544058205d2cb3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
9-gd4f1b01eb53c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
9-gd4f1b01eb53c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b28f544058205d2cb3a=
fa7
        new failure (last pass: v5.12.7-68-g0c053f223af4) =

 =20
