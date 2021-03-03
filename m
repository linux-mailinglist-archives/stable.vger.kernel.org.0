Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC3532C84A
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382129AbhCDAfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhCDAAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:00:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96CFC0613DB
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 15:21:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id s23so5405338pji.1
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 15:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5koLjSuyqTEx0WY01ImZH/UCTPcc4N7BypZfnQADXCo=;
        b=yskzYL6DLyeW4nIEI+8KhASzncHZZ+D1IqMtzmkHqSVCZ36UmzSphBJCwKV/4yaD4m
         clLCNfXpgW3OU0EEUHxUQXDUP/eEd/T5ueq/OAC9yeTxVFkpGfwD1UPEOtvo4Xf+bIv/
         6TFE4robPMqvbHmes5n/TT/xF1D3pLkW7xx/JEmFecBW1V0B5KB+ZPVemZwL9pEOZGX2
         XREhJx675DHK7lfJAsLSoRtUN0izcjzS3+lnMcU4TukE+8MLfLWde6kvcPRbJapoPzqz
         uPrx49fArRXyg/i3XP9uwazzf5NICoCciPfLA+DT5lwN5A00M8mdo0pUZxBYwzK+TeJ0
         V98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5koLjSuyqTEx0WY01ImZH/UCTPcc4N7BypZfnQADXCo=;
        b=U74uhhYUxF8TFfe/Oha6Fs2Zs6dNl1H/wKqRXxjt9pHgq0LpyipY8FBkwkhMcpmNH9
         B4t/fgwBIYeJET8TE9sTLErFI2LnbU9NqlsBixzjIAKCtUUgONj6BH2mSB3oVNH9PsQe
         nd8oepYIyuV0Thv61ylxVQvpi+QyFn+smLbXhRjpmziouOz5JWjMCiTWsU1m4SX4smux
         D9UEG6cGK5+fiWWf5PljKjX3MGh9LQeVn8VjI2VfGCDCGjsrrVicy24fKAdqXGBLKOPU
         L5+d0oQs2WtgIrS7jl1K/1+cuh3QfgFLfpkNyc8Xq4RvPYxlc6amnRziAP6vfc2Wex/Y
         vYHA==
X-Gm-Message-State: AOAM533XdoP1xCkY2gdkqDbS/PZT65nTCr/+E4u2ZQjO+kA0DPK4l0Fb
        3osnaKOlcg5nndVi6HnMsotyD7kPShaTiBe4
X-Google-Smtp-Source: ABdhPJwXBhYZTUIhGdJY6Y98Oeemn3UUzYBOJdNyi4M7lY58PtsomGNsHt+UlkHe9hgPm8/t1p1Z2w==
X-Received: by 2002:a17:90a:5b11:: with SMTP id o17mr1534616pji.32.1614813673177;
        Wed, 03 Mar 2021 15:21:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm20687498pfo.157.2021.03.03.15.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 15:21:12 -0800 (PST)
Message-ID: <604019e8.1c69fb81.127e6.0438@mx.google.com>
Date:   Wed, 03 Mar 2021 15:21:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-134-gc13a616e215e6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 78 runs,
 3 regressions (v4.9.258-134-gc13a616e215e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 78 runs, 3 regressions (v4.9.258-134-gc13a616=
e215e6)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-134-gc13a616e215e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-134-gc13a616e215e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c13a616e215e6cff32caf7a670671e32f6767771 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fe5a3f25a324708addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-gc13a616e215e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-gc13a616e215e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fe5a3f25a324708add=
cb9
        failing since 109 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fe521c7a5614dbeaddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-gc13a616e215e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-gc13a616e215e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fe521c7a5614dbeadd=
cd3
        failing since 109 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fe535251d020098addd0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-gc13a616e215e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-gc13a616e215e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fe535251d020098add=
d0c
        failing since 109 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
