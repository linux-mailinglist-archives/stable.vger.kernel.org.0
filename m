Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9B563398
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 14:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiGAMm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 08:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiGAMm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 08:42:56 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8296403E2
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 05:42:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m14so2283499plg.5
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 05:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BF5Ea4TFioGoQYksLfUP26/hGq6Gu9e9x0voN44UjZ8=;
        b=oZDpHU4m2hNWi63DPK1j/Wb+UyPv3PEWLKq6+j4Si+tU13bJpjPyBRCNyJDfb9uAg6
         BXeUtwzQ7h+A3WlQCLu8Hqsu5QkPEHpkQrKGDLrYe06UGz3FIF8sTz/AsmHMDhFu5CZe
         8rTeLQ3chLQuCgnumg/tgrUDrfCKd8lKGxyFtSyZViBk/B/N0LFwh+YuuKg1g40wR8C6
         rV2qoq8oFV6C+52P+2YpTRZEqQ3w/hHAm7bNxNGb7kK+4mhOwebNMaYQmgxwan3jtJtk
         OZft2A87guv02VecdN8F+9WHEzld0w7NG6YkcGIeSUuZ944jSDShN0SgeegDIyecLP/E
         4FdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BF5Ea4TFioGoQYksLfUP26/hGq6Gu9e9x0voN44UjZ8=;
        b=IzdJzpP2ZvD40gBmO7yhdR4mGGAJq/uCPKS0tC9lYvtXQbrp8ttuJJrwAUr/6Zj4wF
         qbYP+rwK9N/rw6vMER47bqiWjkkryJ6jBsY0A1i51pWMRKE0xo/Ru+kz1aUq9YtKG8ix
         FyZEaInZAEx2sPA3dEzD7ilWEkWUlKJaHPsI93qaW5zm4A9kKL7M5iHilB45OkYZ59Jo
         2Lzt/JZRKqaNm2b3tOc48VCaKit8NsYunZJDr88lYdm9jYuNArjiAskLJy3vFbEEkpZx
         GcUl9FZHKx2++x39cKphafUnekvfiJrYN5v5FFbKEH5lX9A72sSpm27f1+qpUVkUpXta
         nI6A==
X-Gm-Message-State: AJIora85RF6CZvIoUSFBVuhuiLde5B5ISmcYyZbQKmGT71nQW8x0ipjF
        LZwobV30hCYmgZReYpmbnIfAbmSgKyOT4QAX
X-Google-Smtp-Source: AGRyM1us/ANCI3OTUJIYDfdRVeOyCXi0wkW3C0LIHkaIf+u1nzZu+BB94SH46laFcXyMpNLeViMvUA==
X-Received: by 2002:a17:90b:4a8e:b0:1ec:b561:43b5 with SMTP id lp14-20020a17090b4a8e00b001ecb56143b5mr18260594pjb.239.1656679375141;
        Fri, 01 Jul 2022 05:42:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9-20020a631e09000000b0041183dcd5b1sm5266035pge.53.2022.07.01.05.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 05:42:54 -0700 (PDT)
Message-ID: <62beebce.1c69fb81.593cb.7d97@mx.google.com>
Date:   Fri, 01 Jul 2022 05:42:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.8-7-g2c9a64b3a872
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 182 runs,
 6 regressions (v5.18.8-7-g2c9a64b3a872)
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

stable-rc/linux-5.18.y baseline: 182 runs, 6 regressions (v5.18.8-7-g2c9a64=
b3a872)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
i945gsex-qs        | i386 | lab-clabbe      | gcc-10   | i386_defconfig    =
  | 1          =

imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
  | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | tegra_defconfig   =
  | 1          =

tegra124-nyan-big  | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
  | 1          =

tegra124-nyan-big  | arm  | lab-collabora   | gcc-10   | tegra_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.8-7-g2c9a64b3a872/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.8-7-g2c9a64b3a872
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c9a64b3a872fb2818d217509b16e61ba54c365e =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
i945gsex-qs        | i386 | lab-clabbe      | gcc-10   | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62beb49f8c563110f2a39c19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62beb49f8c563110f2a39=
c1a
        new failure (last pass: v5.18.5-154-g1fbbb68b1ca9) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62bed317649ec59133a39c15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bed317649ec59133a39=
c16
        new failure (last pass: v5.18.8) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62bed164d3ab2645e6a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bed164d3ab2645e6a39=
bcf
        failing since 1 day (last pass: v5.18.5-154-g1fbbb68b1ca9, first fa=
il: v5.18.8) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | tegra_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62bece3184d070acf4a39c1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bece3184d070acf4a39=
c1f
        failing since 17 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
tegra124-nyan-big  | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62bed88397a5aaeb0aa39c1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bed88397a5aaeb0aa39=
c1c
        failing since 17 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
tegra124-nyan-big  | arm  | lab-collabora   | gcc-10   | tegra_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62bed494a27060a89ca39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.8=
-7-g2c9a64b3a872/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bed494a27060a89ca39=
bd5
        new failure (last pass: v5.18.8) =

 =20
