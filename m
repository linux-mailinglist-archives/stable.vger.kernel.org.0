Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A67140160E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 07:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhIFFxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 01:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhIFFxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 01:53:14 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DF6C061575
        for <stable@vger.kernel.org>; Sun,  5 Sep 2021 22:52:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t1so5671481pgv.3
        for <stable@vger.kernel.org>; Sun, 05 Sep 2021 22:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4dvyc/af6fEhvWN7zhm44XlzNhAgXOR6BPsddaz3UA0=;
        b=dlfuVOyl0xdBCPpJThUu5qcWvAA2J17r38MIYCkJzMZjfqfWyVSkz7pBCu11YIa4eW
         d9OHNguNi0bdl/yHdLLGdoJDl6dutnYJRbOK6s4OwVQKgLCu3pxSpbnaGZpxDlZ8jcBV
         1u4yscpOXY9aZ66irdtmBzIeKeOl42A2Hy/+beE2gH3z+020OYzboV4RMJOo60I0grFn
         GAqHI44KrlZXkVnN/j3NraKrzHWUYTAybYbYxksDVLWa1qmVnZACEXratUd5LLsLsyfk
         XaVI/epz1hj7NGuroBAe99sqJtCOmRSVUMo5XUS+iimoEEtRfsw7ht1doXjdu9Yp8ZPF
         mW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4dvyc/af6fEhvWN7zhm44XlzNhAgXOR6BPsddaz3UA0=;
        b=DnL8DpZHkWnTXTYZxct/lKnT6QH8Us0JDnsmm3jsPy0i3gvyiUXXriGtIJqSeah5Ur
         pcFCvq9UsP3bxTwMA50iUmKMi6QZXegxCyRqzRQznDu+Jwfslyo8L3hbuhVVYx4TeHsJ
         j2NBBXYqeGyOQnstp+FNniSPYSATZtTyeHdMYPGMatNhmfXOZhZvzQJlPPAXEH0PiDnl
         Wv51RP2PbLiFXnmGWmRhrauevuaAkklV2YX7lA6pygWgHno61fXEUqbRmZhmLbRNnk+w
         bxx8GhvM2JftXbOkp90i/TEAXz9d4EbrBKAzgfrDGWQRoPUJmf6xl2azt97hCMaMxWW9
         raxQ==
X-Gm-Message-State: AOAM531j8/uNeiNaHUSR9pvraJfM8j6395sek0Hv0iURf2N4f7/OGq4o
        CbP5adeYEZcp9I2Ygb19l3FxuSTtT3Ff/V6G
X-Google-Smtp-Source: ABdhPJxxSzh3g8GEW7TakYv8/9pItV5OyAUNbK+KVjfPWoGX0xy3YCQVs8erTk5a3G1qzmmrA2DbYA==
X-Received: by 2002:a65:404d:: with SMTP id h13mr10811212pgp.130.1630907529483;
        Sun, 05 Sep 2021 22:52:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b27sm7395903pge.52.2021.09.05.22.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 22:52:09 -0700 (PDT)
Message-ID: <6135ac89.1c69fb81.23868.5a18@mx.google.com>
Date:   Sun, 05 Sep 2021 22:52:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-15-g3835d2f168e4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 213 runs,
 4 regressions (v5.13.14-15-g3835d2f168e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 213 runs, 4 regressions (v5.13.14-15-g3835d2=
f168e4)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.14-15-g3835d2f168e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.14-15-g3835d2f168e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3835d2f168e480dd434ecf41382b9ce2cf430c8b =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61357cc6eb49e9f024d5967e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61357cc6eb49e9f024d59=
67f
        failing since 1 day (last pass: v5.13.14-2-g1b53bca7aeb0, first fai=
l: v5.13.14-2-g74aad924bd80) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61357b72671caa7da6d5969f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61357b72671caa7da6d59=
6a0
        failing since 39 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61357c0181c7fdb73ed59693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61357c0181c7fdb73ed59=
694
        failing since 1 day (last pass: v5.13.14-2-g1b53bca7aeb0, first fai=
l: v5.13.14-2-g74aad924bd80) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61357b1373c9767ef5d59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
15-g3835d2f168e4/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61357b1373c9767ef5d59=
675
        failing since 1 day (last pass: v5.13.14-2-g1b53bca7aeb0, first fai=
l: v5.13.14-2-g74aad924bd80) =

 =20
