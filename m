Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6B3AD35D
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 22:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFRUIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 16:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRUIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 16:08:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83EAC061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 13:06:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t13so8672516pgu.11
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 13:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BC35eBGOglEqDyaL5h18J1gFTv1KLbd/ZQlHvjr8Hnc=;
        b=tqNFm2X34OUKRfaidkIy2i+qbvVssAQ+jRqYLCFeBxrfhhPSSe8tAMzRKBNcM7RpRB
         ExPMJPtCarl9SR4Bkytw8/zs4mCkKoh9jU06j4jToE7ZIlUpbDFKD3surgkz39MgAp09
         9y8YylUxD+PJiHM/Jupw67EFZlmGG9mlu3kA5Zhn3yQyXqimz4LpjA4wSxqXVKo3sIBZ
         HVIm9RS/p1V6jRhI33B0YUtOj46Gr346Q8g5Z4RHupyTdLTWDc2Kr4f4EFjo+PXIRCQB
         lMDhhpbH0DhXQi1e1KWUVcyB7nsStMkn0wxBp/S9GUeO6lGy1/Lel76pTnv2wjMqBqdX
         wVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BC35eBGOglEqDyaL5h18J1gFTv1KLbd/ZQlHvjr8Hnc=;
        b=fSZuLSMPt8YTZYmKTNX5cJSTsFuW4lCE7O27quvwtvQP/+qghUqawKVMxQxH6UcR/2
         oFil/DDNZpdWUV1aGQHNdoI6EVJ4GpFQcEJzmI+bD7VyPUtaNyjDDsm4cjZU64nRToEi
         g/ARM+V7fkjqCkBNZvRMJTsRYpwHsG8rdGWAxYlypgjNZRJNFsdzUNnSvxg/FMBNl0hE
         fMLRK5nDG7/baqSzkoyS+AyA9LWaUxW6xrmriB1Evrwuc/3crf7ORfob7kdDqvrI3Fdi
         cdRDNqhXApia8+saebvQGO5OUE/FuUnPGtMVUwmUICFPjIV3ZkOY8PFKWr2rAA2kpHU6
         li+g==
X-Gm-Message-State: AOAM532umAXb8uEyZQAU+AV9v+qzU5i1Nv3h1Bn+GfxweDodR9RtOdR+
        gQ4M8Iea1p+Y64INfSN3AXExIukZNdgGHg3G
X-Google-Smtp-Source: ABdhPJyztWFEUjvBZgLgOUTEP7nOWLw3RGArACuF2q1TPNxBE9HEXmV3DjomgPhT0kLdXmoottdiMw==
X-Received: by 2002:a63:582:: with SMTP id 124mr7970522pgf.132.1624046779124;
        Fri, 18 Jun 2021 13:06:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k21sm9269323pgb.56.2021.06.18.13.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 13:06:18 -0700 (PDT)
Message-ID: <60ccfcba.1c69fb81.9049d.9b0d@mx.google.com>
Date:   Fri, 18 Jun 2021 13:06:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.45
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 148 runs, 4 regressions (v5.10.45)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 148 runs, 4 regressions (v5.10.45)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      037a447b7a0baa71593cb9a57ac7bdb7b9303c01 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60cccda735cac2fd4841327d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cccda735cac2fd48413=
27e
        new failure (last pass: v5.10.43) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60ccde72272ea539f7413289

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ccde72272ea539f74132a6
        failing since 3 days (last pass: v5.10.43, first fail: v5.10.43-131=
-g3f05ff8b3370)

    2021-06-18T17:56:46.177706  /lava-4053268/1/../bin/lava-test-case
    2021-06-18T17:56:46.183594  <8>[   10.749354] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ccde72272ea539f74132a7
        failing since 3 days (last pass: v5.10.43, first fail: v5.10.43-131=
-g3f05ff8b3370)

    2021-06-18T17:56:47.189018  /lava-4053268/1/../bin/lava-test-case
    2021-06-18T17:56:47.197948  <8>[   11.769076] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ccde72272ea539f74132bf
        failing since 3 days (last pass: v5.10.43, first fail: v5.10.43-131=
-g3f05ff8b3370)

    2021-06-18T17:56:48.619181  /lava-4053268/1/../bin/lava-test-case
    2021-06-18T17:56:48.625960  <8>[   13.197055] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
