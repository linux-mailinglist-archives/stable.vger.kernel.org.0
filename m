Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9D0311FCF
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 20:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBFTzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 14:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFTza (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 14:55:30 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9237EC06174A
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 11:54:50 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d26so5457641pfn.5
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 11:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uHL52fmVyt2huAV6YzKgcTdkANe+frEbnItblVC2+xo=;
        b=lLMk0pWfGNiDWJY+tWhcFAGCZua7EifeIPa2fspzUtMf1j1UCK4Zwtf/31d73mINYK
         me3yJ6ydnVxRjtMAOq0Oi7l9JynZ4wDqGPflp2SxPM11ZHdlShRkP/4WKDPMrkdCtI76
         zn8ZzUFSzjUCDdgY3jNBOlajiGLBHAP6R3mUqEuVDdY82HiYPwJ/iFOVWs3cM352yUeL
         o+S+LAp5FdsY17rkjp18wxwAaNx9MisWm2gvEyH6E1e3x8VeZu8YrR8bBzjONzbagnfy
         fjr5ZUqpW1UIw3sUaC12Potbp/O7NEgzYudxVOPiqqsaivWDQcPMYONxYRrUqP1Zdreu
         D1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uHL52fmVyt2huAV6YzKgcTdkANe+frEbnItblVC2+xo=;
        b=cbtPVSz0T5RKEyhj+zOaKc3gQZPR4ilCAcriU0HP1JNke8VPf0mMXuURN7jTUsXLVj
         SoVabWCXPO8Ewr9L7CamhdzJ7ErHhcnJu0qK18IiXcev62WaFnXooaoQq8omnH1ZkEBl
         VAUQTKquAQfQG8/yfZOyr0xeyS0I/UV2yZ1/1/bL7oEVX3/XZEfcF0IvRb+8ZjLMVi+M
         MmPSvUuC1my/RH8Ws1FS8xJ8JenHi1mKMWOTepz3m2vPyOrcEcNzh3Iw4z2dFeSNek0R
         +ozZZcYeA8oavIAiuK/c8Hitqkl8bVpTJq5JvuxnNKH2hZOpcwfgczr0UCYoLrICTnD5
         F+pQ==
X-Gm-Message-State: AOAM531cciaIMYMPIaYrTs80Q06kIpRLPkaZi/N/O7eE5PP2aSQnoKoX
        6brJiVY6ncpDMK4eNuIsAY1SA77uR1KKNw==
X-Google-Smtp-Source: ABdhPJxQWWZ1XgAqwMRDGxbqy8FIkhQWw4tY1/Cx0NBoUE++HBh64QtQ/t0ULZTTcsBbrWTtMmpegQ==
X-Received: by 2002:a62:444:0:b029:1bc:ebb6:71f8 with SMTP id 65-20020a6204440000b02901bcebb671f8mr10310963pfe.75.1612641289540;
        Sat, 06 Feb 2021 11:54:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c17sm13488494pfi.88.2021.02.06.11.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 11:54:48 -0800 (PST)
Message-ID: <601ef408.1c69fb81.b0fc6.cf2e@mx.google.com>
Date:   Sat, 06 Feb 2021 11:54:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.173-17-g29232f8bac23
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 161 runs,
 5 regressions (v4.19.173-17-g29232f8bac23)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 161 runs, 5 regressions (v4.19.173-17-g29232=
f8bac23)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.173-17-g29232f8bac23/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.173-17-g29232f8bac23
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29232f8bac23741aa17b954f49dd03562d612dbc =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601ebd8405bf48684f3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ebd8405bf48684f3ab=
e63
        failing since 84 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601ebdf877b3c0eee93abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ebdf877b3c0eee93ab=
e66
        failing since 84 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601ebd97118b60e8a83abe7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ebd97118b60e8a83ab=
e7d
        failing since 84 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601ebd85118b60e8a83abe67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ebd85118b60e8a83ab=
e68
        failing since 84 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601ebd4fa257001d463abe72

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-g29232f8bac23/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ebd4fa257001d463ab=
e73
        failing since 84 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
