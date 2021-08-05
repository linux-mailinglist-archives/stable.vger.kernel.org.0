Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABBA3E0E6F
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 08:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhHEGfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 02:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhHEGfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 02:35:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C044C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 23:34:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so7145067pjh.3
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 23:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1mPm6eHHiD4ph2D+OQv0HtTxXk7Z1QVGUjCJWypqkuA=;
        b=qaILEpCnoD4clzPd0NqZepGuCN3WnVeNeYqn55ihhBqytvWGYf8YYOaXoSdnbXLR3G
         rpdOUkXjH+a+Dzy5uYjkoJpQTe10Fj0bHmYCXOuh/L2URcskGTK2sD1la0yaUhwkRBv5
         KpetG//5uK99W1zLkp5NMPnrk0dbe3TD24nBndjixYrRrdsgVQIfHN29LeTHesO0iwuI
         OhAbCdsgPu9irvt6wN9nNBkgwD6BT+T797/NMVcHoSo2Vg09GDXFaNnVJI5IshrgEUuv
         jEi8dDdKYu64NF/lpieX43IVlWu6REFzmntUi0avEVRt2M6V06MLaJ51vBHsHkGNsQyx
         Pa6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1mPm6eHHiD4ph2D+OQv0HtTxXk7Z1QVGUjCJWypqkuA=;
        b=Fnfl3ttvraJyUhojfPJPbkyQ7QbBHEfdzbeNn2BTyjgvMcqnJvLBbvEjbYe3CemKYK
         GvPkNUdKH3z9p6MAnXTMTq7sE4WWm+dD2jC72qClvc7T7he0zrM0Jn4khWG+91CNoS9i
         4v5lul34dCS5l9BtBv8byiX7Nd8i+8ZKs6bfYEkMLTAiUYikcVPbpk89VFuSSMrWYDK4
         biSneaFOLGxEZgqWhX++HbXYwtBhNIjHeTKilBH/ZgoCOVvjzHL0o1Ysp5okpPW2oTLA
         BbLLtq/bCObf3mIUmRD1/VTJspJyQ6mpcDY9o4/NnRUvyMsM2Kdv5y/MQma1wtTaoEwn
         uBXQ==
X-Gm-Message-State: AOAM532hKnChjEs/CZojnYalfzb/Hy5ZblSwUZgqEIEyrpoSTkk+OhjX
        oSQHLwllI9i4DOmB3JA/y6S374zZ2z/WRHlyLnI=
X-Google-Smtp-Source: ABdhPJx5qGebfElBBNILlZJUDw2ayxaJ54YKGEtY6CTuFXjmA5DIRcqnwibPfupSCb5Boemk3cHtFQ==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr3155389pjk.236.1628145290739;
        Wed, 04 Aug 2021 23:34:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p53sm5206899pfw.143.2021.08.04.23.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 23:34:50 -0700 (PDT)
Message-ID: <610b868a.1c69fb81.1fe2e.03d2@mx.google.com>
Date:   Wed, 04 Aug 2021 23:34:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.242
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 96 runs, 4 regressions (v4.14.242)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 96 runs, 4 regressions (v4.14.242)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.242/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.242
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      94cb1fed447ac8d328a8b50f9583df4ce70793e2 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610b4a990224f2285bb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b4a990224f2285bb13=
662
        failing since 489 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b4b5f72bc410264b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b4b5f72bc410264b13=
670
        failing since 259 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b4b92ebdb66084cb1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b4b92ebdb66084cb13=
66b
        failing since 259 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b5fb6d3f48ec2fcb13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.242/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b5fb6d3f48ec2fcb13=
691
        failing since 259 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
