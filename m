Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E52C5B9C19
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIONi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 09:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiIONiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 09:38:55 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B268E85FDF
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 06:38:54 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f23so2143223plr.6
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 06:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=5zxdJhrevHiN8kIlCMqzXVHwn9sUHm8Q2KYUc6bCvSY=;
        b=jkwM0OWPhIyb9Xm82ZVFDamTOl5/JhBw0SLdux+lGEUcEJWPuUmLNiQCH2qW/p1eiT
         JThSIYOvG+heBYBmPZg82rZ8ixM1oSYWwg5HaKF7kXPEKnRyIe9L1lHrxlnfb1+nkNL9
         b432bOSuqAKommO0wQmNIb21zSKV/dJ0cOJ2IkIn89U7E3O/aI8D0VGlBzQoNW7wSJrq
         r/UY+4e0h+M+inBMQANoM/zQ6sME/x7dSr01/7Rn4uOwW3Fzjcf7L9r9Htry3nqw8m/6
         kxsxInEaOWEGajDiJp9Q2YW+SK55yS3UfNpxmlsWxfzE0mmoeOvIDqqiwRZmTlDnq0M6
         q2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=5zxdJhrevHiN8kIlCMqzXVHwn9sUHm8Q2KYUc6bCvSY=;
        b=HRHocMbIUBBVBkHMHXkCy/XHGNSXezT7is/p+6cGQUaaWzIK1Z2bXWtI/AsmX0HX1+
         VvAz+uGL2IhpL79VuM+/oR2I9+KISjvdY36QAvq81pWb6/7iQrvB6YnpNqhlDPvY13ux
         O3BHNcppNMlND2nz7oCxDXhDUBwf1k3E9eJApMZW849AHf1UJ04yuseBD8wWC1v3LSUA
         xgJEIxDTDeF8dNxL7dwUpcp1Q7JfJzHKgXdZfZV4HFHBy/fnMXxpJZexXZIYQi4x+QiH
         wDoUmthW8/icRHS1sl2Ux0yGVsGvUKL7VEiUyaVYDV9JCGUW5sTgyX1QJwfYnKEb/bhZ
         ZLeA==
X-Gm-Message-State: ACgBeo3KNDkNK/6iTYQMJfs2GShPovoDMf1AfyxvfBM9AsxUy8Cvr00U
        XFJ40jsUXwwwVWWYtJbPPQyYUTtzNG9ix4xqESU=
X-Google-Smtp-Source: AA6agR4jkDQioTynRsv82nBWx3vyvJwknXZhDKtpfb1iJgmhXegD3D3eATHrvY1YjEQbzFcm/wtRDQ==
X-Received: by 2002:a17:90b:1e44:b0:202:b347:2daf with SMTP id pi4-20020a17090b1e4400b00202b3472dafmr10997338pjb.34.1663249133943;
        Thu, 15 Sep 2022 06:38:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13-20020a62640d000000b0053dfef91b0bsm12289197pfb.205.2022.09.15.06.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 06:38:53 -0700 (PDT)
Message-ID: <63232aed.620a0220.2b72d.54b1@mx.google.com>
Date:   Thu, 15 Sep 2022 06:38:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9
Subject: stable/linux-5.19.y baseline: 190 runs, 3 regressions (v5.19.9)
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

stable/linux-5.19.y baseline: 190 runs, 3 regressions (v5.19.9)

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

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.9/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d1105a680e66b0482bd18048534c58ecabb5c284 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6322f6bc15a84695d135567e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.9/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.9/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6322f6bc15a84695d1355=
67f
        new failure (last pass: v5.19.8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/632301b77ca2364aae355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.9/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.9/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632301b77ca2364aae355=
64a
        failing since 28 days (last pass: v5.19.1, first fail: v5.19.2) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/632303ab6ea8ee9729355757

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.9/ar=
m/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.9/ar=
m/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632303ab6ea8ee9729355=
758
        failing since 6 days (last pass: v5.19.7, first fail: v5.19.8) =

 =20
