Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FD732F0C2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCERI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhCERIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:08:14 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3C6C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 09:08:13 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e6so1805075pgk.5
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 09:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=88+8p1trv4KqFBwHgk98TXjO0Gth/P9IrQXHF1cbMzs=;
        b=PwcsI+X3q3zdQIxtG47EAPAYqaiEImST7Ti7ZuhnPXKAPNljekknSZh1VdEu4lkATP
         4TEHO7ArijivBYOJws0MVNXEhI1iW4Tmmgn51hxCnrOlqyYwEVXqszu5Dt/fU7QQHt/8
         RwEeGBc7TlN8gCmW1GPqZgwm8at3v4QDgD4fgn0NGWwOh7VDNfE7mVp80iLmU6uFUDt8
         SQ5l+IL6jr8lat6zXzsJfbgNjBV8E5H1jf80QxP8W8+ke4xg1Pcw3nC+48ot4NzytC4g
         2IDQsRzn3CqGV4D0yANA5G8VvJSX8Udqh2ojOVAF6QcpHTUvGRMI4Tvcpbs45YrE6rtl
         VcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=88+8p1trv4KqFBwHgk98TXjO0Gth/P9IrQXHF1cbMzs=;
        b=AhPsdUatM0qMCVrIj1aaMsEP7nQC5OybaUlsDqc8Fmp4IpGdUoMGyWp2rhF9UlrpRW
         jq53rVjoEi773bD0wxLiJ2MKWlwt4sXY4A3EyPc1SAkKeBEXJEpB7Tq0VuJ68qs5nWgq
         aq23SBZMfTcx/4AyQ35y8HuXL4KiGrekLSVZobr8VRaxLOMH/UqwkEbCM8IThi2rWPLg
         s91xaFOGl+IWgmWfEP0ufvq4OjX+63NPAEfy4HXnaOawoXHilpa6P5TRWLByn/XcwFYH
         aXLWbad+plafnBIccy4vCBb1Rfxcz2VWDFxPCgyt2oVGRSkIyOugXsQX8SyNYu6cS7iY
         P1ow==
X-Gm-Message-State: AOAM531M0NO9Audc4QgGqUIUNRlj4fnAeRNr/gvJ/Wee1AesyhMQdZgB
        UpmpUE7ntxE0MUq1iWw9yCGcrDYl0UywAol9
X-Google-Smtp-Source: ABdhPJyibB/3EKEoMrhBfZGeYgA7NwMnPtzBSphNPf5WSrtY4Nz5+h2PsI0XvTeIx1EoQ+bnIqv2VA==
X-Received: by 2002:a63:6206:: with SMTP id w6mr7491409pgb.363.1614964093230;
        Fri, 05 Mar 2021 09:08:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm3241598pfk.83.2021.03.05.09.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 09:08:13 -0800 (PST)
Message-ID: <6042657d.1c69fb81.bc342.8403@mx.google.com>
Date:   Fri, 05 Mar 2021 09:08:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.223-40-g31fdc1da4f570
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 84 runs,
 3 regressions (v4.14.223-40-g31fdc1da4f570)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 84 runs, 3 regressions (v4.14.223-40-g31fd=
c1da4f570)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.223-40-g31fdc1da4f570/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.223-40-g31fdc1da4f570
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      31fdc1da4f570e606123fad56182d8e3d5e8049e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424ddd681c7d8aa5addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
23-40-g31fdc1da4f570/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
23-40-g31fdc1da4f570/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424ddd681c7d8aa5add=
cd1
        failing since 111 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424e04c6c79f78d3addce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
23-40-g31fdc1da4f570/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
23-40-g31fdc1da4f570/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424e04c6c79f78d3add=
ce9
        failing since 111 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604230c33024f888b5addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
23-40-g31fdc1da4f570/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
23-40-g31fdc1da4f570/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604230c33024f888b5add=
cb2
        failing since 111 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
