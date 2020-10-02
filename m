Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8512A280C86
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 05:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgJBDlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 23:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBDlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 23:41:22 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268FCC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 20:41:22 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id o25so625226pgm.0
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 20:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gBNjNj79C6p/WhRUouQ4d3AHuTVXNZB2SlZQozdC+m4=;
        b=fW2svS2R5bwQrwt2TY1kfVGN5Xvtxgv0utTKJNleRnnujRwcRfyEAu6tFxoWaeju8+
         wYSGBaUirMFGsTUIqKOM+cmSsbCDG5nPwgkaFfh6Y/BtUGmGQBpslvtEhMtKKehBBUJ5
         ylBnxUMid43SVsLMXEqZJCg8vT/6bZCMs4EjIqQtZz6bvvgbrA9XRY4rbYXwduzZthoF
         7A9K96dGCJnizQGjUp2JV0YJCua71G1XKpHdmmrXuGg5L3xgdsI6mIG9JFRXWREVEmlF
         0L/FU9KgbrptF3cqnGjICZDsxwXwO8v2ws9iFnNj3ImJaXYwoOKQLYRnhur8SzA+gH2Q
         LpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gBNjNj79C6p/WhRUouQ4d3AHuTVXNZB2SlZQozdC+m4=;
        b=KwqpdrhdG6Fdt+3bFGjFQ80YVe5RnKwg1kcgRf/X0DL+S/X4z+1D8yRyyhbH5Xp+oR
         2KgtYRNudlOPt/GfnOu+HKC043eEOEJCyNUwNnFX0w1rspEHMqjgprhVehLFGnY3gxjS
         1MKmN3fugConlRR7tV0/k8cqpOn/C7g9HCACUcmkRRPCRD3YBLOMZ/jnAqJr7SD5hbAd
         RnZWm5kEiXvNXQu9mFeT0Sc2U83Sv6MqCuDGM2BCftO8xp/TbntzUYaeCa2F/9HJ9vMg
         j0MdB54CjYCrSeceN4c5ZDpgXneogxiSamHu9K/HusWiYTzuUeibq3AkxlS9T58IJIgd
         3tGA==
X-Gm-Message-State: AOAM530mEN2XLyLaZcZPqueSVa1KJFiVCFAmNGRU0C72IaHWBrcKqNQj
        o1pB1K9igKcsVVFzxEXbF5F4tlVUswPDOQ==
X-Google-Smtp-Source: ABdhPJygl8RboC4jKFBbwjQIGoRsLz3+Yuy+/d0P+itB/XzZdu8zM0GFWUSjgye8MywjyyQdPV5eJQ==
X-Received: by 2002:a63:4f20:: with SMTP id d32mr183360pgb.82.1601610081063;
        Thu, 01 Oct 2020 20:41:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm89739pfo.13.2020.10.01.20.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 20:41:20 -0700 (PDT)
Message-ID: <5f76a160.1c69fb81.3bbf9.043a@mx.google.com>
Date:   Thu, 01 Oct 2020 20:41:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 144 runs, 4 regressions (v4.19.149)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 144 runs, 4 regressions (v4.19.149)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 3/4    =

hsdk                  | arc   | lab-baylibre  | gcc-8    | hsdk_defconfig  =
    | 0/1    =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.149/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b09c34517e1ac4018e3bb75ed5c8610a8a1f486b =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f766f732fe795cd92877169

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f766f732fe795cd92877=
16a
      failing since 107 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f766d1d152859aa058771fa

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f766d1d152859aa=
058771fe
      new failure (last pass: v4.19.148-245-g78ef55ba27c3)
      1 lines

    2020-10-01 23:55:51.856000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-01 23:55:51.856000  (user:khilman) is already connected
    2020-10-01 23:56:07.546000  =00
    2020-10-01 23:56:07.546000  =

    2020-10-01 23:56:07.562000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-01 23:56:07.562000  =

    2020-10-01 23:56:07.563000  DRAM:  948 MiB
    2020-10-01 23:56:07.578000  RPI 3 Model B (0xa02082)
    2020-10-01 23:56:07.669000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-01 23:56:07.701000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
hsdk                  | arc   | lab-baylibre  | gcc-8    | hsdk_defconfig  =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f766d5d5170ad1a4187716a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f766d5d5170ad1a41877=
16b
      failing since 73 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f76707ff8bc1af862877178

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f76707ff8bc1af=
86287717f
      new failure (last pass: v4.19.148-245-g78ef55ba27c3)
      2 lines  =20
