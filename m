Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C293D0CF6
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhGUKQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbhGUJ3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 05:29:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD2C061766
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 03:09:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so728312pju.1
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 03:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HSPOyO+Mbxtznp0xrtIm/KVWV8QCSPkJx7On+hVBGvY=;
        b=KdVl4AS02OSfNVJgiLk3Mhd/prgwkXuSwIpwJ4HV3RpTYezF+qi6iMrwiLe4hBejD5
         cx76e2jY1jGPp5r+pO2WN8u9tlGG3HD0QTHEhEXrndyGTeLND/C7hrcY0QrboaWo6oBr
         mxUdgqjPIYh/6AYXkEIttuHSblgd9CvhTnl3WTZV1XMcKZ/n+f9adSH0vgUv8zlkhStq
         rs6txIvkvHFDk02clRJQkKFO0iP/bdAar8/UsCKmhf4b9iU8Ohyu9OwDRQ+TtALtPlUj
         I8t9txYee8ETEy91CvmygMvXGyO3WECvfdSfBK23oH9VbTrKwRgYMzB4zW6Lajti7OFn
         kE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HSPOyO+Mbxtznp0xrtIm/KVWV8QCSPkJx7On+hVBGvY=;
        b=DIjWnhjuIesWFBBmKvM8p+IsY8Www/ggNndwm2O2CfpZquBNLDn+nlcFkhKYLoFMUi
         MNhIPllDCzuuY1zks4q2xFlMi0eXe4HJ+/Sv0KX+GDVEqcTpQKQKBtJBpXe4uxyeCikb
         NrXA6GBYQFryi87ZclX8Lv7Bz6lRvbgpkqEY02d45d4xIKAkoEo1cXfzgLsMfnVL+uwh
         BBEw3asgQLAWu9XrK3lFBUtPCi9JnsZQYO175Mvgc8EEoUt+oT86E05X9l3eCo9bk5wM
         rAGCIr00WiFfROM0CLlXxVyJSFqnxZdo50qL0tLL9J/1Hc8NcOSs49uM29fE/W1oaNAw
         mx/A==
X-Gm-Message-State: AOAM533tivmCMNM1TVYYBuFvcjISkhe0u+HJWoM18JwaiV5YrMy/HPvF
        J0R+KpioOVvW45CZPfJHsFqPZ/RH6mdvmJRk
X-Google-Smtp-Source: ABdhPJx26ri+1w7LmJjVYOs3oLZ+YC8yiSr7YJNL79dOepN9rktm1KGXqgIWHnc7joa2vWzTpHG12A==
X-Received: by 2002:a17:902:c395:b029:12b:8640:d14f with SMTP id g21-20020a170902c395b029012b8640d14fmr13674949plg.52.1626862188469;
        Wed, 21 Jul 2021 03:09:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm25765722pfc.157.2021.07.21.03.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:09:48 -0700 (PDT)
Message-ID: <60f7f26c.1c69fb81.db8ac.d755@mx.google.com>
Date:   Wed, 21 Jul 2021 03:09:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.240
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 115 runs, 7 regressions (v4.14.240)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 115 runs, 7 regressions (v4.14.240)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.240/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.240
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      964f3712e6a7447d9d3203f2be3f6c50e78ea179 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7bed43b710b082685c257

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7bed43b710b082685c=
258
        new failure (last pass: v4.14.239) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c3f56c8f6bec9485c271

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c3f56c8f6bec9485c=
272
        failing since 244 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7b824404b726e2685c264

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7b824404b726e2685c=
265
        failing since 244 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7b7ba832078abaf85c288

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7b7ba832078abaf85c=
289
        failing since 244 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7e4bcd195f20af785c2a0

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.240/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7e4bcd195f20af785c2b4
        failing since 34 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-07-21T09:11:16.993328  /lava-4223828/1/../bin/lava-test-case
    2021-07-21T09:11:17.010609  [   16.255638] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-21T09:11:17.011091  /lava-4223828/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7e4bcd195f20af785c2cd
        failing since 34 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-07-21T09:11:14.563442  /lava-4223828/1/../bin/lava-test-case
    2021-07-21T09:11:14.580494  [   13.825363] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-21T09:11:14.580988  /lava-4223828/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7e4bcd195f20af785c2ce
        failing since 34 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-07-21T09:11:13.544541  /lava-4223828/1/../bin/lava-test-case
    2021-07-21T09:11:13.549556  [   12.806521] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
