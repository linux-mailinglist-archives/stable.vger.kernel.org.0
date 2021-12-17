Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112BD479500
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 20:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbhLQTn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 14:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbhLQTnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 14:43:25 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3FEC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 11:43:25 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r138so3067118pgr.13
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 11:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WaJomHHzRZ8vLkBLv7txm2swa3pwZ1AoS06iDJVDAEg=;
        b=Dmp9NoycL1X5//SdpyT+YFRarqI9k6mlcecflTlhWC6QQ3E3lopHSnneEalhJ2MlqB
         amgxnFapCw0+/xPI0HzovPsSPrMqOHz14IGBrf1nDNqMmdT36W7iLFvn+cFTyXlx7zgs
         /NVa3b7YMS+L/Pbzh3n2W6pyNa5GY5k5VTmOgSwsLvUtkks3QuFyj9Ac/90DKC3RosM+
         sVtclBzChuFcHqDbMDfo78k+D5+71vGhKuqV/J/HBWKfTe4xbWXTY/Q9lDK7YnaXPKZE
         H7RhiSVWwXyu8o+Nam8JGztp9X8nGj3EHfkoXKeQUXkS4n7cqrIMgF6WqRTJ+ItDSyKH
         MXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WaJomHHzRZ8vLkBLv7txm2swa3pwZ1AoS06iDJVDAEg=;
        b=3/QklZstCdBalo0QPz2SL9cnLbjPOl+AzD42KM4WziH1ZT1ctNE1tGBaI5pYPwe3WI
         VRUPXiBOv9HI2nDxMMrr/qRbqvZbpTldROjOjICxwVesDQZzZe/4qmjuuAkIVEohdQaw
         owH434dqM8ce5QebH8HfYgAwecCEC9OmipXCJsKC+9UHWGyvSxE/H+H/CPPMN7zO2rnm
         t9iGEgO3TFLqKqWC7qAzl+IQ2+TEhjrz/2GQ6VhlOB8qDvnBrOKjuIhF5ZkZ8adX61Kh
         V6HGtzgTUnuB9K03ZCa95TlONdHt7f6p3TbW8e/lu7jPgX2WVXBwRfpVmRxX1PFysJeT
         bcUw==
X-Gm-Message-State: AOAM533chJyBaDLOXyl/nQjA7/ib6OAExVvlTxR83XrongkbcWqX8TtJ
        UC4wbvijHJmlYu/SyaX+Y2/AYs3qEIKl1HQR
X-Google-Smtp-Source: ABdhPJxnY+yW8KOp8kk3MmwQ4Iq5uGtrw3WTIeYmtvqkL+jZz80h8BfvOVKzxSqd5M/cap1D99vjbw==
X-Received: by 2002:a63:ef4f:: with SMTP id c15mr4134470pgk.322.1639770204279;
        Fri, 17 Dec 2021 11:43:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe12sm12062020pjb.29.2021.12.17.11.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 11:43:24 -0800 (PST)
Message-ID: <61bce85c.1c69fb81.22b45.17cd@mx.google.com>
Date:   Fri, 17 Dec 2021 11:43:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.167-10-g83016d591d1b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 154 runs,
 4 regressions (v5.4.167-10-g83016d591d1b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 154 runs, 4 regressions (v5.4.167-10-g83016d5=
91d1b)

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
el/v5.4.167-10-g83016d591d1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.167-10-g83016d591d1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83016d591d1bc73d1ae88c771684fb0cfba05f21 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bcafcd304b6a51f939714e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bcafcd304b6a51f9397=
14f
        failing since 1 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bcb1aa2230be6093397145

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bcb1aa2230be6093397=
146
        failing since 1 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bcafccc89b725923397142

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bcafccc89b725923397=
143
        failing since 1 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bcb18201155bbaf9397190

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-1=
0-g83016d591d1b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bcb18201155bbaf9397=
191
        failing since 1 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =20
