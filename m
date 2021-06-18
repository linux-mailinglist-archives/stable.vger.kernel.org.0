Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0304D3AD1B9
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 20:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhFRSFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 14:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbhFRSFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 14:05:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A569C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 11:02:55 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id h12so8272610pfe.2
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 11:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3S2YoVGicU1eXN6VEeC/Th+sr/VBVKvsZWHaQ1fJXcw=;
        b=D6L5XJnpV9BuJg+2sUzeVfH5+MfzHjcJdKgvhQ3EpHI3DYB3dlWT5IYDt7POhwi2Jz
         lA2+a8QnR7nSkFATll+Abl7eKdZ+dr8BNsOWT6xRtbCQcyuSOK8uPZvGcqZdKrfVAo68
         hhMkffEULo0RYi9Yb18oND5s8seSs43FL7S17jlPKRKmY9ceyGD2zCHJNEQXeMFLFt/B
         vKfLP6MiWzj6+SE+LCS+8IurY2IXEvQX68AWOxar37wpEL1kTgKTr4XS7kT7Ow+nxmC7
         Vij0j0a7UqHPZvkjakm8f81pIqZ/9RBzvuDp0YZeWro89oBd0t1+JOKIE2vtGTqab2LS
         XjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3S2YoVGicU1eXN6VEeC/Th+sr/VBVKvsZWHaQ1fJXcw=;
        b=qV7M41o8kgOxfAgCN+BvJ7zXMWna9XlqNrR0UeAEQa6Z1Vse9bTMPt8xFKLp2QJVrI
         C9GdaNLeGKtc7claZTYlBxHKDj3mIsVeAYU5Pplo1sQZJpP46AuUTx3BVkrqB2aER/xG
         Zy4AKu9aFnVDu8CddnfBRZ1KZ0I11j8zwG/oBmYCQLoHRIR+gHEH9/L/r9NJcX8dTZ6d
         F8C9bV7RuAtBgrZGWYzsiBt1yI5J6ekyGIu7Us6qkmVgpSDiWPxfcaYz0kzFBJR0yhc9
         /KajPTn801q0d9SQr5ack7Z29iqZMFpFDR+WTakE0TAXHGOGvDxyJxCrCE6ePs1ThDk1
         qMWQ==
X-Gm-Message-State: AOAM5326DoW2iYj2f4c31M1V24UbusTMwCHWOcnZEfwpkmKRrC6MBOz2
        C4iMk+DZriqTnTKJTMfaTBGzTwXBtVTbOfR8
X-Google-Smtp-Source: ABdhPJwffxZomXwli35lURlWtw4Ol70rAae7FHqBO6GR9ho4DNANzmQUwb8mUNzT+OmrEMlcM6TLlQ==
X-Received: by 2002:a63:5a4b:: with SMTP id k11mr11134344pgm.289.1624039374319;
        Fri, 18 Jun 2021 11:02:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x16sm2462086pfq.74.2021.06.18.11.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:02:54 -0700 (PDT)
Message-ID: <60ccdfce.1c69fb81.3e40a.5b91@mx.google.com>
Date:   Fri, 18 Jun 2021 11:02:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.12-10-g737fbf6fd342
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 115 runs,
 3 regressions (v5.12.12-10-g737fbf6fd342)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 115 runs, 3 regressions (v5.12.12-10-g737fbf=
6fd342)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.12-10-g737fbf6fd342/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.12-10-g737fbf6fd342
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      737fbf6fd3421c69cdcb1598b4cf703a54723fbb =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60ccb3e7ca537ee7394132a0

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
10-g737fbf6fd342/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
10-g737fbf6fd342/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ccb3e7ca537ee7394132bd
        failing since 3 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-18T14:55:28.267501  /lava-4052042/1/../bin/lava-test-case<8>[  =
 16.338130] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-18T14:55:28.267849     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ccb3e7ca537ee7394132be
        failing since 3 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-18T14:55:29.281839  /lava-4052042/1/../bin/lava-test-case
    2021-06-18T14:55:29.298792  <8>[   17.357344] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-18T14:55:29.299160  /lava-4052042/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ccb3e7ca537ee7394132d6
        failing since 3 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-18T14:55:30.713252  /lava-4052042/1/../bin/lava-test-case<8>[  =
 18.783596] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-18T14:55:30.713880     =

 =20
