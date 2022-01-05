Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F418485B94
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 23:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244886AbiAEWZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 17:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244883AbiAEWZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 17:25:27 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFF7C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 14:25:27 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id v13so604479pfi.3
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 14:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VXkoa7hTMfbg7v1QbUJaHhh+dpaJG8FJ1/oPHy9vMYY=;
        b=JmxG0yKH2eXJLzYZBXjVRXE2U1d57SiebIZZcgg3edCdPBLjSY+wNa+kfrFY3hBsnJ
         PB7XnlAtljUZGjoSMojbmt3a3crq6cjJKfeE/DZJk70E3Ogph8LnP9iPRhKZSPikUU5c
         dQGtYZegiNJ9XEWh9qahhOLx7LXU5VCPBmrUE9sFu3TLeicDqR+bv9vSaA59AJ+OEWoM
         lsaYqNsiTupAEFBafHuB3XbWqmC1cHk4yz1hPV5SEfj6mvzCX3EE4qpm5pPeducQPmm3
         Us0uLsQQzvRD/ezynoJ2Y9S/ElsLpMImcm7plvaDgJWG/70QYtm10hslXnBxvZ08i4CC
         zpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VXkoa7hTMfbg7v1QbUJaHhh+dpaJG8FJ1/oPHy9vMYY=;
        b=RxXkWDJlJ16pe/RrJTH0YDNHM/IrSn3IhUjmY5D0rc0Gu11NeMRGQvGAMAo7jlw4b6
         eVT8A2Srt8VKcCJO8kDjsP/V0nfO9vmd8fKl/UGgWC5ZZzF8fu5r1f4xRymkEx7YcYPL
         mVSrX6y/oCt1QhrpVuo8gC2FjBYovOjMlCTj88o0ZMnR+yMO5MHG+f8F0RsYJl9i7JJs
         GbUCmMHuci21ntDj5OKlEjsOoVWVofxqJdTHbyFOBwa1bA5nonhQ4kTEbfLB8CBs0FMe
         2ia4eKbO0B3MDPclzMPed5su9Kz+8g6kaMdUODOf740xCtq5TsEsfaalf1fxj3GN08Gn
         32HQ==
X-Gm-Message-State: AOAM533lKLGrRedIDz9reGpmP2s0icAOqUBQJ2Hzut/mBTWzS6y9XEQg
        kf0wM39tuTKE8tyhI14hJ4OQDTTuBOat5nG5
X-Google-Smtp-Source: ABdhPJz+PGVbBZc8CM+yBgQfkrEH8XWJCalaW2vF/bgKve0RzWtkg4+vyc3kMTn1yewxE41Gp8c2BQ==
X-Received: by 2002:a62:1b0d:0:b0:4bc:16cf:dd69 with SMTP id b13-20020a621b0d000000b004bc16cfdd69mr39825562pfb.60.1641421526991;
        Wed, 05 Jan 2022 14:25:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm31293pjk.38.2022.01.05.14.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 14:25:26 -0800 (PST)
Message-ID: <61d61ad6.1c69fb81.28717.0254@mx.google.com>
Date:   Wed, 05 Jan 2022 14:25:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.261
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 142 runs, 1 regressions (v4.14.261)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 142 runs, 1 regressions (v4.14.261)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.261/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.261
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bfdef05c8da46b022172695aa493cff7ac667a4b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d5e9a9e7b96d28c5ef6748

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.261/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.261/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5e9a9e7b96d2=
8c5ef674b
        failing since 22 days (last pass: v4.14.257, first fail: v4.14.258)
        2 lines

    2022-01-05T18:55:15.647031  [   20.017395] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-05T18:55:15.690300  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-05T18:55:15.699395  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
