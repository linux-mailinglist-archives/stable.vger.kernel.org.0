Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719773C402A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 01:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGKXy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 19:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKXy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 19:54:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B4CC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:52:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b5so8210494plg.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZBVbdfjA8Cw07E5GpVMGEf2HSNctGQWZmF2UQi/W3Y0=;
        b=wUDa1hLgmbycb3WIs7h3f8RwLmRTB4MhDjp7fEk6VnNggQjlK/OabmA5hLbTcOMsZM
         MqcPtnjaKLRycqZ51Vi/HVxBypSCSxelARSNSBGODClBLFrxn6m1TLe49imK9Qax3orm
         vzuiBeYyiEf7khNzt1sOs5HQN1qDBkSWens3l9b9Kumzecl98gfxX2OY6uDjLDvRgHX6
         KKGPvSyqtRwF7Kw/m2HRxfryy5hh0US6jQ3ykazMPyAlW5Yzsf5PJTf+f8Gvih19sMxI
         gbIl4A2FAvFWpXSELit02llRqysj75Qfby840nf/MWZLf5bYtV3m68Pwp1wKNDcdz/ef
         ocsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZBVbdfjA8Cw07E5GpVMGEf2HSNctGQWZmF2UQi/W3Y0=;
        b=n2gDKhSDhnDkiu68+rLlFz6/mBJfqcO6Sl+ufREypA3qTvxKLPzigSR6aPglyiAiY6
         +yIhhSRHqVv76PsDdwjyH12+wncYOcnGDcZ9lPkss68daGUbflfwPiYnuzGDiYZCqRL9
         BDQXTJ1bQ2hqdIQ7LjFs5gHafxj1sptYULThJX3hneYE74SaunkFA6OHvrQIfjHJZ6af
         yaevKBDGm8vDDsRL2jxxIWwOrhTHnedAqzaMjbYvRqXHOz2anbsQv7F7cYvOB4vQm4BX
         Eyl+QN+RMM+4HrCZ198Ah1sHJzdhst9IUtz8Q15SGGRq5G5KnDLoRnbzk2Ms2CwU8q0I
         Aedw==
X-Gm-Message-State: AOAM532235V9iOdfy/miN1sTQCVBlQZuh2jG1FaiFN1ASc0cr0u5ZvnG
        a4iHbSpTJQfnilZLUcBPudNTkOakg9wlchsb
X-Google-Smtp-Source: ABdhPJzPpcIavRq4RHpALqTghj+ybPD/2CIjfa7loBvzsORTZUtuoH+bA5QD2aZf9zRrKXdcIsnwDg==
X-Received: by 2002:a17:90a:3b44:: with SMTP id t4mr27268473pjf.203.1626047527551;
        Sun, 11 Jul 2021 16:52:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d129sm13105708pfd.218.2021.07.11.16.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 16:52:07 -0700 (PDT)
Message-ID: <60eb8427.1c69fb81.e56b1.6d03@mx.google.com>
Date:   Sun, 11 Jul 2021 16:52:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.275-122-g9473844ebd34
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 107 runs,
 5 regressions (v4.9.275-122-g9473844ebd34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 107 runs, 5 regressions (v4.9.275-122-g947384=
4ebd34)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

qemu_i386-uefi       | i386 | lab-collabora | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.275-122-g9473844ebd34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-122-g9473844ebd34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9473844ebd3498da314a030ba55fe894c237c26d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb495d408e130497117984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb495d408e130497117=
985
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb4afb7005ac16051179a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb4afb7005ac1605117=
9a2
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb4950d75ea4498411798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb4950d75ea44984117=
990
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb51d37fad57eebc11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb51d37fad57eebc117=
96b
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386-uefi       | i386 | lab-collabora | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb551c2d6592671c117986

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
22-g9473844ebd34/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb551c2d6592671c117=
987
        new failure (last pass: v4.9.275-28-g6b87a8c3f6a02) =

 =20
