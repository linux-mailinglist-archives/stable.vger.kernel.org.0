Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74612DC451
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgLPQcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 11:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgLPQcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 11:32:21 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52B0C06179C
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 08:31:40 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z12so1771540pjn.1
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 08:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rTacAzP4JPtIs37H9l7rlA7Gux36hshcgZyYhZoZPVE=;
        b=DIfBqrb3pX/SGVFG0wUFsyf3IKsnZulh+dzZTji2lWsejkUXtPHwwKajw6GCHVXimM
         SBdfH3h/wzOFjkkR4O2uLUoc4bhQXifVGG4IVX80t9C1nvQ/rGReivqYTEAVNTu7XcW5
         5rXJkr4ReASAfCMd9GHu9kvXH41fcGztmShlSb3iqnESpvgQC3pzrMNCPDrERhIh4UgB
         zQWDNuVV6UGMqXF7XMboB8JaKx6hgcaMjgmE8CuGGmyEPkxCwvAvDnds5Zkx0MDkTKWK
         GxXY/u+MNCYdT4CvbZmc+Ikgf5LtgTh9dkdSTGUSWMuVc917qp+Fx+6KAu2kn8GT2SDT
         EnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rTacAzP4JPtIs37H9l7rlA7Gux36hshcgZyYhZoZPVE=;
        b=Lz5GigE2DG1KsG2Nbo44VicMWrZLcFgmiy2oEItfLFjDN840GdwATBq+MuOfQ8HbVo
         99LI2O7dORc32FVapbyzOt5tuNzZ04jmdv4Zf8B1vdWYNrmDPAiHkumC3bNBJqrYX0n/
         6Pk5E/n7HS5vubjyQ/3XaHKv0CEiurNGoVF8nnfMeqk/mmJB706NtGoaT9ULRQWsJWux
         YE6wmjlPKg7RCq8JiyRSXaxeEPMSAGZaphOMlE1Txg77PeYYjliLtqn/IWbK6ZoWPoba
         eqGHm/8l5LJXP6j2Y6dLx98EO6mqOfW+VXorcoRvLIviN9sUMAYZFJHfGFWp90AehHvu
         ItdQ==
X-Gm-Message-State: AOAM531OtezUlOJPUKHSEiBj2GBp9iCZrML34nxPf6eKGJ7+P4ju1weY
        SOAn+19AJJfSQya6WRlG+Gu3mBpZ3pR+Fw==
X-Google-Smtp-Source: ABdhPJzBrfOeXCWl8aF8kOED9a2nuNl43CIvWEg+cC9MR23HhEFypexWoQaZp5cvEkwzlSxtcAklRg==
X-Received: by 2002:a17:902:8ec4:b029:db:f9ef:564f with SMTP id x4-20020a1709028ec4b02900dbf9ef564fmr2385640plo.19.1608136300039;
        Wed, 16 Dec 2020 08:31:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm3070122pfj.95.2020.12.16.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:31:39 -0800 (PST)
Message-ID: <5fda366b.1c69fb81.2bd27.69cc@mx.google.com>
Date:   Wed, 16 Dec 2020 08:31:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-27-g2bef1183de380
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 131 runs,
 3 regressions (v4.19.163-27-g2bef1183de380)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 131 runs, 3 regressions (v4.19.163-27-g2bef1=
183de380)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-27-g2bef1183de380/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-27-g2bef1183de380
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bef1183de3806d87d6849076b8f9f43cd8373ec =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda03fbe46b323cb7c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g2bef1183de380/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g2bef1183de380/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda03fbe46b323cb7c94=
cba
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda0402065aa24236c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g2bef1183de380/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g2bef1183de380/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda0402065aa24236c94=
cc4
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda1a770dee5bc85fc94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g2bef1183de380/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g2bef1183de380/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda1a770dee5bc85fc94=
cd5
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
