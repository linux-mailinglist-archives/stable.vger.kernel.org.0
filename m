Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17CC2EAE40
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 16:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbhAEP2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 10:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbhAEP2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 10:28:22 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E775FC061574
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 07:27:41 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q22so18516953pfk.12
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 07:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KEQdrwo9ATy14VRUm6tXbd38OS0m62CwERCjsJymR2M=;
        b=HK553sx/Yeg86gSSX8Wz8keDoULNj37zuOIh6LyfdEQH7O0lvzrVoXB/3VZq4kxo3w
         jW1hpj5d63py1qsHCSVrJ4ecLP5VrBCrEHTKAjvC0YJgIGKV3twqneG7JahQUQuF+PhP
         xko4cyFdSmood6/OZrEumWVmw0nyj8iD+fNbRzueu6l5Rqn3omYSwswRR2Wv/GzgWhD2
         DvRC9PPRS8dg/O/rsXuHEUyUDNOE+dwJMSA4FlLGNSJeY2pa3YQhoBd2Puyf80ATf0j/
         E2bE3c+Yu/YTRMNioLrYqzWgjaousDiruHPf0cZUZFhQNEbk3P9M2dTbVYvuhnF0hxRu
         2iPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KEQdrwo9ATy14VRUm6tXbd38OS0m62CwERCjsJymR2M=;
        b=Qi6impf1hZZZWx8MyTlYsJIfuTU/31Q7ogCbMUo8vXcEDm6+K5aExCDPFzBG4Jh+8d
         EYJq4qu76wgbM9/3z+5YlhIEA7XJVQfOy7V3J4LpGwArLIEBywnjrB40PPlHyEGmDSBv
         UjXbTfTePTaahcqiIokcqdyCr8WOr4OHtkk4wxBo3AZ2v4w81YxBLbhtpI6SWp7wS8zy
         U/LpHyrZJnBNJfQ4DSnhbukrOdxfXFq0fDXwDyaFhXefzgM+0A/7fcXSaA8plrLFiWuV
         DogFCkuCdngvvd8EOdBxbTfE5cuQtMRre5k/Fp33KLy5GlxmZeC9lmsS3X3nIUkASGg0
         ZzRg==
X-Gm-Message-State: AOAM5316hTAI12O8NWIdFAidzCshdtCinAWXArzbKhND75FDznHlNq4a
        J0P4LdayUAJCVRPbegAP/+xpndq+58Ba6A==
X-Google-Smtp-Source: ABdhPJwFa2lB4ThCwGGTssy1alsr1/zHF/2DgUy9n7AcyZBrNt2Nx5WfyJAbhn3+oLgupyQiUCk8uw==
X-Received: by 2002:a62:1749:0:b029:19d:960c:1bb8 with SMTP id 70-20020a6217490000b029019d960c1bb8mr71699907pfx.63.1609860461107;
        Tue, 05 Jan 2021 07:27:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i13sm177025pgd.32.2021.01.05.07.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:27:40 -0800 (PST)
Message-ID: <5ff4856c.1c69fb81.73aa8.0631@mx.google.com>
Date:   Tue, 05 Jan 2021 07:27:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.249-24-g85c1baf2e49aa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 126 runs,
 6 regressions (v4.9.249-24-g85c1baf2e49aa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 126 runs, 6 regressions (v4.9.249-24-g85c1baf=
2e49aa)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

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
el/v4.9.249-24-g85c1baf2e49aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.249-24-g85c1baf2e49aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85c1baf2e49aaf42f5cdcc0c4b0e712fcc31d8d1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff451dd6e13871e4ac94ce2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff451dd6e13871=
e4ac94ce7
        failing since 12 days (last pass: v4.9.248-48-g718e3a8728c0d, first=
 fail: v4.9.248-49-gb763f0168900)
        2 lines

    2021-01-05 11:47:36.969000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/127
    2021-01-05 11:47:36.978000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff4528d3e2da9d027c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff4528d3e2da9d027c94=
cd2
        failing since 52 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff452aee46b3e0729c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff452aee46b3e0729c94=
ccc
        failing since 52 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff45295014f3b6788c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff45295014f3b6788c94=
cd6
        failing since 52 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff45784ea5aad7c5fc94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff45784ea5aad7c5fc94=
ce9
        failing since 52 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff47131943d21ef55c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-2=
4-g85c1baf2e49aa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff47131943d21ef55c94=
cd4
        failing since 52 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
