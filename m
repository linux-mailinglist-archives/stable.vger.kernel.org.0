Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B28427CC6
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhJIStM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 14:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhJIStL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 14:49:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3EFC061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 11:47:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n2so8327717plk.12
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 11:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HEoyIQtQFb442T2wF3tuiksMPe6ZRBGw8l1hJorBgwk=;
        b=5iOluiRmhay37Avdlz1+P4lojVfNAHFXK9U3vfMY3+/1VxciEThyBxAuNpMGnR1l3A
         uPQ2hIeShcCQE7joaNo/Mupdq6TsWHV95RaA1bYNxJnVbCDAIJK4q43vzL9MW4uPWW4w
         KZRywnCbhcWRPbgEFUcIImnl+kP8ZwwbzTAdV5lqjpnk2zNTAAcD7xpV/HQJ/FgIm7Xq
         fy8K+KWnpVt4ySP8cFK6UmR/CK6Zj9jjp7mU2uvlsXXKTVbDHEE8rLsS5bvWEVF4raTT
         4Rv1fhwQBG3Tv8SFNs2Xc9m286V3C5R40EjPcXiYDWxbWLlr0HybtG2yEk5ZHb7kmHce
         idIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HEoyIQtQFb442T2wF3tuiksMPe6ZRBGw8l1hJorBgwk=;
        b=gcx46FcXdZqdkv9Xg8pcxHuJrbUEu6UPWsvmj6ERCmzNb5pdbPF2gm/6Q9FTe95NvG
         MBXqFhtlwReBdeUkad3EL3AWVUjcWhDZ4EUlWCC/9lwz0fL9k2S6+bI6TfZL9Fs3+gKG
         evoLWVQK78D1YurimPXtTwp7Pxg2npGpPBPh149RIh9h2hJc1kSkfQb6qBpcNBq/LH5e
         XeqozbMcs7wrwBt5/kBQOFjqyQIyx+s73icsabVhRTERTO+twN/a7YGogbIbc83HqM7S
         UFvtteWC2YN03JmRiPDQcLW2p01ygWwnrhJP6L+3NtgEBMPKrYHWm7UsRJ4tP6E6ICnC
         /GTA==
X-Gm-Message-State: AOAM532hGvgwiSS/D/2RKBsLeF/T+VA3/pWUH4LTqY0C+xxm8l7iaCU1
        4p67zSgGya6ZizMTXHJ7xBuRskyWGxb6QJdD
X-Google-Smtp-Source: ABdhPJwNlCAc+yQJzCSiuXuGwhf6W/tfHNlLOMVmsxVVggyaDLOI6QnzWFCJl7yJgQgL9JfWICPxgg==
X-Received: by 2002:a17:90a:c982:: with SMTP id w2mr19362851pjt.30.1633805234230;
        Sat, 09 Oct 2021 11:47:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o189sm2957156pfd.203.2021.10.09.11.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:47:13 -0700 (PDT)
Message-ID: <6161e3b1.1c69fb81.94a31.8234@mx.google.com>
Date:   Sat, 09 Oct 2021 11:47:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.72
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 186 runs, 4 regressions (v5.10.72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 186 runs, 4 regressions (v5.10.72)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.72/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5aa003b38148d584f20455ecac85c51187d0b71e =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6161b0175614b1ce5799a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.72/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.72/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b0175614b1ce5799a=
2f9
        failing since 17 days (last pass: v5.10.64, first fail: v5.10.68) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6161d1fc49e1d51d7799a2f0

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.72/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.72/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6161d1fc49e1d51d7799a304
        failing since 115 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-10-09T17:31:21.097203  /lava-4684522/1/../bin/lava-test-case
    2021-10-09T17:31:21.114109  <8>[   14.108564] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6161d1fc49e1d51d7799a31a
        failing since 115 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-10-09T17:31:19.691899  /lava-4684522/1/../bin/lava-test-case<8>[  =
 12.685295] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-10-09T17:31:19.692425  =

    2021-10-09T17:31:19.692942  /lava-4684522/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6161d1fc49e1d51d7799a31b
        failing since 115 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-10-09T17:31:18.654832  /lava-4684522/1/../bin/lava-test-case
    2021-10-09T17:31:18.660642  <8>[   11.665984] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
