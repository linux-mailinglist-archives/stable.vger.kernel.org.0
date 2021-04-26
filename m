Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9336B531
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhDZOqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 10:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhDZOqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 10:46:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E3FC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 07:46:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p17so3156769plf.12
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 07:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MgdPJSgBzawN+9IINMCz0ToBC593mxri73GqHMbqBAM=;
        b=vwD3pT3KvtrqoAin0SXTNSLixvtCoZ34flHGU3snWmU/rc8lmt1KsYiHRWWt0/11EC
         /+ftNZwNMXrHbeHRPxalkbJK/Id9f6P1dYWUZaAG0BpADLI355zhvXdQ1DmpSmkKpysh
         A/6TWGY4eJi6TizgNiJ3aDwFDI8WWnP7AySWN1OPKtZS1TxvHAGQ9yR11eVL0PhYRR2C
         HR1kIu0a1wGfOw2GzfxpkUhj1mufcdEAn6kklQzhBCXQiSV8SrtvgZQMDjt3HlUFCedQ
         nk+3gpw026nYTOOLgC+Bn4gLnxioEPoFh5B3Y76M6Ysd3WPjhA44X516H32OcsbsOBMP
         /Aew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MgdPJSgBzawN+9IINMCz0ToBC593mxri73GqHMbqBAM=;
        b=JmLWugFDyCdXHTP4dGS6WB8AsQlnUsyRM4ylmMrEqYSUNv/qgdPwvsT5VZSdxvNaUr
         5trUGfokanGuGlmFVH/oQTJ0MtvZ/5ox611vVN03JwMeE15F1XL0JAV0Izgw8guVEa93
         bGULlKpe9Ex1ca/Cy5H+QqLz8hMXMF5D0XUEqwUt1+SBpD16ExnqRc5cmlhcX3mBaYhj
         m2QOtBgI39Vj8QQsHHMfo14kEH2ZJPrGYOTrKk0x0EOB49lGuW11RFiUPwhL8PX7gr/2
         DL94LqlpH8JXRAciDEZm5h75FIvTQBrxwx5Pccx/ZwVNC1/lDvavNlo0Wtao4B84Wbfp
         lx2g==
X-Gm-Message-State: AOAM532SDQ3Cdnv5NpFk8UOUy675VHy/pAECqoA6ldjMCyhATrGAvwnf
        oC+uHNAgj2Tx7Cm3SBuLsYqoZA6vMoN4nOOA
X-Google-Smtp-Source: ABdhPJzUEUh8agm52r6NCOrgl6MhnSH51q+LeUwGLX23PZMwPWneLZyq0cQiq8wcH1MQD2VT4gPZrA==
X-Received: by 2002:a17:902:a406:b029:e6:78c4:71c8 with SMTP id p6-20020a170902a406b02900e678c471c8mr18729122plq.17.1619448368877;
        Mon, 26 Apr 2021 07:46:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r1sm18375pjo.26.2021.04.26.07.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 07:46:08 -0700 (PDT)
Message-ID: <6086d230.1c69fb81.500b0.00d2@mx.google.com>
Date:   Mon, 26 Apr 2021 07:46:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-48-gbf9d4d8afd730
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 109 runs,
 4 regressions (v4.14.231-48-gbf9d4d8afd730)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 109 runs, 4 regressions (v4.14.231-48-gbf9d4=
d8afd730)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-48-gbf9d4d8afd730/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-48-gbf9d4d8afd730
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf9d4d8afd7302b27f90fb67fa78fcabb2633d5c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60869e530e25ae18199b77bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60869e530e25ae18199b7=
7bc
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60869e63823bc57eae9b779f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60869e63823bc57eae9b7=
7a0
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60869eae34db05f37e9b77a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60869eae34db05f37e9b7=
7aa
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6086bd96d84a9ff4789b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-gbf9d4d8afd730/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086bd96d84a9ff4789b7=
79b
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
