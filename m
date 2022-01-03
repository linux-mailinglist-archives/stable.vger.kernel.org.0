Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723A1482DF9
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 06:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiACFUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 00:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiACFUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 00:20:20 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8CCC061761
        for <stable@vger.kernel.org>; Sun,  2 Jan 2022 21:20:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so31308304pjw.2
        for <stable@vger.kernel.org>; Sun, 02 Jan 2022 21:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W29HQJ+6pmWP4PpK7aUML+sii4Qiy06RSR1fd4gxawc=;
        b=T6Rdk2X2u9J7wCC+CGNBJ2pSjSdSfrTgtczXCIZgMAiJxystxYBBGfafAIsK5tlynM
         jIfMwNrFutWIzg56Par9YqDnOOtmlmT+66lia8sUsqN/YM21P/wYKekphzvXz7oYKUbZ
         jf+wdrlFKyiiGhm4mKmhMIZBfwsNZIm/c8/5mlknx+WwlhqfKcG7vgOH05NSa+e0pcTS
         omZ/BmRSlkWHrJLceBru5L6++eAOq3UxE8UCqOVVT5CxAj8ap6pwRuwFFdpVqPLaD7A8
         /ketLwdDmOKrsjc5dd4MhtoeCc/NF7uwP7T42a3xhKMxy1Day3vkVDiQM/mHVGYRVK8I
         l5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W29HQJ+6pmWP4PpK7aUML+sii4Qiy06RSR1fd4gxawc=;
        b=geo425MFy915Hu9vwOGdwUsYkGwvOPFHU5/A/uB7fmdXYk+twKBW61bRT4MEUZxW+L
         41ClEMP1mgCF117pqeCSQ2eIfmMFF52BMwZEgvHOHLv0+8QIH4vXEncEgBEbhpc8BeXu
         fZEmSgUSRDOx+DO9LPP5tuheHHJ6jygj+EgdHOMEmGoVKqZ9CQDO8wO6Bp9EAZ4q1d9n
         Mh+XnYNCth4Ptxxj5jluQevH/3Ld3qArt7hTL2FNde657nwQpZ4fz073uDsirBPYn7CE
         TLmzfQ6W0o36G8LzMZKg9i89slPH1rn/UJknQalRVXCuvwzxuRnMwCubhhlbUypIQzmG
         tLrg==
X-Gm-Message-State: AOAM5313dF4Bo4ckGvHPtoPmHH3CTSHZpfWEBlwclR1dzpA2lurXjWh+
        ++4pDVg1NTGnapKUMNxOnGKCn86H1n82eVRG
X-Google-Smtp-Source: ABdhPJz6owcFHK1LjoIGig/s385PyoJPi2u4lKac5odY8lhmJPB+F7uGg8uqoWqSH5FS1tLPKToiGw==
X-Received: by 2002:a17:902:7ec1:b0:149:6a62:5dd3 with SMTP id p1-20020a1709027ec100b001496a625dd3mr38680716plb.33.1641187219284;
        Sun, 02 Jan 2022 21:20:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c124sm35797987pfb.139.2022.01.02.21.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 21:20:19 -0800 (PST)
Message-ID: <61d28793.1c69fb81.ba601.1e2b@mx.google.com>
Date:   Sun, 02 Jan 2022 21:20:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-23-g7f1f0a5db273
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 4 regressions (v5.4.169-23-g7f1f0a5db273)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 4 regressions (v5.4.169-23-g7f1f0a5=
db273)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.169-23-g7f1f0a5db273/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.169-23-g7f1f0a5db273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f1f0a5db2738e87fdc0cb025c91a8909ac2c1d6 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d249d110021647e9ef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d249d110021647e9ef6=
73e
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d249dc10021647e9ef6753

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d249dc10021647e9ef6=
754
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d249d310021647e9ef6741

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d249d310021647e9ef6=
742
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d249dd10c197c844ef6754

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
3-g7f1f0a5db273/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d249dd10c197c844ef6=
755
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
