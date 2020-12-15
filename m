Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE562DA7EF
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 07:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgLOGE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 01:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgLOGEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 01:04:25 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345CEC061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:03:45 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id s21so13807382pfu.13
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uYUdLB6udjFxUJlESwJXpOMDLC5scN/weLgHow4/TOo=;
        b=1Dn46mdBEdlY4HrSI252hSpbRje0OarUtuRyHeh+Z7pGxbXuw8O7aKn5PXL77G6O6X
         dKf6Fv0E/sLpc2Wg8Y79lkHxrOJaYT0KmzbCg+bxjm+uxPPE09HaUreJZiA/4JMxo3M+
         /EqwuYmjM9a1etBBS4G1AXbgYUiXDu3R96bGfdlwd/wrOBVOZ4TX6lSVV96upLeVY//n
         +FAA2AUs2BCE8izsqttdNo+D8VSSO3yu7iKfNfvD7NQqCQ+ogNaSUnFed7/nj9kCl8CZ
         OMz2ZfnXWS1fPEv5U9uRFPgkQiMHIrYWamPhdXLzqQIu9h90j6C4Mrf9okEXQXJJxXPw
         OPKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uYUdLB6udjFxUJlESwJXpOMDLC5scN/weLgHow4/TOo=;
        b=j5BkQyvL5n4tzIV/ypADnBKu3Ze3cq0CdXTjIv0UJXrhGKLnAUROuGaJaXCvvvFCZn
         m0LvN/KtC9F01BA+8bBH8r8ktl5sxGMGyzgb2/pF5EJ+PnwQ7N5WPLniMvbjdC/u5XLl
         6hWNSKrlicJXnhgS4l+/b2CtJwQIqpsOmPCAOOInYbEX4eoHt4952ZMm8lwj1v87KiyQ
         GinmJeW/l+KfmjuK41vhqEzMoaOu3mBpyP8PU5Ts0y50InpsMMxoefJNJRcKVQfaHhpI
         miwOQmpuJWVSdCjQL6/qnPED0NuSiwkiAaYCql2B/qQE1FF0o54mJXAaanrnZECGdUoh
         mLjQ==
X-Gm-Message-State: AOAM531YDB54R0Z4LXL0JsAFZelsXzMbF39geYFvu0tD5Z84fY85SDjL
        +JFPvdR5pL9BWm8pTWrkrSkx6Qmq01BFNg==
X-Google-Smtp-Source: ABdhPJyL8NHIQiuvgwNVfvwMcofuiLIjDPVaEpBTs/bt8HkMch/Ov3SvEv6ULGeV3D6Rbwhx3ZvE3w==
X-Received: by 2002:a63:4956:: with SMTP id y22mr27352137pgk.266.1608012224207;
        Mon, 14 Dec 2020 22:03:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm23110244pfb.104.2020.12.14.22.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:03:43 -0800 (PST)
Message-ID: <5fd851bf.1c69fb81.18ef6.ffa7@mx.google.com>
Date:   Mon, 14 Dec 2020 22:03:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-11-ga3f32b90fa44
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 6 regressions (v4.9.248-11-ga3f32b90fa44)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 6 regressions (v4.9.248-11-ga3f32b9=
0fa44)

Regressions Summary
-------------------

platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =

panda                      | arm  | lab-collabora   | gcc-8    | omap2plus_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-baylibre    | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-cip         | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-linaro-lkft | gcc-8    | versatile_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-11-ga3f32b90fa44/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-11-ga3f32b90fa44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3f32b90fa44080665f50469c213719676b4dc7a =



Test Regressions
---------------- =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81e8af63397e552c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81e8af63397e552c94=
cdb
        new failure (last pass: v4.9.248-6-g1d3e7d6f3f6f7) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
panda                      | arm  | lab-collabora   | gcc-8    | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81fa4f2c2e59b27c94ccb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd81fa4f2c2e59=
b27c94cd0
        new failure (last pass: v4.9.248-6-g1d3e7d6f3f6f7)
        2 lines

    2020-12-15 02:29:52.190000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-baylibre    | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81c4bd9fede5b88c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81c4bd9fede5b88c94=
cc1
        failing since 31 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-cip         | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81c611a646a38d8c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81c611a646a38d8c94=
cc8
        failing since 31 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81bff5dcd4e4edac94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81bff5dcd4e4edac94=
cca
        failing since 31 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-linaro-lkft | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd85141696b4f99a0c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-ga3f32b90fa44/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd85141696b4f99a0c94=
ce3
        failing since 31 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
