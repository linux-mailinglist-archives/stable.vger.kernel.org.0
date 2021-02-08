Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDE312882
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 01:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBHALC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 19:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBHALB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 19:11:01 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3E4C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 16:10:21 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id c132so9106692pga.3
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 16:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yX3TzFjVI+NFzmKfxaIAjLCfDLDREUiI6xAv/QnAb7A=;
        b=FUo6vahZvpzGWwl1+TjUMEmRQbLo16F/SRFVxg1k5JeMOg2oagE4ugqScpb6jiTd5o
         73NUOLksal7O3biaB8TegFjjQW45cZvTQC6OO0ACMuwDiMh48+QtNYEd7yk32qrlQuWE
         9K7/GCWQweDg5u8l2A0tqXyeMBhpNY/Jgjto6VJGYHmnJY8goth0XGvO0aQukJNBeM4+
         m4sOhtYAzQXwDdf6FLNOfKpYgfnOQNH00LT2x5Ocvy/g+LZ8ZAAnp8W2UnPcZAOwnmBN
         pO4dhYiY+ZNINWlam6Wm7xDSo4kPSk3wvUWYw4ceRHlywBlkKJNSkqxZHjrzQJZxPFQz
         mXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yX3TzFjVI+NFzmKfxaIAjLCfDLDREUiI6xAv/QnAb7A=;
        b=oSHmMsqA33Jh50pMgon8tz2QIge4hm5Q1c+SWmOyeH8g14MzDOLLAJIcKpuDPRboQ9
         VOcoN14Ggo++J1udT4APkFCgVlfBC8vHZUNnhjTBHU1ti47Mm6m5+uHNKrLWGC34GGWs
         ZXraJhv6Pd0wgQlCp+o1H7C+K8MkcyHPt624FekVJE/wgC2TH6dP15WkLmuYk/LAES86
         VaVG7xY4l93uGC5fucH6Jwu8fZ1ICfzwLSkRBirzsXQL/tPu6tSsKpebghw6vOc3QN+e
         SfMjoRMSbgrbAIHK17CdejdGyS+x7v3N1rDcyHVrJKNS0uZ0wgz69Al2yu7wc1W6A1ZI
         CB0A==
X-Gm-Message-State: AOAM531Wl9MbrLfbvVrE8psbDQ8v49CLAIGrFFhwHjjLFaRUSPT48UO1
        e9TZD6RPGqA0oY3SCHIuaxjq/Dhdmf4faA==
X-Google-Smtp-Source: ABdhPJzr0UdnF1JnkHB28DGog6cz06S53vFAwwogoYJc/gSK6GsSPIMBOIVlIFsrMumTfW/ZmqE2mQ==
X-Received: by 2002:a63:1c09:: with SMTP id c9mr14507488pgc.185.1612743020217;
        Sun, 07 Feb 2021 16:10:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d19sm230589pjx.54.2021.02.07.16.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 16:10:19 -0800 (PST)
Message-ID: <6020816b.1c69fb81.b7769.1002@mx.google.com>
Date:   Sun, 07 Feb 2021 16:10:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.220-3-g9106c86c869f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 142 runs,
 6 regressions (v4.14.220-3-g9106c86c869f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 142 runs, 6 regressions (v4.14.220-3-g9106c8=
6c869f)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.220-3-g9106c86c869f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.220-3-g9106c86c869f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9106c86c869fba2cd961fa83b7d8352a6dcbe742 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6020522fd85bef9d873abe74

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020522fd85bef9d873ab=
e75
        failing since 61 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602047305472b1ab203abe89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602047305472b1ab203ab=
e8a
        failing since 86 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020473ebe820cf1b03abe7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020473ebe820cf1b03ab=
e7c
        failing since 86 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020473bbe820cf1b03abe71

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020473bbe820cf1b03ab=
e72
        failing since 86 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602046e6127c55ff403abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602046e6127c55ff403ab=
e71
        failing since 86 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60204f1175a8ddbb763abe7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-3-g9106c86c869f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60204f1175a8ddbb763ab=
e7b
        failing since 86 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
