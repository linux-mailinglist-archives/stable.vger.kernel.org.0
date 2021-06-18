Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD973AD501
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 00:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhFRW3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 18:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbhFRW3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 18:29:10 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20220C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 15:27:00 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u190so5180087pgd.8
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 15:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4hSOonKcqqPQg8DCjzL9JnKMQy8/7hAZnhRbrI7PLwc=;
        b=2PzReMcjYV/CqQ45xHXDvTTqKVJKFO0+dd3A3K+jtlBw3ApeKpTqhMM0NG928r6WzP
         mKBQWb0bh6n2JnysJGhGgj97wezii9msfPKd0PIu2yYVjwpE4aKpyLNQg9297y5qg0/I
         YHEqa0T5J5W9Z+HukAkqxdsN20/klg3iCsbEgL1IGWbBPGiCGRt8vPWYUDn4KS9WZEll
         gxZgP68jIFajfwr1tHmHCZfgVtk4sg1BNgvdUgbYFsIUKKLL8+kR218HhfwBExi9kEYv
         m0BLGNLnhBR8kSpX+iyYNT0rPFrvC7v0oPY1gr5VgE3k/fkIpUJwSFQgzLoZB4hq2oGF
         Sk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4hSOonKcqqPQg8DCjzL9JnKMQy8/7hAZnhRbrI7PLwc=;
        b=mHY3lPZoPnqboOYQA6Cl7BH/5NeLn3QsvCrxArBhKt3652x+qkK4IZaG0WPrEZko9p
         R7pyAjafn2JK9Ad02EpRF/ek+/tA2J69UpVO8A1K0FRmFz4Re2ylXklbGGo9b7my2lSP
         yruHpnLq8LK8H/uaSLUgce2hsD3C3lZFm+L2T8ryRQ6KCNnF2v5paz5Bm9/r1+uUtcHy
         FUhffGxpMXLF3r8LpcuNsM8v1qIGPZqeyFXWmfmKHDnGsaopsU4HpOxfpwo3H/TIYQjS
         E1YKGR8WoDkGWlyoKfgEq7Y7OmJrnMB7Uh4SUWEowzKagAfKbJyQWlnh1bf1ySovULoN
         rYog==
X-Gm-Message-State: AOAM531Wvu/JswB1mqrflEJyqRrueIaXR9reP/Nur25Ev2Hm1LhQIRBq
        xJ7ODaxin9nSbvWKu3ES3Ceij11J7Yv4mPPi
X-Google-Smtp-Source: ABdhPJxcjwVP+8vS2BETJ7EzffmuOru4G7vc8oR4Du2K59ko8egRlfXTq+egINcFiSgiEAiduDAncw==
X-Received: by 2002:a63:5c04:: with SMTP id q4mr12000804pgb.127.1624055219452;
        Fri, 18 Jun 2021 15:26:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j24sm8847650pfe.58.2021.06.18.15.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:26:58 -0700 (PDT)
Message-ID: <60cd1db2.1c69fb81.d54b7.912d@mx.google.com>
Date:   Fri, 18 Jun 2021 15:26:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-25-g88c198632eb2
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 4 regressions (v4.19.195-25-g88c198632eb2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 4 regressions (v4.19.195-25-g88c19=
8632eb2)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.195-25-g88c198632eb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-25-g88c198632eb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88c198632eb265188a1aa5612290bcf0412ba0b9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccea41f728abc20941327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccea41f728abc209413=
27c
        failing since 216 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccf269ac35884ce2413272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccf269ac35884ce2413=
273
        failing since 216 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccea4aed3608b50e413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccea4aed3608b50e413=
267
        failing since 216 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd179080ba0eb112413279

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-25-g88c198632eb2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd179080ba0eb112413=
27a
        failing since 216 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
