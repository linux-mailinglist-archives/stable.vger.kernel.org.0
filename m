Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906DD3C8E4B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbhGNTrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235866AbhGNTqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 15:46:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71633C0613E4
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:40:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j3so1981103plx.7
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nttsxdk6yQJR3/zBuMQqTHO3yy35T60HgnQ/ekY8T4w=;
        b=uUL8XBQLSNL32JEjf7OjM7F/LXWQVSkSOPiedQM2gpU3W9RHD5HNMUmmqVHBZtDtHD
         zDJRiy6XV5OWAH/z/hFXis/wW/yHGD4WATU7t1mTmL3UVuWTzy8hGhXLvNi4Awmh38P0
         RO8fNBjCyb2Jlr2K69Ev8ohQPtNJx31VHZZf6QgOkh9q4gl4x6Ebd+wI52hW7Ugjz2B3
         1NDd2UpG4rG0NW+uPYz/iWnmlxCEX1YRnVDfuFHCecI+/UnjfVwlNoQeukmpZfTggV3y
         B/YE6kKsopFEu2EgpxYbOGfyEIf8ZoDv0pJmaga85KOCWmLK6Dli2TC8NnmygqMLArxm
         DkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nttsxdk6yQJR3/zBuMQqTHO3yy35T60HgnQ/ekY8T4w=;
        b=j9sVBZex41f+IqXeOwk3bNINHCVsRstlVikhfv3G1oT7NyE4AlDj9pDtZVJZqpGryn
         pXR+TZPvQiFNJNfuG3W8TVDgmbCFIkfwvWb119Qsh4Lo5LepQNyP6oyW/b+OkcTP6j/K
         afsagusoXUq+J96lpC18o2yfOUtl2665XYqkKkFbIE4EJQRC1RtBSK/S+IE3MCujkPYa
         1FVgrYqvgcjrv57ry30YrUYtF2jOTTKaZtqcOrJUN6rKG8uEbES31WVHnIaBqOJvBVVy
         OMjxkXPFP+pvuc6DSAQBPP8F/uS3SXwLze/3UAB72Q3v7oego1OQoDU6obe+YW9aNv0E
         R/hg==
X-Gm-Message-State: AOAM531fX7Y0nt+TkYeiy1SUsDIqkHRnRfmEw5ENl3g06iKqQcfXxPiO
        vGS41uUUxTXllF+ukTLxiix/xzYHlefY2L3g
X-Google-Smtp-Source: ABdhPJwJZOKJN9JwsC4zS20Qo8YZv66wdFNkOiGNhdjIYPecsNm9w7PGbKtD5gCw+h6+eTlCcdM+7w==
X-Received: by 2002:a17:903:4042:b029:129:d6b5:ce69 with SMTP id n2-20020a1709034042b0290129d6b5ce69mr8607372pla.33.1626291604819;
        Wed, 14 Jul 2021 12:40:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p33sm3719078pfw.40.2021.07.14.12.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 12:40:04 -0700 (PDT)
Message-ID: <60ef3d94.1c69fb81.2f95a.b1d0@mx.google.com>
Date:   Wed, 14 Jul 2021 12:40:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.239-159-g430a97fa23346
Subject: stable-rc/queue/4.14 baseline: 142 runs,
 5 regressions (v4.14.239-159-g430a97fa23346)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 142 runs, 5 regressions (v4.14.239-159-g430a=
97fa23346)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
meson-gxm-q200    | arm64  | lab-baylibre  | gcc-8    | defconfig          =
| 1          =

qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-159-g430a97fa23346/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-159-g430a97fa23346
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      430a97fa23346703abf23615fcb0c00abce581bb =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
meson-gxm-q200    | arm64  | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ef12c2609016f2988a93ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g430a97fa23346/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g430a97fa23346/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef12c2609016f2988a9=
3ac
        failing since 135 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ef100ee9ca4384e78a93a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g430a97fa23346/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g430a97fa23346/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef100ee9ca4384e78a9=
3a5
        new failure (last pass: v4.14.239-159-g3434dfcb53058) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60ef0a0195675aa1668a93a5

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g430a97fa23346/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g430a97fa23346/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef0a0195675aa1668a93bd
        failing since 29 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-14T15:59:36.492190  /lava-4196887/1/../bin/lava-test-case
    2021-07-14T15:59:36.497482  [   17.542370] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef0a0195675aa1668a93d6
        failing since 29 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-14T15:59:33.047349  /lava-4196887/1/../bin/lava-test-case[   14=
.091633] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-07-14T15:59:33.047740  =

    2021-07-14T15:59:34.060605  /lava-4196887/1/../bin/lava-test-case
    2021-07-14T15:59:34.077791  [   15.110325] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-14T15:59:34.078186  /lava-4196887/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef0a0195675aa1668a93d7
        failing since 29 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
