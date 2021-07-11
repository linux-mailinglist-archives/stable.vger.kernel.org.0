Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA13C3EB2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhGKSL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhGKSL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:11:27 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48C1C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:08:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c15so7833239pls.13
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N1nAre8MxnpPM+442TFT1YQX3tj2vbsENVHQB3UC2d0=;
        b=YgVIsL/pwh46SowqyEab27TBjRGIAp2cla1SoupByBcZqAFjf0E3znbmAmSi2iZLf9
         5SCSr859GIP2r+9OQBQe6lCbi4t7TkRJ2qlyC1yCUieO7DtfJ+FY/ci/b2nTM+d5XVQH
         joGkSATdG77U97jBQ0PGVRyO+dsn8kvAgrZk1gFkvfaul//ll/wq0s/FVn9JzTweskhG
         Bnovjyru98AA5CPYouY51CoexvhHhtNVoQ09rjeWYj97mJdWSL1CswjbJMt64XwtjBH5
         FarLNTGBHJQo+mCICkmy6kzBJPxlffV3JWPuipx/MHBO9Npw92HOV3yg05FPQ5NIp7zu
         682Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N1nAre8MxnpPM+442TFT1YQX3tj2vbsENVHQB3UC2d0=;
        b=YuHZWG5fzl3rNc91rGBTSyZYInmHE2mSaDe4FgbWrJvSzw7cF/VawkjLGGljG7zyI4
         77sdo6MGylvL/I6rs9HZNBU0rvbKCZEk1bVw747zA0E0ZtDM8qL1DPdw5EilYrtDf7Ld
         nBse9kY5hCVwg55bPZkAiYTDCyUCBdCw/HGWtPOveASrmdR2gA28fV8VPqvCqxqmmKJd
         QnDGh7t4S2IjbU685k5SML2TF94ain0sgo3Y8ONEgvjV0VWbVhng/iLy02zjATD9qWLD
         1D9xJiOzZzWEajSFh9SLnDOhbTG+wlib1GY8ACBlWVPEWLpd7TwvyvLZXqt7MFF8Uwed
         jZ1A==
X-Gm-Message-State: AOAM533s5XiS+3awNFMgSEAWA0W+D79JB0lD2JbBH03UqMrrEMiPDOEp
        UYXOwcpsgwyIaJgKX9LMiDoH0b4s2DCVSLjz
X-Google-Smtp-Source: ABdhPJxCgJZR2+EsZkZeiq65bbY/Ju5c3ltaCPod8EJskfUriUMJfU/HHQ3Ylg9Pz/0WetvVG1kRXg==
X-Received: by 2002:a17:902:7b8c:b029:129:5733:2e3b with SMTP id w12-20020a1709027b8cb029012957332e3bmr40159978pll.4.1626026920042;
        Sun, 11 Jul 2021 11:08:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v21sm12691766pfu.192.2021.07.11.11.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:08:39 -0700 (PDT)
Message-ID: <60eb33a7.1c69fb81.19300.55ad@mx.google.com>
Date:   Sun, 11 Jul 2021 11:08:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 193 runs, 6 regressions (v5.12.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 193 runs, 6 regressions (v5.12.16)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

hip07-d05         | arm64  | lab-collabora | gcc-8    | defconfig          =
          | 1          =

imx8mp-evk        | arm64  | lab-nxp       | gcc-8    | defconfig          =
          | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      362de415aea85e09c8c8741338ab746716539c7f =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0237a9752480fd11798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0237a9752480fd117=
990
        new failure (last pass: v5.12.15) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
hip07-d05         | arm64  | lab-collabora | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb035569bacd610c11796b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb035569bacd610c117=
96c
        failing since 9 days (last pass: v5.12.13-11-g6645d6f022e7, first f=
ail: v5.12.14) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
imx8mp-evk        | arm64  | lab-nxp       | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb03aa79ab9d0ec611796d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb03aa79ab9d0ec6117=
96e
        failing since 2 days (last pass: v5.12.14, first fail: v5.12.15) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb0b709d83f264a6117970

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb0b709d83f264a6117984
        failing since 26 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-11T15:16:56.088744  /lava-4175826/1/../bin/lava-test-case
    2021-07-11T15:16:56.094084  <8>[   15.792431] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb0b709d83f264a611799c
        failing since 26 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-11T15:16:54.665792  /lava-4175826/1/../bin/lava-test-case
    2021-07-11T15:16:54.683537  <8>[   14.364914] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb0b709d83f264a611799d
        failing since 26 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-11T15:16:53.638950  /lava-4175826/1/../bin/lava-test-case
    2021-07-11T15:16:53.647686  <8>[   13.345473] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
