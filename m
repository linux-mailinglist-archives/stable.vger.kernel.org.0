Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E859B3A9B4F
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhFPNBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 09:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhFPNBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 09:01:02 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D236CC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 05:58:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v12so1065022plo.10
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 05:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LsWgGR8IDubgRdjm0GKcXWWScmHd4hUgLe5LPtvV8zY=;
        b=q2CfL8wXekGQcJ6oio5DLdIr1nrH+JTCcR5w4N31YJPlok3KEFJKHHUDe1HEG9sC0P
         CmWIuWQwo/phnnp35Z18fi2XYED4oir3nK9vJ8sBgmXI+0o/GSX+vEXgaqp5pupG2hXe
         SOdihHcLQXch2R37kjpHuujwa8jM3digpQMoM7ht0go/TXV7mqIEi6kQlXe0UZ1qzPH/
         MGO3w+acRJxd8F848Sytt9pxctoox8ilhPT450ejs8ddLmj/MrhFTAD/qAVHYNqP3M/z
         uFK/B/EM4n/2Uz8zuJ0z0X4gOhhwtD1i9lODIIPonyGqGr2V4HywvSZyrQ9kyL6mN08Q
         jznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LsWgGR8IDubgRdjm0GKcXWWScmHd4hUgLe5LPtvV8zY=;
        b=HUmRF3L5kRY1T3TuU/PLoHlk5flv1s1rLGeB+gqNhH/Mb1CdUuXcAxpLWC7s/f66qJ
         uvaXVesZ70Fv40KaD4yHJM1nWyjmdgthSv8EqVbIf53MtnfNodmGmmi0BmRKzLVJsoT8
         DAuPu4W6qdRf88oP1L0sarkgesjJJtk8O950Z3Bm+KvOpcdIkzdS8mNs8NeJOv2VLvIA
         y2CxePcoF8m3N+C8lCe0NSLZfrW1S+VuyTAQCanXLuOCM7ssCxhV6hzmRFoI5bmald29
         WZ+gQbZHqO8LaI23yAZsr8Svw/vuWAMyJYzZB6JvScU8K18Qr2MobSqvx+EXbD+8Cfvj
         xthQ==
X-Gm-Message-State: AOAM533nSPE6sumBxkcb0GUxJ0TC+Hi8M4g7mWWQoN+KZlWv85dXwGmw
        xCAlQtlKTz0vkCLyoBXfmeAMyhz9JfGe3gz2
X-Google-Smtp-Source: ABdhPJx98vUDxz6K0vMKVwRypOkosyN5x0uTI/TN+jaxipYsU1grb2q99kmMGIupqBMhjDKkVaPV7Q==
X-Received: by 2002:a17:90b:3709:: with SMTP id mg9mr4860102pjb.47.1623848336282;
        Wed, 16 Jun 2021 05:58:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s37sm2342169pfg.90.2021.06.16.05.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 05:58:56 -0700 (PDT)
Message-ID: <60c9f590.1c69fb81.e5126.6442@mx.google.com>
Date:   Wed, 16 Jun 2021 05:58:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.236-50-gbe2d6b3abd46
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 4 regressions (v4.14.236-50-gbe2d6b3abd46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 4 regressions (v4.14.236-50-gbe2d6=
b3abd46)

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
nel/v4.14.236-50-gbe2d6b3abd46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.236-50-gbe2d6b3abd46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be2d6b3abd46eda39555064af17b4eab85bf66f2 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60c9c79bc6c3fcd5de413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-50-gbe2d6b3abd46/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-50-gbe2d6b3abd46/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9c79bc6c3fcd5de413=
275
        failing since 107 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60c9ec70666276703f41327b

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-50-gbe2d6b3abd46/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-50-gbe2d6b3abd46/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60c9ec70666276703f413297
        failing since 1 day (last pass: v4.14.236-20-gdb14655bb4bf, first f=
ail: v4.14.236-49-gfd4c319f2583)

    2021-06-16T12:19:52.683770  /lava-4034794/1/../bin/lava-test-case
    2021-06-16T12:19:52.689093  [   13.035153] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60c9ec70666276703f413298
        failing since 1 day (last pass: v4.14.236-20-gdb14655bb4bf, first f=
ail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60c9ec70666276703f4132b1
        failing since 1 day (last pass: v4.14.236-20-gdb14655bb4bf, first f=
ail: v4.14.236-49-gfd4c319f2583)

    2021-06-16T12:19:56.134771  /lava-4034794/1/../bin/lava-test-case
    2021-06-16T12:19:56.135241  [   16.484306] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
