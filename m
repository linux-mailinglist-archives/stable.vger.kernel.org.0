Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E49429DFC
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 08:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhJLGvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 02:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbhJLGv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 02:51:29 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009DC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 23:49:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 21so6716643plo.13
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 23:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gQJhER0GcTaNuVJVaV9HdZ6Vsv3EL1EdQe0t9kCUDX8=;
        b=2mXlR2bdw8oCX3yMHKpabEyEussg7VB3Gh2j6zOdNfTYUkcNzFy8XicBMIAmONKKwP
         4qa2JefvDlGypzPoh0llTDIMSzG1iNXxdJFqVYXlEVEY7/LeR5kWkim5KKu/bNzRdWoF
         Hjon5RuT7FgpkSUsRmqGf/x0uCi7XF8oIBF+y6OiDGY4ZgYLwdwbSP6gXyqa7Gpc7dD+
         wmnOJN7UvoXs0DmU/dwEV1wfhNY9eensHMHZ9+na60ztXSlF+rqsBAfjihB+NmaXGcjV
         y+Lynf8OgtU6F7JIJQXvgDrbaqbSxTu7SUMdoJH+yblxXWtxFkS54YXDtnyTmxuIT7yo
         L1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gQJhER0GcTaNuVJVaV9HdZ6Vsv3EL1EdQe0t9kCUDX8=;
        b=DfqatvUZMRcJDJ6RYNQlv8NudWKhcjvWb+/Jj5p9TMF+100vOrb4uhsqD6+bY0PicX
         kzfd8i3CUVwGrSOoi17DMvkpkMihm7PjE0kkIeXWlCVW632NWKs5tDRoiGxx/t6JLACw
         rAahnTzVtMoMNl12IAIfvMfgWFtBlAUG7ZQnI2n8eqd2Pltn0CXhOW+uqZhvSmnpIOiX
         CuQbEFbFrUmz1fSEnhkPGw2IlfMiDGcKwKBOutZhUZFt14YKWK610ID+sV8KO0eKJ3xG
         V3xF05wYWPw9uHrgvilGw2u0tajafLhWiZusvaGdoOe10YpRQ3phOaUdZgW5zouJ7P6l
         /VGw==
X-Gm-Message-State: AOAM530gQnSW7Nvp2iUoYBy3ahKRtCEpY3+BspzPIgQ/ViElbL/yIB0N
        sNye4/KBu4pQlGbu0Cmg4Hh96ZIZ4AxREv7N
X-Google-Smtp-Source: ABdhPJyh/DQVnWz1aoieMwGW8ABoEXyXg0rBpng99L1QkbqHRO5UMpHu6VmrU4y/A1AaaVaP6kWJOQ==
X-Received: by 2002:a17:902:db0a:b0:13e:e968:e144 with SMTP id m10-20020a170902db0a00b0013ee968e144mr28773324plx.43.1634021367842;
        Mon, 11 Oct 2021 23:49:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm10233633pfl.200.2021.10.11.23.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 23:49:27 -0700 (PDT)
Message-ID: <61652ff7.1c69fb81.3b7e1.cb0f@mx.google.com>
Date:   Mon, 11 Oct 2021 23:49:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.72-83-g0d59553e5bda
Subject: stable-rc/linux-5.10.y baseline: 176 runs,
 6 regressions (v5.10.72-83-g0d59553e5bda)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 176 runs, 6 regressions (v5.10.72-83-g0d59=
553e5bda)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx7d-sdb               | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.72-83-g0d59553e5bda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.72-83-g0d59553e5bda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d59553e5bda91f40076ce48a3f6025079d45ac4 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6164f942ea9764768408faaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164f942ea9764768408f=
ab0
        failing since 102 days (last pass: v5.10.46-101-ga41d5119dc1e, firs=
t fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx7d-sdb               | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6164f6708a9dcd0e5808fac5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164f6708a9dcd0e5808f=
ac6
        new failure (last pass: v5.10.72) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6164fb88a7c991565508fab0

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6164fb88a7c991565508face
        failing since 119 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-12T03:05:26.956391  /lava-4698234/1/../bin/lava-test-case
    2021-10-12T03:05:26.974041  <8>[   11.536437] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-12T03:05:26.974544  /lava-4698234/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6164fb88a7c991565508facf
        failing since 119 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-12T03:05:25.936329  /lava-4698234/1/../bin/lava-test-case
    2021-10-12T03:05:25.942423  <8>[   10.516750] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6164fb88a7c991565508faf8
        failing since 119 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-12T03:05:28.382498  /lava-4698234/1/../bin/lava-test-case
    2021-10-12T03:05:28.399471  <8>[   12.962835] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6164f7b6de0bed8a9008faa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-83-g0d59553e5bda/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164f7b6de0bed8a9008f=
aaa
        failing since 3 days (last pass: v5.10.71, first fail: v5.10.71-30-=
g1164874f979f) =

 =20
