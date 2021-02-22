Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732A9321D4A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 17:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhBVQm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 11:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhBVQm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 11:42:28 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E1EC061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:41:48 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u11so8058907plg.13
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tGqMkwIafMWkJajaxTl51UBOxjDj+ryoBMvenlph9aM=;
        b=fazBwr8UMPNwnMyG63wGVhsWyctq51bvSEPgCaT4VNb2FTvdZASobT0K4C67leL2Ux
         BOYm4fdpm7irOrBHXBidXd6kRIBn0HVtgqorv+RoMyY2e8ePEYLS9BG+b5GD8AAiVWzg
         so2X2oH1EMGoyjH8RAVvI7us6smWyH/p5G9IDSmLdC430S1apPGSAD6rKuWArt+GwBs9
         IpLbDUgm4dlyJauLAfJqVRIdkRjX86kEneTbH+V3G01n5m2NiRE3GVWRBu0HRT1JpV0B
         vWJsVanz9vIxpm/QPMyxV8BhZl931pzUpP7PxFb1LJznirCaE6dPgcQvs+gJmBtXJZNm
         eZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tGqMkwIafMWkJajaxTl51UBOxjDj+ryoBMvenlph9aM=;
        b=sh8x3uAXAVwpXJSsq6od8YDMP+ZkRsMCGfZmTIFyT4/dV8XvTa0XYfZkhm6mYh5Kth
         /lYjCBA8rLETl6l9Tv9NWQqy2lQAEO1OZAPTpd/EV3tG9kwzZr9GnfCYOiFh2gf3W8IJ
         94rETkl8Ydi82PcePrgOCGav1YiKAAchPJ1clsLvxOAKrbdJzqLOgdKz8QK9pjnAchJb
         XX88mE+W5feik761GAKcmwpo9J+RiM3ZSuNgQU6mCQaur2+/bet1707AmsB1kfdFAiJS
         MDvKCmBquT84wGOa3CNaGsKMiP1buMoLUKRPXFeARx5zaToj4GKphe/aAF0DpBMhgCRa
         iHSg==
X-Gm-Message-State: AOAM530puLcQ18PoBHP1ylhl9/QsOdWErDlT/U2q4NCIy39VmlDByZ8W
        Po0JX1Geos6yn0A+9Ee/W5xXrdI1FdkaEw==
X-Google-Smtp-Source: ABdhPJwi2RhmYqYZbZu7TS8mRYodgkmTTf8nj64obg2YwS9tZoH45LOzu6KOHlHIVpb9rSZqM9P+mQ==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr23720850pjb.62.1614012107493;
        Mon, 22 Feb 2021 08:41:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c22sm18988602pfo.136.2021.02.22.08.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 08:41:46 -0800 (PST)
Message-ID: <6033deca.1c69fb81.32c00.94b3@mx.google.com>
Date:   Mon, 22 Feb 2021 08:41:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99-13-g62563d4af72dc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 107 runs,
 2 regressions (v5.4.99-13-g62563d4af72dc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 107 runs, 2 regressions (v5.4.99-13-g62563d4a=
f72dc)

Regressions Summary
-------------------

platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
hifive-unleashed-a00      | riscv | lab-baylibre | gcc-8    | defconfig    =
   | 1          =

sun8i-h3-bananapi-m2-plus | arm   | lab-baylibre | gcc-8    | sunxi_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.99-13-g62563d4af72dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.99-13-g62563d4af72dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62563d4af72dc193f261ba08223d91cff160edb4 =



Test Regressions
---------------- =



platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
hifive-unleashed-a00      | riscv | lab-baylibre | gcc-8    | defconfig    =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6033a4eea54f5d4147addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-13=
-g62563d4af72dc/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-13=
-g62563d4af72dc/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033a4eea54f5d4147add=
cd1
        failing since 94 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
sun8i-h3-bananapi-m2-plus | arm   | lab-baylibre | gcc-8    | sunxi_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033a4b2fb19492b32addce5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-13=
-g62563d4af72dc/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-ba=
nanapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-13=
-g62563d4af72dc/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-ba=
nanapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6033a4b2fb19492=
b32addce9
        new failure (last pass: v5.4.99-3-g59acbf2e564d)
        1 lines

    2021-02-22 12:33:14.454000+00:00  <8>[    8.085815] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
