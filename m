Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BB738F303
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 20:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhEXSch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 14:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhEXScg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 14:32:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A32DC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 11:31:07 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso9966347pjb.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 11:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8UYQ13tkg3FB+u/LxNy/pLjGim+3N344pwG+EntG/7U=;
        b=U12HuB/GJQYpgTcL5zmbZ9JdeYMctJrBtaoKtdydSlg5aGKFzrq8VkxoAeyRw0GZCM
         CIAH174znSprRgQDev4xYDDRQfKNrAbjnVPGFMEtKEyoCJTBJkNOys5HUj25sl5iihRT
         5sr6+cn2dOlbhUHXDwk6bfZch0oDfUvja9g6KZg6JzBRoC++4EECvW2ZtHhHU9FUIr5e
         MlR6m+UvcgS33Nc6LaN+ONe96dk7rryQ8NYwVwut29amUYGTfZizpdPjxwIU+jlyDdgj
         LDdvicQd3hpXzPcG9tWrHi9DvTxyo64r/lH0/TynRCEwm/LttC06I8UWQnlcuEXI8LUw
         UJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8UYQ13tkg3FB+u/LxNy/pLjGim+3N344pwG+EntG/7U=;
        b=EphKZcZCgkiAcBgMqioBg28Iiezg6wLujSSvQHE0Cux1o7iI+5TcPKrPE4GaXBGxiG
         Ufwmfnd01QxaZdAIJA9gRRM0Bfw577a1J+ec8VmR5ajW2vJJc/nCK3x8gkYymb0t6lBP
         cdKCpYRqEjbm7KYzE00ztEHlZ0R9AGkpjdUGHtH8lTY+S3+racZu6GNdVT1wOS/CzOaG
         mOZOgBbUyCwN3LWUaUpQXjItKYz4QWJgAWR4b1+crPVLRZbXUpRbZ/ZZKa+f96Ma5SQY
         yCSYsGvUr0uUX/OmDQJoIUC/DwfuluYgbF4gvVQT628kNJxu8gmZbChSSKkA0AjxXG3r
         YQcg==
X-Gm-Message-State: AOAM532RvvYdsAEzh486pvi3AJU3Gf0EapIjRbEZOoFAwKY5V5AxmEMa
        Ty6ZAMhQZW1/0dYSZcEtLy3+y4+7Za7j8XnN
X-Google-Smtp-Source: ABdhPJz7bjHNdCvuE7b6ubwPDgj3ZAgZVKfcrR0IcFfMaLpZ4uJCcJ+0mQ13nLdH5JwPZvo29PMDPQ==
X-Received: by 2002:a17:902:b683:b029:ee:f0e3:7a50 with SMTP id c3-20020a170902b683b02900eef0e37a50mr26405238pls.7.1621881066554;
        Mon, 24 May 2021 11:31:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2sm10557709pjo.1.2021.05.24.11.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 11:31:06 -0700 (PDT)
Message-ID: <60abf0ea.1c69fb81.bc026.3192@mx.google.com>
Date:   Mon, 24 May 2021 11:31:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-37-gc227796ef00c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 82 runs,
 4 regressions (v4.14.233-37-gc227796ef00c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 82 runs, 4 regressions (v4.14.233-37-gc22779=
6ef00c)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.233-37-gc227796ef00c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.233-37-gc227796ef00c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c227796ef00c2ba1a0c5e032d2ce67b84f0e6719 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abbe139605088e5eb3afc8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60abbe139605088=
e5eb3afcf
        new failure (last pass: v4.14.233-37-g8ff7c96a31db)
        2 lines

    2021-05-24 14:54:08.072000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/101
    2021-05-24 14:54:08.082000+00:00  kern  :emerg :  lock: emif_lock+0x0/[=
   20.238250] usb 3-1.1: New USB device found, idVendor=3D0424, idProduct=
=3Dec00
    2021-05-24 14:54:08.094000+00:00  0xffffed34 [emif], .magic: dead4ead, =
.owner: <no[   20.248657] usb 3-1.1: New USB device strings: Mfr=3D0, Produ=
ct=3D0, SerialNumber=3D0
    2021-05-24 14:54:08.097000+00:00  ne>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abbd8c7cde96edf7b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abbd8c7cde96edf7b3a=
fa5
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abbd957cde96edf7b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abbd957cde96edf7b3a=
fbe
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abbd430596a78010b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-gc227796ef00c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abbd430596a78010b3a=
fa4
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
