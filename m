Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34942C2F6C
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 18:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403966AbgKXR6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 12:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732036AbgKXR6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 12:58:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49479C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:58:34 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 18so11059747pli.13
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D7SjhGGpPy/90C6uuG5OOu7D2tY3KInc3rmP8aJILqE=;
        b=TbyqNHbN1CdshFGMfk0WGOZX/1gb6gXBvsSV3afrAh+AUm438rsaN60QQQpuE7lN0U
         VpftXDBms+a51jxcZOGmeI/Trw+ot+nVkRY6JwV/tqsdtFW81omTB9H3/5Z7IclfPxxF
         wlg+4YBTKIFBtx7sEbLYqn7XFJXp2tMuMctv94T7v3psLSHftbUb5GJmZ0c0KCJMm+4n
         XdeztnWxU3sf3jP6Re8zrWqAjkr5MNqxK9aYm1VU+L02qEHXhSRcDsikKWNbE4wPjVxS
         gBldgQu1pjVOZuXLnYh05nCMxH/tAgDfcHwgQNCVqtwcyPiUQkOUU8NJepjhPrgyyVY9
         tTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D7SjhGGpPy/90C6uuG5OOu7D2tY3KInc3rmP8aJILqE=;
        b=NkBgVaXVagdAchuVxMRY3gz35+SOF0+8S0H6v3ME/jz2+91XEQlR4df5nDfVFzFHzx
         6qZFriDH3pg+nqeaWTjNWrq8dQVTivk2oiQG/D5EZrCVDBbfI1SlhJBesIQODaDNnhgd
         fz+MBES+JWi7qNMo13rnucUq8Y9LizfUyid8Y4Y9nvbEEt7e4NmTXfdjqMbHI4GNuYWM
         8ubaAkDvQvtGIUD5jL9mKhSKmARsCszzkivf1ypQu3WrvBZDqZu1zJz3ItVfUF9sSe/a
         kWAO6lyTeyOAWaDl+qqHd5TTgiFojKytZ8EBCjL2HXzLf11P0rWXIKvQOGw7qdljII30
         CLqA==
X-Gm-Message-State: AOAM532JdSadMwuESZdX1PGNIZlM2a8dQkdv2spfKwhNuAkG2milPxP1
        MMhH0YqcSKYUnEQLuzLyUKp1IJ533XhXBQ==
X-Google-Smtp-Source: ABdhPJwJN2IP4cQobeCbML8qmgvj3Z1oK/yelJfLiSAm+mf1xCtqHFbluDHiZc5N7ktHEOus7JgwKg==
X-Received: by 2002:a17:902:43:b029:d9:e66c:bbfa with SMTP id 61-20020a1709020043b02900d9e66cbbfamr4896497pla.61.1606240712177;
        Tue, 24 Nov 2020 09:58:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5sm906398pgs.13.2020.11.24.09.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:58:31 -0800 (PST)
Message-ID: <5fbd49c7.1c69fb81.17a0a.1df3@mx.google.com>
Date:   Tue, 24 Nov 2020 09:58:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.159-91-g4d7b9e2c9767
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 170 runs,
 5 regressions (v4.19.159-91-g4d7b9e2c9767)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 170 runs, 5 regressions (v4.19.159-91-g4d7b9=
e2c9767)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.159-91-g4d7b9e2c9767/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.159-91-g4d7b9e2c9767
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d7b9e2c9767cb37f2a6109a4f8b267998813ad9 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd161bba52935587c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd161bba52935587c94=
ccb
        new failure (last pass: v4.19.159-91-g7dc301cfbf37) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd1659642267ff46c94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd1659642267ff46c94=
cf0
        failing since 10 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd164b642267ff46c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd164b642267ff46c94=
cba
        failing since 10 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd1648b3aa7a062cc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd1648b3aa7a062cc94=
cba
        failing since 10 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd15f6a614c98c07c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-g4d7b9e2c9767/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd15f6a614c98c07c94=
ccf
        failing since 10 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
