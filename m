Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634103B4612
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 16:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhFYOu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 10:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhFYOu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 10:50:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE68C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 07:48:07 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso5673732pjp.2
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 07:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UYzo1Dk6o5sNKocL1zGT3bnQl6fKYxc+MIP5C/+wnYE=;
        b=UlPUmfAUwSOGUWnhMdw9TSUZ4tAvWTbp4i9rERU0AoyN0NDhAHNYpq7zNKvq/ek4dR
         XdOI3s9zly51TINqxK9o4ELMNYnev8Iy922MUopa9exFWdMyXQChFpRSey8vSJZcvTCl
         5p2eWkZZHJH55h3uo08O9jAv7gkytuEPwrHRka670E830Wz7drTQk3C95zDd5yo0a49v
         /6tLBFM1uogOdRgtOIK5xvBD5i9pPV0vAT3Ca7lbYNNpgLPyFfQhmgN06VwjqO77Flkj
         XS8dBwlQ4RVIX3Hssesd3eiu9Q2IsTupoAz9WNTV2b4VNeUj2BgH/dwG7Hv5IYRuv7dt
         cZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UYzo1Dk6o5sNKocL1zGT3bnQl6fKYxc+MIP5C/+wnYE=;
        b=nC4FxNzag03sCh1bMN9OscNftrTgkxyaPcsB/7P8b1YIeL2hWsJUyorMOVTEbNdSsj
         bChoRLsUuvk0cwKaYuFzx6NXr+uny0+X/VCD7qR3Xjo4PIpajsZMNKUK3RT80XRP1IvB
         nrw7Xh7oAkapLyipgBoGD6NdZgdon+AQIq83shxBLZH7USGuwE/JwZEgQHD7XmpfTIkG
         KcPp/LhROrfU9FVAO7zw5Q7wvBogDiRJryiz8SsMx9bBZ+UotDDJp+1m5cBg1L3Wp48y
         UfvnENjTdJpIrxV9iqIqDgIEfCB5QNF/uYYvY1UXxu9L9pyMpX5AQVl1WW3x4BNBauXq
         99Lw==
X-Gm-Message-State: AOAM532YOlaKlgsBQp0t3WR3pdNCIvvTUQcIdReKa28Lrnjp2635+BG0
        CxlIqH8wioxPOt/5otpDHKWhqidHfjWOgSz8
X-Google-Smtp-Source: ABdhPJxj+CMznE1t0R+qwztIBHXcfL+omKeDO98e19fTJQM2MkRd/hCR2JMc9Wf5S31KWXbBAnRM0Q==
X-Received: by 2002:a17:90a:d598:: with SMTP id v24mr11075066pju.185.1624632487303;
        Fri, 25 Jun 2021 07:48:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm6675343pff.88.2021.06.25.07.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 07:48:06 -0700 (PDT)
Message-ID: <60d5eca6.1c69fb81.ea117.24cb@mx.google.com>
Date:   Fri, 25 Jun 2021 07:48:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-70-g2321b9d92a5a
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 4 regressions (v4.14.237-70-g2321b9d92a5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 4 regressions (v4.14.237-70-g2321b=
9d92a5a)

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
nel/v4.14.237-70-g2321b9d92a5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-70-g2321b9d92a5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2321b9d92a5ab823c297109cb2fa626d3f55b5d2 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d5bfcf296fca0f83413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-70-g2321b9d92a5a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-70-g2321b9d92a5a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5bfcf296fca0f83413=
26a
        failing since 116 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d5c89d06a16ad893413267

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-70-g2321b9d92a5a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-70-g2321b9d92a5a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5c89d06a16ad893413283
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5c89d06a16ad893413284
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-25T12:14:14.285464  /lava-4093866/1/../bin/lava-test-case[   13=
.489742] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-06-25T12:14:14.286007  =

    2021-06-25T12:14:15.299842  /lava-4093866/1/../bin/lava-test-case
    2021-06-25T12:14:15.300415  [   14.508367] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5c89d06a16ad89341329d
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
