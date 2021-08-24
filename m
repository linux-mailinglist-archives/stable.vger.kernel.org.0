Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A2E3F59E2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 10:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhHXId7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 04:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbhHXId6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 04:33:58 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41B8C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:33:14 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w8so19114356pgf.5
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aEqirRI+2fYuswf00tVyGWlsVUmrOpwcAroSKzJVDFU=;
        b=zxDa5IBw4s0Dcw9pvpI+5/phJRO0ZEIRtBAb/bNGoVKKWht5gy9uaYGruXcHfC2cAp
         /zXZcNnmhrBgyPKfqJA7O8mtIhyfo/DDpcWqn0UaxxFlvH+Xlz02ZlC6xILJCfTV6zLH
         bARQpjTJvcauqLLsmlDCTPmpFXL2VA1c7dvw/8zb4OEvIJCpbFBhUFNwgrCISdjm2v+N
         ePNLgQAWUOkj6hGXxvTVwD+QbEkzIxMn11Vn0WVsxNnvswzKdcHn8HW+XCtlGhZlDI6m
         XgvslHDsFjGPhYW8S4atmT7+KbKTf/De0nmRoTtrw4Vy7ACir5PTJ5dFpmB1Y81P7zPz
         /84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aEqirRI+2fYuswf00tVyGWlsVUmrOpwcAroSKzJVDFU=;
        b=MfIg8Lzfh/mRVUthFRFcRsoJg7oUrxgseNx5YKVmB6U5HmW38A+aAB8wv6uEvosE/b
         WUZ45FQ7eR8U5IZXIVjZsJkecDfiaalGqmTBocXX0OxK9CsijZH5vhDtVJghg7G0S9Jk
         Xk/NaNdRp8Pf98ECCdkGywT83T2PaD6szX9g7c3F7RhJ7GufDdRTmNZ9yyq6uXUVauYm
         L77zT8tu88UCjjp90DbEHT6Vm9vK5JP12yal7yfih0VmpVAUG/wK58jZTB+Py2OUmfPw
         1r/+d9kjN2D48XvYH4vZheeVjjWMrCCFsR6OqmTJrG88bAV14WK1SSBF7ZZJhgDIlyXT
         BU/A==
X-Gm-Message-State: AOAM533MkUZ7utjQzxdKz3e0E+QYtB950nHSOKfiKNo+qsGJfEqjLzzI
        YceT3PMRqFM7TqUxmnVX/PWxdDonQxlotpQM
X-Google-Smtp-Source: ABdhPJwNittaaLHiF4skx3nK5tJk++G02C+2LPFKh0lwcF6HnGTX41AVP50PaqRbor8Fj/jMXfCsqg==
X-Received: by 2002:a63:e446:: with SMTP id i6mr36326672pgk.288.1629793994393;
        Tue, 24 Aug 2021 01:33:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b8sm1689691pjo.51.2021.08.24.01.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 01:33:14 -0700 (PDT)
Message-ID: <6124aeca.1c69fb81.f564.48ff@mx.google.com>
Date:   Tue, 24 Aug 2021 01:33:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.244-62-gd58d37959b08
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 110 runs,
 3 regressions (v4.14.244-62-gd58d37959b08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 110 runs, 3 regressions (v4.14.244-62-gd58d3=
7959b08)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-62-gd58d37959b08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-62-gd58d37959b08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d58d37959b0846eb437df23ce99f4c6bd5c84ca8 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61247e745a537ff4158e2c7b

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-62-gd58d37959b08/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-62-gd58d37959b08/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61247e745a537ff4158e2c8f
        failing since 69 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-24T05:06:44.050280  /lava-4404482/1/../bin/lava-test-case
    2021-08-24T05:06:44.067405  [   16.409295] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61247e745a537ff4158e2ca8
        failing since 69 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61247e745a537ff4158e2ca9
        failing since 69 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-24T05:06:40.600017  /lava-4404482/1/../bin/lava-test-case
    2021-08-24T05:06:40.605625  [   12.959038] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
