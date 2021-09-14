Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B5A40A1C7
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhINARv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 20:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhINARu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 20:17:50 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44029C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 17:16:34 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f65so10435759pfb.10
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 17:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UIwcBGxuaQ+Ix3cjdVJTXsH6fklT0whTlZ6X0c9VO7s=;
        b=F/0NcWJMw39lqSz8NlmUgro8aB7W5vIKU93sFUwwVR/gtoaM1ga5fqMAwoNxwuRhP8
         L48qCRPakV3hjplIeXZy1K3wRsNv5MGngfS6eTYkxkf/LDIGFaruCX1SethcK/04goVr
         fPKOqdbwaLBR5orfMY75gaKLvpNNCx6h7cxVE4ryr0FJJdc2JOrYrr6/j6KKEeV7/Gpr
         oCy+iI5L/46t+O3Geumt+aJOJbQx2bKhrpgVV4jN9dZj5vRiaGceNV6fcsij4RMn0SgK
         5VsSP6mef0txVU1T69OIH9YkuhzlNJzYFF3z7AKQbtKYMIDV4zhTtJD0mIVhc0LJrypj
         5Gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UIwcBGxuaQ+Ix3cjdVJTXsH6fklT0whTlZ6X0c9VO7s=;
        b=dYIw0u/lYcwsG3KryA/HsAApM5vYGTvNKldNp47VbV8hL9D27l8KpeKuIYLg8+zwj1
         dtZjQMjNjjwk+sfResUg1KdGJQ4fXRyOrYa9EFqNRuVaCMB4wSDlXCN2cV6XkSiWcFT0
         twYsc0LbrzvipWuxJi5MUXOm0nO/O7zGlaQp+Peep7+IncpFtZMt/yht79N+T7HsZc4f
         YCGoKvIauKM7eLCJmF6bdTZ4QB+i5t1+HZ1Rs7osGDOcFjqCyopW6kVP2fLxfIZdeRIZ
         x8vHCmnHu72Ly7unfgU/DL7bAR9jG3m7CFv887I0oIU7hWX0SxjYDksmZegxJAw2FkxR
         11WA==
X-Gm-Message-State: AOAM531g6sPMRZKzCuPz26FGNWV9A5OTH7bLVADU+KAv1g2UnZqHNKYv
        LJ5fF7/fsfUcClVnJ1IAORpipbkwlD7GtnNa
X-Google-Smtp-Source: ABdhPJxD4s6FwgwSE+YEIArTBjKHPyQj2IsDsv0uVqyb3IpwKugP38E2XPneDASWc5tNoBvlC1jNAQ==
X-Received: by 2002:a05:6a00:98f:b0:40c:96c5:b4fd with SMTP id u15-20020a056a00098f00b0040c96c5b4fdmr2038437pfg.0.1631578593426;
        Mon, 13 Sep 2021 17:16:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p68sm5168700pfb.106.2021.09.13.17.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 17:16:33 -0700 (PDT)
Message-ID: <613fe9e1.1c69fb81.3f17f.016c@mx.google.com>
Date:   Mon, 13 Sep 2021 17:16:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-121-gae1a50dc8893
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 140 runs,
 3 regressions (v4.19.206-121-gae1a50dc8893)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 140 runs, 3 regressions (v4.19.206-121-gae=
1a50dc8893)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.206-121-gae1a50dc8893/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.206-121-gae1a50dc8893
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae1a50dc88934cf02c531ddf5a805e462d1ca579 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613fb6e9871d4ff31399a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-121-gae1a50dc8893/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-121-gae1a50dc8893/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fb6e9871d4ff31399a=
2fa
        failing since 299 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613fb42b879fed616e99a315

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-121-gae1a50dc8893/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-121-gae1a50dc8893/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fb42b879fed616e99a=
316
        failing since 299 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613fb88d25108da01999a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-121-gae1a50dc8893/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-121-gae1a50dc8893/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fb88d25108da01999a=
2ee
        failing since 299 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
