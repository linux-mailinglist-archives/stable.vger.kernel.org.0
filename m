Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB83700F9
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 21:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhD3TG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 15:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3TG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 15:06:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7E3C06174A
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 12:05:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b27so768065pfp.9
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 12:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/uXSwDdu3vh41QOwrFG2mlrxFdD0c2Q4/p+uS+mMAvo=;
        b=zHaYFT80rmFIPDQT9wgpylGyQ3/kMJaXczpgYf2C3ztFYnqW5wf6trc1Zw4Sf0P6Bc
         812adodl1vvYyulA8g3l/yadBrLja2OpCX+G3HtaYvu+Gq+Xmsxdj+fpBwQ96Vi73I6B
         /eM6DbzNC4xh7SzOYrwJ5QJ41XsXSCYfLVCeJA3MmbS74z1mB5xRIhpHZ96USHQIHIlm
         qnstfhFrF1EvDsQtWZ8ET1LZuCPdCcXOTRjo9GzvGEjfw1rwurkKomFskViQTsJeTqXP
         OEXIXzGd0JiTHcvsXmTB95wvRUB5cXOfhKSHR9V24fGkejor/0RCHIEh0l496yYP17sB
         XGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/uXSwDdu3vh41QOwrFG2mlrxFdD0c2Q4/p+uS+mMAvo=;
        b=kfxCaPIC3MekPTmFhttUtlGSm8edSdp8ZTxgTmXA814K9qtg7am5j3TiWulNMn4trv
         aTGhdV2/Dec8Rsn8WbK66R8MuF3Y2pHM55TH72uhquspZgaGyXd0JRHN+vqljNFTpFEo
         iErFburEWdfLwjWvyKz+G8szonH7MC4CdvwVr3sBqDaTRAzAFjJAX79HDB8vZiSy0WOU
         fy/nFisF/IqjXRx6Deb45tnMBEeKw4Z1CSHFlB+gna1PfqrgQMedOk7+YAH+a1fUAdMV
         oAziPqISGvdAyVnPYmH9UZGHhyigIojgDIx0BTK27kHEdtFf+SQPQj/Gfhvxu16jHiGF
         YexA==
X-Gm-Message-State: AOAM530YpcSlR1GaaNcUveVUtyBxx3h3/L3nimGHB6I/MtaJKHSo0D+U
        zUrRNomfVnMBiRFVg5N9ceIIdxptyKKTplws
X-Google-Smtp-Source: ABdhPJzaBIzZQfgcBW6J7GxdsRySFqpp5zfJDRZvFrKBP5UwP0k74pxF+dyKYY68wT34F0z2pOX9Sg==
X-Received: by 2002:a63:211c:: with SMTP id h28mr5863229pgh.278.1619809540206;
        Fri, 30 Apr 2021 12:05:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11sm3030796pfa.108.2021.04.30.12.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 12:05:39 -0700 (PDT)
Message-ID: <608c5503.1c69fb81.85e2c.72b2@mx.google.com>
Date:   Fri, 30 Apr 2021 12:05:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189-2-g1bd8f1c8ad2f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 94 runs,
 3 regressions (v4.19.189-2-g1bd8f1c8ad2f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 94 runs, 3 regressions (v4.19.189-2-g1bd8f=
1c8ad2f0)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.189-2-g1bd8f1c8ad2f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.189-2-g1bd8f1c8ad2f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bd8f1c8ad2f0ad5fd897ee7e37f81b867d78b5a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c1b726a5d97c7259b77a0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-2-g1bd8f1c8ad2f0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-2-g1bd8f1c8ad2f0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/608c1b726a5d97c=
7259b77a7
        new failure (last pass: v4.19.188-58-g6eafc8cc1bd73)
        2 lines

    2021-04-30 14:59:57.413000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/111
    2021-04-30 14:59:57.422000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c19cc299b7df4b09b77b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-2-g1bd8f1c8ad2f0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-2-g1bd8f1c8ad2f0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c19cc299b7df4b09b7=
7ba
        failing since 163 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c281264db8a43dd9b77ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-2-g1bd8f1c8ad2f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-2-g1bd8f1c8ad2f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c281264db8a43dd9b7=
7af
        failing since 163 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
