Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C25332AC2
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 16:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhCIPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 10:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhCIPkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 10:40:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC29C06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 07:40:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso2956121pjb.4
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 07:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cGSh/kpruwz7RL3NRjC692oP1OOpbWGX1YNsfFGDAoI=;
        b=dRjCHS/MKHGoMpC8eLH7rZZgXkPGdaXFx1SRGhGtm4k6T3+mwrcS6A0HW+LzQ+JugJ
         t8QUJy6YKwaTQSpWFxFsDzlIA/TFXa4fnX+R7pnc3p3gOVSBQsH0xSWEKOxuW2UAFNf7
         llLhFt4lD59jdRABikJcx/Ga7y15QFLl6VTSmaTIbX+vXFmu8nIxG9APSRVFCeIA5wvw
         zoSFwY/KwGv6em237Y5qNdsiCwfCyFKSrZg2bYwut8R4amtVoyk6swbKXQWjH659azYw
         Thn1pwX0G3fagY9MzjksvWOV+QtGumOSQCTlrRECWojjmpZ3xYsF93gAS8T3gQocR06b
         viHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cGSh/kpruwz7RL3NRjC692oP1OOpbWGX1YNsfFGDAoI=;
        b=JddshMneq6/akAkxNqmkEuYxPIy2+RxrEPlG+R5K+y0zlAaA5V83EN/rzZ0xRA6o2F
         4eMKFDsmJIVMB90qsmyUkHxCTTQqthnV7GmGSsuwWPet8MHKJyQCLaSkmb3+zkATG5PO
         ZO49+pLTNaMR5UYWRcJhUmfrVajlW1rBWZ/DPFx86vLr5AH6Qv/GIDmAgzU8IYdiqGSV
         yZTC+bUgIRgkJMN2F3SqPEkbNhU3FYgP0UEpxwwsl9dhx5NSMqEymMHCCpBTFSmyCh1T
         +X4fFY+EgVmgc3qBoGdVNbIr6NM03n+1K/lydaqHGt09CFIdjymH47iend3E29VEA4Tg
         /rJA==
X-Gm-Message-State: AOAM533DbHIb/zKPaXGdThrEjVDNb/VLxLUQFNG9XIzkJ5CN1bCKW1O7
        BAAiVQQ70WG4HKUj7X638fGNhpzQobzyj2/J
X-Google-Smtp-Source: ABdhPJw8WvoKqWLFMeYzmtfITuekB/F6PRciieCCotwyzbFPAqIB1yIO1XnyELTSLyPKP4bK92xgow==
X-Received: by 2002:a17:90a:8908:: with SMTP id u8mr5145425pjn.135.1615304403515;
        Tue, 09 Mar 2021 07:40:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 192sm14103961pfa.122.2021.03.09.07.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 07:40:03 -0800 (PST)
Message-ID: <604796d3.1c69fb81.f200e.2f58@mx.google.com>
Date:   Tue, 09 Mar 2021 07:40:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.104
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 96 runs, 3 regressions (v5.4.104)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 96 runs, 3 regressions (v5.4.104)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.104/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.104
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      84d5d3c9d3fbcee10bc16d3a3316af9a924c91c6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60476722d3e578d288addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.104/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.104/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60476722d3e578d288add=
cd9
        failing since 110 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604763e5bd297385d9addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.104/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.104/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604763e5bd297385d9add=
cb2
        failing since 110 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60476338113a486ec6addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.104/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.104/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60476338113a486ec6add=
ccb
        failing since 110 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
