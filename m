Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29F232B1F2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbhCCAun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344134AbhCBRPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:15:14 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E83C06178B
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 09:13:54 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t29so14227709pfg.11
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 09:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=skGlPiAz06rnfHhwJ+9qqm2H3WwuCgvYcpX+McUALAE=;
        b=Zf6u2eJXc62YoDNKmPc6CcnbBDRsFpKGww+2Bgknpco3kjRus8H+dbVHtffJY1qHW9
         e4EqHhKXHkLIvXSJ0lmxHY0JSdxFRXcoWKVLaP3DIXCeMfPsk9MWXTfSBKCxDgS/sZH6
         3bF6vq+cK7swt8SclkzrXBg30SNBiW8TjdaSItW/DW9X5+ilS82ANvD9bbQ10DwZ6RTE
         X8/JWQlqcdOj8/IYcPdrIUFwqtEjPckyjr20qwxnSDUMf9+mP7TIzJ0wedc3XNkH/fX1
         t6ZCE3PnQKyaoEbqKBdnOCuhO2il1/Mc4rwoU9oxeBbytPu+432Dq0lOb+lwvTRqj3Hr
         RpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=skGlPiAz06rnfHhwJ+9qqm2H3WwuCgvYcpX+McUALAE=;
        b=atII4afuN0Eu/LtepHJRl7Vl8tUJ1vaMIg631UWB1DAdEFlXSweAF3vZ1n6dWRHUGY
         iOkKlCWY+Y5EHTLozwcdvRQbR8OKNeVTlSVQM5ElBv8yazpnvRG5J3nNauRyRK86EBQR
         YT/XmlleSrMMFNIoV/vNzX6QCM6JnljQAQhFZzMARo7S44Fde5ERRcqFRRXNM4j/hGrg
         D4fdiFV9wvVc8eBWGA7nPFv76K1GnL5E72+5iHX80lY7I49eTQl834uCwEwlNmnMBpEJ
         PMh5Xd1XVsrsb6/QKrAL6asjA512+Zadxh3q4/iUs9o6yYxfyPF9+DVhucnqqv77Idvb
         JpBA==
X-Gm-Message-State: AOAM531GbHUhrCgXftZTBk/bkb3opBBRxe1pyJwr61xVMJbldHRCAA2u
        904BZD/rHyorWjeBFmcWNAoe7157Snnqpg==
X-Google-Smtp-Source: ABdhPJzp9/hj1sgNjpi14z36vcmVJX2MsRZa1zC9B1mAv67/iwq+zbMa8I9f/APyzGti3i//BwMu0g==
X-Received: by 2002:a63:5c4:: with SMTP id 187mr5224806pgf.269.1614705233906;
        Tue, 02 Mar 2021 09:13:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm3871301pjh.22.2021.03.02.09.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 09:13:53 -0800 (PST)
Message-ID: <603e7251.1c69fb81.17fdf.859e@mx.google.com>
Date:   Tue, 02 Mar 2021 09:13:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-248-gbe9fac34eff6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 93 runs,
 3 regressions (v4.19.177-248-gbe9fac34eff6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 93 runs, 3 regressions (v4.19.177-248-gbe9=
fac34eff6)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.177-248-gbe9fac34eff6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.177-248-gbe9fac34eff6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be9fac34eff6bc947c29cdccf772b7671f70dbc8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e38ace35348f0d6addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-248-gbe9fac34eff6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-248-gbe9fac34eff6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e38ace35348f0d6add=
cd1
        failing since 104 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e3894acdc5b43caaddcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-248-gbe9fac34eff6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-248-gbe9fac34eff6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e3894acdc5b43caadd=
cd2
        failing since 104 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e3859f77bbac0baaddccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-248-gbe9fac34eff6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-248-gbe9fac34eff6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e3859f77bbac0baadd=
ccc
        failing since 104 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
