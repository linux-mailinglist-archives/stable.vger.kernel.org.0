Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F7829C8E5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 20:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442358AbgJ0T3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 15:29:06 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:33058 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757043AbgJ0T17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 15:27:59 -0400
Received: by mail-pg1-f177.google.com with SMTP id r186so1374697pgr.0
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 12:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J0E78/ZKk4zbQsfqgosOKRfUQN1eGLf1llU+JNXXYbY=;
        b=jH3Fbx1kmJ9w6Cwhn90nFWE0Ed4WZQXnXmyOuEDmE6P2qsp/KVmKlayEh2r2FLCkpF
         nHxY4WWfhiBne03UP0wM84jEvhbJzmWiz8g+f/7Kw+odTHK+EU1giR4WxIcLkEyy3m85
         u+uIkomfQRo7PdD25NmRYmpQ8HvJIzcx7eUdPWyRa7qZSTnwylPIQnoW+FPSgpxUaAlr
         DOEnjC/W4nPJ/t6xRPzUtjlzAhyYyWh14ADbEhT/G4vx4hvciZ06ZBz2rrNgeQ9AJlB2
         hYmeYcNCkbaNTdl5lLXF6klA4BKYLqBzEvHLVp/KybuPAve6x9mUr0gayDBZxjIlBPtt
         GDBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J0E78/ZKk4zbQsfqgosOKRfUQN1eGLf1llU+JNXXYbY=;
        b=CpNl6QVdFJSSC/0i5nuC6MqofYeX/FD2YqYXR2kGcZ7ryZ1v3AiX/Mv6xlPvdJANV2
         rMotH1BEQkHo9J+MPc6EgYOaOW067tpm/oxGzZqb/+sSre4uQIeXKN70ZUNlJmbC//m4
         +t7L3Nc/R3Koy8ivA3l8vODpn8/NflLPZN+QvJb5nbKVBDfzApqUacZ0l7oZ1xlgmyMK
         ZZ0+JO5Ufp7oS+enzhbWwX+UU0N/OIzMbD+a62Z22LSegiwwjDrHck5XjQfAoDy4h8ty
         Z4xxZ6lG5/FsQGK2h8NuI15cXeU+R9DA09xooz133kFYsIuOC1/1WKGbP/rBNF2IyZva
         11EQ==
X-Gm-Message-State: AOAM530O1KhhY4Xk2HcoIou5n3b0RiDCbi0ffQl3VmYok77PxwjrPtPi
        9MUAX4G/EJAoeM+oPyXb1qA/R0im/4j3Ag==
X-Google-Smtp-Source: ABdhPJxQfeer04Ggo5kwXa4LOBL/f6e6svn+wB0fZSLTRVGVJHyP7gEFzkXbQXgm19DKyuiQYo9DPQ==
X-Received: by 2002:a63:f502:: with SMTP id w2mr3127281pgh.186.1603826878652;
        Tue, 27 Oct 2020 12:27:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13sm3227138pfj.100.2020.10.27.12.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:27:57 -0700 (PDT)
Message-ID: <5f9874bd.1c69fb81.ce7c0.62de@mx.google.com>
Date:   Tue, 27 Oct 2020 12:27:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-265-g8919185062d4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 167 runs,
 4 regressions (v4.19.152-265-g8919185062d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 167 runs, 4 regressions (v4.19.152-265-g89=
19185062d4)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

hsdk                  | arc   | lab-baylibre  | gcc-8    | hsdk_defconfig  =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.152-265-g8919185062d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.152-265-g8919185062d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8919185062d40d0559c701be480cc8fa547291ed =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f984074a66e78706238101b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f984074a66e787062381=
01c
        failing since 133 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f983f9b9adfa85f09381012

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f983f9b9adfa85f=
09381017
        failing since 10 days (last pass: v4.19.151-22-g5f066e3d5e44, first=
 fail: v4.19.152-16-g2fac1e5e3bc9)
        1 lines

    2020-10-27 15:38:45.566000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-27 15:38:45.566000+00:00  (user:khilman) is already connected
    2020-10-27 15:39:00.962000+00:00  =00
    2020-10-27 15:39:00.963000+00:00  =

    2020-10-27 15:39:00.963000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-27 15:39:00.963000+00:00  =

    2020-10-27 15:39:00.963000+00:00  DRAM:  948 MiB
    2020-10-27 15:39:00.978000+00:00  RPI 3 Model B (0xa02082)
    2020-10-27 15:39:01.065000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-27 15:39:01.097000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (377 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hsdk                  | arc   | lab-baylibre  | gcc-8    | hsdk_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98405a23b9f364f2381035

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arc/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98405a23b9f364f2381=
036
        failing since 98 days (last pass: v4.19.125-93-g80718197a8a3, first=
 fail: v4.19.133-134-g9d319b54cc24) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98427b87f1264e75381051

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-265-g8919185062d4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f98427b87f1264=
e75381058
        failing since 3 days (last pass: v4.19.151-22-g5f066e3d5e44, first =
fail: v4.19.152-33-g0f1e84b5bbc2)
        2 lines =

 =20
