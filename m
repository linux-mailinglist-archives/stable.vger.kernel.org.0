Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AB63FAC0A
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhH2Ns0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhH2NsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 09:48:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C45C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:47:33 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j1so7713463pjv.3
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MPR/MseFTn+eMJ0PHw84WV6OhaKAkNUl1LH0uADaY6g=;
        b=AKIUu00dr3OH41axqzliNx2EiS9kbZr1BHXhfCt/WlOPTGNLhltzCjeAR9kgMoodGk
         4pRbWv5uJN8/vyYUXuObnZF5kB9AYVXmJwwFFCrMPinjy8mD4lCX7+U/JHPwhuf6Wj1O
         /jOTeU8c/8ocRz74nfkHDqriNzzQIy9E8Z6aacF9fVEdNPIx2ZLd/VJXdbE403GhZc/i
         pEpCgrBsG2/BQQv3VTtVWd5b6564BX9Xexi37raImxFii3lLISNMnQTqmP56w9w4Fl2W
         MpMq1ILfWRXxlHV/omugoRRFeXw3MUA1gpeNqR2LRoH6HzKKyc5K/Temt/pVO25szA9X
         kWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MPR/MseFTn+eMJ0PHw84WV6OhaKAkNUl1LH0uADaY6g=;
        b=oRmC1m2/xcBdsj280r1FAr9FjTkePFQ/yzTYaiwx+Xx1CFsjr+uxjPbsYXeLhytWZP
         i3j+069nFVZ+pLdip8z8LUjhOm/yAa6Jsx+RBY62FiGhMJF3COfk6crcoaw4Ipi45to1
         8LuNgwz+Yc7pLdYTWr+ldBSz4H5uFh4F+nEqQHs+j8uonwTokMXLpip+B1AZw5L2/JRY
         nOqx45R35zW81yQCKiv66C52gYphVTAGF2DC6NkY5sqmXt0i+AoVbqrLNoaokiMvRPvY
         Cera2tVhCTPZW+Vpnh4KCgavmqJG0Cdixna5OiOzcqpCrJAnpUx8qieBaG9ra9LAe+Zm
         4zfg==
X-Gm-Message-State: AOAM5330JavwlW6AB7eGMrrxeynLHNcAr5r/VlFoYfCg1gtosIzsqlSb
        Agx/KJjkaiAe9FZmJFCmvBmvmPJuGjgKI1JU
X-Google-Smtp-Source: ABdhPJyEViE6N1h7BsBB1MIrL7Oyx+CwJoVhh0HGTGAmXiWaJKoijyDru6duyiYliTll5/ozA7l44g==
X-Received: by 2002:a17:902:c406:b0:138:c28f:a779 with SMTP id k6-20020a170902c40600b00138c28fa779mr4051682plk.1.1630244852880;
        Sun, 29 Aug 2021 06:47:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 141sm13650483pgg.16.2021.08.29.06.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:47:32 -0700 (PDT)
Message-ID: <612b8ff4.1c69fb81.31a83.2e53@mx.google.com>
Date:   Sun, 29 Aug 2021 06:47:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.281-6-g44440a746870
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 105 runs,
 4 regressions (v4.9.281-6-g44440a746870)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 105 runs, 4 regressions (v4.9.281-6-g44440a=
746870)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.281-6-g44440a746870/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.281-6-g44440a746870
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44440a7468703b8cdeadd5933fcb7eca97b94be3 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5abd7afa5283648e2c96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5abd7afa5283648e2=
c97
        failing since 287 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5e94b9f61fecc68e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5e94b9f61fecc68e2=
c88
        failing since 287 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5ab8058e21cfec8e2c88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5ab8058e21cfec8e2=
c89
        failing since 287 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5f959504b594678e2c84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-6-g44440a746870/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5f959504b594678e2=
c85
        failing since 284 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
