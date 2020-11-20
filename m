Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41512BA99B
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgKTLxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgKTLxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 06:53:08 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D780BC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 03:53:07 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x15so4747163pll.2
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 03:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lJALTbs/+8uCG+N+cC0IdBO5EgvGl126b/QcUm272l0=;
        b=uNcebz392+Yg7FTpeecyOcW8CcBk1kkrBemLnIV1iHqoUMeGBdhslgZKe3e8fMuVon
         AHo9rz7lkRFo3aDdc/8nW6to7Yvph0u5Tz4TiE+0vxmkgrqJMj9A2iJ3IFOuEcVNT07x
         nwZuNc5lMZUDWN116KLERoYwIr25dcTFTTcD+UqlPdmHwoW2uHOuhFctUg/Dblc+6blI
         3xcSNo+HJ6R6jeqtTmJKTDgVB30piU4lY3A93wAmA/CrUr3N3qdudlMcC+rP37GGXfiW
         NlVB8oOmrwJGIWicgXcBFDy/sdSHcAyOp+VaiWFrLj5BLY/MYeztnbDk32qNaHGGkgrx
         TG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lJALTbs/+8uCG+N+cC0IdBO5EgvGl126b/QcUm272l0=;
        b=LxJB7vufR97jf6nbAtoS/Bl0JR2Sj0lg/WeDFwaw5puOFoFB+LeaRRjdc5nE4J7RnT
         mNKDbw9rDnA85w+4/QcDOnKgdGIjdO+twzWuLI4Tw/SbbOx78pr/HzpgWcdJC+p2FEsQ
         rP9L0gnRNabmBjw4Y8bN1DTK/Kczth0/Da6/S4KGozQSlpH1460xXl47TOJ4U4SNlxSv
         k5ErjJAaM1E8NfIaoX2mreDrvowoScNN6KrwMKrF9pKYd7fhYuHQpEFBuQCjjJhvmj9Z
         qohTkKoW1eJ0CtH7vx+V8dh/l97nODRWlJvW6PYsRr11y5wS+cdoZUTysWvRVwCSF9jq
         ci3Q==
X-Gm-Message-State: AOAM532EodDoioPYt1Sbn+8txynJQa53Pycor2h7yj6PVgSsUBkV3aGF
        46WIuImHHSAB0MIbWJSaHQ7r3CoE6xrYig==
X-Google-Smtp-Source: ABdhPJxUgf4lS8W76+qB8OnEzQZhn+dB3MdRh2pYbOtISgRckO7eHjlWERHtm+Wwb5G/swcA6nWDpg==
X-Received: by 2002:a17:902:9341:b029:d9:e385:bca2 with SMTP id g1-20020a1709029341b02900d9e385bca2mr4820981plp.64.1605873187042;
        Fri, 20 Nov 2020 03:53:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4sm2170086pfa.103.2020.11.20.03.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 03:53:06 -0800 (PST)
Message-ID: <5fb7ae22.1c69fb81.a1a7d.3bc7@mx.google.com>
Date:   Fri, 20 Nov 2020 03:53:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 155 runs, 5 regressions (v4.19.158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 155 runs, 5 regressions (v4.19.158)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.158/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c746135a12e3f329171ed168ca0078d468f6d85 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77b0b5fc36ef11ed8d95a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77b0b5fc36ef11ed8d=
95b
        failing since 157 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77b81e3e9067a1dd8d912

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb77b81e3e9067=
a1dd8d917
        failing since 9 days (last pass: v4.19.155-42-g97cf958a4cd1, first =
fail: v4.19.157)
        2 lines =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77b85c92fc28537d8d908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77b85c92fc28537d8d=
909
        failing since 2 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77b99e3e9067a1dd8d92e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77b99e3e9067a1dd8d=
92f
        failing since 2 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77b7bfb83ca0a21d8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77b7bfb83ca0a21d8d=
92a
        failing since 2 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =20
