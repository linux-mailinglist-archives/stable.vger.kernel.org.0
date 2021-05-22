Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85238D63E
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 17:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhEVPHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhEVPHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 May 2021 11:07:37 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B026C061574
        for <stable@vger.kernel.org>; Sat, 22 May 2021 08:06:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 29so5518787pgu.11
        for <stable@vger.kernel.org>; Sat, 22 May 2021 08:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HdTg/bmKHOCxhs8Eaj4P8eKJShDHj0mWrZ45lW+nmUU=;
        b=nyxIIhldoBlySdcY4sbc5IrhX92pzADAsGxDuYy6INr12e1H4fROz11vlx7GGXYv0u
         V4oiGRcEiSw6v43Cy9DlusqvCRa0HZAIQwWvULuE3ApjpVUCzR8M7r4bXaFABQedDYI7
         NGr1fFXZkBjH2L9RgddS0rg229+Ygh1dIBKSd7YmOmuUzJewnIun0XyabqAgsYdJdJez
         3ijdmDXJKKn5WTO+hIA0Y1ALjfCoxanPJuknZZXJlnrifjYx/iH/GumUKTtI/VdeJgs6
         tOunKtJEoT/xwCCKo6Nl/kDhb9sfi2S8/H+qVfF2eybQAHaMAUmLM4m+SckHlqlqk+XH
         vYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HdTg/bmKHOCxhs8Eaj4P8eKJShDHj0mWrZ45lW+nmUU=;
        b=nAczscp1ynu/73MqU/frzz0PtQTAjhZ/FynHMmm2dSoulxfaqmVDzyAABdC4FW4NZN
         lRMqdhmD38kuH0MEWTI5Ilp+4bKDMho+O1JCXNFRud+o3KezvPrOkcuFrQLT1SVcLXLt
         OHZWurgqdokpAuvsVW//GFUprxaDS+xzT4ix1n1nEZSjd/95Pi3hucJWJDL7IIaD9Rzb
         y7eBUHNpuAv+xBhCLBBMmzgRcpUu0Kt/23tOCWs1sU4gRNE4DjZQKGHrKHhqKSb52h0g
         R6Xhon4yzjBp/Amstw2s4jT4nGBo9+nIZxyqg/Zrn14i/61T5RQ7o6X9yzsU7OWyxUAd
         Y00w==
X-Gm-Message-State: AOAM533syseWY1oMlgquhWCUbSDMH77gB2qJwjSKEeB++W54pFvh79qe
        IDlDn54C3SIJmSo/rEqD3sa5IucpNcesZumT
X-Google-Smtp-Source: ABdhPJxRODHMUyVX+fIHPT1joiidXYKJymCoFgZ5ln556GLJvmqLJRmt7C3HSzlnQ1aTpqHnVwANuA==
X-Received: by 2002:a62:1496:0:b029:2e7:2674:147 with SMTP id 144-20020a6214960000b02902e726740147mr2102366pfu.51.1621695971260;
        Sat, 22 May 2021 08:06:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22sm10823303pjp.42.2021.05.22.08.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 08:06:10 -0700 (PDT)
Message-ID: <60a91de2.1c69fb81.d127a.4b87@mx.google.com>
Date:   Sat, 22 May 2021 08:06:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.191
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 126 runs, 5 regressions (v4.19.191)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 126 runs, 5 regressions (v4.19.191)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.191/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.191
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1e986fe9ad15b8406034c504afc5ae76f0a8e852 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8e9ef4bed7c2c55b3afac

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a8e9ef4bed7c2=
c55b3afb3
        failing since 14 days (last pass: v4.19.189, first fail: v4.19.190)
        2 lines

    2021-05-22 11:24:26.431000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/98
    2021-05-22 11:24:26.441000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-05-22 11:24:26.459000+00:00  <8>[   22.829956] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8ea0e5ea674849bb3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8ea0e5ea674849bb3a=
fcf
        failing since 184 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8eb40de73c1acc5b3afbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8eb40de73c1acc5b3a=
fbc
        failing since 184 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8e9b6eb0fc4e9f3b3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8e9b6eb0fc4e9f3b3a=
fcf
        failing since 184 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a91167a7e0284135b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.191/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a91167a7e0284135b3a=
fa7
        failing since 184 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
