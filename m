Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5621B2F9562
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 22:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbhAQVHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 16:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbhAQVH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 16:07:27 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C8DC061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:06:47 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 30so9684987pgr.6
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3kSlLbCBqCc9sgZn268wzReIS+SkohL8WnUJheKmPOQ=;
        b=MCD0cqcZwmwoSEwZbxH1fuQbENuZvFDqMMgUcQFkvAxDGQc7Km7V7bY81lBMm24eem
         EqF4YcVKhMPiYzQoeaSo/+XBlgVkhOV4P01n0IWRL3CGaegmOzYKa1yHP5CEaw+Z7uyZ
         C1jPTuZKnlbrxZQpfZ8+Qc/nMpmJEcjsUEmcnw1Qwl7uDllACq21SgUw/UTySVOmWKQt
         o4QRc1Xct9vii6/Q5Fp4cv3GKrxkU0k4262X24TSMjgPU8hQO7JV/Drkn/+sC3AwY7oV
         E+JRajyl17Be6Bik6cx/Q+JwRNj0ctGpgnXxe1mtjRz8kbF80arUo5ITkcX87sPZ58MB
         1BPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3kSlLbCBqCc9sgZn268wzReIS+SkohL8WnUJheKmPOQ=;
        b=AZHlaPkqrdigIespdrZ+nUVVx+PzZL6mywBx27k3zdecsYeq2QXLqXpDac4S3Md8TW
         bPJB2RVcWit/X/nDCKkBBFDpdwrzMY6qoIg2pkOs04rjgMOzBNlTpCgPOswgYBFaMCXR
         7P98jV1k8gdQw28Na0TNC/nf7TK8w645y5geTX+IimPu2ueYj4fmWPKY5vZw3aisD9IX
         bs2DV7Wlz6f5m0+Ks8GXPXwcdx0mpOoIhvyPFZNMel1ikpKB5/HyIBSgmeFG4HW3O6Tp
         oSFq+/p7of22iwLscGbTmesSWQ3lOCnonB36sDGjlpQQxE9g0xRD46/KyGU1TrRPzpkq
         VH1A==
X-Gm-Message-State: AOAM533wdJbVPQ98T0nPnrPV6N75BwC0JAbxUkUr1SS9J+4wo48Q++pU
        BksvSDYuia0tlZ95oYo1zM2k7U96Sv10bA==
X-Google-Smtp-Source: ABdhPJyxPTLj+OqPJFBrr5me/5yum4bUx7AZtYRWq56HwiJ/XwJWW3lSvRZFdxG/bt1svlEJT1YfMw==
X-Received: by 2002:a62:ae18:0:b029:1a9:ac67:3b1c with SMTP id q24-20020a62ae180000b02901a9ac673b1cmr23348766pff.29.1610917606558;
        Sun, 17 Jan 2021 13:06:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d76sm886012pfd.193.2021.01.17.13.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:06:45 -0800 (PST)
Message-ID: <6004a6e5.1c69fb81.8187c.2090@mx.google.com>
Date:   Sun, 17 Jan 2021 13:06:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.216-9-g8a3b695cf8a34
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 130 runs,
 6 regressions (v4.14.216-9-g8a3b695cf8a34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 130 runs, 6 regressions (v4.14.216-9-g8a3b69=
5cf8a34)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.216-9-g8a3b695cf8a34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.216-9-g8a3b695cf8a34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a3b695cf8a34b46e191f88ccbd8f78b2b14ea8c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/600475302ab7dc68f9c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600475302ab7dc68f9c94=
cd3
        failing since 40 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004761308eedd45b8c94ceb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6004761308eedd4=
5b8c94cf0
        failing since 2 days (last pass: v4.14.215-28-g698dbcc987be, first =
fail: v4.14.215-28-g44cb20ad2e61)
        2 lines

    2021-01-17 17:38:23.070000+00:00  [   20.459625] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 72:28:09:81:63:59
    2021-01-17 17:38:23.077000+00:00  [   20.472930] usbcore: registered ne=
w interface driver smsc95xx
    2021-01-17 17:38:23.109000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-01-17 17:38:23.118000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-01-17 17:38:23.135000+00:00  [   20.528259] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600475144336ddd2f8c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600475144336ddd2f8c94=
cc7
        failing since 64 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004753e475bf7e753c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004753e475bf7e753c94=
cba
        failing since 64 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600475177a41d92c47c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600475177a41d92c47c94=
cca
        failing since 64 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004753206c2b0b387c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-9-g8a3b695cf8a34/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004753206c2b0b387c94=
cd4
        failing since 64 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
