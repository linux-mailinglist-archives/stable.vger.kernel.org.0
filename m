Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89472D6AFB
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 00:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388150AbgLJWbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 17:31:14 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44289 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405120AbgLJWYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 17:24:51 -0500
Received: by mail-pg1-f170.google.com with SMTP id t3so5577967pgi.11
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 14:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9c1m/EMxEw8374Y20d39KnGql1wjXo7U5N+rDVYjYUg=;
        b=rmXwAfizIT+hAHpPK4qKXdH0/36Ip6O/9Am1QNjFqe+0IFmCfhz0BG2M9xKhQ5qpiy
         XClafQxSuxYjcUGAuebWbiGzq39s3AR5whPI1wcsQ6SfA9lEDN78DCL7HLIKm+tsKmfd
         o5gdk+5LMInuBXvm/byvgQv++P0+PXif+oSx7A51uD/e21Xe5YS1RUE6C0RJjVQAAiFk
         hMVGEStZA1AARcAVlmX2CQSIC4kFZjqNO1GikZBRsRLxhxwG53HXsaiN0ahLJug7sMIG
         /Sbeb7Yne2bUnnoXzVNc8974UiUm5JPofCBJQkIsP9Tl+UquYP6A6trFLO2mN++y5jI+
         z3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9c1m/EMxEw8374Y20d39KnGql1wjXo7U5N+rDVYjYUg=;
        b=j/oqUqc5fQg4NQvcm6AN+N2sHW3iD72wqdbqapx78QxkTGuYFbOWLfCQznhj1oDn5Z
         u8gPATy935XKfYjkG77SiRXrbRA6SsSwZtTCczckpQj/6rFGOjeOUyqf43XpmsxilDWs
         gK0272+HAATkI0Jcg7PJWkw/J14eZ1M0Z5Sn4n1yECSg/OLeHuKFo9qx3uQrXv5mqow3
         c7Sx6OMh1uwC6EToKUtnjZy2kQFLb3I1yV9GStpsst6nemK2y0RVcw16SyW1VHgkLfx0
         tssr/9uagXTPEvPLVIj8DFUk1gyoeK9elPMYnlunnk/h6WulcMDYImo/ppFHS8p4zxmx
         SENw==
X-Gm-Message-State: AOAM532CrUF2co1TWfgBIUaYn50rbFvIMpd/CUzW3SCavUV5a9JPdiT5
        8iwuspEWM9AvCVHnvCaqWVSB/vodsqbZgQ==
X-Google-Smtp-Source: ABdhPJwlwzqkl44nHyPWfFjFbZyxWznQ4jMVAJIrc8CPYkEQ/Hs/KC5vsAZKj02eX4DUwNA5wIEJWg==
X-Received: by 2002:aa7:82c5:0:b029:19a:aaac:9b4c with SMTP id f5-20020aa782c50000b029019aaaac9b4cmr8617091pfn.75.1607638987727;
        Thu, 10 Dec 2020 14:23:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 129sm7697695pfw.86.2020.12.10.14.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 14:23:07 -0800 (PST)
Message-ID: <5fd29fcb.1c69fb81.57c53.e601@mx.google.com>
Date:   Thu, 10 Dec 2020 14:23:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162-40-gbaa0b97cc4354
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 162 runs,
 5 regressions (v4.19.162-40-gbaa0b97cc4354)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 162 runs, 5 regressions (v4.19.162-40-gbaa0b=
97cc4354)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.162-40-gbaa0b97cc4354/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.162-40-gbaa0b97cc4354
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      baa0b97cc43546762fb574b0981e16f4e7e87818 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd26d2dca5934eebfc94cea

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd26d2dca5934e=
ebfc94cef
        new failure (last pass: v4.19.162-27-g7042181619c5)
        2 lines

    2020-12-10 18:47:04.939000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd26c7cc03259dc36c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd26c7cc03259dc36c94=
cc3
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd26c9d444b23ea5fc94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd26c9d444b23ea5fc94=
cc0
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd26c7fc03259dc36c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd26c7fc03259dc36c94=
cc9
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd26c2b91ff9870fac94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-40-gbaa0b97cc4354/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd26c2b91ff9870fac94=
ce7
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
