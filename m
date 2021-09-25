Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2462C417F10
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 03:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346462AbhIYBlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 21:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhIYBlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 21:41:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05CCC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 18:39:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so11575645pgc.6
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 18:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QIKJotL4qMBLSRdrCI8B8Iodm6j09GpKD46ydEYacE4=;
        b=Af8BZ+yt0zI0AuroARUJRMPK9eRWQLl95FbG4cbyhrLW9YHIgEJmkmkGAB0NmInvDn
         JtBqMGmxG+YwcWaY/q6r67hfWoXHjJOPcViis6ftdljTnopxsv5APaZO40vuksGIQJmJ
         /ZedV9PPOHoWOkoME54KQKkJ74wU7B6et7dCZkg5OnfgbUx+7jDXuSwuYiMu9x8bck3U
         D/Xb1adHkqQ/bIiRHB6c/6Y9qRFTS2dzBtcdD+ZGEmnaJfi6WBQHotoDprmA9I6dZTdd
         v6K3CLTY80JMw9oD2qyntKlmAytvZ9lTZLN9DHvCqpWZQVCtjaeYntct5yLSx2tLiNqy
         Tfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QIKJotL4qMBLSRdrCI8B8Iodm6j09GpKD46ydEYacE4=;
        b=SfsXHNfvtRUhn2aEv4pFpr78VbLm9NIjNHbwO+aELDzloRmxPFvioqiAZsoZ1ni1OV
         xswfrzwIT4vfjiZe94IhfVaUxdVQ6hjB8o2BN52l/g6AWSUuTp0ZKyEdEo4emiya2Bma
         8QBY+M+stbI9DZj6zsUEVZaj8UdnCHkvHwRvz/YGa+NAZ2RJoZnsTVRoayykUST1wpo7
         XUpdm8P35i5kZ9qpWTVemj8a4i64dU/nxO1CH6z5ri47K25HDNuqtDHRSoVzp2dZ4Dv8
         InS+lpkKbqldPKzP63UK+TTPJCClgAYASrqlPslxTHb0K/XML/bjiP8x1wrTHRCsJl9O
         apSA==
X-Gm-Message-State: AOAM533l5KrbF2A3jUlz4oZKyvA/NOFJYMC0ZBQ8cS3RStifgcwHRJWm
        WlGu93R2ClPnLfmJXeTGv0x3YjSEouqeNUsW
X-Google-Smtp-Source: ABdhPJzdjr4AOJOYTM3RWABpjX/aACW6WrfzEFnbpVn5ylVRne1fUtk/ZITTHdoeJ9Gv40+klTkEbw==
X-Received: by 2002:a62:5216:0:b0:445:49d9:7b09 with SMTP id g22-20020a625216000000b0044549d97b09mr12834598pfb.60.1632533975915;
        Fri, 24 Sep 2021 18:39:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm10398647pgh.17.2021.09.24.18.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 18:39:35 -0700 (PDT)
Message-ID: <614e7dd7.1c69fb81.2f9e9.2988@mx.google.com>
Date:   Fri, 24 Sep 2021 18:39:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247-28-g4e502419d5ea
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 67 runs,
 6 regressions (v4.14.247-28-g4e502419d5ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 67 runs, 6 regressions (v4.14.247-28-g4e50=
2419d5ea)

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

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.247-28-g4e502419d5ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.247-28-g4e502419d5ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e502419d5ea6cddb023f29220f4e53913db546b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614e38830fc8cc8b0c99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e38830fc8cc8b0c99a=
2df
        failing since 314 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614e38910fc8cc8b0c99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e38910fc8cc8b0c99a=
2e6
        failing since 314 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614e389b8049ad86f799a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e389b8049ad86f799a=
2ef
        failing since 314 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/614e44dbe73b023bfd99a2e7

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-28-g4e502419d5ea/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e44dbe73b023bfd99a2fb
        failing since 101 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-24T21:36:13.836151  /lava-4580641/1/../bin/lava-test-case
    2021-09-24T21:36:13.853006  [   16.064954] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e44dbe73b023bfd99a314
        failing since 101 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-24T21:36:11.404567  /lava-4580641/1/../bin/lava-test-case
    2021-09-24T21:36:11.422693  [   13.633229] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-24T21:36:11.423029  /lava-4580641/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e44dbe73b023bfd99a315
        failing since 101 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-24T21:36:10.385706  /lava-4580641/1/../bin/lava-test-case
    2021-09-24T21:36:10.390742  [   12.614155] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
