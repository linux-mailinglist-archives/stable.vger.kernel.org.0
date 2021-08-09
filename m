Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26103E4FFB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhHIX0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 19:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhHIX0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 19:26:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A84C061796
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 16:25:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so2476746pjb.2
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 16:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ctI3DPxIYAZ0NBloSJq6BusOpDF/zzZhy9tr6vZLTG8=;
        b=fu/beiE9//U5Ai2pijuNNrU1VWPH1FOiF6cnNGAphE3AH5dj933yrcOmyHajiwuTMU
         RzwvfeARp7hiKntgtbtuAwFcQ+bRbhLbo9CEn8rvvAv63dTZxtEb2zRqLA2snLB3IB9Y
         FF7Olst6FdUSone3H2S/GCVojd+B79AnDv2z5h09mY4N7xnw+8xXPJQhUodmu/oH+mBl
         bLFWLXXVRzwjHw4kAmugVU3Yuy4Dtr6rS7ZbUCBTNyoJHhpW7bWfzyQDd54Z35hvtEKf
         9A0YeWWOmBL2cS9lpA01pTfVMzTKuEdOcMBu9x3jB/bfutol1I9GnM2A2X3kc5DqE6B1
         CdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ctI3DPxIYAZ0NBloSJq6BusOpDF/zzZhy9tr6vZLTG8=;
        b=JpUgAXJWk5jnbd0j1DYTGozpVuF5Xj8ENn5pviEzFkgzIUhp3UlRSkfAqHzo/sPSmt
         NJRBGB334Ax9pPoiwmKVm8R4yqWyC4NtcyD0bHI/I1HJcTkgAmkUqMl3ALIFGvZJo1AH
         ItPcgpPMEfZDe1zBsad0xpSy+8BFCp+NXauv/qFQF1YXldBAgpTeWPe+VJXfK1oGSe//
         duWqWlFr3X+4GdkFgK++8+0LrBJnpohe5OfKHhNj09N3yQYe5XZcqtrWjgJ2gWY9BYKl
         tBfvmsTXYgOqivv4myPBH8fjg6LQrg/d2Ycp2jJKOvfMsAx4rzLTYt59/MDFW7JQEkni
         J1rA==
X-Gm-Message-State: AOAM531C7y3knibfWSsgXOLFVQOA+IgdH3rudxK8RmhrmqzZPvYlwbkq
        jRBN1ZI6bVKAgq6zfJuIwI0tnVIRfirz1MV2
X-Google-Smtp-Source: ABdhPJzVbG5R/1LWKQk9gu2ADh3au8jGbxnIk3R5y1+tVdux05NXRVIEwtKQV/LhAiDN2fLnpOz4hA==
X-Received: by 2002:a63:f754:: with SMTP id f20mr199565pgk.385.1628551554630;
        Mon, 09 Aug 2021 16:25:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t12sm24508096pgo.56.2021.08.09.16.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:25:54 -0700 (PDT)
Message-ID: <6111b982.1c69fb81.ef325.8bf0@mx.google.com>
Date:   Mon, 09 Aug 2021 16:25:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-126-gb04ed4b2e724
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 108 runs,
 3 regressions (v5.10.57-126-gb04ed4b2e724)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 108 runs, 3 regressions (v5.10.57-126-gb04=
ed4b2e724)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.57-126-gb04ed4b2e724/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.57-126-gb04ed4b2e724
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b04ed4b2e724be0ecb9ddff01abd637b467eb33c =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6111869e67d4cdf9d7b13679

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-126-gb04ed4b2e724/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-126-gb04ed4b2e724/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6111869e67d4cdf9d7b13691
        failing since 55 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-09T19:48:33.966675  /lava-4337366/1/../bin/lava-test-case
    2021-08-09T19:48:33.983575  <8>[   13.714517] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6111869e67d4cdf9d7b13692
        failing since 55 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-09T19:48:31.521534  /lava-4337366/1/../bin/lava-test-case
    2021-08-09T19:48:31.527280  <8>[   11.269944] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6111869e67d4cdf9d7b136aa
        failing since 55 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-09T19:48:32.562504  /lava-4337366/1/../bin/lava-test-case<8>[  =
 12.289563] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-09T19:48:32.562844  =

    2021-08-09T19:48:32.563040  /lava-4337366/1/../bin/lava-test-case   =

 =20
