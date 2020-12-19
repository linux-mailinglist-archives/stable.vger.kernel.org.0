Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5AD2DF0B7
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 18:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgLSRjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 12:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgLSRjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 12:39:06 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692F1C0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:38:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id hk16so3251348pjb.4
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jKNHkuGp5wF2rK/CVZm1YE/V7+/S9GcejGc2nyLuSGA=;
        b=B/a7ge917BwUwdGZQ0rKgT+az6cxmVnhZZR8lHv8ECey/uVmlsM46vaLihcTuk78zg
         Zq/ffl0/gUZ4cjZVIpmz7FJXFnCCWeRCte7n2UUMsVHrzbKjaGfjRAau/sJof0wZWgXw
         y6nLAOA9LAZgV9bfo6NN8XEWkXjHhIfc3tricH2Ol133PGQe97yiDAMq1pQwypsjiVX8
         1lmVWEmyWSuDiPPsZZxWy6spRHdvDb6FLPwdgM6EdDb8scnPpBRLoiRzXAvAFGNOiFab
         aq94KudAgElpHQCBh4nR7R0nSbz0CG5ySP3pxwHEMDvYuUsqz3/6hjkz9AEsEVZ9V8z+
         4UcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jKNHkuGp5wF2rK/CVZm1YE/V7+/S9GcejGc2nyLuSGA=;
        b=sgc/h0PCpVNpTpqlahBJv3epGiYEnJzhKiqt29rCL/mxe7/bmxlnjov5EEcAgj35sL
         ZXLMbZllfwpBbO/WNA9PzG05Jc5G5VH02+2RVeD+Qd1XD0v+XFuopAv4/zPfs/vyBT4C
         lQRuUVm6/LW6pfiXGVHCKYBIvKox2eUhRisZKvtEDe3r6+4Hk/PcnxgMGvFMV7W/VCI/
         4kz1JD/l+LoH5ZBSEMQcdZCO4ktnq6ad1q7xY3FKj0SDGTMWKvqO1kenUe8vEE+2OYlF
         n0JtVHyn7PIWSaIrBSPgfJLVaeuDbVCCBZK1S6i0oupT1Rby5HqXeflPvF1zoguekeAs
         2QDQ==
X-Gm-Message-State: AOAM530FyR6y0VGy0RlDh/wZuTo444FsNbtphMVr7IvCJDnjhp4N2LOC
        BQO6k7nKDTS31hfql424UBaKylNvF1q92w==
X-Google-Smtp-Source: ABdhPJwVFKOB0bG3lQzxRNN4B5knuMVQuenLB/9GMyOckgzOppH2X+nbsFK3PC2m01PhjMV/7CTHuQ==
X-Received: by 2002:a17:90a:4f03:: with SMTP id p3mr10114436pjh.69.1608399505623;
        Sat, 19 Dec 2020 09:38:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm10482525pju.37.2020.12.19.09.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 09:38:25 -0800 (PST)
Message-ID: <5fde3a91.1c69fb81.c1fbe.d4db@mx.google.com>
Date:   Sat, 19 Dec 2020 09:38:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-55-gf909d4560074
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 133 runs,
 4 regressions (v4.19.163-55-gf909d4560074)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 133 runs, 4 regressions (v4.19.163-55-gf90=
9d4560074)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.163-55-gf909d4560074/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.163-55-gf909d4560074
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f909d456007403e053f70d758e4eeb23bd856263 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde065c2d26490d74c94d07

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fde065c2d26490=
d74c94d0c
        failing since 38 days (last pass: v4.19.155-42-g97cf958a4cd1, first=
 fail: v4.19.157)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde05fabcd7c1ee21c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde05fabcd7c1ee21c94=
cca
        failing since 31 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde05ff708ff64d05c94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde05ff708ff64d05c94=
ce1
        failing since 31 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde05be571ed461c2c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-55-gf909d4560074/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde05be571ed461c2c94=
cd9
        failing since 31 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
