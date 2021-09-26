Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977A44185AD
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 04:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhIZCc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 22:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhIZCc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 22:32:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32920C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 19:30:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so1411505pjy.1
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 19:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ay4yxQVKm3i29HeDNfH/+cVNLnP2FP8gDpJh9mZDEU=;
        b=pkaHC6CAhP4Vm3Bi5BCdyOXPjHCZMcSbM46wfSuENUvvZtosZmdhCIMtD2T817tFFt
         qnV9N653UpsO6gSwjtPmr8DYqZbja0rbjsBRBoVktEwlMfNjWgwzskwpM0UT++7gxMg9
         ND0ugFgFg28K0JfGr7xQE/Vwg3p1WQfKY8PL1/zRnvbeL1umNew0AQEwvzV7kwlrjkKG
         LRBCGpZVKN+1qX7OC+3ctWxZDH/bFo5YJ7wztxXP384tHqPSOOZHWiPaq9IAr/wZm0we
         UVsqO6LCgwQVkvdAJlTSFkMq7D8vl5oMBguv2CJfRcPN+Yeh3C8n3VrD2t6ZlRkCeoLn
         PLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ay4yxQVKm3i29HeDNfH/+cVNLnP2FP8gDpJh9mZDEU=;
        b=nj058hz6qlsp+CqK35XM3+vR5gQ/zC80vhC6NTpoYPVXggDhSxRlGZHUVS6mucCnfj
         IFnPjlyDQB+7jR1zJ3JiFrJ+ZdNaYtzjM7zHuGy/79eoUUHIf/38Q4vHcH0PZTqlkBu7
         U9gUzcbpiyCS1q+FUk88r73SPvEaeYOUdVRMOd4fj95xC4lJfSZwDjwI1vViuGgiQaYI
         c0iE5ozVtOmxPIMVvbh7NIl2xot1CDOt1jq6H6gQPCCBCBrj4BGuYd7HCo1n9nIk3QUG
         FNBvYbuIcq1xTkS5QF6WM6HSjiXqIfAIU9VDvMiFBn4MJAe1x9vnytYn/X8fsixfb/BW
         xG9Q==
X-Gm-Message-State: AOAM531w17sAJKojGqqAbeicYXDomClyvW+290Jv8t9pn0viceISX0QU
        oGOtGMfJV6Md70Shp/bQ+F/PC9WGmywRdO0a
X-Google-Smtp-Source: ABdhPJzvrYMpc7ZSlAimwzZUwfbv8l5NoNI8sWi23ml0SuUuHntKINuymTB4gDaKAC8mtDJVYjv9zg==
X-Received: by 2002:a17:902:ba8d:b0:13d:cb44:369c with SMTP id k13-20020a170902ba8d00b0013dcb44369cmr16125108pls.40.1632623451523;
        Sat, 25 Sep 2021 19:30:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v24sm6278143pff.107.2021.09.25.19.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 19:30:51 -0700 (PDT)
Message-ID: <614fdb5b.1c69fb81.a0e4b.3854@mx.google.com>
Date:   Sat, 25 Sep 2021 19:30:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-26-g6dde44894253
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 43 runs,
 4 regressions (v4.9.283-26-g6dde44894253)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 43 runs, 4 regressions (v4.9.283-26-g6dde44=
894253)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.283-26-g6dde44894253/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.283-26-g6dde44894253
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6dde448942531bbab9d0ecc5ec19f484651427cd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614f9c197b16f8b1de99a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614f9c197b16f8b1de99a=
2f5
        failing since 315 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614f9c1f8f1fb1070d99a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614f9c1f8f1fb1070d99a=
2ec
        failing since 315 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614f9c178f1fb1070d99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614f9c178f1fb1070d99a=
2e6
        failing since 315 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614f9bbc4671e0c66d99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
-26-g6dde44894253/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614f9bbc4671e0c66d99a=
2e3
        failing since 315 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
