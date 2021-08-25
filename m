Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C4B3F6D2C
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 03:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhHYBjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 21:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbhHYBjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 21:39:13 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9744C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 18:38:28 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id w8so21548576pgf.5
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 18:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NUA5J7pWaR7eLj6B/66vmQ3Ul8W8mxfNQE207JHGK+c=;
        b=KBDBhhxCkOt0WRJyvNqNYsOe4p8LsAdiIpmSSQ66T9EtCqyuurHjCs/aSAoIFSeYis
         1rki5E1VgjSqpwXmVTvHy9662mtqQZS9Gck3CRaflZIdzePp0jaTK1E87kVUHNMiPR1L
         g7pLYD/fk/Cz8W/cL0mgrEZgVM5MTKvwKjC8QqUF9Q/ESm9Y/gZ+pDM3PtPJk6ooITnW
         gaNCGdGn6evlDDILPCffeWJr0sfvrmOmDv/3R92ZPBqcbwG4arVcWbyk3jmm6ufOlEU1
         QmHHRzOddWzu+i5a0lqiah3X0fiEy5DTEN27HoXZt7YESqUzCQA2rBcEmLbqh20F0u06
         vjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NUA5J7pWaR7eLj6B/66vmQ3Ul8W8mxfNQE207JHGK+c=;
        b=Xl2LSJYHbC399yyP2AAqfuz3TQvdAWQOvQ1u5xMKfHE/0MMhxTYEH1QHZ2/sS11gXz
         YikPIlQhxyjORIcMlctdHtJTZaf7l9mfFQaNyl7u3EDzDnUcxcAbL+Gzwu1W82wIFs7u
         cb0nMTh08BFa+hLJfu6wgLisyvGkuqz6rc3mrBK3xUV007U+hQW6bR0NKZYLKd5cc4+h
         mnQmgU7UN9/8zn8eB5xyh0qURQiYlwVWLLBj3LoTIn2Gq02QZCuxhNxHeO5wjEZhR3L+
         jhdgnycZ37jAPFsM+rsMv5ZSeCr9HJOFxd38awXC7uU+yMQ7bZeoh0ADrI1s+EmTD9cu
         GE+g==
X-Gm-Message-State: AOAM531FKz85hAvelr2HkLJfuee+IEKSy6+By50c2UXMpxfU3AroCwH7
        a9TruCsBdr2sv7ZgS2JIPxM1kwzcVrUfif2w
X-Google-Smtp-Source: ABdhPJwQpAlR0wFdtJ+MIsOsV4wWUjqKogyA2m88hvOFe+cZ4C+u8s9TPoTTQUv4qPZNOMyXHus+xQ==
X-Received: by 2002:a05:6a00:1a4f:b0:3e2:1f86:3235 with SMTP id h15-20020a056a001a4f00b003e21f863235mr41471025pfv.26.1629855508015;
        Tue, 24 Aug 2021 18:38:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b190sm23479871pgc.91.2021.08.24.18.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 18:38:27 -0700 (PDT)
Message-ID: <61259f13.1c69fb81.5449c.5c8b@mx.google.com>
Date:   Tue, 24 Aug 2021 18:38:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.60-97-g812f9eb4fd7e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 173 runs,
 6 regressions (v5.10.60-97-g812f9eb4fd7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 173 runs, 6 regressions (v5.10.60-97-g812f9e=
b4fd7e)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
  | 1          =

imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-97-g812f9eb4fd7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-97-g812f9eb4fd7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      812f9eb4fd7e83e3a6754f6acc5ea2607fbccdfd =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61256b8ddaf56362818e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61256b8ddaf56362818e2=
c88
        failing since 54 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61256c428385211ac08e2cab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61256c428385211ac08e2=
cac
        new failure (last pass: v5.10.60-95-g7e1be9cb3c48) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61256ba52761ff45f18e2d06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61256ba52761ff45f18e2=
d07
        new failure (last pass: v5.10.60-95-g7e1be9cb3c48) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:     https://kernelci.org/test/plan/id/61257570347c0d71178e2c77

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
97-g812f9eb4fd7e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61257570347c0d71178e2c8b
        failing since 70 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-24T22:40:31.674670  /lava-4408554/1/../bin/lava-test-case
    2021-08-24T22:40:31.691431  <8>[   13.379276] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61257570347c0d71178e2ca3
        failing since 70 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-24T22:40:30.267806  /lava-4408554/1/../bin/lava-test-case<8>[  =
 11.955246] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-24T22:40:30.268507  =

    2021-08-24T22:40:30.270384  /lava-4408554/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61257570347c0d71178e2ca4
        failing since 70 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-24T22:40:29.231299  /lava-4408554/1/../bin/lava-test-case
    2021-08-24T22:40:29.236865  <8>[   10.935795] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
