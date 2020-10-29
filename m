Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917F129EC7D
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 14:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgJ2NJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 09:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJ2NJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 09:09:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7F4C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:09:17 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 15so2271649pgd.12
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WXeQCdC9dhoUiV3CRqTdFsd8BDn/wSZAu34EoA1luZ8=;
        b=a6Fg4JWwEnetDlY6S5sOMp0loN2QzxmmSHLWS8etDn60zxnzYFfGOn2/Zfs+Fw4LO4
         jdEV3+AJtqxzlr7tmXjixwSUndvARQXlQCRpmgnlnWGA2lT4dE58Ie+n6YKGBwiB3+uy
         vQ8qw8p5xddKq3lISxNd5oX9DQjT2rQK5gdz5RHUkIZvfBcIG6+Q0BR3uwZGHvgFw5P/
         LZBESUQrxSWRGn9ES6QNmIPik5SA40RL6DT1huy7LVatQGLfzXY37s6/G82zmcS31JVY
         8Z15TwQv2Veo+rQroQsr3bBz9SDLt8WSde3f6+mZQhDl/Hg0loAq6qyMmn57s41Vbj2O
         bppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WXeQCdC9dhoUiV3CRqTdFsd8BDn/wSZAu34EoA1luZ8=;
        b=eDyRE8RFPoZecrKn9MJkTFxL+RcWNYYRUbFAwgBWAjirNJkfY7dewxBndNCnZahvgu
         CPOcLDVjGFCFy1Bkf+kGIWJp2Lq3mwk4980u27Y9sUrQtbIrKiH9Z6ddNud1tKwy3qV7
         PYHTtQsGTq/+ZbnkybTRD0oVWt3eveflEagRK9fd1mYbCG/ww8H+c6PtVANjPth1gLJJ
         yJV10rBX6vUYBSotT8XQyvywyFDICefih/ZXvi3JqdcgzE2vKKitT/KCwZSvmITAvty5
         s1GGZE7ERZcJbOoqLDeF3VPcUys8zUxtn80fEsFsdXW6b/HeY7BSITaTZ1aN9UWapNCz
         uSqw==
X-Gm-Message-State: AOAM533RvD7Oi9tnu+qkhSh00wkEwCl30E3MRQQpQbW/J7AYuvxvmQTN
        SJ9FS2jGraSX8XYWm6nHNlQBn66tVeU2iw==
X-Google-Smtp-Source: ABdhPJxqJvClDLA2qD1UFVcc38jkjgKUOPprRUBDELnvZ1+RUeQLNb+bxMaPcXdAUwZJ4TsK0WDRwQ==
X-Received: by 2002:a17:90a:f211:: with SMTP id bs17mr4417711pjb.153.1603976956686;
        Thu, 29 Oct 2020 06:09:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm3139460pjf.36.2020.10.29.06.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:09:16 -0700 (PDT)
Message-ID: <5f9abefc.1c69fb81.44b3f.6b6d@mx.google.com>
Date:   Thu, 29 Oct 2020 06:09:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 166 runs, 2 regressions (v4.14.203)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 166 runs, 2 regressions (v4.14.203)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.203/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.203
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2b79150141611d3c6e1b55d4e70f49602482f0b8 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9a8a39eb7d63cbfd381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.203/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.203/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a8a39eb7d63cbfd381=
013
        failing since 209 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9a8cf55ba8dc4870381012

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.203/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.203/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a8cf55ba8dc4=
870381019
        failing since 14 days (last pass: v4.14.200, first fail: v4.14.201)
        2 lines

    2020-10-29 09:35:45.678000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
