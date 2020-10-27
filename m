Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5298129CB59
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 22:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373831AbgJ0Vg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 17:36:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34202 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506164AbgJ0Vg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 17:36:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id t14so1553499pgg.1
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 14:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kZztB1uz7seKZ9q0zJv6HXltPYpG3gT8ELgTLnpEeNE=;
        b=l4YGDK0XUzRzWIse4OaukwZ9SUotndnxhVU4HLsRXRDQAda/dk07JM5I0wxgtpgOaz
         jde+wLE2mO51HPqsqEQhrytWX32KDscwjZpK++6LWHFSbfIGvoSWbNh6OS3ZqPU7Zqc1
         9cs+uhNKlTJGgXzywYppQXtwJA5qQGioDGB+/XMnfZHaN4/hqu/iRQYpxczoXD2s8nR5
         80pNpzEye4HS7gFhC3y1PaEbv1Fx0fXDQeebTejNset4lQM6XKWESEnyZhWEAU8NZVO9
         JHep34osT7bGIVjJEXsYsGw8G1r2IVC8SRAD0cgOoHGc5cxE8Zy55Ga9+PidgEsVsj9w
         CKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kZztB1uz7seKZ9q0zJv6HXltPYpG3gT8ELgTLnpEeNE=;
        b=Tit+0q2uDgNCGKf3POak0SB/IFEmIEFy4ZzOImiZfalVNINPH8QPrpURD40jAYo6gC
         CUJrb6TaRJ05TcC0q8GijxxSW6p4GbuB3OzYlH1cBHS5dRvEpnA1gKkbgipGd4cSd9Zx
         7STNZ1r4/UB0XGe2cuD+des7mBnIiiefg3JISOWfxJcPSpg+zmFZsCIb7N/hr7FsdPUN
         FH8g0BLtC8FvwmxMbRKeqJ1XKrr5pVcMDOJfrNfWpi7qH7GQgmhR880x6+1hEcCmVO0G
         CzdsQLmKp6vZDbSQ81GeTQyvF+TL5LKkLv9W7vlh/4XYv3+7NfCA9EvYNHTtSus6zby7
         j1Dw==
X-Gm-Message-State: AOAM533pzkXOjh2sUxuu9VGt+IRkze4gMmKTm2L1w0AhwmxjxaZdTPOb
        tt4duhZS+vp7oBuzAY5Pp2peRxCZZexiDw==
X-Google-Smtp-Source: ABdhPJzpiAu/PVzCzVwsHqNCmOqsDXLIOZFy65RktwU1T2cgdGOoEUWfM3ltGOfOCZEjYH/c3tfA1Q==
X-Received: by 2002:a63:a504:: with SMTP id n4mr3590785pgf.365.1603834182852;
        Tue, 27 Oct 2020 14:29:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm3511021pfj.90.2020.10.27.14.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 14:29:42 -0700 (PDT)
Message-ID: <5f989146.1c69fb81.cd47b.7042@mx.google.com>
Date:   Tue, 27 Oct 2020 14:29:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-265-g35a69550df89
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 166 runs,
 2 regressions (v4.19.152-265-g35a69550df89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 166 runs, 2 regressions (v4.19.152-265-g35a6=
9550df89)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-265-g35a69550df89/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-265-g35a69550df89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35a69550df89d80d4643e3b153c9bc5ab807b128 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f985b3d9800fdd41c3810b5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-265-g35a69550df89/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-265-g35a69550df89/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f985b3d9800fdd4=
1c3810ba
        new failure (last pass: v4.19.152-261-gd2b228260b67)
        1 lines

    2020-10-27 17:37:10.301000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-27 17:37:10.301000+00:00  (user:khilman) is already connected
    2020-10-27 17:37:26.390000+00:00  =00
    2020-10-27 17:37:26.390000+00:00  =

    2020-10-27 17:37:26.390000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-27 17:37:26.390000+00:00  =

    2020-10-27 17:37:26.390000+00:00  DRAM:  948 MiB
    2020-10-27 17:37:26.405000+00:00  RPI 3 Model B (0xa02082)
    2020-10-27 17:37:26.492000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-27 17:37:26.525000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f98605eda1f8da669381031

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-265-g35a69550df89/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-265-g35a69550df89/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f98605eda1f8da=
669381038
        failing since 0 day (last pass: v4.19.152-260-gbad1094e2c61, first =
fail: v4.19.152-261-gd2b228260b67)
        2 lines =

 =20
