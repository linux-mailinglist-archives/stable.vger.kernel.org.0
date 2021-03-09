Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0AA332A5E
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 16:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCIPZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 10:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhCIPZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 10:25:43 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B380DC06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 07:25:43 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q22so911916pjd.0
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 07:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbPFkG6rqTmh/FNZOwkkoRMG8fLM+Rxf2H3Awev3XNw=;
        b=qLvNjKF6Ld4rYbgMIlgZ7mt7pkvpExPr22I+Sh1UghSexzfDTtGg4kEACCHJDe9sed
         bP4KF1a6p1O60PY2dE22OoD/Gww4Yvwqm+eZ+BPBI/kscJI71Z3c3sKTlZjRSM8tTpTq
         icLwHiPDe25tOGvO0oiUv/b6M4XKTUyL+Ef4LY0i1D8s+ieEKvgR+FGKxnWdLFCc08Oi
         IGUuVdpffvxav4pT/Y3YWRU3IA4GLuwrQXp2LiHo99dXUIbSRSp55nz6rn3EEG4wU/dR
         CL3EVeJcLTSh+UB12QicUF/Dr+xefrIoC7mT7HZw0OaDBNm2WUs8I0FnaMByjm+11Avw
         LUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbPFkG6rqTmh/FNZOwkkoRMG8fLM+Rxf2H3Awev3XNw=;
        b=pUeck/kSHj1/utSOjpGUmoC9BzNp6zjMrmDOL26Lk9X+NJmMW7pHHLnXgh0PlFuWog
         6OC6frVnacS9pMEefb8sb4Jov2JprRm2tV+enpZlavzVvWotx4Wvq4gxyHEWT4qLqS1B
         VvnbtOrcpCxPVTSemclOhEOnSIFF+5fJvNFslPnC+I4Zlsx95rwrE1u6VGIRKvSUICWf
         nrYVwt1UdgBqkarlX0AXSrkVtGgAVMOs8/m0Byy1Ol+1wHL4CpzfD7LNC56Oogx89HIt
         hCO6plg6c4R2w3U/gfF5zQh/qqzN5zIZKkAgP8ZR7P5gykaWNXu2gHt93hzsFl8lNhRa
         RFog==
X-Gm-Message-State: AOAM5335kpjrd/EIJHAoK1yl9BjpmH31E+zKwjZ4awG/Ew6M+qv0yB30
        IWU9z5S5E8ibFM8onaFc4ysw5Gt1n/Isn1iC
X-Google-Smtp-Source: ABdhPJzM8B1txxVFDuZLA57J7LzlZQ0ywV6m80F+sEAre3yekZ2uzr0gs4RRl5Tj8qwo5KkBM6D1dw==
X-Received: by 2002:a17:90b:3909:: with SMTP id ob9mr5387521pjb.181.1615303543086;
        Tue, 09 Mar 2021 07:25:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v27sm11989971pfi.89.2021.03.09.07.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 07:25:42 -0800 (PST)
Message-ID: <60479376.1c69fb81.9d616.ca5e@mx.google.com>
Date:   Tue, 09 Mar 2021 07:25:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-5-g5ea2e1b3a389
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 73 runs,
 3 regressions (v4.9.260-5-g5ea2e1b3a389)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 73 runs, 3 regressions (v4.9.260-5-g5ea2e1b3a=
389)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.260-5-g5ea2e1b3a389/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.260-5-g5ea2e1b3a389
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ea2e1b3a389a5ac109662ce723516aeb68c7b5e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60476466909d484803addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5ea2e1b3a389/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5ea2e1b3a389/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60476466909d484803add=
cb2
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604760bee928fa3f78addccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5ea2e1b3a389/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5ea2e1b3a389/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604760bee928fa3f78add=
cce
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6047604e1c8a4c4caeaddd15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5ea2e1b3a389/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5ea2e1b3a389/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6047604e1c8a4c4caeadd=
d16
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
