Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59483827DD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 11:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhEQJNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 05:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbhEQJLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 05:11:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57338C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 02:09:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t30so4203627pgl.8
        for <stable@vger.kernel.org>; Mon, 17 May 2021 02:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=foY+dm/Dds4ONBQyM/zQZ5LmQ875kUJ5bJszMnT0XYI=;
        b=QqQXm1EjYJlMuIB6iwWfjrSRvkTAdqTbdRgn6Pn5M1qsklwG+mSFlp7+lyxYdZxXDR
         WvGyDex3//XpqWcE1vi9CRgIo9UK9KT0rGugATfbIlqGTldWHurZsaTmdcJF/V0jeFuJ
         p8Ibs1zfri1pWuda4vN8iwppnF44fzdHdB9uW0NiWNQ78s+Q4zW69jtkurvL1DF0sZeR
         JnKJSndWTFX/bJxJXm8q/dbjCDHUef2PHyh+CThnp8nuCA0MvclUBkJCdr/aiT9hFMxG
         h5kKuTcAJNZxen83QHnde92ZIgYJ4uleU1M8fVHpP9jwY6rlJSuXocstQ7PS0u83LdZy
         12Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=foY+dm/Dds4ONBQyM/zQZ5LmQ875kUJ5bJszMnT0XYI=;
        b=YCPj/dFbtngDAMDEah+54pU3gNSK69THqDdS1c0Ll5gVad/eJXutz8qAfZVS2XEYJO
         8vco8IuhVFKALxXPSWUm5vUhHoiiaGVe+Uj3KAG26JCHEaUdsZt8EHXzV/Aq2tvzTn9M
         FWU4uPewFh212+2R2K5/XY/b15isJIKzwW6WuPjtpU101kM4b9OqGpcQ+y285SXsqok0
         IImoOIoC7Oe/RV6uOst8lqT4AIZZ65/kLBsSWziemWFXTVptkcC7TesSIdEOEtZq+xko
         55aq0sy/fH+sCsyCdODFcEiR685RTORL3Z/E6nhcrSE+Zy9+Qcj2Gxk6uXh124a+y8M3
         hsSQ==
X-Gm-Message-State: AOAM533jdLad3x5M70TaRkeWi21z3D3sWLNH3UsG1X1j6A4oEh9uy2Ge
        AzP6Ri0+lcIAc7Cs+Zh4SM5cU2tO4KUXHek3
X-Google-Smtp-Source: ABdhPJxOzdgetIIjzQmavVrTg9CLkicqBSBtTjKZmvc3teZ8JTsKQes1Za9Jf8e9WXVSdk/OacZPIw==
X-Received: by 2002:a63:7158:: with SMTP id b24mr59938013pgn.310.1621242589682;
        Mon, 17 May 2021 02:09:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5sm4381223pjo.34.2021.05.17.02.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:09:49 -0700 (PDT)
Message-ID: <60a232dd.1c69fb81.d8343.dab7@mx.google.com>
Date:   Mon, 17 May 2021 02:09:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-373-g3d6b7bbfa574
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 134 runs,
 4 regressions (v4.19.190-373-g3d6b7bbfa574)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 134 runs, 4 regressions (v4.19.190-373-g3d6b=
7bbfa574)

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
nel/v4.19.190-373-g3d6b7bbfa574/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-373-g3d6b7bbfa574
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3d6b7bbfa574f63deb51f6cac0779fdcf9c8fffd =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fecaeead9f21a5b3afd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fecaeead9f21a5b3a=
fd4
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fed2f8ab01f41fb3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fed2f8ab01f41fb3a=
fa5
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fee1ee6d1a3387b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fee1ee6d1a3387b3a=
fa8
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fe85e566087477b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-373-g3d6b7bbfa574/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fe85e566087477b3a=
f9d
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
