Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6A33ED539
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbhHPNKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbhHPNHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 09:07:41 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9C7C061149
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 06:05:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f3so20638540plg.3
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 06:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AiAJ6WRp55PNyNj8qFjBWrhBXFQKjSZm9BV1ZfO3SU8=;
        b=XtZXQcGOc0hVetM184lTb2EI2/uaAo6AhzY8RwqaIyQqnVeS274y+woHgJBMtQB8sK
         dryd7zOZJgs5gG8055tbIJFLGOixUr3K/KGYhfiJ50CjdbOFPeGYZPL3MtTClYfSjcO6
         Vs5gMdYiQ0gD36URbzI7a61NB2q2t5KVC1eOgkjj4mtEJGHkwdl759IFmocCZdKr83Qg
         xH5QjW6uPGtjChcBMitz69VdXbN/4vYff7k04m05oYTVOOgJiicBJS1jvNpbrOqrA+di
         6R7lIioAy4YuY1VGo0wfLsf0Dlsyy9Ds2Mm3QBK7eGkhW4lqzEs8Iiko883rVIrCB5jY
         yhGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AiAJ6WRp55PNyNj8qFjBWrhBXFQKjSZm9BV1ZfO3SU8=;
        b=QBbJp8oM7C/pYaWmlZppYnPPu9f364SSVZaco3J+5zxbqxjW3lKOh7/kuDFn7LjTv1
         Zyqy3Hz4LcHHJsoDDUxsSJxEJaj/11B0qt5Z6XRbstUnvHHITtC+gEVcTWzFGyPA3gEj
         IHb0oYdDEXWbDvcCodjMpX/aSY9o7pGLDdl2gQxh+sXEqGlxl+MJ4Jwa9t7yGGuTNXDr
         CRrfxWxb+TBrpGBOupXyIrNq8PvwEbKW/75VU2B1TXZyV/oD/ZyJV/9KjnZReRUOUArQ
         k8TZBz8l9WCiXhvBmvXeabrghd5BI2MjeIlU0whva173OnAztS2x+e5Boe9p/Mshem6V
         x/8g==
X-Gm-Message-State: AOAM533aw9dJ1Zo1AGFAoETLAqXdKFtmbqRy9LCwvU+Ql9M2QlkuVmi7
        ixbWlBZiWKHPvaAm2iAFYslCz6TfisCX+0eI
X-Google-Smtp-Source: ABdhPJzR7q1ldKp4rsn/iNKEeTFEQy8+fMuoyQ3ZFqRAoLyC7pDiiLuyxS/HbkefvQUVmv3XsQbStA==
X-Received: by 2002:a17:90a:17a3:: with SMTP id q32mr17245406pja.195.1629119118799;
        Mon, 16 Aug 2021 06:05:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm13708163pgj.75.2021.08.16.06.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 06:05:18 -0700 (PDT)
Message-ID: <611a628e.1c69fb81.85715.3f91@mx.google.com>
Date:   Mon, 16 Aug 2021 06:05:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.141-61-g6fb21a963637
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 179 runs,
 3 regressions (v5.4.141-61-g6fb21a963637)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 179 runs, 3 regressions (v5.4.141-61-g6fb21a9=
63637)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.141-61-g6fb21a963637/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.141-61-g6fb21a963637
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fb21a9636372d670f802aba78ca89b0572d4b3d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611a32638bb25b331eb13662

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.141-6=
1-g6fb21a963637/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.141-6=
1-g6fb21a963637/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611a32638bb25b331eb1367a
        failing since 62 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-16T09:39:41.396194  /lava-4369618/1/../bin/lava-test-case
    2021-08-16T09:39:41.413628  <8>[   14.841752] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-16T09:39:41.413855  /lava-4369618/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611a32638bb25b331eb13692
        failing since 62 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-16T09:39:39.989607  /lava-4369618/1/../bin/lava-test-case<8>[  =
 13.417133] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-16T09:39:39.990082  =

    2021-08-16T09:39:39.993362  /lava-4369618/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611a32638bb25b331eb13693
        failing since 62 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-16T09:39:38.952559  /lava-4369618/1/../bin/lava-test-case
    2021-08-16T09:39:38.958257  <8>[   12.397528] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
