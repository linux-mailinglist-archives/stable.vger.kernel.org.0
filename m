Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69F03732DE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 01:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhEDXjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 19:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhEDXjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 19:39:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB5C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 16:38:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id e15so607362pfv.10
        for <stable@vger.kernel.org>; Tue, 04 May 2021 16:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ihf3D/Hh9PWOM6TZyyGo74yt2rFJXsaUiBlBrmwVi48=;
        b=zyKrYQ7jEXAqSaWXG9moFojh6vu42+WNW4V91abXQEsP276toft6dBblJX03SFmK1G
         0KEi1xToDKkVR6oBvBiFDMuhyW6jwgMsHiHmh7HEWkUIEkl3B6u5RZj2TqoVWX2l4gBe
         pBu4G1rw9omU7XhGxMe+oR82Zr9tLXLzWwaTXLlieSTlwc/zbkVvCWg+IA5ZqDap429l
         KvVB8g1iurfGDIS3dnG743f2YOFe/DMlNxmX/uquQODLTYJ3LsvGo37dxiAWBkCzCUnH
         EzmmP3KSJdr3sAmOLWnv8XQHxbdni3RdXHwf/CcTLKy/5Pi+j28Un+yvIQjENoAExdAL
         DWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ihf3D/Hh9PWOM6TZyyGo74yt2rFJXsaUiBlBrmwVi48=;
        b=GxuyWkfuQFCOq2Tv/W0m6u3489bdjcG98UnLHeTP2mCOCV8rJEZA9845EqXApQjcFe
         1jPZmahprPKRnY+5kSRJkVjTB3vQ2m46RxemXxVIKA5Z2+OTvlN5pLcKj6G2Pr46PFVV
         owUaGSJToy1/AVd4yFZEipUVJA13Jut0GLS6Y7C1ep2UvRb8htn5cpcCM2FfthvcizK4
         Ug96xmp8Sa9jC7SJWJwemVQ8NW/kDlJuVBr4Ec3dKgAbXXvsYJ5JZd2IYzZYGPQIEMfx
         sI9FLrZI80GHb7iUdnYSh/h32WT+61mgaeJQrIsCZUsLVwSA+BCcEdWsJ/+MXv8p8LTz
         9S0g==
X-Gm-Message-State: AOAM5331UJ4xHLpdKP/2H5wtFJwxSHMrcfINcoFocxwBxmVloh5ZuS2y
        zYoCfknI3HEn/wShByqmyFa6e9v3ecepoawa
X-Google-Smtp-Source: ABdhPJyV6uKGcQnswRQPiTXNUCcoFJ4veXLE8abIw+zZeHaQjglwaxFlYts+2rnbNBpLFG8ZuFMy3g==
X-Received: by 2002:a17:90a:2844:: with SMTP id p4mr8324977pjf.89.1620171524590;
        Tue, 04 May 2021 16:38:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s32sm13376067pfw.2.2021.05.04.16.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 16:38:44 -0700 (PDT)
Message-ID: <6091db04.1c69fb81.108e1.35b6@mx.google.com>
Date:   Tue, 04 May 2021 16:38:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189-8-g29354ef37e26
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 73 runs,
 3 regressions (v4.19.189-8-g29354ef37e26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 73 runs, 3 regressions (v4.19.189-8-g29354ef=
37e26)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-8-g29354ef37e26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-8-g29354ef37e26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29354ef37e269d99a89ad0cfabe86058ab3b72b8 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091a09f3508e8267d843f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-8-g29354ef37e26/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-8-g29354ef37e26/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091a0a03508e8267d843=
f23
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091a0a460fc12e635843f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-8-g29354ef37e26/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-8-g29354ef37e26/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091a0a460fc12e635843=
f27
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091a0a28420da95aa843f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-8-g29354ef37e26/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-8-g29354ef37e26/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091a0a28420da95aa843=
f1a
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
