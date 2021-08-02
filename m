Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098163DD109
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 09:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhHBHNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 03:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhHBHNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 03:13:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFF2C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 00:13:25 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k1so18639004plt.12
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 00:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ypBHyUnIZWCdPnrOijbYZQr8HpglEkJ1BAvWhU1W5Sc=;
        b=CLTnGqVbVI1X9/E1q7pUvS4WT7GPRBbtvLoENCsdLLAfrOgW/8VYy/MDn2f+wdcXNS
         vs0VSQUTTu7qyOL2P1mDez8F+VEEZRqPiLIP5+2p2DBbbNENoeE6Y0vTkYCqFN3+PRn4
         fTNJ4m7LNd5tn3r2VOC3Y5MoMHFj1JRkQFJni2wfIxcNRCurKjP2+QptJqztn0Fc+pl5
         Gy56mpKD+YyTwGnp3a9hIS5pE3syZbazhf/HN6uS8Jh5gbjuWLAzRlMYpBXH0L7x5yz0
         50TOq4idHF18XdzOD4LZEl6O33tkRdWeHz9+I91fvCevhUVbE6FuUybjLbsYzJSNnsti
         apeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ypBHyUnIZWCdPnrOijbYZQr8HpglEkJ1BAvWhU1W5Sc=;
        b=pJtbAfyh3DOg06HrWVcjTXrzXJM8VrGo+Uf7LOByx8XK51B0hBQwIuLVFZBEI2M8u5
         ya/vYWx7X0LB2haLRd+kK6MqP6BJnzfBPx41wQ8mE0JZpElxABYXCc8PyrmQt3tUD1yx
         yC2xR3t9S/BfYuHWxaAVaXiUwi16NydaoKKQbLgjhWGyiosa/O593Kk6EPDo0yPYBQSq
         bG156UdOj0Wzj+f7YpWNc2ZF2/Kd4UDCLcq5gjwipbZAKMPb+vqYHc7fJM68Ikzty6fM
         w/2gp2k4/D7T0645p5crjmeaxtJvR0JUPSIbBQqUd4mId2LkW+qJdFx2M99vnDh66J71
         ykvQ==
X-Gm-Message-State: AOAM531ORN2ku533KOPrFzFJO7W3K8Rl+puslMLJ/lyPY/hMo8Tq/rTl
        COU5bEqeqAIKtj4N97uj6kAykf/65qHisxrV
X-Google-Smtp-Source: ABdhPJwEgoGRHj6Ly36RNjMtQXmSW81kHqvdRGJTKFREvTab6sfvKUM2VzWsE/ZnD0hpQTcu3GVQWg==
X-Received: by 2002:a63:5945:: with SMTP id j5mr824245pgm.104.1627888405108;
        Mon, 02 Aug 2021 00:13:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm10408898pfc.157.2021.08.02.00.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 00:13:24 -0700 (PDT)
Message-ID: <61079b14.1c69fb81.54b83.ddb6@mx.google.com>
Date:   Mon, 02 Aug 2021 00:13:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.277-32-gf64739723b62
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 142 runs,
 5 regressions (v4.9.277-32-gf64739723b62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 142 runs, 5 regressions (v4.9.277-32-gf647397=
23b62)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.277-32-gf64739723b62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-32-gf64739723b62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f64739723b62add0058ddeef80bc476747f91cf5 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6107623b4730c65ee585f462

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107623b4730c65ee585f=
463
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610762380d89c5894585f48c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610762380d89c5894585f=
48d
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610762480d89c5894585f491

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610762480d89c5894585f=
492
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61078190d00bdc4efb85f464

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61078190d00bdc4efb85f=
465
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610761f2fc364cdf5e85f477

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
2-gf64739723b62/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610761f2fc364cdf5e85f=
478
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
