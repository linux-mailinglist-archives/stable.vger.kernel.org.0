Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735F4537985
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 12:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiE3K7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 06:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbiE3K7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 06:59:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26935640F
        for <stable@vger.kernel.org>; Mon, 30 May 2022 03:59:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso4193118pjl.3
        for <stable@vger.kernel.org>; Mon, 30 May 2022 03:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3vTY+VJrQLSmQ7GfwaQLMMU1Bs2LszWwlkVbpztniKQ=;
        b=jmu46P9DIzgT0O/qJ/7WyQkfRqAzkW2vhbbMVX1fhFcIBnW8q7EbNi0XH4fRgfDbQB
         kfxvmMeRLGmaYDBIzNGk5LpQ2xUI9p5MuUiNtTlVN4HC5dttlpmay9ksv2dtBhCpb5Qt
         Uf710v+x1hYgHGJSzchAtppOxSvO1MiviECWdUPQLg4y7/vruigOIkQzLF1OomnoELHU
         otkDFRx3rZSyzQ0BDVqqNFqXG45lZt9wnu15NRXhLifapONteiezA0rwNQDWDZRw6q5q
         fWjVGx5e9k3biMWmXLbGhK3ZmgrV3BMMOkk3w9C7f6rYOvjdeHP62HuHFfC1I65ZOXHV
         UYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3vTY+VJrQLSmQ7GfwaQLMMU1Bs2LszWwlkVbpztniKQ=;
        b=vW14KZCkOYd6lzi0vHGVVJ18jEMZtC/2ClK7Ps5+O+GENbvNkVP6lJUFswz91LhoiB
         8+Wck8iwNexOu2EWLOmYCW85dYlgoTnRrW9D+wb1blis4XkRhfnilGl+Y/j22Tv3Rg7I
         GT0kGpwZPfZb/XKTwzTjmoGawFW1B+0rcuAscQyEQU/E8uZTyORTRQ7M/qyeeERuZdtx
         VZu47kqTk3ltCObemb/bJ1opn8qsjetb/FkblZUxdLQNK6qPOivDUXP7K5qhKcjFg7Af
         23hBkdhUYAtl5jjWqT+XsmgZiBW0PzpGjf2kUnVHae/ghuhj59vTu7osrHOOJMkkDPvU
         pbfQ==
X-Gm-Message-State: AOAM530MrHacahFVKdBjEZLs1RF7pagRL6S0nfbxLEG7GrpdbyGfpKdr
        JDSrYJuRNaMwPLiUrFnWVPL+Z8XwTtrRuMgujHU=
X-Google-Smtp-Source: ABdhPJwqjIT1CoVdjP2l7d2XLIl7nyjJN6Pnk18l+uY39NxxyiPEzXjrO5s3CBsNdcEsxL4XR1lc1w==
X-Received: by 2002:a17:90b:2c0b:b0:1e3:25d3:e76f with SMTP id rv11-20020a17090b2c0b00b001e325d3e76fmr414720pjb.150.1653908376205;
        Mon, 30 May 2022 03:59:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b005183fc7c6dasm8597010pfq.5.2022.05.30.03.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 03:59:35 -0700 (PDT)
Message-ID: <6294a397.1c69fb81.ad2fa.2fb3@mx.google.com>
Date:   Mon, 30 May 2022 03:59:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-154-g1ef22a290e0e
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 163 runs,
 4 regressions (v5.15.43-154-g1ef22a290e0e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 163 runs, 4 regressions (v5.15.43-154-g1ef22=
a290e0e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-154-g1ef22a290e0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-154-g1ef22a290e0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ef22a290e0e486214360259905e21085db94fee =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62946f52e0dbe78e1ea39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62946f52e0dbe78e1ea39=
bd5
        failing since 60 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6294718575d5e781d3a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6294718575d5e781d3a39=
bf7
        failing since 6 days (last pass: v5.15.40-98-g6e388a6f5046, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62946e14fbd1e280e8a39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62946e14fbd1e280e8a39=
bd9
        failing since 6 days (last pass: v5.15.40-98-g6e388a6f5046, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62947abdfb05544955a39bcd

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
154-g1ef22a290e0e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62947abdfb05544955a39bef
        failing since 83 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-30T08:04:52.503890  <8>[   32.862698] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-30T08:04:53.526379  /lava-6500429/1/../bin/lava-test-case   =

 =20
