Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D805F5B9CF1
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiIOOWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiIOOW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:22:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEB29C8E7
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 07:22:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q3so17949406pjg.3
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 07:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=MybHgy0I0CggYox7QwxlGHDihMbcxSi0OJRQytpHzZE=;
        b=UvePUwlvNwZiMmCAtxUxhEGDZc3TcRvYa1MsU9/doRd7ojRjdaGN6saiHKYZ7BcgHh
         Ebwq5KRA6Vz022uIVwOf7Sn7Xco/mGy5CEbEqOW4XeNnOx0MESeuwMcpqtHQHyZ+yrG/
         1mpXOqErLjnDs6fzlO7o0F7sYed3WmD15/hD2uG6X4RXymYfQv9rDYjJzJ/SBkLZCFba
         YSnB11b6GKXl7v80mrWOyiHNCaNsZKmw92J9FAz/rVvXs93vgkG4xllEBuWfGGK4cATg
         TZrW/EGWxvsxV9IKvLqU0yvqH5b8veJlFGCbTJ3bSkeHDU9+kwR4L+aX+Q1Z4z8K1E8w
         GkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=MybHgy0I0CggYox7QwxlGHDihMbcxSi0OJRQytpHzZE=;
        b=QQn+Wxe9AvGxFKcPMyAdGZNmF6gzV6jqFilotRaCK+GN1X6YvNs+Iwbiod28KHrR4n
         wiEjf5LZLVVWzUYfaZNM0DDR7ZrUQpD1kKG+RfYUniLBOC/R3mf+xc4n+JugfLypMBLW
         Z7AOflIHI2XYcsWVQVj/dBR1/wKPFEo0QZIGP2cPHk8hhWRnoJcTJSJQwSS2zA3srru4
         phS8YpZ7FBjQcG7xWgaRqUPUH5dp0ebWDqtAWLdWTTMK59vY/HBuPVQY4FDArfJWEbXK
         BRNITGUAGLdXVBOhW8QhbB0ukCmf8MTd0PU6oXb4U8yBaplfo/1CL4FW3eM7hCKdojl8
         nkBg==
X-Gm-Message-State: ACrzQf3mSjTjAwpqDOu0l9ftlNFnNOp5ZjUpRyptFUmmiFxxiRwatp3t
        vbaffGNPdv7RPJ6a+kFKafpdG52p1cmcDdMNaug=
X-Google-Smtp-Source: AMsMyM6lh+MYOE/8+7SGozm04kjbKCgPiGeyoGm3kxXEUvELM0fqy2z8flAYyK9xs6EeGwVn4uwZUA==
X-Received: by 2002:a17:902:d0d2:b0:178:1047:1cce with SMTP id n18-20020a170902d0d200b0017810471ccemr128067pln.150.1663251741927;
        Thu, 15 Sep 2022 07:22:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2-20020a17090a590200b001fdcb792181sm1705398pji.43.2022.09.15.07.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:22:21 -0700 (PDT)
Message-ID: <6323351d.170a0220.f3a26.2c54@mx.google.com>
Date:   Thu, 15 Sep 2022 07:22:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-189-g8c5a354f83064
Subject: stable-rc/queue/5.19 baseline: 203 runs,
 4 regressions (v5.19.8-189-g8c5a354f83064)
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

stable-rc/queue/5.19 baseline: 203 runs, 4 regressions (v5.19.8-189-g8c5a35=
4f83064)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =

imx8mn-ddr4-evk      | arm64 | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

odroid-xu3           | arm   | lab-collabora   | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.8-189-g8c5a354f83064/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.8-189-g8c5a354f83064
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c5a354f83064b2e49f4cbb641a3b38743cb628d =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/632302779d86e1fc6b355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632302779d86e1fc6b355=
64a
        failing since 2 days (last pass: v5.19.8-181-gaa55d426b3c1, first f=
ail: v5.19.8-186-g25c29f8a1cae5) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/632307a7f80e0605903556ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632307a7f80e060590355=
6af
        failing since 29 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx8mn-ddr4-evk      | arm64 | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/63230b7dbfa1507acd35564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63230b7dbfa1507acd355=
64b
        new failure (last pass: v5.19.8-192-g612c301cd75f) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
odroid-xu3           | arm   | lab-collabora   | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63231a8519e2bdecfa355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
89-g8c5a354f83064/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63231a8519e2bdecfa355=
669
        new failure (last pass: v5.19.8-190-g006ae7d3df80a) =

 =20
