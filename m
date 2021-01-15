Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529CF2F8016
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbhAOPxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 10:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732260AbhAOPw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 10:52:59 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2509C06179E
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 07:52:03 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t6so4917170plq.1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 07:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5c0ZokoAWbjgzreoc25g5RGCku8IITtlg0hExTKw+OM=;
        b=1j2Ui9KLR/1WaGErC05tx8Fnmst5q/PHcSbp8JmlrKwKCilxCYmPPJ6I+u5BXJAqFA
         vDC98fUrIVUSn+WPAyo5SdHEl7YTtd/OZ4MtsJrOsKZgkrhCOFXJ6SrA3MtbWI3FOGgm
         v1zFHyya9rS12cvSf4GoGNww8tL1es07H4Zdbe1YPAPKzUuOYT2ZrN92xEm94ndHMjjG
         8BCpZ8bhSqEoc8ZWJ90eYkPr3VKuaPoTMwIvWzSajYm3M+rq77YFn/K0H21qq/ZqKrxk
         TyUDVetmGeaXGddlwLiuZASLRctAg9xlJwN3Qr0CBUzFDl/8Xd3HZDfSJBKmVxlgkgJi
         vQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5c0ZokoAWbjgzreoc25g5RGCku8IITtlg0hExTKw+OM=;
        b=WU7+7L7kw3FotwmVTL87px256GCWXS/HmCjuOG7nUAnab96qEBH45fbkRVcXKtYXOf
         fQhgQErKgiManHD/9op+LErs2ywnXh3j+0kKy+w1P2OJG9+uXiHnyHfP2wxMv+VZc8TY
         ET6vL6bYudqLyqRFc/2VKmJw6jd4ElwhyJOrkOqyxJkBLSSK5XT3no6nQ0jcO9Eay3XN
         xxu2a/eq21iT0xK/vBZaetVFupdgA2PAlJo/WB5g5WasiWcnfLrEsvaiYf0xNkN5XQnr
         eloi1dhAizHX7qshGbwYIDrwOA0GdjkAjqzByjCzQW2sQFe0IbsGv/keaVjI84gvQVe5
         dAdQ==
X-Gm-Message-State: AOAM533d+NG2IBwIET6diOIFxr/w2cunAWvPzgiL37NMvKqNYrgL7+7T
        Umnx/RcMgZNzR2xibHl8MjF93vYBuKHjLQ==
X-Google-Smtp-Source: ABdhPJxhIK1uj9je2D9BugBvLTnx7Y3onWSbvDN6I/+zoUjM5O74Qdv7xtOJoGyiW9jeGEhKuwjYWw==
X-Received: by 2002:a17:90a:4d84:: with SMTP id m4mr11328089pjh.145.1610725923029;
        Fri, 15 Jan 2021 07:52:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a18sm8507807pfg.107.2021.01.15.07.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 07:52:02 -0800 (PST)
Message-ID: <6001ba22.1c69fb81.1dacc.596f@mx.google.com>
Date:   Fri, 15 Jan 2021 07:52:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.215-29-ge0904e5ba4c7
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 126 runs,
 5 regressions (v4.14.215-29-ge0904e5ba4c7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 126 runs, 5 regressions (v4.14.215-29-ge09=
04e5ba4c7)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.215-29-ge0904e5ba4c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.215-29-ge0904e5ba4c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0904e5ba4c7b92b4b7c15f985cf11de0fd958f2 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6001895656bbc1299fc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001895656bbc1299fc94=
cc9
        failing since 290 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600186de8c72b92407c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600186de8c72b92407c94=
cbf
        failing since 61 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600186dd8c72b92407c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600186dd8c72b92407c94=
cba
        failing since 61 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600186d70b8f3c7151c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600186d70b8f3c7151c94=
cd5
        failing since 61 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60019ee2ffe83dbe82c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
15-29-ge0904e5ba4c7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019ee2ffe83dbe82c94=
cd0
        failing since 61 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
