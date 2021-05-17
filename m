Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2019E386D95
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbhEQXNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbhEQXNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:13:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD157C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:12:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n3so4018704plf.7
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=52hpgrg4ZmlkCv4smthZ2SgUXeoLfJpjb5ReoBRYNj0=;
        b=htKiSEajWZjBiXbBdhzu8DR6q/gVPVOKO99KvIX78IbWC3O+ZMWqfiLGROdn5ZMgwZ
         JNsyQSW/tw03kfpPwH5FU057NduzjqcR+jZl7PUFG4ODKHX4/uEAq4KdYTZhbX0FEbGT
         iSaMTLwfK72PK80JIIPETW66XwLww6QowNNvbKPjjMs4TNZZmnxIqRw0iZD2MpOyr6kY
         3gm/LEP41o+/RM03y0Dbwc+fcsy+oCgtOW2zao50kG4xJIH+RpkulRD/5AI9P64v3jeL
         nf3UD1eAVazXH/TSrsoO2ngZF7L9j2IyLN1aAhcKtZXgBcMJZ4ZIV2yWubyR1Cv6kd4J
         QDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=52hpgrg4ZmlkCv4smthZ2SgUXeoLfJpjb5ReoBRYNj0=;
        b=ZIJ36wkgKLczKbTIKxkClwBi/bqcDeHdQ73FOSc4FEGXeseLwSQ9k4wliAZBoZxI7/
         HUfG26yenoga4x5/qEtw/ShTOgycdp1zltkB27IZ72n80Ns3YbjcoMqfdlWwZ5IvWadv
         8UM3qYlwYEJ0J45W8YyZ6VH5kK4mfQyLNcRhudByTCsjxSOuBpRMgbMY/AKd+xWPc1KE
         jsep9eLuCU4xEw7xqy28rTYe9COl0q6KZ/KVnR2cNBkkxtF+H3yaZlVIfC77s7qaiQFS
         BRct/O9wEW9fvN5CzVqixCHyAwAjiOJBWoDx2VKUgCESJNrKqTmb22kkx9Sn6vtif8zw
         5JNA==
X-Gm-Message-State: AOAM531quDH3sDT6p/IA4uyyFID6t/jtVqSEW7iAI1/mK0jzU6iNZ0+V
        KhtjdQm1nBizWoy34Q9xepmzDyqeK8e4iIAr
X-Google-Smtp-Source: ABdhPJzl+kuISrOW/uXullXYc7G1aqiLk8dxe4k8p93hjBn8W7dBNZvA8RhaWd48ZZEDLei1dj4TVA==
X-Received: by 2002:a17:90a:1588:: with SMTP id m8mr1650105pja.226.1621293157096;
        Mon, 17 May 2021 16:12:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x133sm10929822pfc.19.2021.05.17.16.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 16:12:36 -0700 (PDT)
Message-ID: <60a2f864.1c69fb81.f274f.532f@mx.google.com>
Date:   Mon, 17 May 2021 16:12:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-301-gf41744cb6730
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 4 regressions (v4.14.232-301-gf41744cb6730)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 99 runs, 4 regressions (v4.14.232-301-gf4174=
4cb6730)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-301-gf41744cb6730/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-301-gf41744cb6730
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f41744cb673004450114cf9b68c21417cccfdb02 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2c87b83011d1518b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c87b83011d1518b3a=
fa5
        failing since 77 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2c3ef19fbeb250ab3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c3ef19fbeb250ab3a=
fbe
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2c3d2d25c2b098eb3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c3d2d25c2b098eb3a=
fc1
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2c3c25074f07c7fb3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-gf41744cb6730/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c3c25074f07c7fb3a=
fb9
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
