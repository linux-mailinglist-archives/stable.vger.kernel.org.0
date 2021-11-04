Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A595344543B
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhKDNuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhKDNuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 09:50:22 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18D9C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 06:47:43 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l3so3971282pfu.13
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 06:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7jtQ31MVjNanL/dvwurF6mhZx4dY/jc5blhowqFMUh4=;
        b=TheHqj2gfr7spO2+di8LJqBAngZbEMj033g+QTRFPanracj/HTYu4Et0aIX45CECwV
         v6VBlyBM5NWbZFcKaShGQuCfFMmCt7tGY9VObCVRnQpNPD7ZZF3aR4HAGRdWwI4l2l8U
         IEsh1E/vLRswcUp4oUwo5W8hnubdZTaA6IPeY0EQecJNnRqd/qaAcUxhmrSuoriqw4JM
         J+8RPXSKw/3eLfvcfcupXjyVFXFCjeJxlKrWQL4O82mGF6t+sgoYos5+rgkv5bx8t5zC
         5L7/mLSe6jAjK8TxD29+GgkjetNYlLms7NGny7dDwQVjcug1XbBPyhLBuelbcXQpx5R6
         CXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7jtQ31MVjNanL/dvwurF6mhZx4dY/jc5blhowqFMUh4=;
        b=bgBJiCxYRQRvsL9P2XxpPkmXrALmGpWClOH6eAZ4+5uKzAd1D1TxXYvpTadSQftdoO
         LxZ+tb5TLVX8G55Sj2tobkCrXPtrVCHMhLPFX+/mqRHGtHBAP75cfzHrLD/1U4ugklvQ
         te0rHHLQzzM2e7GXJBpsjoUqcEZI3T69hu/NYgpMHoEAj2Ly5sGH/Kq/FMSBxGO3tAxP
         35FO108oZonP5CyfnnPUl179kSIKLR8hC0LpOpmBHd+/tFZ/J+by9vnhDmGoOuAT9LcS
         9koLztqdVnFPfLdQFk/rsmJIw0ns4ybR+q9i+iKTIC+AwzoAIiACxMbwotaeciWg3p8c
         eG3w==
X-Gm-Message-State: AOAM532+n8idpRw9GZjrQxoRZlQcUZzYcymdf8fDUNIFchFPOmnNBR4K
        gNo9l1ecfJZ+D00imuiHVueCpi40076XR5ET
X-Google-Smtp-Source: ABdhPJwlbJ/KwOfrOthyeWF4IZrX19uC+B3pe0tTmwG0FIT55Mu2pA8MkYhu5zMhwQEXSpkjlOSW3Q==
X-Received: by 2002:a05:6a00:1a8d:b0:480:203b:4ccb with SMTP id e13-20020a056a001a8d00b00480203b4ccbmr40469325pfv.25.1636033663177;
        Thu, 04 Nov 2021 06:47:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm2715861pfj.82.2021.11.04.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 06:47:42 -0700 (PDT)
Message-ID: <6183e47e.1c69fb81.613dd.a11a@mx.google.com>
Date:   Thu, 04 Nov 2021 06:47:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-5-g6679047d3ab8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 129 runs,
 1 regressions (v4.14.254-5-g6679047d3ab8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 129 runs, 1 regressions (v4.14.254-5-g667904=
7d3ab8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-5-g6679047d3ab8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-5-g6679047d3ab8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6679047d3ab871bf3e78f2aaa52ee7b12b3478a5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6183b37b93e12718a13358df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-5-g6679047d3ab8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-5-g6679047d3ab8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6183b37b93e1271=
8a13358e2
        failing since 0 day (last pass: v4.14.254-2-g86b9ed2d25ed, first fa=
il: v4.14.254-2-g116ed5b2592c)
        2 lines

    2021-11-04T10:18:17.347895  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-04T10:18:17.357052  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-04T10:18:17.372006  [   19.884704] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
