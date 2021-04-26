Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0308A36B328
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 14:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhDZMhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 08:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhDZMhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 08:37:39 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289E8C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:36:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t13so2856134pji.4
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mpCTnGyGqp9ffqULXVkXE7sPbMzOXB75QdYuJGMqO2U=;
        b=qrWb/6NHo5qwrPVmsW+udFdPKisXLVV68jCxsKFfjS7amoAYo5p7tv3bbKKdd7eMz/
         6h59rYsf4VCSDKqymFW2eYDLX4tb0bsW93otDP5P1XimG98fiMFpjBx7MXj8l3pFUzcA
         wc3kySGpOoOzokpcqeGClfhTHTrpkzvqOtrseobaE2f9ROddmfR3NvN/JKbVCrztFP9E
         YeInRkx2p9abvDa49bKzj0RqSqMISzHwp7wVNZt73MV4wz0x3CjgzC4LrxoFXohVB/oV
         +1cQoFsWqEcTSmwYbDaBkVKzDQxDEoinnmw5w25GFL1WdgZu/gH4xwMtjMkBDf96LBqt
         TwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mpCTnGyGqp9ffqULXVkXE7sPbMzOXB75QdYuJGMqO2U=;
        b=oyZShryaKX2gyhVnFRvJ9pBKymJa6F9AjZ1KGZ3gyXV2x22ocH55/zPPfQgrWJoXh+
         U80XzV2gIra2YC6Jf5XJhj+seWje/PtBZQUYIqPh33oTSkG9SIVzqI27qk/f362jyk93
         p/lIG4rdkTCfCLeP2XCg1c8IP0Vo2rbUje8YAMZygCRtXywbe0ZGVjUNovZ7QeNg8JNe
         0dhi1JFbDbDDuHIvREqYjcqAZakDarBCshcDL0vRQX7ZCKml+eiCMC5pcJJd95oKDhtP
         siCfnKJtjbVpU5sAKrGt7qqSGr7DjChkl0o60XdQsB4SeolaqVvofE2RUoHAZuC5yaSA
         /d5Q==
X-Gm-Message-State: AOAM533d2yvU0nAd0DT14GxQZKNDhuTb27jIlGxPxEIG3dWctYnda7Wb
        1of66MhvdpEUwhWGRnhOxDX6KarDvFg8xxr7
X-Google-Smtp-Source: ABdhPJyYW3xi1+t+htQJpniakX86gnYDTYUqT2UV83yR5CgM+yjPTnRRVyoJ5nAQvtz7xWLfujUP7w==
X-Received: by 2002:a17:90a:f2cd:: with SMTP id gt13mr20885266pjb.43.1619440617435;
        Mon, 26 Apr 2021 05:36:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z13sm11380162pgc.60.2021.04.26.05.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 05:36:56 -0700 (PDT)
Message-ID: <6086b3e8.1c69fb81.14dcd.0db9@mx.google.com>
Date:   Mon, 26 Apr 2021 05:36:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.188-57-g2ed6fe84bcf42
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 125 runs,
 4 regressions (v4.19.188-57-g2ed6fe84bcf42)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 125 runs, 4 regressions (v4.19.188-57-g2ed6f=
e84bcf42)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.188-57-g2ed6fe84bcf42/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-57-g2ed6fe84bcf42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ed6fe84bcf4278eef2d6cfc45bee7ee772029ca =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60867d2a4ece1d3ecb9b77d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867d2a4ece1d3ecb9b7=
7d3
        failing since 163 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60867d26e14e93d3c99b77b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867d26e14e93d3c99b7=
7b7
        failing since 163 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60867daabc675a2b939b77ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867daabc675a2b939b7=
7af
        failing since 163 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608692b4ae880beb089b77ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-57-g2ed6fe84bcf42/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608692b4ae880beb089b7=
7ac
        failing since 163 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
