Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4703C44736E
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 16:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhKGPOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 10:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbhKGPOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 10:14:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31F0C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 07:11:39 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c126so5182575pfb.0
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 07:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4Erq4hYkepIYM0bGqksLXCGPg34EvpMxXjv5IRSBsm8=;
        b=gMK3sy/srASXbg9VThZQ3YvqIBTmOimepI631RNOUnOuA7HiTySr52V9wHAoI/bFis
         he7DoMEvlCgAOfUvTR+a6ZzIiZRgw1DPdLS/Zc6/59qwPRPrUvA90EjFXrvYaeO0bw2r
         nmz4x55r5pIHhu71Nodxs9xk9Q98uWOypX0kx3vin3xR/GrX2rgCVifcW+mrct+F+7v3
         d/EVzR5c4Ptl+kW8tzexOaJKOmotpcGRvlpcNJva8FfZb58qT30cxrkgr4HcMbdtsbXy
         TBdYZ39Z/M/056LxTHQh66FWM5dZ24K7j3mWfkiFvZcKPPpoPhGvK6vC1vlVttwEGs0g
         Y25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4Erq4hYkepIYM0bGqksLXCGPg34EvpMxXjv5IRSBsm8=;
        b=mQoS6Sibpqv3n/NTG+VnBAFXQEiwuWQnxrbg6hgGDUtyORFwRQOeQrt63ruCBAlZYF
         QHais2k3FzxoUhvHgZDlCgTHObSCeFtzL3z2VEmHK/R+lFULs1ep9si9Oe8UEl3hEXbh
         FmZVTqYKrChDUadJ1tQt2pVeaWNExOaN3jq6/iTijxNiZYBASZA4Za9tZKCdb/xW8Sxd
         rIXeGdAWlF00sRl3PMzClr10XVsM0T4E7V20wtJgVZfX7k57azcslOwalDCui1buBxKl
         lRixiwVjXSn/b9Rj/Pln4dU/sFTIMcnIDDaLOQuEvDzcEEc7nT3SekzLjwkSdkeq0gzS
         pNEw==
X-Gm-Message-State: AOAM532kYOtst1u4zmLw1qz2/jX/nBJeA2HdHUqYzLg1IVVYUX4U2Wea
        pC0DseAQzKZrmKgPqCAnbGXPlc5hlczsy6OB
X-Google-Smtp-Source: ABdhPJzyCs+8fu8+ZuUN5DUiGLZKlYXhdr9NqCeJKDtRLz+l7ckPmYqnD/dhQ30mJtSD4E2zjkZWow==
X-Received: by 2002:a05:6a00:88e:b0:44c:c40:9279 with SMTP id q14-20020a056a00088e00b0044c0c409279mr74851438pfj.85.1636297899071;
        Sun, 07 Nov 2021 07:11:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm13354323pfv.110.2021.11.07.07.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 07:11:38 -0800 (PST)
Message-ID: <6187ecaa.1c69fb81.efaea.7b7a@mx.google.com>
Date:   Sun, 07 Nov 2021 07:11:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 140 runs, 1 regressions (v4.9.289)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 140 runs, 1 regressions (v4.9.289)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.289/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.289
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59d4178b517472a1f023886baded2191458a76b5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6181aadc8ccae40df7335916

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.289=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.289=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6181aadc8ccae40=
df7335919
        failing since 2 days (last pass: v4.9.289, first fail: v4.9.289-5-g=
c1043f1153b5)
        2 lines

    2021-11-07T11:01:48.020405  [   20.235260] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-07T11:01:48.069620  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-07T11:01:48.079042  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
