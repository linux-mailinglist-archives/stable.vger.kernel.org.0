Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900C83E3AC5
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 16:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhHHOX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 10:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhHHOX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 10:23:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD27C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 07:23:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso2524460pjb.1
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 07:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c/Om1jQURRFoPObbyjG0Aw0SEHRk35MrLBmxL9MjoWo=;
        b=Sqm/VffsCFYE+K0HJAiexN8kZgTemKcCNIotoDwVhdDwiqD7QkjxuxgGzLEq9aZwQA
         6dKbRsAoBXeT8IstlsNRtanvL3zrAVciKhn3QFotxlwcB3KHE+TDPcCjVkJkOew/CAsC
         j9wPUBYoLh+wGw6xx1bOibETCehVguuz7eopk32YATxfSqyAidX4J9weP5TcjW1IVM9q
         h01R2QGGWe/T3Vfc1vKFosz8gcsm37sa9PuXEEIcRJ462fOXhI/XrMtPO+3kHoX66G9P
         KJGgkUicLXGcc3rUxuP4t8ozjCZDaTv75YIPTbX0DzaMoqvP6zh65w8eSEfpQ1Du82su
         TfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c/Om1jQURRFoPObbyjG0Aw0SEHRk35MrLBmxL9MjoWo=;
        b=bAHHZ5wlOKVgVHcOsnMmTRYqAKnqGPqxt49/J6a9sMCtporwBLkm9xa5PAuJ7nqxBx
         nIKG/1sxwMFIAHTXbE/BynYqHC8ZauVgzp7J1O1yWV57qZqdd7XvLpwjb1l32ITQ0sfZ
         gObE+1vj63Bxl+3+Eg+PZ6AMFeIUER52jHMDU92xnS5BTNmalFAUsy1iHexA0VQGKK1g
         1LweIgC7aDUOBaZKOtUhGWPiiH0/5RE/E6qwhfeaTCi6ZuhvOpT/92l1L2vtSsoffQby
         FzfqWadmBha24K8q0Z3j4CRbRMnxcQqI2bnri1JglM+zhslZUJBaF2Azfkfvq+dxvyyD
         YqFQ==
X-Gm-Message-State: AOAM532lQIOixvrXhYgzgDvQUAWCiRfOy+ZLxvRxhoAuQBzx6V6H0bmW
        oCUtdV7oFRmACb1RH9RPBArYmrW3s1/v7Zhn
X-Google-Smtp-Source: ABdhPJy46NHthKyGNjoVgLVnuqRzuZDqmh5E2WpHPxEBv2UFzkPQSCIcuH+jQPaMzdd/HrIG+9WQdA==
X-Received: by 2002:a63:580c:: with SMTP id m12mr17203pgb.157.1628432589676;
        Sun, 08 Aug 2021 07:23:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t26sm16673102pfq.75.2021.08.08.07.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 07:23:09 -0700 (PDT)
Message-ID: <610fe8cd.1c69fb81.54612.e54a@mx.google.com>
Date:   Sun, 08 Aug 2021 07:23:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 86 runs, 4 regressions (v4.14.243)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 86 runs, 4 regressions (v4.14.243)

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

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.243/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.243
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46914f96189be290174e378c6bf9ccadfdb9ca1e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610faf8e8ce9e99bbdb13683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610faf8f8ce9e99bbdb13=
684
        failing since 494 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fb92545993107ecb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fb92545993107ecb13=
662
        failing since 266 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fe044aa61d40a1fb13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fe044aa61d40a1fb13=
667
        failing since 266 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fe809d07450e2c5b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fe809d07450e2c5b13=
662
        failing since 266 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
