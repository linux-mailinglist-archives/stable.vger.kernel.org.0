Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD1A4004B0
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 20:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350466AbhICSNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 14:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349959AbhICSNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 14:13:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10273C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 11:12:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so102886pjc.3
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 11:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pq+nvLrTder982K5gafGLcTcOd/8je6tIkCPPft4iLo=;
        b=hPwa1oAjcI1MN9OrQNfVOQxtR3z4LjhDmWbsVX83BscnsF0X8NzhhG7a3t3cwr16sp
         Ns0UFoEKkCh8fH/qtR4lcZEgtK15kB2eOUwT1mPGngofZUbTrnVqlA2fEvirCveWAR0w
         iwi0fLWYGcDxLAO4RXgp6xO0jbKtgkscPqhGzu38ZNCxNzA7fWgC6o9Ss7aXraoXQTOK
         I7Xbs2O8+uWf5HWAr0IzGjFQPp4CC8Q9ORleC0fedIpKiI0JlQlcCIkWiPhWd6S7CTzg
         ZWURHJsanzHLIz0fvjo/z4jmrTV+RVuzFsVzZYhRqRK1VBpPFfkQegIr8uCkidz5QfYk
         GHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pq+nvLrTder982K5gafGLcTcOd/8je6tIkCPPft4iLo=;
        b=T7/cCZcjlC0ZeBi9dnu2v2nr0jLHhCKgbYQC3A+rJKiNTS/+f7g7s+FR7a+DDSP1k1
         RL0LDE2w3IDJSHZCEgE4IBsdYgyOlqNYa9vln3mxv9l9pnoVL0CwnjHOVJISUqy670BL
         THE+sovedBnJO8gSEfkETCZqCO/6FWzKA4PaQ0N533MdCmk2yBmKPTdxiPX5fSjY3l+4
         nn4lV04wst1gyPfn7oNagiZKaCkVqoGisYoDFtvaDcLsBTDeT86BRfrb2GRJz2s5aCzU
         GSs6UImV3febcBQycqSz8cn5RFOxXXFmb66+IZRY/UvQRnfOlwK47nbvHgJgPr1dUs90
         qI7w==
X-Gm-Message-State: AOAM532L+EEL4IeN2Z92qj3tBz8kQ87D6iTBIPUuWV8DwO1VH79afUpt
        gqv7hTO6pWKhhyHAjjcChEExuaxTobOQQEzA
X-Google-Smtp-Source: ABdhPJww6nPg/l3KfM4vwBpznEukkiWa446LzEBP4C6OT7yzcpbgSMjjPRt5PQc7zvWsHHTMBZfgRg==
X-Received: by 2002:a17:90a:fb90:: with SMTP id cp16mr231494pjb.140.1630692756396;
        Fri, 03 Sep 2021 11:12:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm14186pjv.20.2021.09.03.11.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 11:12:36 -0700 (PDT)
Message-ID: <61326594.1c69fb81.333e.0106@mx.google.com>
Date:   Fri, 03 Sep 2021 11:12:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 179 runs, 4 regressions (v5.10.62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 179 runs, 4 regressions (v5.10.62)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6dd002450bf7b9143aff3af42ad1e12efe9a4f8 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/613235da55365d21a1d596a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613235da55365d21a1d59=
6a2
        failing since 63 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61323c4c23f84bd813d59677

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61323c4c23f84bd813d5968b
        failing since 80 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-03T15:16:03.912678  /lava-4443855/1/../bin/lava-test-case
    2021-09-03T15:16:03.929410  <8>[   13.894019] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61323c4c23f84bd813d596a3
        failing since 80 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-03T15:16:02.505580  /lava-4443855/1/../bin/lava-test-case<8>[  =
 12.470566] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-03T15:16:02.505942  =

    2021-09-03T15:16:02.506139  /lava-4443855/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61323c4c23f84bd813d596a4
        failing since 80 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-03T15:16:01.470087  /lava-4443855/1/../bin/lava-test-case
    2021-09-03T15:16:01.475222  <8>[   11.450979] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
