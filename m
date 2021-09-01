Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996893FE27D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 20:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbhIASqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 14:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhIASqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 14:46:00 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F688C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 11:45:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 8so375020pga.7
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 11:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qZxVJ5RW98NQ8NTiRRAqTscgXS001Av49/yKHPh+qdQ=;
        b=K4tG2GUKdfKP23xDsRbKCKYfDtSTPh7tX5UKM0970LzTf5w4pE3FEocuFJFfPslG4z
         FXVdChg09ZesO8tkHEqh8xb7jCxNB0QgKzVutbf400MKTqShtpoFy/UeCYbHfMEW/tar
         9PRLUDW1LJcJ6T05dw9m8k24NLcwEU6ECt4ghwZWG7RB7610n5RKfaHoWPuJbNRqUnuF
         i5MdLrj9SIZMpLp1b0sRZdRR8jhrXntP+7qAUe/iz0OgjVK1OoyiKbohWWaMI4e8M/D+
         PoXXB9E+IKjWma5rM8Pj+Ii6696lTTgIg1AHiK6wSGx4ESH4rQLljkrSVFDIiQ+TLct2
         CsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qZxVJ5RW98NQ8NTiRRAqTscgXS001Av49/yKHPh+qdQ=;
        b=mwIzyOBJLZzKo1dcZNeucE3ZoCUlV5TcJNNmUyNi7Tsi1EhgEJ/YXL7xtX3Nby6mvB
         GU09zBwuk01kvz1FgqX56Y0hCwbsI9DEYbSCIp4GI8+IENG0Sb7Gd+WGSMD6zoGBxKDx
         5p0N+d1Jm8NEgqDUxO2UOPdQhDzwE/ttHlmw1LZ3O3yJB7zzLwbyw6zxuv4LbhTfUiN1
         CP7PtMA4Oyrff9vLxkkRmcZTaJxZvA/+l3+ULnAJdHX1OT5cc0I1c2tJPANAIB8GcxJQ
         Aq+kq++48EwxvKonzpym4KBYi63p4H9u4NwKMI0aI0nB1cmfzLc763hfgF+yVOatHrA1
         G3oA==
X-Gm-Message-State: AOAM533QeBkzwQ6k40fi/FSiWylYbWTJSAMNetpp35nhNmi2otPbhm6t
        sK/3hlsxrhx0UKW8U6WUJAk+A0LUN9JOEtiW7vk=
X-Google-Smtp-Source: ABdhPJwrPkpOYXlOF2wxRkiizHqv8OLfyB0k/d4sRu/WRRjhoI0MmW/VM8zSYeRgysD7XjJannqq/A==
X-Received: by 2002:a63:e916:: with SMTP id i22mr497300pgh.76.1630521902648;
        Wed, 01 Sep 2021 11:45:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm415896pgs.27.2021.09.01.11.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 11:45:02 -0700 (PDT)
Message-ID: <612fca2e.1c69fb81.51a7.1bb0@mx.google.com>
Date:   Wed, 01 Sep 2021 11:45:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.61-104-gab8ec6b0cfc1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 195 runs,
 5 regressions (v5.10.61-104-gab8ec6b0cfc1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 195 runs, 5 regressions (v5.10.61-104-gab8=
ec6b0cfc1)

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
nel/v5.10.61-104-gab8ec6b0cfc1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.61-104-gab8ec6b0cfc1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab8ec6b0cfc1050241cdbd05816acdac92a08bcf =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612f92e7f86896da6cd59686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1-104-gab8ec6b0cfc1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1-104-gab8ec6b0cfc1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f92e7f86896da6cd59=
687
        failing since 61 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612f93b02f6f95ea03d5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1-104-gab8ec6b0cfc1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1-104-gab8ec6b0cfc1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f93b02f6f95ea03d59=
66e
        new failure (last pass: v5.10.61) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/612f98d8dd2d06802cd59688

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1-104-gab8ec6b0cfc1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1-104-gab8ec6b0cfc1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612f98d8dd2d06802cd5969c
        failing since 78 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-01T15:14:12.610266  /lava-4428563/1/../bin/lava-test-case<8>[  =
 13.357479] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-01T15:14:12.610717  =

    2021-09-01T15:14:12.610916  /lava-4428563/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612f98d9dd2d06802cd596b4
        failing since 78 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-01T15:14:11.170620  /lava-4428563/1/../bin/lava-test-case
    2021-09-01T15:14:11.187771  <8>[   11.934931] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-01T15:14:11.188005  /lava-4428563/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612f98d9dd2d06802cd596b5
        failing since 78 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-01T15:14:10.151519  /lava-4428563/1/../bin/lava-test-case
    2021-09-01T15:14:10.158520  <8>[   10.915744] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
