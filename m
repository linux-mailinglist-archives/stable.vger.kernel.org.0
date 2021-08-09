Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE43E3F47
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 07:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhHIFOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 01:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhHIFOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 01:14:20 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC3FC061764
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 22:14:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e19so1586041pla.10
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 22:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4xi1BGj+36QKu0f6f+/m4S4BiFGIs6B2Ecx0WGFR0Es=;
        b=OOltZL/1eGbs3Dg/CcJ8C34Iio9JIlG0na8TwEvgIcL2T/Y1Y+u2xQsKk/mj931jN2
         QP5wU5ACqKY7A4s+bW2X2wlwe2rnTmAWEKHCXobQSbdJ+m+9WuwlCuKznDHHfXRC+a2O
         nH1xIpj63eGBF/WrECnFW7X2NYR2LY+gN6BNBoxaMG5WObbkP57REGi29nA/apu4cUFZ
         SHnWAjr1fhPNh39/czvkh5JvsvFUd30oFGZIcnBXLUHI1ePUDfc/9YLpwGruhAnAx4mU
         KaRxs4J7sm9BvyTleVgnIsO+gp8jwVvWX4TI7JXiF+ZjPQ2/y2Qh7GGivlyiotDtGnen
         kFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4xi1BGj+36QKu0f6f+/m4S4BiFGIs6B2Ecx0WGFR0Es=;
        b=OpQ0B86G+ANf/O5ND3+0VTk1y3UcvWDA3OaAJZLAxRoi+MrcNNK1F6UHD9HSodgbQY
         gTfmMMwfnd7B1GBFuSgrIyVjIbZoiJJqNkbH2CxEkRRcFplewK+Mc0WoXAb0zYi1cRUb
         SGVUQ8dLWh1/IZD3i7Ty3iG9/tBy9RnTL2c41qMkToKOYRQoVHIs8YqoBRWOsfd2F0St
         C2jez/kc/MDsHXvIbxc2KYpqnudybff0W45tmNhakMQW02Loq4MKDzY3T4GhWz+XwDek
         dX8VR/IP5t5Y06pKykrXTjeNMm4jkriv/0QZs8rgIQehwRG3luTcvNwrFNWmksyOuqTM
         hy8g==
X-Gm-Message-State: AOAM532mPOZ/TAhsJCfWzcmPSm3Q2DriblI4g+HqGx3ymKCpS46AY91z
        SZzECdySgq4WVthp8kqIEY9+Xhv1uZ4dJ3dS
X-Google-Smtp-Source: ABdhPJyfAMHaratcgfubbM5JZezAlgaKbUQFD3KbKFplG6MdPn9GQnp0F+lz0A3FdjQL04cT1o0CBw==
X-Received: by 2002:a63:f749:: with SMTP id f9mr762195pgk.77.1628486040318;
        Sun, 08 Aug 2021 22:14:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm21941913pgk.34.2021.08.08.22.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 22:14:00 -0700 (PDT)
Message-ID: <6110b998.1c69fb81.eb4b4.1616@mx.google.com>
Date:   Sun, 08 Aug 2021 22:14:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-18-g5ff0226f10c7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 77 runs,
 3 regressions (v4.19.202-18-g5ff0226f10c7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 77 runs, 3 regressions (v4.19.202-18-g5ff022=
6f10c7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.202-18-g5ff0226f10c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.202-18-g5ff0226f10c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ff0226f10c7418050ba4d09bf18e4343cf1c90c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611088c73313428593b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-18-g5ff0226f10c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-18-g5ff0226f10c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611088c73313428593b13=
667
        failing since 268 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6110a0661dd894d053b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-18-g5ff0226f10c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-18-g5ff0226f10c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6110a0661dd894d053b13=
66e
        failing since 268 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61108f915fb9a7c488b13664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-18-g5ff0226f10c7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-18-g5ff0226f10c7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61108f915fb9a7c488b13=
665
        failing since 268 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
