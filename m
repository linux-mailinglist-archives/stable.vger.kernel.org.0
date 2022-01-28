Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3850049F23A
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 05:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345873AbiA1EH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 23:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiA1EHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 23:07:55 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D045C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 20:07:55 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id e28so4988351pfj.5
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 20:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YzRQvh9TZYGDktZPxcViMqmwfSsvWZRUjGtpdoYDEbs=;
        b=GEv8OvO/xaMMRJlQyQgdzB6pIm7bSRcyOg0AWUdK/+EDsoo2uMg5ma2gDh+mhIbvOz
         21woPBk7Re5yplGJoz2xpPRCQmERQtKextv/O0tSJcSF02UfoP4VSjgQ46n/m2B4pgTe
         NCcXA2+TRRkcblinYrZ2RKmY4M3RmtGbjgFbPYeKfeEEY+oq/748SHA16bKEefyEGT2G
         ycSZTXBeQ4nEtv9D309r+1tE7HVve6lKHwgH8QwAfSm/zyqcu23BIXO9JHRuxtdIsEmv
         Ou57l8aQXGX94ZBxvZnaPYIE7iDkvsK1pEqj+3x8R97dIa/XPm8JkiF1ICdZrVChC1tW
         SsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YzRQvh9TZYGDktZPxcViMqmwfSsvWZRUjGtpdoYDEbs=;
        b=1HivD8rjgEIzajvUTBaGooZIllzeJlFXNEo58b4dcxqRZ6HHr1vgGSDCot2hVN+yXS
         qKDoBQNeOcZMgYmvAogikv7wbNqXf9UB9D5U4mPkwrsG/2jT9Wnr5uz7HsEjdzlMJuVH
         sl3BT0Fx50XvaDwDhpuS4mwPBe97wym7jmVD+lB3NRdrJ1sgzq/lv949qF5DyxqlrOiy
         iClhyC439j0aFm+UdSzxSN7FM8AYw00yivCQTD0Sen539soRwJgrlP6AIDMtqzRc0wgM
         ctJ3mbV6vWw6kDzGfeU0bUCtG7qGTejoNuCeC9usrBBI8gQhNIVFT7rVd0AVlvEMNS+5
         OL7w==
X-Gm-Message-State: AOAM5312IMuaXdGzUJpS8Lw97R7XW6SboGsZdaRVIbERv61t1+fhU0r3
        WqIpcysaAlCg3vKa7Yq99LuErXHcYnZmhNrJ
X-Google-Smtp-Source: ABdhPJw+XOJC0BzaiM1F9NII0q31VPRVJnjzWcaOWSX8J1Vq8hk5MoTvyUvI2+RF9w+TIHjMxPJOZA==
X-Received: by 2002:a65:63d2:: with SMTP id n18mr5165126pgv.245.1643342874718;
        Thu, 27 Jan 2022 20:07:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y41sm7554116pfa.213.2022.01.27.20.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 20:07:54 -0800 (PST)
Message-ID: <61f36c1a.1c69fb81.6ea5e.5ee5@mx.google.com>
Date:   Thu, 27 Jan 2022 20:07:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.174-11-g7efd6d30182b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 126 runs,
 4 regressions (v5.4.174-11-g7efd6d30182b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 126 runs, 4 regressions (v5.4.174-11-g7efd6d3=
0182b)

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
el/v5.4.174-11-g7efd6d30182b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.174-11-g7efd6d30182b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7efd6d30182bdda3f31066197aa85f17eb181755 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f3349507298a53ffabbd8a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f3349507298a53ffabb=
d8b
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f334bc28224e852babbd23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f334bc28224e852babb=
d24
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f3349407298a53ffabbd87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f3349407298a53ffabb=
d88
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f334bb28224e852babbd1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
1-g7efd6d30182b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f334bb28224e852babb=
d1d
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
