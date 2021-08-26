Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C6F3F8DC6
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 20:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhHZSXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 14:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhHZSXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 14:23:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECA7C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 11:22:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so7188654pjw.2
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 11:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OEUtlSDMlxIYAAXY7eIBtW1ABKE6o2uC9h+fvlwieT4=;
        b=A0T/7NboQy0NQvPeVEZWio3kdZ7ZHdiVzRudmKqI+ea+YlPT3EEnkPwTjLT1HGy0Kz
         FTkVy4twgXKFaT3+FsZyVe7NOWVdvh/9xKoWI8YGv1+zOvWMANEEKLEXA4AVyWs1rL39
         iH+xoShJnbnOAP7i+AtdpKIipDTphfUzn/S9lI4g8ppwdpHyBCtH0DXZUy6+8Z+Ydxuz
         3WeqtlJCYELL+o6MCzGJ/SrAQz1fuijSs3jEAumgtLQNY+qn0Kgf5lTHWgwyOYTRQ4Ns
         tdFtEAGCynBkKRnVNhK7pZpx6FXLBVpJ0VqpOOQtYRDtAIJ+habwPhMzVwRdfPj+PjxK
         YnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OEUtlSDMlxIYAAXY7eIBtW1ABKE6o2uC9h+fvlwieT4=;
        b=kYJXI18sH93ZvvpTPixKmlBo2uu1FvvR5zi2C3mxESwwJBMj2mZJJO3WDxB282KkwL
         8vAyEnkHNKWwLFNvc1iiDdoYPKAOdgGcl/ZUAlJDM5TS/FtbMIdHWKnogn+i1NMSHlST
         VTOUi9FfvYPV4+6n6r6b7hFGUOkDZdtHHeYEnoRlXdz51Hzp8MEWYyRcgph1KOxg23B6
         1IBATseoSDWHYJvcghMkGzeTjzhUQSgOS/SGZXVES/6Jq+GVY6iQ9BxZYL4rAgkdoVQy
         YRyMZNhXvVglbkiW9gsNmwaLP9GgwiBT3+sVM25z1j1jknS0ruKvJiM/6Xg7wJe8U/DA
         QsOw==
X-Gm-Message-State: AOAM532qXtfndo3SkFWW9PKs/Z7/lgylkaJzmyL9t/CdKAdGQmSlCt1M
        z1E85R/6m8TZ6EppOfSGeHWFY+LkZi5cVgrV
X-Google-Smtp-Source: ABdhPJx5Sw/nNqQNv1Bj/EuX3wa9Ymvg7kXZf3gRjv7H91QUrRfgZp4cI1pDg1spZs+pibdipFvf2A==
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr5886415pjb.103.1630002154103;
        Thu, 26 Aug 2021 11:22:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 141sm4134591pgg.16.2021.08.26.11.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 11:22:33 -0700 (PDT)
Message-ID: <6127dbe9.1c69fb81.31a83.b810@mx.google.com>
Date:   Thu, 26 Aug 2021 11:22:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.142-60-g61b23c28325a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 186 runs,
 3 regressions (v5.4.142-60-g61b23c28325a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 186 runs, 3 regressions (v5.4.142-60-g61b23c2=
8325a)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-60-g61b23c28325a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-60-g61b23c28325a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61b23c28325a2e2dcd0ef1826b8685135bcc6e92 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6127ad046f45859b9a8e2d8f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-6=
0-g61b23c28325a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-6=
0-g61b23c28325a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6127ad046f45859b9a8e2da3
        failing since 72 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-26T15:02:12.740992  /lava-4417945/1/../bin/lava-test-case
    2021-08-26T15:02:12.758509  <8>[   15.122784] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-26T15:02:12.758964  /lava-4417945/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6127ad046f45859b9a8e2db9
        failing since 72 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-26T15:02:11.319019  /lava-4417945/1/../bin/lava-test-case
    2021-08-26T15:02:11.319353  <8>[   13.698149] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6127ad046f45859b9a8e2dba
        failing since 72 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-26T15:02:10.303937  /lava-4417945/1/../bin/lava-test-case<8>[  =
 12.678639] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-26T15:02:10.304407     =

 =20
