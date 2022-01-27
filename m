Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F2049EE38
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 23:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbiA0Wmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 17:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244835AbiA0Wms (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 17:42:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F40FC061749
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 14:42:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 133so3667554pgb.0
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 14:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7QmFPj1fvlOTGvI/79Sjr1M8Bl2InplpM3Uk/lCLHg8=;
        b=3vDPaq2Sl9r9lUYez1LbChsUTC5npDxxd/9rpD61APJAnPYilr4qUO2O1552mnVH7k
         9oLSFqgE2SoVlg7lo/qhT4Z31GeTPPjm3qnRB9qWoCntqBrqy/5D8ws79ChYFjgwydbF
         lbuFOsCZML5cR1uRDqNBq4H9MWZrPOVOeQn4Ey8Sr/oHX0I/hWu4VSlP/XwbCaEn5HFN
         LuKRjv3asNTtIpvnjRiccglc/EzwQDREqV3qBbiKlqL7xY0CXMuUaH7gHVrAB/R05e6Z
         S6VAx0EuSKC2OU3x+bn8mQx53JzsgCHnj/VllYifbceLVjKCaJZ9Iiaodf1wiuULNWJL
         KRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7QmFPj1fvlOTGvI/79Sjr1M8Bl2InplpM3Uk/lCLHg8=;
        b=AO122N6EGn8TYXGhPb3ULssCFNvOMXxQab68fqwYGgyonYBCvCpe7GqTOR0QsnuFSl
         FgVPcFMGQ0BU8RzI84odFYqZNcDYayHi5CDHCQya4ASEC95Pjx0xzNNXvlBxszmr8ieU
         CvzsEuUZy/RcsPl5yvxXw3m8MyJcrwFJ2syeQehTnviAhNTV7eokrR2Z/OL/BIe6nz1o
         UL1NWrVkF4oWr40pP9PplTNKEGPHuGvtMOt61aPM4+nTZljkIShpvX+fqYcNsbVSeCpk
         rUOOj5rjD23s/IlLK95WMnhdd+chkZQFB7YeY4ImtbmzmC9YmnyXzk8IgfORgc6nnzWY
         oyyw==
X-Gm-Message-State: AOAM531OZbRcptf5r6en61fBOQOzH3ALicHLOMbIuMPyonIrGKi497OS
        GqBbQ7UY1ytXFP5BT5P8/E3VOWrcLG5rHAvLXtM=
X-Google-Smtp-Source: ABdhPJz9A7oRUS+H2d/76eRbrU656Em4kdf44GwyWXprqXi17qNZ3Ka8r1Bp9d3oQFS20XL/cDKXKg==
X-Received: by 2002:a62:30c5:: with SMTP id w188mr5227383pfw.45.1643323367720;
        Thu, 27 Jan 2022 14:42:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm6582643pfc.123.2022.01.27.14.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 14:42:47 -0800 (PST)
Message-ID: <61f31fe7.1c69fb81.11d7b.297b@mx.google.com>
Date:   Thu, 27 Jan 2022 14:42:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.263-3-ga816c082cb80
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 119 runs,
 1 regressions (v4.14.263-3-ga816c082cb80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 119 runs, 1 regressions (v4.14.263-3-ga816=
c082cb80)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.263-3-ga816c082cb80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.263-3-ga816c082cb80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a816c082cb802807f6548940bb78b806ad74ca90 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f2e54e9c0adb3a25abbd2b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
63-3-ga816c082cb80/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
63-3-ga816c082cb80/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f2e54e9c0adb3=
a25abbd31
        failing since 13 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-01-27T18:32:26.586761  [   20.124999] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T18:32:26.629968  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-01-27T18:32:26.639087  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-27T18:32:26.654397  [   20.192687] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
