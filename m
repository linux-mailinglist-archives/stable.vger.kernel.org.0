Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0572414175
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 08:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhIVGDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 02:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhIVGDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 02:03:33 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D48FC061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 23:02:04 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q68so1536845pga.9
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 23:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=13oJgNbELKUQHQ51IGZxbBn8L7a8MQ7nG/zc2k02Keg=;
        b=NkASVQJq8hMjSM0zofukCY/Nz/PGoXTgMKgavf9R8p/jgowaRsVtaH035Vf8TjyKy3
         fVk+L2E6VpLsLsFt4BDj5hCEpeKpXdr2MMo/xllYvGNmplBBXcCdAdI9jqMhiPftZD6b
         CUsvGS4b8EJVFxw+6VazCXi1XtS+2THBlgqpkyshTjHB/I/bJko2UBBptSOMWFSYwHRX
         bK7mZaW+XPd2v4c6DTWaDFwlUEGCGqmNb54sEHSE8Dx4x1JXjCw46hhiDXx4VT1Vtmc4
         oGAmNCBTw+HZaV6WkAoVfep/QHnRLAlY+2cGiL1qdgeOCbVoZuYv3BD7jwpr8VHwYHs4
         YCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=13oJgNbELKUQHQ51IGZxbBn8L7a8MQ7nG/zc2k02Keg=;
        b=tCHrEfI2wH0klnpY1JmO5+bCFKNnb+j3OYtUIFXn3W5C+tF9M9VMhFeNfKItHM/Z6u
         8LvB6kn4/VzDDXQ7kXUnDJ2o4zfo5f2ncwTpljoS3JixI0QVY2vZx/JotB3U8I3xDDJn
         /F0DOxZ07f64PO7+IRUi0Z6Zatmc5NhQngIEFiIMQ/LfYX2qc9e/2VcCG7mN5BuacDFz
         OkHMfWU5pRoBlG//B9HIzGTMwrAoxDoet1wdkmvM+Dq4XFhXfvTpnTMQpJlRNfDmOdLO
         NDBB6nyT389pvS2SYErVjKdIrR/psgYrAGPOhgCtyVhtSXKXRj3ifYuKFpns6yopNFic
         togg==
X-Gm-Message-State: AOAM530PckUduJSLiW4CX0fruQ+dCWhMQHDJ44vgCIHK3tGr0uWhAVyr
        sd7k/YezPCfRTEudb5XsF83B62B1BWe/bpLf
X-Google-Smtp-Source: ABdhPJzntAQTCNRM8F+FtBXcgwC5yZvQFR8GM9J4KwqmgY+/yS40tFR6XAWf87OzQjcVXsGJMMmk6Q==
X-Received: by 2002:a63:e613:: with SMTP id g19mr31535155pgh.12.1632290524070;
        Tue, 21 Sep 2021 23:02:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o8sm932792pjh.19.2021.09.21.23.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 23:02:03 -0700 (PDT)
Message-ID: <614ac6db.1c69fb81.3e45a.32fd@mx.google.com>
Date:   Tue, 21 Sep 2021 23:02:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-175-g92ec57063600
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 72 runs,
 3 regressions (v4.9.282-175-g92ec57063600)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 72 runs, 3 regressions (v4.9.282-175-g92ec5=
7063600)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.282-175-g92ec57063600/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.282-175-g92ec57063600
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92ec5706360024e85585ba08e42b7350d6cd6c48 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614a937b949dc4202a99a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-175-g92ec57063600/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-175-g92ec57063600/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a937b949dc4202a99a=
310
        failing since 311 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614a8c71d0f2ba6d7099a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-175-g92ec57063600/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-175-g92ec57063600/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a8c71d0f2ba6d7099a=
2dd
        failing since 311 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614a91014b6e78c89399a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-175-g92ec57063600/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-175-g92ec57063600/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a91014b6e78c89399a=
2f3
        failing since 311 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
