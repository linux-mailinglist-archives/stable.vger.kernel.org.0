Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EA52A2187
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 21:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgKAU1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 15:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgKAU1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 15:27:14 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEB3C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 12:27:14 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 62so1706218pgg.12
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 12:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mgxocgythQiUu4CNyAAZlHUyHY3pVJfjYFg5ADEr4BY=;
        b=TIP7U1yzY7o78Bva5RagwtdqcClcaGxtHnR890++byQX0HXMGdb3eULt7/fqzvAgrn
         nsd2/GuNbWB8CD4BWaWBU5ywR2eCpFywKtMy1cmmhQhCGv4z0TJhxYDEKkfuixpHUx/D
         7ZNtLAiGdTBPYyU7yGGc51W02twaOA60OAIoLHAa0JTrR4r/1MwE0n0vSvWvHZDoMaU8
         U9P+M+gSzrIjV9ubGc995DJ9CpPrs/0R+jtb+5Q8CUc1N6Kqye2ZI19tS4fJ0hb25oXc
         5zLqkvO0MDhALJnn7AhodFAXBFQHY3n2M8eI5wGRu8UNjQAfryNmm4bDzH6iQ/OAT+T0
         aI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mgxocgythQiUu4CNyAAZlHUyHY3pVJfjYFg5ADEr4BY=;
        b=CGR618Lgz61OSYm5VXwTV7HQTxfTMAISOHFzbUxMk3L9l5/0GXbaa//5beFagPeL6K
         qu/WCuOtAs6x+152g5v0iL82rD8ziyuPPxwITmoTfhnbeOY1a+QDrMWzHOBZMFLhAtVH
         93lZ5LB4dAyeobOPamR2BbHmym3F/gDHxBP20TfzBy/u012/FDPR7slhLqhycthUZ6U+
         opfYumjHh4C7+nwu0iD2X9Mp5Cw9vU333/uJTN/wH2hp6tQdVvSLIN3M/fWQqr6zB7Zz
         dlrjNo4dosZjA2VbaXcLFKOoEVNBaWEAtp8xxwRi5vqZVZtl06wBnLT59FEUQVjRP2PG
         LzQw==
X-Gm-Message-State: AOAM532M+m5h8jEG2UB8GFhm6F5wwGxyCCeAfETv3KMOvYaJl2/wcnIl
        TEfmgspJv3cUP+Jb8D7PkYQQqBHSiwPTyQ==
X-Google-Smtp-Source: ABdhPJyZwuHN6UtpwuZEwi4tWQ4kX1D4bRX6e/DrZVK33dnyVCd/lz52TdH2//uhCXqdZt9f7O22Bg==
X-Received: by 2002:a65:4905:: with SMTP id p5mr10153264pgs.299.1604262432577;
        Sun, 01 Nov 2020 12:27:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gc17sm1097071pjb.47.2020.11.01.12.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 12:27:11 -0800 (PST)
Message-ID: <5f9f1a1f.1c69fb81.f517.499f@mx.google.com>
Date:   Sun, 01 Nov 2020 12:27:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 171 runs, 5 regressions (v4.14.203)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 171 runs, 5 regressions (v4.14.203)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
   | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
   | 1          =

panda                 | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig | 1          =

qemu_i386             | i386  | lab-baylibre  | gcc-8    | i386_defconfig  =
   | 1          =

qemu_i386-uefi        | i386  | lab-baylibre  | gcc-8    | i386_defconfig  =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.203/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.203
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b79150141611d3c6e1b55d4e70f49602482f0b8 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ee708e4bdd422133fe7e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ee708e4bdd422133fe=
7e7
        failing since 100 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ee8168f1769a3043fe7fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ee8168f1769a3043fe=
7fd
        failing since 215 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
panda                 | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ee8574a2221aefe3fe7d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ee8574a2221aefe3fe=
7d6
        new failure (last pass: v4.14.203-13-gb2eae82b6b0a) =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
qemu_i386             | i386  | lab-baylibre  | gcc-8    | i386_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ee62070d52b17673fe7ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ee62070d52b17673fe=
7f0
        new failure (last pass: v4.14.203-13-gb2eae82b6b0a) =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
qemu_i386-uefi        | i386  | lab-baylibre  | gcc-8    | i386_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ee62200963f0cf03fe804

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ee62200963f0cf03fe=
805
        new failure (last pass: v4.14.203-13-gb2eae82b6b0a) =

 =20
