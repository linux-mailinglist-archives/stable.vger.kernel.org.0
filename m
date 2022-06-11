Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7960554718E
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 05:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349779AbiFKDTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 23:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349815AbiFKDTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 23:19:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3FA203D20
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 20:19:20 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so4474274pjb.1
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 20:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yNoPsGHywQXMOj+qsjNY+fzPGfC1qaDsB62JFcpqUM8=;
        b=bPPSToVvAfB+UIJUwX58JtCS08w4ZTwkJNiz6lMYgeXSNyxDVNpZEyjYptAYs0XjpN
         osHB9C1Avxza9IfNfJhFD6+zD6btHP1hPrP00qXWdZf0QejcFcMelRscXyRyHpAGphmO
         OaOqvdEbsJl9LnhQeCbBcUpcqmaR12j/9oAQfyyb1wyWAYlGt1n/WoYgptJZRFUXy1N4
         fc8PTMQ3y3/5GGzlpVIwFbTPsh34BCFXqO+uJLjRuQJKi4j8XeSboOtks8WJLG1N2cod
         92ql+KOg+ZKe59Tb/O77p6GxTitZF49JHPjmvk5baJsdb0qnxGudxG1NhWiBfl/hjYph
         22EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yNoPsGHywQXMOj+qsjNY+fzPGfC1qaDsB62JFcpqUM8=;
        b=DEi+8plgtfHxRLp5Wu2Sng/cNVoDp4Xpwg8k8TBzJxmGkkb22m8PC7YnJt6Rb/c9UI
         kxPiPsMmP3fquE7swkvZ7nTgalHQP/n5YXob72WtBBz7hS2c948/NQZYO9FXstq6IU9N
         TP25m+7B9XsyqmaYvcPTtborKWVISH0BAy16IC12siwq2rJ3z1cvgI1d2SPg9n4KHT31
         BrBquYyUz4Xcd7O//j7oaw6QHAV4gcV+8ww7dWjvbki8CYuGbmK38xe+glOReG6Anca4
         gusqOWeDvg1uP0r4I+rDoi5LKvoTxNRSEiifoGe+r+iR7Ogzbov9GG0sQ9bce0GlGrRi
         6yRg==
X-Gm-Message-State: AOAM530CyMq4oKZy3iqu687t8xgENi9RuhnHjFfThz3wx3hPZ+G7Ww0K
        sgjbOrDoZhT4j5+9yI3+YcR6SIss11gju19R+9o=
X-Google-Smtp-Source: ABdhPJzp5rbkyN/qzK7ZAO9jQHoeUTrjoxvaedNVu3y8a1BRfa1GdgGuO2snc5UWtzMZGMMTUj9RsQ==
X-Received: by 2002:a17:902:c244:b0:168:c4c3:e80e with SMTP id 4-20020a170902c24400b00168c4c3e80emr2938350plg.18.1654917559350;
        Fri, 10 Jun 2022 20:19:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ab8600b0015e8d4eb2b4sm433620plr.254.2022.06.10.20.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 20:19:19 -0700 (PDT)
Message-ID: <62a409b7.1c69fb81.497c5.0b08@mx.google.com>
Date:   Fri, 10 Jun 2022 20:19:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-798-g69fa874c62551
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 176 runs,
 4 regressions (v5.15.45-798-g69fa874c62551)
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

stable-rc/queue/5.15 baseline: 176 runs, 4 regressions (v5.15.45-798-g69fa8=
74c62551)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

jetson-tk1         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g         | 1          =

jetson-tk1         | arm   | lab-baylibre    | gcc-10   | tegra_defconfig  =
          | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-798-g69fa874c62551/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-798-g69fa874c62551
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69fa874c62551f08c836501328291ad7d38c9508 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62a3ef576415aaede9a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3ef576415aaede9a39=
bde
        new failure (last pass: v5.15.45-667-g99a55c4a9ecc0) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
jetson-tk1         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/62a407be1b96cc23b6a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a407be1b96cc23b6a39=
be9
        new failure (last pass: v5.15.45-667-g99a55c4a9ecc0) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
jetson-tk1         | arm   | lab-baylibre    | gcc-10   | tegra_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62a3ffb3d4e8593191a39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3ffb3d4e8593191a39=
beb
        failing since 18 days (last pass: v5.15.40-98-g6e388a6f5046, first =
fail: v5.15.41-132-gede7034a09d1) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a3d3f13075567c3ca39c00

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
798-g69fa874c62551/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a3d3f13075567c3ca39c22
        failing since 95 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-10T23:29:32.795973  <8>[   59.821523] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-10T23:29:33.819806  /lava-6588615/1/../bin/lava-test-case   =

 =20
