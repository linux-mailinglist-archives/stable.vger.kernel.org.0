Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648AE3C425F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 05:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhGLD61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 23:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLD61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 23:58:27 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7557DC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 20:55:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b5so8464693plg.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 20:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mdHzj99NNF1jtKmfRfUNFZ53yCTtQo4EDW6xT9bQ7so=;
        b=tYSwXjwJm2BC/2URQ9j40vYNRwVRuqleuyUNJ+pBlaxL6IGvP6AR2C+R5CXgveu/3q
         pMdFLh/Zx7fDNXqeAP9WjUVLzb86nGqG9h/Fp5wwDy6ILGuQOSzs/XDncXLe8kKe9DJD
         1mLIi8kqRvV8m3ynEM/R7b7ApeEZOEPABALaRfJsMUC6WDDkUDgLNyjKoXMGKW3FLqyt
         CSAeFn4sTUKnrrEefPANOVOOK/rgPNQR7KX1fPh9ESZBlZIFuJcq9k6+7bxbj9+RJ2Dj
         OhHQt1uAsLh+5KqqPewhcKPWuD1muGqA0ZCfYoQg2SfdoDGWcdV0uKbK5btl77b0iqvD
         h/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mdHzj99NNF1jtKmfRfUNFZ53yCTtQo4EDW6xT9bQ7so=;
        b=aXDZEM8FNmrZ1uKQvy4jTfWPHo/aGGJBZsoSgosQNIAViXV9h6lbWxSkx2ltqSHOrS
         0gatGnKGwpTBW8gIUiLu9H9Ivc+8s/AonJRKSi/Gy0x3oHKXb0J14bJ6zKu9JmpwDRFQ
         xHChkVtBwXy6GZsbqvDH+CeKbmFet4vGfbMudMne1Av7Z3aIF5W8P7VqBAzb+Lj85XWe
         84ETZZpEk38B/YoPJY3axXuyGsTO4lVBrul86OmzYYUwm3SbKQ2JAGFhus8Lqi4PVdn7
         GcgLgdSyaqb30N1S8iE03JWBRf9atQWoxaQQ5KnobWiV/Z0SBRbdzsWfojLF3FImgcv6
         QHRw==
X-Gm-Message-State: AOAM532nlewRTgz0YgEeSgEn6wvYRWbt/pXGqWjtnfUfeA9mC3qFeeXj
        C3QCedHGYuQ978FzQvlAk0xDRVboySGzLJy7
X-Google-Smtp-Source: ABdhPJw2EhX6d1byZPr3U/gA8WwzkLMoM97igHEgYWVG93ZpRmZOJhZO4FXiIqcx73ik+I/1vNsKmA==
X-Received: by 2002:a17:902:249:b029:12a:fb53:2035 with SMTP id 67-20020a1709020249b029012afb532035mr7025142plc.73.1626062138817;
        Sun, 11 Jul 2021 20:55:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10sm502223pfg.160.2021.07.11.20.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 20:55:38 -0700 (PDT)
Message-ID: <60ebbd3a.1c69fb81.20933.1fdb@mx.google.com>
Date:   Sun, 11 Jul 2021 20:55:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.275-123-g3ee35125d5695
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 104 runs,
 4 regressions (v4.9.275-123-g3ee35125d5695)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 104 runs, 4 regressions (v4.9.275-123-g3ee3=
5125d5695)

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
el/v4.9.275-123-g3ee35125d5695/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.275-123-g3ee35125d5695
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ee35125d569536fe626dd5ce741cb7ec5f18c4e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb84cc65b6f937dd1179d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb84cc65b6f937dd117=
9d9
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb84b18ccfeb155f11797f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb84b18ccfeb155f117=
980
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb84d065b6f937dd1179e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb84d065b6f937dd117=
9e9
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb8dd7954919ded311797b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-123-g3ee35125d5695/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb8dd7954919ded3117=
97c
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
