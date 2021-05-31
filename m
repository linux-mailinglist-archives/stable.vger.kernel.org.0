Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD663967C9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhEaS11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhEaS10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:26 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B3EC061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 11:25:44 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so48603pjs.2
        for <stable@vger.kernel.org>; Mon, 31 May 2021 11:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sYKmec1T/sf/ssrY3olhJ6kOkhJiPYIzoRlOr7ka0AI=;
        b=UasV6R6V0rJ0RTQ+h2veqAQj3ROoXFv1R1lqJbkBla1igXtLFqVCey3vLuZ9MoLqKh
         PDBjLIfKFpOrTZwguw3tjBaDf/VUwmKDAA67ns+8L2pKtigCnuZxdj1oTDKQQVJUobS3
         xIMTjkRsSrnFExSz1nk60r3dNncKwinw6/9K+tJccEH2IsphHfcRCtBMjf414ksvEums
         hNjKaU91uIhxYMUFPhRyAi/msHlfi9hFKa6zIS9j6F+jtvUuZVvrhM6oigHarWDlrrA1
         A3kBy3wFSybwLcW0LO2DR4uH9t+gkPmjxGWFN7Xhk80QEl8KQJfyQ/NbGQY/aC5ojGEl
         TNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sYKmec1T/sf/ssrY3olhJ6kOkhJiPYIzoRlOr7ka0AI=;
        b=RiTlctG9V/4qASm64P9o9cCItLQGblhXQA9FhdKKkv1a/CDSjGgbLTeh+txf0cuMZu
         URge9P/+/JV1q1zEOJiifF8swNP41DvXf8YGxM0R47J79wVdlZXD1NrHD1Hdp2ULPhOY
         /6kX24s/mAl34m5NXjpfQX5eBSRLL5UAaav+lxjcCmxiRw1O0GHsSadZzHZn0bcnDQ9o
         NCX5GeivHIRtSiIbvYHLCA/ZlxbTfgjjTC9duVpjBgQtQ0dItfZ6fzwm6xCNo4dQGqAk
         TENeSKaXbl20S775TmVwjM+9B0HSQ6g9Ou44wdFITL/nNZfbzUtWefcCUOZ3+umtYl+U
         JV/g==
X-Gm-Message-State: AOAM532Ig2KIbvpdYs7qGloyIL8WqqzR+wtUDwniU7QlqN9f+SqOsVVb
        s1D7SklAWLpkCucFUfeaCPJwUFR9TYikunSm
X-Google-Smtp-Source: ABdhPJwWxDERAo82S9b9xDnChEFvGjaBRa+i2pJDdKAMP+CAwp1rLQWhQGnH/4LITcpK01jeZGpSjQ==
X-Received: by 2002:a17:902:9001:b029:ee:f24a:7e7d with SMTP id a1-20020a1709029001b02900eef24a7e7dmr21611952plp.42.1622485544235;
        Mon, 31 May 2021 11:25:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m191sm12131458pga.88.2021.05.31.11.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 11:25:43 -0700 (PDT)
Message-ID: <60b52a27.1c69fb81.c06da.5a98@mx.google.com>
Date:   Mon, 31 May 2021 11:25:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-117-ga36d95367696
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 130 runs,
 4 regressions (v4.19.192-117-ga36d95367696)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 130 runs, 4 regressions (v4.19.192-117-ga3=
6d95367696)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.192-117-ga36d95367696/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.192-117-ga36d95367696
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a36d9536769615470fb664509e528787a54a26fa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4ee322b40e3d63fb3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4ee322b40e3d63fb3a=
fbf
        failing since 194 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4ee3a9cdf8007e9b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4ee3a9cdf8007e9b3a=
f9a
        failing since 194 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4ee3c10adcdb4e6b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4ee3c10adcdb4e6b3a=
f9a
        failing since 194 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4fddcd2356aa35bb3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-117-ga36d95367696/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4fddcd2356aa35bb3a=
fb0
        failing since 194 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
