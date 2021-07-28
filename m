Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454CD3D9705
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 22:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhG1UrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 16:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhG1UrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 16:47:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093C6C0613C1
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 13:47:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k1so4180813plt.12
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 13:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=34VQ4hWNB96neBlbEIZ/4zDUJcqb+I73fcAqN3SIWm4=;
        b=JorLHSUryXFNcjU5p4agktd0ttf/6qBidJ2wlQsYMquxpFKrNhSKu214DhG8l7Cxqc
         ArVa6Ng/ono0nSPBXaMWa5HwtDvtiahdaTaGIOA05qGDiRLr+bInar1mPCnh3b/XveWM
         EVYEMEb6Yhv6T0JHQWwnsqfRyMGF2qz66WwCjb0FIhOXBx97duJkvmPvhJTGgXxa5aj+
         C3brBV4bPzlqet9Pwju3LoyaElQkUKVAUIPNXNFk3ZcTYLrOZ9uYP4hVUVzi45JMMHus
         gDucwgHb90/Z3zbf2UKmnQPek4KrC5R6a0juOBBwD6vEscKtP+uav1alGV85D1mVEN12
         OpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=34VQ4hWNB96neBlbEIZ/4zDUJcqb+I73fcAqN3SIWm4=;
        b=bkylbPsVZCX9IVGrawVOUyb3Zz1hgCdyvvUujNLpvxolA56C5sxV4h39DzhN6aoJ6p
         aY5P9k/01Fb5GyhSMve2l+cuB/TRUN2bbywBQGhVqZmEDtHk0jejRD2LjF4DpJnT2SVT
         dWmKq1WfMWxEsD+s6XlYrN0mibuN0zffev4Bv60uVYG6+K1jiaGqSHd3B0fNyebgZofv
         SqqiD4njuN4RZ8XLBPpwsRDxmfWKn3UG8ki++wlgAHPe2l2ZDZWjbu8+cyicFt0Kfg/e
         p9BppSJV3s3dNycGNiEbhWE1DB7Rlb3/B7IVqO6/23z8ykT0sTMCGdBpECXdfv+9EC3Y
         M2/Q==
X-Gm-Message-State: AOAM530MWM801PBmRnGv5+fdJviL/Y9ShEP0ZdQfnWJtZHqVetbAXSjm
        BxxXFpLnaJJb8ihmDW98Wt/q3qyBwIO4RFu3
X-Google-Smtp-Source: ABdhPJx8mi6dV1fdLP5yR77mzFeT/Iq1GQg3tyzpXJbr80ct/KrTwb22ZrS2djVhVrBUyaJDekPA3Q==
X-Received: by 2002:a62:154e:0:b029:32b:743f:dccb with SMTP id 75-20020a62154e0000b029032b743fdccbmr1403275pfv.57.1627505228393;
        Wed, 28 Jul 2021 13:47:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gm7sm635942pjb.28.2021.07.28.13.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 13:47:08 -0700 (PDT)
Message-ID: <6101c24c.1c69fb81.88796.2ab9@mx.google.com>
Date:   Wed, 28 Jul 2021 13:47:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.6
Subject: stable-rc/linux-5.13.y baseline: 103 runs, 2 regressions (v5.13.6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 103 runs, 2 regressions (v5.13.6)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fdb13a7e573640853c481ddabf7a192fff42bba =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61018c39bda1b192105018c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018c39bda1b19210501=
8c6
        failing since 7 days (last pass: v5.13.3-350-g6c45a6a40ddee, first =
fail: v5.13.3-349-g1d9dba03aebe5) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61018a6da1a18d40415018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.6=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018a6da1a18d4041501=
8c2
        failing since 13 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =20
