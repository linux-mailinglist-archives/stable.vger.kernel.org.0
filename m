Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9343E402EFC
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 21:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhIGTdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 15:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhIGTdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 15:33:40 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B72DC061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 12:32:34 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q22so15073pfu.0
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 12:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3lPN7wGl/ajSOEmivr9kv6zaWDeQ4//mtDgl3i+1HH0=;
        b=Zq061Njnl++4V3SXcHya1t0wIFz3ZSBHWtBFn+vo6x1Zg1f1SGY+CGCJzRlHFZtGc6
         SdJ8tieQ5rQVmillvMRHNaZX+rjpVEqoX3dssTTplkX7GyXu4FkWrVSSqdqLHEYfPICK
         609UGlT2SaRcPc2bNlOHsqy3bkCzgYsxMTmGKiaj44ngzup8/rhb7ai6bD6DWZZ4upM6
         Aqkeu/3HjSt/NB7ZTM6mckZCVqekDER0z6eQYk9Y49NzeMcSmiaTh5SnkvS9/D9+T3Nl
         PAGg8ebHjIRcQjAbd5deywlaIbGAsf1SWAMTpc7oeTyh5fSZ/aGCdc6DOnkNBEYmkdCl
         Us+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3lPN7wGl/ajSOEmivr9kv6zaWDeQ4//mtDgl3i+1HH0=;
        b=grgSq7uDGd+Nh9dOT0ZsCo+C7fv5eFR1UCP1FjWKPMXfIhiIDodiBUUcnHD0RjpRWc
         drbPvbEnQcAVBpJZJX4RN7EFhnSZczFjL3YrxSDzL7L0plio6tYSr42kXZ537t5RVWD4
         0Zi3BpfGqkkGa8ZnfBJb5z7VVUdwLDcwHDWKwc6JTVQhl58u40hzzJXA9QNtJazeQze+
         2Aftaev940cDse5lYLop04HQIuMmHAmIzP3H+aC1w5klq2ssU64BLPJ+kYE7F70Be3rX
         JnxUaCu9K8AwynejvK4l3LpX3U2MMTuFdTqqVqISfW5g7zmO2tqo2BBfCyq6/skU9pIj
         WMOw==
X-Gm-Message-State: AOAM533cP1naOHHDNn9m/miMs9C6BUVcFYi73nouYLuwqo21QR5kOOxQ
        A3Ql92JLQ8CPQlb8YxGTobi2EhFTd8uUpkJT
X-Google-Smtp-Source: ABdhPJw1YeElJWV/4161HeBSkz2A3VrlozNrF77Ge0IbTxvLOcluedhOaGf0YjmqxlC9ntsmNSx7yw==
X-Received: by 2002:a63:841:: with SMTP id 62mr18444941pgi.354.1631043153525;
        Tue, 07 Sep 2021 12:32:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q29sm14635673pgc.91.2021.09.07.12.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 12:32:33 -0700 (PDT)
Message-ID: <6137be51.1c69fb81.3224d.8b9e@mx.google.com>
Date:   Tue, 07 Sep 2021 12:32:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-12-g4a6168861a83
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 187 runs,
 3 regressions (v4.14.246-12-g4a6168861a83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 187 runs, 3 regressions (v4.14.246-12-g4a616=
8861a83)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-12-g4a6168861a83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-12-g4a6168861a83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a6168861a83d8358a3b3c30509e417741959d68 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6137902d12a5029128d59665

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g4a6168861a83/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g4a6168861a83/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6137902d12a5029128d59679
        failing since 84 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-07T16:15:22.040326  /lava-4467851/1/../bin/lava-test-case
    2021-09-07T16:15:22.057496  [   16.380250] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-07T16:15:22.057909  /lava-4467851/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6137902d12a5029128d59692
        failing since 84 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-07T16:15:19.608492  /lava-4467851/1/../bin/lava-test-case
    2021-09-07T16:15:19.625465  [   13.948219] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-07T16:15:19.625986  /lava-4467851/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6137902d12a5029128d59693
        failing since 84 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-07T16:15:18.589383  /lava-4467851/1/../bin/lava-test-case
    2021-09-07T16:15:18.594954  [   12.929324] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
