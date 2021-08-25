Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63A53F6CA9
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 02:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhHYAhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 20:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 20:37:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBC6C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:37:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w8so21435095pgf.5
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8fWlJxGcFwNB9PnHTf/upOWVd6IEiJYH3Ony6saqTtE=;
        b=0IjaS3rG1cxg+6AyrS9Fb2N+y+hIT/mQK3N1b7Aa5NWEQMP1BujGIpBnKTTTN5AffV
         kAiS7/VVY9pibKcMQKTM3FSiD1NSePHjDNqchpPacyvmGONQXW8QWeL6fFATmsFH8Khk
         GSk91rokk1PcHvdGdch8zbk1QmbOrPksoq+9QG12mg33WW7R7SiRKVKiINlsc5DLfMBo
         XEQHE4GH5W80IR9/mMlaXZSm/8434uir9umQLz+ayDyfG1+bkce1dsrHIxRGmY724BTx
         I8X+RS2xdYCd/m2RvukV67yJPlr+3eALs4IMty2WvMJvZAVf12EjAXN6pkA8MqGcRmYt
         4U1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8fWlJxGcFwNB9PnHTf/upOWVd6IEiJYH3Ony6saqTtE=;
        b=VeKm+PoJfhM2UTaV5fM1+QrOmf2UAdnSo6N6dXxi2WyQdw+jt9BvGUogx93uObGcQu
         oj+M5jF1tm/42UgOja3VFDL54eeEhsJ99o7EMc4US7cVINL9PyrWVmx+31v5ZNRjYS1W
         hXafrEkF167i3Lj05sT1F5aBvAB01TWRv1P2ZIBswlfImH8MTWndmmHAHAWLoVrRW9qs
         QO7gbicuprN7A4zxyAWwqyRuL9//KP4vzMi6lNjCBor79E6XGbGlH2qIr2iq1CpcZa/h
         4IPtK2MkCiKo5oBfiXjCpSkXuyB6t7tYPCX+cTgZhdEzIFOqG7zXlznaXpzUmu71UXtM
         1HFg==
X-Gm-Message-State: AOAM533uoXqMuaGNgOxaPxuIu/OWSGMJ4MvVwu/ZWGDZ0S7poR3Pu7Qx
        BH8C9C8omNaJp0ZHhLp6kyh3DGuEvH1gGrLc
X-Google-Smtp-Source: ABdhPJxgRFMnjzUMe6Ve0vs+mEe+gPIS2qZaFUi98aRsfUZSjKC06dO0fs7dmo5q29MXN+po4NG+Ug==
X-Received: by 2002:a65:404d:: with SMTP id h13mr16375609pgp.130.1629851827172;
        Tue, 24 Aug 2021 17:37:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm403436pfd.112.2021.08.24.17.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:37:06 -0700 (PDT)
Message-ID: <612590b2.1c69fb81.94656.23e3@mx.google.com>
Date:   Tue, 24 Aug 2021 17:37:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.244-63-gc883e4dd09f2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 158 runs,
 4 regressions (v4.14.244-63-gc883e4dd09f2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 158 runs, 4 regressions (v4.14.244-63-gc883e=
4dd09f2)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-63-gc883e4dd09f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-63-gc883e4dd09f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c883e4dd09f2d04b8ef910216114aeca47ec6879 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6125820fefe936105e8e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gc883e4dd09f2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gc883e4dd09f2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125820fefe936105e8e2=
c7b
        failing since 176 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61256d6df1b041beaa8e2c78

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gc883e4dd09f2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gc883e4dd09f2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61256d6df1b041beaa8e2c8c
        failing since 70 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-24T22:06:18.770870  /lava-4408218/1/../bin/lava-test-case
    2021-08-24T22:06:18.775875  [   16.114722] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61256d6df1b041beaa8e2ca5
        failing since 70 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-24T22:06:16.345411  /lava-4408218/1/../bin/lava-test-case
    2021-08-24T22:06:16.362506  [   13.684607] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-24T22:06:16.362996  /lava-4408218/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61256d6df1b041beaa8e2ca6
        failing since 70 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-24T22:06:15.329586  /lava-4408218/1/../bin/lava-test-case
    2021-08-24T22:06:15.332378  [   12.665903] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
