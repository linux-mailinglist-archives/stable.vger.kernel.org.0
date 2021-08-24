Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA983F6C4E
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 01:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhHXXoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 19:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 19:44:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6ACC061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 16:43:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fz10so3953084pjb.0
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 16:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HhRoY+EqkihVNK0uM/8mUrEtkwIeYa2x4x7DQgCzRgY=;
        b=01JE0TRDU9dRy+GGd0lIM7PkSW8xk/vaAbv6XhkVnXAsojQQPkPb4chJkMlcCtAxW1
         B3sD3qouZdSDyA6CZGtfPv0rxjfGXI03IbJvwMgQmHvhuuCUFeOVbhKHfWcyBP+jNb1L
         ENryODuSMw8I6AZ3wZzeFj5YEjE6xaBN5A87wTc6w2rkM0kgEVYo7tMgPXokQzTZ6xD5
         909ivhKWFRP6kZFCZtl1s3siLAidHgkkOhOERUA5BNDB/2M5+aHv3Q36x1uYTF/XIc09
         kjZ7dR21Thw4iVPJjH7LmuVVVzOajRtJLu2m2bwqC/R4dTZLP7E5i4lgnVJ2Mf0OTzPs
         7HdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HhRoY+EqkihVNK0uM/8mUrEtkwIeYa2x4x7DQgCzRgY=;
        b=n+mRoaiR5Vonw0FZUlCBrxHPqrZz75wqveU6ym6883uI35xdVbC4JHqISlCb3/+Mpv
         q1sNAkKYDIZVI5Fod4lrwXjBNGqdHgixM88i2uZiVX5Da7ndUAL79gxfoayXqx2BXfHA
         QeMYy7cXC6p90DKS5YXwcfSsNPUqWTm/5s8bIrnVmt9V69+OqDdis6VyqgYHh5tQWX2L
         kQqNbQFN0ULvM8d4u4j2CckkdOFrAANREcD0FKRL6Ru8Xw5pFums/16MgxURqKZ1Tv4J
         Lsr1j+9I5dRcFZhEhuyTX7XAu38kmfqxfdWUB4gfrt84NPZFsRCj4hOCygCpQOso2UfE
         r+0Q==
X-Gm-Message-State: AOAM531yjTMVtBbox60r2SZztwQkvUqarXmjQ4Og2b/XYS5wu0zsbFwY
        K/LTL2vNi8Aisx8YQig/0jpJ9s75/VQRAQuV
X-Google-Smtp-Source: ABdhPJzDiaC4CsZDp1nRMNWRuNHnRcnW3uBRjMVX6kVY8R2uzau4wnU4b1ENaQcYnbwU8QR0o+ZLyQ==
X-Received: by 2002:a17:90a:a88b:: with SMTP id h11mr7032265pjq.44.1629848596870;
        Tue, 24 Aug 2021 16:43:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ob6sm3344756pjb.4.2021.08.24.16.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:43:16 -0700 (PDT)
Message-ID: <61258414.1c69fb81.549bd.95c5@mx.google.com>
Date:   Tue, 24 Aug 2021 16:43:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.60-98-gbd3eb40a9de7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 200 runs,
 5 regressions (v5.10.60-98-gbd3eb40a9de7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 200 runs, 5 regressions (v5.10.60-98-gbd3e=
b40a9de7)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.60-98-gbd3eb40a9de7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.60-98-gbd3eb40a9de7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bd3eb40a9de703ab9ab65f9c583e40d185d6aaad =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61255d478acc552a1f8e2c89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0-98-gbd3eb40a9de7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0-98-gbd3eb40a9de7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255d478acc552a1f8e2=
c8a
        failing since 54 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6125552d2ba4bebca38e2c98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0-98-gbd3eb40a9de7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0-98-gbd3eb40a9de7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125552d2ba4bebca38e2=
c99
        failing since 10 days (last pass: v5.10.57-136-g252d84386e00, first=
 fail: v5.10.57-155-ged2493daa915) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61255ddde0110e95eb8e2c81

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0-98-gbd3eb40a9de7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0-98-gbd3eb40a9de7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61255ddde0110e95eb8e2c95
        failing since 70 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-24T20:59:55.349634  /lava-4407794/1/../bin/lava-test-case<8>[  =
 13.907968] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-24T20:59:55.350229  =

    2021-08-24T20:59:55.350819  /lava-4407794/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61255ddee0110e95eb8e2cad
        failing since 70 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-24T20:59:53.927002  /lava-4407794/1/../bin/lava-test-case<8>[  =
 12.484482] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-24T20:59:53.927543  =

    2021-08-24T20:59:53.927961  /lava-4407794/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61255ddee0110e95eb8e2cae
        failing since 70 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-24T20:59:52.889903  /lava-4407794/1/../bin/lava-test-case
    2021-08-24T20:59:52.895737  <8>[   11.465211] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
