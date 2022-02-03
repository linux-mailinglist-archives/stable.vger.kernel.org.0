Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4194C4A86C3
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbiBCOlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351343AbiBCOkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:40:53 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015FCC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 06:40:53 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 132so2442870pga.5
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 06:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XciTsAAMZCXitDfKj1ruqsmopEE4VtzzXozFtgmmHso=;
        b=0g5qmig6dfQznKHDTFRIKCwi0RF4E1zw4i21d2EfXJ3WKA0VVWQC8XW2N6Snletz+F
         VeCRd/IB3HynaQQT+IETwGlpBuSdoz786f/sZJLzvMiJcOIzmvTYa0AVQZd+PRwUNeT6
         nmxkfsCh7i5v2tuirR1mD/vUhnvqgcwuiY0IdWdFQ2NPmCmkvqqtjYPJsysDq68JUJhs
         1f5NnCKNjQlZXwUsZGKkW1TzZhaUErl3zDwH/oTDboHzNfk3xHTlbS/nywY/wDQlSiNt
         JXmM+PrJ4Urk7aGPa977mabLDXxHb/Vlk/wcssjvQSzG4/oixpWZyzp69ugeXf/BAYA9
         qp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XciTsAAMZCXitDfKj1ruqsmopEE4VtzzXozFtgmmHso=;
        b=mUOdzyT+Un/Tn+RnR8CIqm4NqdKFmvg3L1FMgbEO4BZNt1VUwYp2GdmSNFnX8wVNN/
         xXDVXvC54tcRcjDc5P2b1wxkLqUj32O0ENvIvMP2LxVZgfSwJUB50mNqhIkGy/wmhXfM
         TfThZgukXkmaB2y3A2IIBCjE7phW8h5IKJe+ytf3J0rWewV3XuUEjGwoRY5XIHLdRuhi
         cwLF1J51s0t1jZ3LLfBWD6MQFXhuCRestEoU5Vcv6Lsx2myaNaDlXrJVNzjQzVrd2qKw
         GEpBIH+BCb22gt4P1pl7B1cozkbcJnktLRkrwPEmufxmzUZ8Haj8xAOVfhOSvX0DnnFB
         1Exw==
X-Gm-Message-State: AOAM533BMleKN3ZuyP2BGRijxPXAttVvX64ZC8HVFQsRAMo0uWyd1QZO
        3Zm3btY5JjNtpzaNN3dgG4A6jH+1hH7n1dsR
X-Google-Smtp-Source: ABdhPJx3KPCVLp34jZvc1DUoeifhuC4Wy0PNLHiNro7oXfeY/xsxnKJ1Ehgmo0yPwdQK9nDZIJqX/A==
X-Received: by 2002:a63:154e:: with SMTP id 14mr27867598pgv.27.1643899252364;
        Thu, 03 Feb 2022 06:40:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu15sm11532959pjb.5.2022.02.03.06.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 06:40:52 -0800 (PST)
Message-ID: <61fbe974.1c69fb81.38927.c55c@mx.google.com>
Date:   Thu, 03 Feb 2022 06:40:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 153 runs, 1 regressions (v4.14.264)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 153 runs, 1 regressions (v4.14.264)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.264/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.264
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b86ee2b7ae42b6b37a918b66236608e2cc325f59 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f546512d40e78244abbd2e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f546512d40e78=
244abbd34
        failing since 15 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-02-03T10:16:06.746905  [   19.899017] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T10:16:06.789117  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-02-03T10:16:06.798688  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-03T10:16:06.814693  [   19.968353] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
