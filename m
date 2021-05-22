Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735F238D66E
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 18:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhEVQIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 12:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhEVQIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 May 2021 12:08:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE5AC061574
        for <stable@vger.kernel.org>; Sat, 22 May 2021 09:06:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z4so10310772plg.8
        for <stable@vger.kernel.org>; Sat, 22 May 2021 09:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0S5DxImNlGG9ASz/6hgnB3yoo7YHD4iGy6vGmSJkr7I=;
        b=MUI7M4l4+s48qSGJHLCZhIa2HydcSa62Sa3C8mUh9YicN+81xVbt36glwe3olykFro
         x2bFJ7Kqf4H4th4R6Cu+2bz2440fSCMv8/C3eVTo5LiXyHnJla07fsdzxFzwR5HTsOZj
         xFQ2bY/c2Vod4Vzr3DkJC1k4WN2puxroyDZDJwS85GGRwOuOMNoqqRMZKtMp/VsqF4vo
         o2LyHARPXIlN4yiXPJ/5wzbgQs1tDVZ1PvR4omYBVwA8qvU9lLQLUsf/4lO9BoLsPrJZ
         0wRz6G9Yhf7ww/CH5gJi0l+WxIPHS66dIhIxxOi1LfZzochKBzhxLXhoiUbMpk6D5X+J
         8xBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0S5DxImNlGG9ASz/6hgnB3yoo7YHD4iGy6vGmSJkr7I=;
        b=bVLNp1sHnYPVR26e6hajX760cVBYVEohlfnKckMFCK2yFb072YErmOeRa/Pq7u6xhE
         +3bLDs5h0Rc1QMu8RLRYbKfjdhKQRwBf/pxL1or5TNw3+8zUT+qV1zuhtZuizzDxDYHi
         U224jGp4WXL+dTw99BiShGBSPoeZlcUXMqpOVhv1EQimKcZUCDtH2eZ8Y3T2ljA1sz0J
         bvw4w6DgzAxypiKqoMgyim3UYNIU5Pu2JJZpZ35LZ1xFOQ3/xBxW6AsuqRNxhe0DqMIL
         a97fhzE4Oh7vQFgW6a2eDieLlo/hARgehzql209KaHzzJGArIkbnTO5eVJlTB4Kn3dPG
         ZDOg==
X-Gm-Message-State: AOAM533FlfXHKSystxvITD1DMwyfJsbM1Ly6IXJR2Vr0PaRFC4Mfivlf
        9cp2foepUuu5EFma/WBhjV8n2e0ddkakwmZZ
X-Google-Smtp-Source: ABdhPJxHnpnSBatKvYDfpAYhJkkKJi+Imo6EuQkwaNU6XAz7zLFbEqnhVUC/qVt/k5pGb8VLYv1hsg==
X-Received: by 2002:a17:903:2082:b029:f6:9d83:3ede with SMTP id d2-20020a1709032082b02900f69d833edemr12020443plc.40.1621699617869;
        Sat, 22 May 2021 09:06:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12sm7299846pgi.44.2021.05.22.09.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 09:06:57 -0700 (PDT)
Message-ID: <60a92c21.1c69fb81.1c2cc.8478@mx.google.com>
Date:   Sat, 22 May 2021 09:06:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-424-gad52cac0a8f5
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 126 runs,
 4 regressions (v4.19.190-424-gad52cac0a8f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 126 runs, 4 regressions (v4.19.190-424-gad52=
cac0a8f5)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-424-gad52cac0a8f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-424-gad52cac0a8f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad52cac0a8f5b951aeba674ecec28de7e1c6e08f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8f6efe2ea0a9790b3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8f6efe2ea0a9790b3a=
f9e
        failing since 189 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8f703b9655a93e5b3b0ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8f703b9655a93e5b3b=
0eb
        failing since 189 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8f6a89d6e9b9574b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8f6a89d6e9b9574b3a=
fa4
        failing since 189 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a912e17e1408204eb3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gad52cac0a8f5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a912e27e1408204eb3a=
f9b
        failing since 189 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
