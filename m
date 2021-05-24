Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF4E38DF36
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 04:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhEXCam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 May 2021 22:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbhEXCam (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 May 2021 22:30:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B5FC061574
        for <stable@vger.kernel.org>; Sun, 23 May 2021 19:29:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10271012pjv.1
        for <stable@vger.kernel.org>; Sun, 23 May 2021 19:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BmDWUNc5yxg1pmXX9c0lxfRwK0ZiJLXss6FboOUscsI=;
        b=F8lcdjsQnDjgrEICYAFwLcKqMsevnIWiKb2n9bPAdP6m+4pnhAn+sKYGyt4tltfIPH
         aoSwkR8uNyoAtH65e2yUgmndS3t3CyjR7VJKJC3ppDBIu3jYNYlN5TzwTfAO3IiAqjKO
         +C4SX4EYaWVSwyTI+2XurEwkLVxxX2X7nAP9a9j2d31VjB8hxhg4btsj6VjiF2ozJ9HG
         QTnZEzHL2vKVQar2cnzGVNhkPHE/wXSj8e5EwhyR/3wLLdHL8UhoDSvPLBAYFLwCkwv6
         xD5phwhVTdB9fMJt/vbgODhvwH7rSNctQ4tHUUAUnSBlRjR+tN+8FRS40huIuTADvbiH
         ovGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BmDWUNc5yxg1pmXX9c0lxfRwK0ZiJLXss6FboOUscsI=;
        b=AwrKRALwQBiY762brlmzxBwqBIybbHzu4tFQi/N8VxkGAEcl2oR3UqUdRAmnKdJf0e
         9Cw+bEadSPKq9YqHf/sUo7ecp+qNw3eawQygVnFrMCbskXEMAuP398L9Ytr4d6ZafA2Y
         mXRYik6+ujZBQ2br00+M1UbRJrinyquq/OA2qWZy19NGI6gDKe/e22k5j2X2wcsO3p2I
         TlOLroYhlFalccZViYCN647p0lqbOuO6xaOgPUui2fsbxVWyvgs8Ka90qYMuE/TfwL3Z
         TCYvVj+U/9l0sTFPqXeAFvYeSAYNgaoEGcy7N8SwpG95e4i1mZaL3ODqHiXLhnNYcgB4
         3w8w==
X-Gm-Message-State: AOAM53209+asyhmoKNDIH1JXE/1jpli0bcTCba7eHuMEJYphC6TBXrle
        YnsphBWePwKPabQBH9uxhkngFm2tLuf8bjlp
X-Google-Smtp-Source: ABdhPJxQZMNpQnu8p/ZUCPcDPRzvpou8gY4Lzy454KRfG0suvAjLBGTEutOy9LcfHDOI75yk6dQwgw==
X-Received: by 2002:a17:903:22d1:b029:f2:67be:82fb with SMTP id y17-20020a17090322d1b02900f267be82fbmr23116006plg.15.1621823354401;
        Sun, 23 May 2021 19:29:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s12sm13445191pji.5.2021.05.23.19.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 19:29:14 -0700 (PDT)
Message-ID: <60ab0f7a.1c69fb81.751e0.ddfd@mx.google.com>
Date:   Sun, 23 May 2021 19:29:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-433-ga1bcf11cef15
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 109 runs,
 4 regressions (v4.19.190-433-ga1bcf11cef15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 109 runs, 4 regressions (v4.19.190-433-ga1bc=
f11cef15)

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
nel/v4.19.190-433-ga1bcf11cef15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-433-ga1bcf11cef15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1bcf11cef155020793dd7dbd2d760d928b5a786 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aadbb99e4564da25b3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aadbb99e4564da25b3a=
fc7
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aadb9eb7470b3d20b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aadb9eb7470b3d20b3a=
faa
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aadb4f4365c4eeceb3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aadb4f4365c4eeceb3a=
fc8
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aadb29dc2c870bd3b3afbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-433-ga1bcf11cef15/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aadb29dc2c870bd3b3a=
fc0
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
