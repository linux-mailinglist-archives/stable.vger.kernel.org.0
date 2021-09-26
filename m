Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0F418AD6
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 21:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhIZTnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 15:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhIZTnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 15:43:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459F9C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 12:41:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l6so10254621plh.9
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 12:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kz0uWBPOrFmbM0q0RRcwhNhXODAOUofC8cxicIH+RjI=;
        b=b1vxACntvaij7XK2uooUVmxm4jcFlQr81BvPfyzA/VepnJOipDCd5sBLNLQqEOo2SM
         m0WQKdbHxRhX7O+wYGZ0o/cKdePsGDsWPwpp8wOYawQZTmsPpnnEPydBOmizZrA2HoqU
         uIf7RbT1mq/RhoQ0Pw+TRpkn9lwQwQXTch3LBXuntS9TuOoOmfNpZP58nXzQOj8K0C0F
         AI3ByyPRtlwFB0PTi2KqkHz0MBc/r/FiuDGxRT+v8SpK1cmcy25vLyxqWpqiTNV0xKeL
         DYaAtEAMfFXNtvKZWOj5BwbMkC5mKfKtTGz52xknS+hxxmA/uPDotXsvCQZm0ob8M/3/
         xPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kz0uWBPOrFmbM0q0RRcwhNhXODAOUofC8cxicIH+RjI=;
        b=8BYSGDEbAacSBH3wLEQtq7eArLdqyP7x8ft6kI6YP34+psGRuci4Wj5YpB03ZM0wKo
         oLryoppfoA6APTUnJ8CvPLq6i6Roa9TzwbZXWFb3uOIvPxs4oQjg8nIBV6pGg+S7tBp4
         vURVDjWpZcFhPR09/MuRm5mVOHr6rp96gZyvcSoL5A7NWlO7Ed46BQIxgcWIfUFuyS7+
         T8aABW9B1ombo4S0jqF3u6uqdm67X57dwYvZ9pPNJb/ZINCAJZZvGVAnqiKkdrlwfIym
         5lw1QG2Z9Prgu1hMqkAYrPeBVn/1gEpanhzyVE15HWFtXh4KngnmPLCPtrF/hRoibjJL
         F5Hg==
X-Gm-Message-State: AOAM532j5yOCDM5xPjJIAIB4sSOvwkr8KPtu4KJd7ipOalmYuCItpFE2
        UbR8EtAM7IBNe4scYyDvgEkfHwEHyRsckEQv
X-Google-Smtp-Source: ABdhPJw4lAD7wSC2JXF18Ov0JWCPw4xuZzyaIu/QUw+fxSPL4L9UJNiFR+gpihLVelQXXfG932we7g==
X-Received: by 2002:a17:90a:a087:: with SMTP id r7mr15645636pjp.84.1632685299334;
        Sun, 26 Sep 2021 12:41:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v24sm8149033pff.107.2021.09.26.12.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 12:41:38 -0700 (PDT)
Message-ID: <6150ccf2.1c69fb81.a0e4b.b017@mx.google.com>
Date:   Sun, 26 Sep 2021 12:41:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.69
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 69 runs, 3 regressions (v5.10.69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 69 runs, 3 regressions (v5.10.69)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.69/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5f4196eaa90c139ac470111b8e2deabf5f283baa =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6150947fc54dbcb2ae99a2e2

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.69/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.69/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6150947fc54dbcb2ae99a2f6
        failing since 101 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-26T15:40:26.702048  /lava-4585566/1/../bin/lava-test-case<8>[  =
 13.716368] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-26T15:40:26.702615  =

    2021-09-26T15:40:26.703035  /lava-4585566/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6150947fc54dbcb2ae99a30d
        failing since 101 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-26T15:40:24.240860  /lava-4585566/1/../bin/lava-test-case
    2021-09-26T15:40:24.245963  <8>[   11.272470] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6150947fc54dbcb2ae99a325
        failing since 101 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-26T15:40:25.265300  /lava-4585566/1/../bin/lava-test-case<8>[  =
 12.291871] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-26T15:40:25.265857     =

 =20
