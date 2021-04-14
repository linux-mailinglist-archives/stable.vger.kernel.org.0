Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41DE35F662
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhDNOnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 10:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349875AbhDNOnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 10:43:46 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A60C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 07:43:24 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t22so14596372pgu.0
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 07:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fxL3LKeIS6j0JvlC4iTJgDvWVeN4q3zHqf8yxw3XgsU=;
        b=GJGKbU/zhz0YEiUhOtPLfAVyTYTgOHe0bXwDhV8/sREuAh8r00Dt8x76/Zy93XzH1Z
         YxMHOHd65c8FmC2PkIEgq7QDEslCChW3IH13YV6AYwgmVnTNcHEIIA6EuCmQ+ht4g/jG
         LrGNCq7iN/5wNhZQ1dFJD3u/QQGw2sn/k3Td8a9Do6O7brikKRq8WlzdJ8Qpzy98WX2N
         1jhb8BEPp9/tOJIXncfCfcBjfppL1wKsuv/94oe/e/ACSiDalDKG+ZbG3+Z0UKZ185p8
         m5Z8cGTQZ9M3ZqR7IMjLLhUQd5NxIKZB6dGkgA0sLeXN4FOvWTIjejeYzSz63hc1Hbkg
         ZbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fxL3LKeIS6j0JvlC4iTJgDvWVeN4q3zHqf8yxw3XgsU=;
        b=NYondX9cP5VKlTo9kAUKN4peCeZ7sVurY9uA0VXrUau3NmNCt7rf7wjmkWoURSqEZq
         dDb7QbxVzKqQ4wBOM3dkE2NizM0YtULCfQAdm1SfKZFyadqdRNn3H9Vdr1Z91zoq4L7/
         lEIdFJbF/g61DKSCCORLpHzva1s0BIosBA8BeJ95S9Xd1hV2ySjluLNUurhw6/rkZoEb
         aQ3riNvPKslLi4UKp7+y7ZepdJDONAJcB9lR+aPitZkDTxyHr+NHaEbN6vy+IkC30Vfn
         qxVTSyomuEJzwyPcw5nzy8SquZ2SfSCAAwul+mI03R9NTsVByDRCkpCfaiwxbHpSHzyR
         Oshw==
X-Gm-Message-State: AOAM533PGNV3nupbnVp/p9yntCIiKZHFawz0gd8GOccNRzTLGe6C8RNJ
        ZEnUoR4S08zelqEEFY3rc/FM4mA43Dq0JA==
X-Google-Smtp-Source: ABdhPJyf4QHKHlU3xMSjINJKuZ6s+nBJO7FuhWBoW+7Om+WGwUQbzyfR3yN9BN0gmMnc5V46KEBnQQ==
X-Received: by 2002:a63:570e:: with SMTP id l14mr37715147pgb.159.1618411403005;
        Wed, 14 Apr 2021 07:43:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18sm5045932pjq.33.2021.04.14.07.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:43:22 -0700 (PDT)
Message-ID: <6076ff8a.1c69fb81.1eb72.e99d@mx.google.com>
Date:   Wed, 14 Apr 2021 07:43:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-42-gf374bdb11fcd2
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 4 regressions (v4.9.266-42-gf374bdb11fcd2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 4 regressions (v4.9.266-42-gf374bdb1=
1fcd2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-42-gf374bdb11fcd2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-42-gf374bdb11fcd2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f374bdb11fcd22e0c44db37408f5f5675cd09df0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076cb55c095ad9810dac6dd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6076cb55c095ad9=
810dac6e2
        failing since 2 days (last pass: v4.9.266-17-gbef36b8f37175, first =
fail: v4.9.266-17-gb18de8247ff14)
        2 lines

    2021-04-14 11:00:33.417000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/123
    2021-04-14 11:00:33.426000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c980ebf621e70edac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c980ebf621e70edac=
6b2
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c98f1e1fdeab57dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c98f1e1fdeab57dac=
6bb
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c9273aebc6d41edac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gf374bdb11fcd2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c9273aebc6d41edac=
6bc
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
