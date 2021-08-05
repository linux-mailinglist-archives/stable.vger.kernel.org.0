Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4953E1E86
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 00:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbhHEWSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 18:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHEWSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 18:18:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFFFC0613D5
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 15:18:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so13112820pjb.2
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 15:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GPPNWZclYbP00IWnb9lMnwfHwsiK1p3KWB51b2Zpnoc=;
        b=z3/fLFPKUIYIB/UjIl6KLwDADGtukKC5M4oMHjjZzgRsFOILHv8635Yo1FGswGWj7D
         NVd4+x9v0R+pKQqqJtpxrvTvhQR+xpe2p1bex1kIsZXjnQJ1Fe/2Wb3YAmVQbVAqKTkv
         VSa+/vKa25NThIIlevVp0heSWiWAaVAsuhzDA7fj91m5ZD15Nbj3luv2OP04iSF+BbvC
         6HQOql/596otmYZQMMO+uN3eUWhP6HakEbWZUJSRI6VSNm4saJ6bBDXUd38jLFOGOei6
         L744SA7yW5FnXgM//36sCDvG5Juq0PXqT8ecwDiaQVH2ZThqMSq8eRq/Oa1ASKEuMNZ6
         2ywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GPPNWZclYbP00IWnb9lMnwfHwsiK1p3KWB51b2Zpnoc=;
        b=Ab5j4wmHv01r+/tu+RnBsOkBAoEq1VMEUqkWF3VbxnKFw69txCX4KppuwiUMN2+uxY
         4mRddMZKJ3nNWgLjiXXaUfkwc+vnjyl8ye5cGug4MNm7p7jwxM6UANWQZ4SuyEk20jUw
         uI5fDohCkNJMXE0SW3fkSd946A/KxcbdZFjBneRnfiMwdu9LjugRP1XYlDhwBz0abJyN
         csDZVWt8MVwq4rv407apy4pKP62atKwnjj8hWRYmKvjm4tfEFQDvAAUfelBnV1SM/3CM
         TRDLmUcmUDkmzbzERYHjwTHUnhb6x1/qIG3C2dgBaORsncHOZWJCZKbJPnafPkKPJwhq
         ObbQ==
X-Gm-Message-State: AOAM532JapdRSvyqlCAUW0N+MdO3CPFB3kNPF0LiFsnCmXG+Mlld/pbD
        j2ezlWMN2EKPd5DYhxl9xlGZjiTIS66CArqv
X-Google-Smtp-Source: ABdhPJwVinrA4+AeAPxQz79itcJIwwMSh+4wLpxQ3ZWT7RvPiX41KredWIgz8NuuYfv6hLj4ApTEaw==
X-Received: by 2002:a17:902:c205:b029:12c:dda2:30c2 with SMTP id 5-20020a170902c205b029012cdda230c2mr5737214pll.74.1628201899861;
        Thu, 05 Aug 2021 15:18:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm7738479pfi.55.2021.08.05.15.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 15:18:19 -0700 (PDT)
Message-ID: <610c63ab.1c69fb81.a0972.841b@mx.google.com>
Date:   Thu, 05 Aug 2021 15:18:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-9-g95de2c523b1c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 76 runs,
 3 regressions (v4.19.201-9-g95de2c523b1c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 76 runs, 3 regressions (v4.19.201-9-g95de2c5=
23b1c)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-9-g95de2c523b1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-9-g95de2c523b1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95de2c523b1c3e2f3d26ea8055d408dbe13f8aec =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c2e4fbe8ad5ea79b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-g95de2c523b1c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-g95de2c523b1c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c2e4fbe8ad5ea79b13=
66e
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c2e3bacb4a80100b13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-g95de2c523b1c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-g95de2c523b1c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c2e3bacb4a80100b13=
664
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c4aeff6ff5718c3b13673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-g95de2c523b1c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-g95de2c523b1c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c4aeff6ff5718c3b13=
674
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
