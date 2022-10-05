Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326675F4D71
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 03:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJEBkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 21:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJEBj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 21:39:59 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BDE25C4E
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 18:39:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 129so14130660pgc.5
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 18:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=QaXxO/ojfG0Ge+tXCT1W0zBAQ14LFpCSnVpOXsGOu24=;
        b=J+v3LtbTOZkP7uqJ7VJgXxixfW9bY0/iGQCbkLg8kmuT7xwRksZ1XIP+bAo1ku74oZ
         4CsyoXC6cr6ntD+6h78rKakKcXuvgAVQB81BTpSQ/R6js6NqiUHdBK1Hh1OTeErBgg6Q
         P/ltWRp1/mpeFuRP75qawuoHxf6gLkVueNGojU4mrkB0HY5G+4+c5UHr4UTW6/XfgKGR
         sDt8STnhhPBImkth0bn88eGU00t8AdA/n+zsjxoBEfN8dMjGAmYbv1KgLyJ8FdqZuSIl
         SMbUJ98304oWdYY1fAP8HaMgWr9St/rs6xRuGeyaqofURmXmL/70CTCsqOMrGww4xlaJ
         uoow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=QaXxO/ojfG0Ge+tXCT1W0zBAQ14LFpCSnVpOXsGOu24=;
        b=GZAyA9RjBHqLK0sjSoFxlp4csSqYYxwKTGOnUiDo6ZsHuSBS/18XtkkgzDi96X7Koj
         1sIYyr4T3+yeByFZ93w1+4CQTG+kW5JNeDCHzg7b3g9A5OYcU+KevHGZuotRFjEwEApZ
         2OS9s3GbgZhk7DJpQKQN5Itm2v7jIrGVAnnDJsDRvF5wVS7FJleqrTj4EI5jCbLq7u6D
         OKY4I5726EWupJVdCpUPd8lpR/r0612+WpYj2p7m0I+j1SD47PhuKxmgIfhoT8PEkaWw
         GKz1C0Tn7yq39+ittEPNYhI03GbMLHtqlC3Fymbz1lwP0/laqgewW0AgbclnUAJhFtC2
         BoOw==
X-Gm-Message-State: ACrzQf1mFnKDxixr15l4DR/Tec2A4vbBDXGKLxyDEBvPw2sYWzr6jEXc
        u3y3kVTqMk3SWFVHfloZKU+KSuVil0G4T6GN9tw=
X-Google-Smtp-Source: AMsMyM6Rc4aEbp5vfAjYViERJHv+bDmvbADHZvNvU+LbXojXPySnav/X8trAe66TT0pS1vOAMu7zcA==
X-Received: by 2002:a63:4b02:0:b0:43c:1909:d350 with SMTP id y2-20020a634b02000000b0043c1909d350mr24969155pga.188.1664933994770;
        Tue, 04 Oct 2022 18:39:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7-20020a170902690700b00176b84eb29asm613849plk.301.2022.10.04.18.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:39:54 -0700 (PDT)
Message-ID: <633ce06a.170a0220.e9db1.14ca@mx.google.com>
Date:   Tue, 04 Oct 2022 18:39:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.12-109-gd520502dca79b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 75 runs,
 3 regressions (v5.19.12-109-gd520502dca79b)
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

stable-rc/queue/5.19 baseline: 75 runs, 3 regressions (v5.19.12-109-gd52050=
2dca79b)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.12-109-gd520502dca79b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.12-109-gd520502dca79b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d520502dca79be16efb9f38ce7cbac1219b67e16 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/633caceceda7dee71ccab60c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-gd520502dca79b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-gd520502dca79b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633caceceda7dee71ccab=
60d
        failing since 1 day (last pass: v5.19.11-208-g633f59cac516, first f=
ail: v5.19.12-101-g42662133e9bdb) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/633cb59d435620dda8cab5f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-gd520502dca79b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-gd520502dca79b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633cb59d435620dda8cab=
5f8
        failing since 9 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-186-ge96864168d41) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/633cb706d3650b8ce9cab5f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-gd520502dca79b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-gd520502dca79b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633cb706d3650b8ce9cab=
5fa
        failing since 8 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-206-g444111497b13) =

 =20
