Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0550A5BB113
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIPQ0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 12:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPQ0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 12:26:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76765832EE
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:26:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 9so10616875pfz.12
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=P306AWlfr+gEKJCBIrAX/dS3kjP1sRlwTSv3+2rNOgE=;
        b=lLBA8y748wNnif+fYVVq2HeETpCFd/Ie1N+eehnjseSFK1aYjZzUsj7mp2ElVbjjs7
         IhPHD/HXqI3Wi0pkLhAz3auIafwW7/6/VQmMZew077gF7sQlNyZjXfbcCcvIV3pfrdXe
         7GHiqkRaL6yGFkDYI97fBM/4u2UFplmBYt0+23f2gfwG8lIMXlD5rw/wOe2oMM3LmUSi
         Z+Y9pcqEA+G7Ok9lLFCjZTKE+CVhmhF9zRv+iq0imaWsGzrvHXsGtBTMR/Nl+Ifh53xx
         WoTtu8DHc69YxLFLZ1hh10lfhRSmPE1MYXGmPaaj5DEF2iIKt/0Iu5fY0I+Ofvdsti/x
         YIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=P306AWlfr+gEKJCBIrAX/dS3kjP1sRlwTSv3+2rNOgE=;
        b=hMHVvt8HoJ58lk5xv9N6tc3v338eim8W/OEkSB6IvRqoF+XalWIciGU/QHrIJvYQY8
         1Ce6Rm63+oZSbPE0NWiq1ScpcERmiJqVDXpFa4SEGh/LIgWQD+7VGTsCRCBYQnPgwJg5
         L1IquKt1qP8UaLN0lwEjbzTe8qfd/KCa7mIhmHUtypvNiuXxU+7EaT0ezZ67w1f57AYr
         AC5aiH1U8b0DYXA/v3deTprZnTFFB4wdk1URcTKwlUjMdFepLnH1pVprVExDwLfZAd83
         8RYi0pcZr3fEJkPfwinyZqR0N//9G+j4qte1TU++MTOG9TmKQa8fSUYzUSiWToQNZRtb
         01HQ==
X-Gm-Message-State: ACrzQf1BXN/hi/zDl09GtxdUul34Ae/j3RXSqkwM977hsVLSO6Q0LmkK
        2FI0kUJrlkPbRO7qnbSXDts7NNr6cwxz2XtwsOw=
X-Google-Smtp-Source: AMsMyM7b8L1h2fUpU9xXz1H1kWUxR0yVprdFc4Mev5m9UUvnlAjDjygpBdYQgecpbVkb/AbPRT9TNA==
X-Received: by 2002:a05:6a00:158f:b0:546:b777:af17 with SMTP id u15-20020a056a00158f00b00546b777af17mr5581958pfk.51.1663345563787;
        Fri, 16 Sep 2022 09:26:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10-20020a1709027fca00b001714c36a6e7sm14994376plb.284.2022.09.16.09.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 09:26:02 -0700 (PDT)
Message-ID: <6324a39a.170a0220.ac1f3.b8ad@mx.google.com>
Date:   Fri, 16 Sep 2022 09:26:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g3cc7eb2847e1
Subject: stable-rc/queue/5.18 baseline: 88 runs,
 5 regressions (v5.18.19-1-g3cc7eb2847e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 88 runs, 5 regressions (v5.18.19-1-g3cc7eb28=
47e1)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie   | gcc-10   | bcm2835_d=
efconfig          | 1          =

bcm2836-rpi-2-b              | arm   | lab-collabora | gcc-10   | bcm2835_d=
efconfig          | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

odroid-xu3                   | arm   | lab-collabora | gcc-10   | exynos_de=
fconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g3cc7eb2847e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g3cc7eb2847e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3cc7eb2847e18b384a07db3870c0e67b0c0a5264 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie   | gcc-10   | bcm2835_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63246f256c17638d8e355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63246f256c17638d8e355=
659
        failing since 30 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
bcm2836-rpi-2-b              | arm   | lab-collabora | gcc-10   | bcm2835_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/632471f9daeb3719ce355687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632471f9daeb3719ce355=
688
        failing since 32 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63246f2a6c17638d8e35565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63246f2a6c17638d8e355=
65e
        failing since 3 days (last pass: v5.18.19-1-g935d5e1a94dd, first fa=
il: v5.18.19-1-g05c6ce2df587) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632472f18cdb26f9fc355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632472f18cdb26f9fc355=
644
        failing since 2 days (last pass: v5.18.19-1-g0e020e474faec, first f=
ail: v5.18.19-1-g429feaa18205) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
odroid-xu3                   | arm   | lab-collabora | gcc-10   | exynos_de=
fconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6324907555bc577cf6355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g3cc7eb2847e1/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6324907555bc577cf6355=
658
        failing since 33 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =20
