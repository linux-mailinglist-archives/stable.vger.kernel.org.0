Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62178418658
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 06:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhIZEsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 00:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhIZEsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 00:48:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D604BC061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 21:46:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bj3-20020a17090b088300b0019e6603fe89so9161989pjb.4
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 21:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zyWTSFDS4EAv7iZp+qPu8cFcgAvkGmEWP24rgeQ0B68=;
        b=qdvPw1mZgRmvNelM6vWqsEiTC6RgH+z4bYK81MSIeWiTBQCWjL+SM7IXTKHY+FRDIm
         pDceBqrXpk3QKO0naRAwvr02BJlWuCLLt1Sr9LN4mp4Sb2Ymz05UySSqjqq/S/6kZsMV
         RJSF/Ucepy+Fi1kdx6JtllYrxNA1DqE67BeJ08UHfNK0cdzhHfcyt8ysm0FSY8snmiHj
         RJwN1ZxctCihTZ7tj3AEq+UU0cYNGtrkWERKHaiKGSFawQ3QjEzH8xR19l7fFDyvpKRT
         yFZk8YvifCIEcEAJ7dyI5tle/2XWO1j1S+O1IhhhUENg0/Jz5+OOagX42bqEaKc4ucEk
         8g0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zyWTSFDS4EAv7iZp+qPu8cFcgAvkGmEWP24rgeQ0B68=;
        b=fUPNw9WBnF5zqJ6Wqed6mr3ywk7sqdjsZljYSg7Pwa1BPM7GVfKysliloF6Lm9BMXq
         1iQ2mMz96FCYjy29Kr+AY8x2nWo/n8tgy8bRdDTjP2v23AYhE+rTWXMjC0xQY+EOT6Zh
         0l4QYXgAqiVlA9w/OLXkKmzWSdTdlvVKA3I3YrMFEuOy9FFyGCdDxxIs1qrCmVf9s6Nu
         ylWI1tJjFZIz9boxH5WpIMRivhvLq5fOU11zOMDvqNEC+mFgC7s8EusxGJ+hwqgvYMfp
         WqcBO3qUuG7x5PMU4mqYjdzpm1KxmGbV6/57PcnArXwbIfGyzjAqCsyo+FnLkffDo6Nm
         hu1A==
X-Gm-Message-State: AOAM5319EHx73G2hjmEebCuZbDxb8e5d2M+jtnoO5Zi2BeUOMZhQVVIN
        JRFhJFsF8E0pdMU7eMR6Kezibse7+gklHQ27
X-Google-Smtp-Source: ABdhPJzpBDwYC/q/3XTvplPQ39In+i/jng/xdW22Nq6WKHTCt88DuWTJFjSZSXd+asRuRDtf2aWqLw==
X-Received: by 2002:a17:90a:1a5c:: with SMTP id 28mr12193601pjl.23.1632631595135;
        Sat, 25 Sep 2021 21:46:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm16628644pjs.56.2021.09.25.21.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 21:46:34 -0700 (PDT)
Message-ID: <614ffb2a.1c69fb81.c63ea.677f@mx.google.com>
Date:   Sat, 25 Sep 2021 21:46:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-34-g6acc348b20e1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 114 runs,
 3 regressions (v4.19.207-34-g6acc348b20e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 114 runs, 3 regressions (v4.19.207-34-g6ac=
c348b20e1)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.207-34-g6acc348b20e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.207-34-g6acc348b20e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6acc348b20e12abd0f06a270afff377270d60331 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614fbd4f142d35f4e599a2ef

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07-34-g6acc348b20e1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07-34-g6acc348b20e1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614fbd4f142d35f4e599a303
        failing since 102 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-26T00:22:31.356836  /lava-4584067/1/../bin/lava-test-case
    2021-09-26T00:22:31.362094  <8>[   17.804560] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614fbd4f142d35f4e599a31c
        failing since 102 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-26T00:22:28.934076  /lava-4584067/1/../bin/lava-test-case<8>[  =
 15.364069] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-26T00:22:28.934415  =

    2021-09-26T00:22:28.934629  /lava-4584067/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614fbd4f142d35f4e599a31d
        failing since 102 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-26T00:22:27.897459  /lava-4584067/1/../bin/lava-test-case
    2021-09-26T00:22:27.902604  <8>[   14.344411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
