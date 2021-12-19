Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA71A47A20A
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 21:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhLSUU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 15:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhLSUU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 15:20:27 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3675AC061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 12:20:27 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id k4so7535598pgb.8
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 12:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7Vqv1FAIAtraKYIYInQzp3Fyux+Qhb+g6H45hioKM0U=;
        b=7hUnXXpUhOoKUHzqy5r3UnjEtekRwEnUly4STjAI3W7qyVHQKX5ibconrFMKK8N8Rt
         JB3PBMyqqzBLLUCCKM+1P80SqkgV70Xn0Rf7nbHwpR32KZAUzAFLzQ8dgX4Ei7GG3FYn
         IrZ2DyND8PpkRsX2AFUIxjt6HkV8lVZn/Qfvbjxj4B5CiTxMMLJK/wrIuHIdp+9MEr2d
         ZU6TCB6lLEf2+cY0mdoKQJmGIgVFyoLAjymeZb5faFgaVXtEJWvD9vTdwviN7aJLTBGu
         88MQBNI5Byml9kJUXYsbtV3IhQJDiB2sTbkRNMpkjVfJUTVxOymjJYXf9WcrpL1c0aGw
         lakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7Vqv1FAIAtraKYIYInQzp3Fyux+Qhb+g6H45hioKM0U=;
        b=6SjWCMBQcUhGxgbfO9Ymex+ngw5zBQUg6uyS+0OO/hoOsP0MnhnaDiyHSMmzix96Ga
         QhC1anzIOd5od/Cfrd1uih8/hXGXLSpvEcOQDU1VT2TbQFHDluXZvIXpCyBCH1Qj5Xbn
         M7yXR5bDTza6H1MteTcY0K9BABJ7lePzlexqQOTzsMvujYXDNRT+PM14zwxZNZb8evGA
         lF11BtDcHxRj8J34/mJOOY8Y3Y3CNbse2J7+N5aSl4OhvLvPYkojx2jxmrhYmzPyiqJh
         /jErALjoKH7qhsscynD6XgaH1TINgoefYPlgwjuOQ7R2qg7qyk9pL2kol7If+huOB77/
         QSgw==
X-Gm-Message-State: AOAM533nK8haA2h5HBczIFdHUU/Kp2p3HaLApRCG2hN+IgofRKkqsaE+
        Rn6SVzazeH7yRTuFxxDyJufk/XuasQYMX+Ra
X-Google-Smtp-Source: ABdhPJzHWU04DBVLUg3N7ZSfbvICh6WftEOxgoJhuD+h0T9xthzaIiN3v4wdMZzCCvQd3qGOhQClkg==
X-Received: by 2002:a65:6a45:: with SMTP id o5mr12129422pgu.273.1639945226520;
        Sun, 19 Dec 2021 12:20:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id my5sm2136092pjb.5.2021.12.19.12.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 12:20:26 -0800 (PST)
Message-ID: <61bf940a.1c69fb81.a9d7.5b11@mx.google.com>
Date:   Sun, 19 Dec 2021 12:20:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.167-43-g447e481328c4
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 196 runs,
 6 regressions (v5.4.167-43-g447e481328c4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 196 runs, 6 regressions (v5.4.167-43-g447e481=
328c4)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.167-43-g447e481328c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.167-43-g447e481328c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      447e481328c4707fbd3b31b0cebeb5e3489b2bf5 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf59ce13e2978c5a3971a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf59ce13e2978c5a397=
1a9
        failing since 3 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5b84fb55fc5da939714c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf5b84fb55fc5da9397=
14d
        new failure (last pass: v5.4.167-44-gcef075bf53d1) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5ac744a8ca2038397162

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf5ac744a8ca2038397=
163
        failing since 3 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5abb89122f911a397149

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf5abb89122f911a397=
14a
        failing since 3 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5aec88f4219091397140

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf5aec88f4219091397=
141
        failing since 3 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf5ad4258300f65f39712b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
3-g447e481328c4/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf5ad4258300f65f397=
12c
        failing since 3 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =20
