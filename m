Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63434408197
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 22:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhILUnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 16:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbhILUnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 16:43:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89734C061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 13:42:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k17so4527573pls.0
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 13:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0JII4TC7XvpSvd90NF8bCfkf08jit20pa48ptEvUVMQ=;
        b=HL4viIjxIKfjOCR1KavKnvbac7a0JKErOUvMLpJOwQp1iq008+qj3gu/0R0QzdcMHg
         wkmT7WGcO44Q7ahWvoWgIxm4+SoMBphO8sFnuUIgl6iz3sovwIpqWePe4hLaBLvDjZdk
         NGy4ykkm1cyMKtzHbWed7lnO55E6eGIZkiVD3EkuVZ3K+AFRyFYwr+cpcGQT5C3fQypT
         Y4uuA/r6Enl3sjOsxokVeV3tjoUPqAGXKUCtfaTIO9wnqlK+AP3fEib7FhgXW8LyN3RV
         eTqtlPIg5RYdJQ11bQ8enXTkVhaewXiXNBYCdICCZPAinsKQGdioElX33CXU/qWpNymm
         kgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0JII4TC7XvpSvd90NF8bCfkf08jit20pa48ptEvUVMQ=;
        b=KBHRqImM12v4rWzNmcJgDz0Et/y0Pr8zUEV0dUHu3mMbTnT78HNZ8vrAYXzoTX9UMm
         XUlfpQ6n5ZefBsyfDJi208HJAoc1tONd825UOU+sAGhb7RA+awd9CT1GsJ0LQaLp62Ec
         jEG5FWMRfVqmYkLyZJ8lytD1E2Yi09Cf0qcG2Y2QItQbBmm3d3JhwP2GOfX7Z+noEkCt
         RIAVExLDzC5gASNyvlEsZur9JH2PLh0cSRJtXVUOPBlYtzeLTxsgve1H7cxdRl5PB6j8
         ukb7+5DRxgrJrhewK7HmucXTxD2vWv8gahGucw00sYz21TEvWxijBaHreJvkFXa9rD5h
         WR+g==
X-Gm-Message-State: AOAM531EM5NjStj0ZI7vMaUxTgcQjpMOu8U3LUU/NmFLchl5tFeggwHY
        QhPU2+dF5W2ML6XQbyDMw+yoTynqWD8Nbw==
X-Google-Smtp-Source: ABdhPJycVQh0ul0RzNm+n8qsious6OEFkzrdKs1Nv8D8tDNR6NXTIrxZbL5tvBlEQINuhmPueRsdZw==
X-Received: by 2002:a17:90a:930e:: with SMTP id p14mr8926482pjo.132.1631479345972;
        Sun, 12 Sep 2021 13:42:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t22sm4640766pfh.204.2021.09.12.13.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 13:42:25 -0700 (PDT)
Message-ID: <613e6631.1c69fb81.9848b.c0ed@mx.google.com>
Date:   Sun, 12 Sep 2021 13:42:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.64
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 194 runs, 4 regressions (v5.10.64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 194 runs, 4 regressions (v5.10.64)

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
nel/v5.10.64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb83afdc0b865d7c8a74d2b2a1f7dd393e1d196d =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/613e385a2ae121f9bbd5967f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613e385a2ae121f9bbd59=
680
        failing since 73 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/613e378561639e740dd596b2

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613e378561639e740dd596c6
        failing since 89 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-12T17:22:53.700671  /lava-4502480/1/../bin/lava-test-case
    2021-09-12T17:22:53.717611  <8>[   13.850445] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613e378661639e740dd596de
        failing since 89 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-12T17:22:52.294067  /lava-4502480/1/../bin/lava-test-case<8>[  =
 12.426754] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-12T17:22:52.294758  =

    2021-09-12T17:22:52.295185  /lava-4502480/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613e378661639e740dd596df
        failing since 89 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-12T17:22:51.258033  /lava-4502480/1/../bin/lava-test-case
    2021-09-12T17:22:51.263105  <8>[   11.407317] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
