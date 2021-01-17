Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9EB2F9580
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 22:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbhAQV2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 16:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbhAQV2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 16:28:00 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F47C061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:27:20 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id j12so1868613pfj.12
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g9vHhSiE19xBBz6nvdWITOd8pWo3Y4uqDXU9tFzNNe8=;
        b=Xf56z/sqmItkQGS9T2tB57kYmEIN1VlB8CVUOxvuYsSVK3a98q/ky/nIVtxutxvN9s
         T+wS5dq7s9QtyoKzpfnPwpIzwbLMxgfx9BbPF/WBQ9SHBu6owxMeY12o+KP1/hfx/33r
         OPIRYKmEYvHG2s308kbLq53Fscu+vC3h/sMeYPQfTUpym03w36TUZi9aHLH1GB2PbKp3
         uQ/omuV02Pjy9wM1AhckyFbhbCbLzcsouu3KgG5cJOdQTC+3ygOR9mxx2mCt4CRDeNQt
         ZOE+VIDJ7SRQTbYn6VxnWryrLcKCgfKC5yzOrMXSD4ZnwARWSERIblXtMre30EAFKK3i
         0jQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g9vHhSiE19xBBz6nvdWITOd8pWo3Y4uqDXU9tFzNNe8=;
        b=S2l/eg8g+XugO6EqEYDpYqSg7c3MFwxc7VXvsLpisXhkVZghtKAWpHb5EovmLu5aop
         yglIH6Pjpo/MRu6cRszUPHC6lkHnxl/LykKI7dNcx5AYeceys8vJaQrFCoCiCT8nnexW
         Cw2rUnwflr9hdrn6UHKcVM/0C0oA+I16BSJ/HmCcuXiZntPoC+LL2GH9K5ECjSOUHmN6
         CBBwFbP9QOlOyXNbbKzKJ708K06dUMBqbAw6+Rp2dlNMQlYq/005KRa3kZfoAJhsSjKY
         XCqJ/xu6iYWjUelz8r7ANK4JisEIGA5oehmC0+iLBTOSf/c9e5rn53DNXGtX1lGTyWU4
         yDhQ==
X-Gm-Message-State: AOAM533Ob1/yGhaUzrU2MHi9BwEZ/sfH5Gn9H9nQFXDctknOhaM9VaYh
        r1UwnRim/ZR1BUMXXu/qy6d7maWzM2l6Vw==
X-Google-Smtp-Source: ABdhPJymAmq8awgzhbRp7h4KKOyBle4P5CfATkbTWabbv4bEuQOIGmBUe7ZT2caxa3cfgvZh/5pE6A==
X-Received: by 2002:a63:4b5c:: with SMTP id k28mr22750169pgl.294.1610918839620;
        Sun, 17 Jan 2021 13:27:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b26sm13904581pgm.25.2021.01.17.13.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:27:19 -0800 (PST)
Message-ID: <6004abb7.1c69fb81.8651c.1db3@mx.google.com>
Date:   Sun, 17 Jan 2021 13:27:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.252-4-g8f1315d1b1ec
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 9 regressions (v4.4.252-4-g8f1315d1b1ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 9 regressions (v4.4.252-4-g8f1315d1b=
1ec)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
jetson-tk1          | arm  | lab-collabora | gcc-8    | tegra_defconfig    =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.252-4-g8f1315d1b1ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.252-4-g8f1315d1b1ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f1315d1b1eca82e05c4267c29e7f84f50e3bac2 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
jetson-tk1          | arm  | lab-collabora | gcc-8    | tegra_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60047b6be746ae573ac94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60047b6be746ae573ac94=
cd2
        new failure (last pass: v4.4.251-18-g7615952354dc) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60047993987e871e1cc94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60047993987e871e1cc94=
cd8
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/600479b3326d96c83cc94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600479b3326d96c83cc94=
cca
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/600479fee9e8e756eec94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600479fee9e8e756eec94=
cd9
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60047c5055483f4cfec94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60047c5055483f4cfec94=
cc8
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6004799663e2830003c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004799663e2830003c94=
cc6
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6004799c987e871e1cc94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004799c987e871e1cc94=
cdc
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/600479e4e9e8e756eec94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600479e4e9e8e756eec94=
ccd
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60047b33aa23b7c6ecc94d1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-4=
-g8f1315d1b1ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60047b33aa23b7c6ecc94=
d1e
        failing since 64 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =20
