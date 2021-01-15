Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CED2F80C7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbhAOQ2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbhAOQ2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:28:13 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7026DC0613C1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 08:27:33 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 15so6320510pgx.7
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 08:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fW6vPwe5x1y8fNc7Ukk8Xm2WuGeS2NIT+HOtI2W/ffo=;
        b=t99rhwdcz51GxIesRx+Baxm9j4DniQSrG8/hmChaf7Ueqk8b53XeCJD/LreJ68n5Wi
         MP/Sgm12oGMLa4CcthD7B2MAxHzO3cA/+dgDhEhOynJPOZJp8vWWxddxIZh/XAtiTPAW
         nmyw6vIW9jc3JwaAijh6V6mxB99GyB+BIXY0dHXLz7cia7RgxCyb1DAmTdSYv2knbCR5
         jnRgopEDXPr236NOcp51Y88WL98yEhMMqyNgFNj1UNdAjlVkyEKmZlvrMpy5p4G5ZXP0
         hF9z6M5D3kMryiaAgAe9OdfppjZlixW7MD/C7ilCqbJGkVWwBrnV6BPylgWNwijUgZnM
         XOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fW6vPwe5x1y8fNc7Ukk8Xm2WuGeS2NIT+HOtI2W/ffo=;
        b=l7Iei73PZZVAV9wAL62tChnnZQ5512vAyi28bxqqVLM33VICCzqoiDj8PBsOXH3AEo
         fvRS/S3fX5HVkEKtP/mZmvezkRCijcfBqTPOMRe/MUiwUTS1nKfigipZfC428Rcfr773
         CTmrrMoq2rA87/6MORk25WtXPR49GHL2T03slRqhewkAc9d68IlERHNVJLIGQmYIhqLK
         JHrq7erlea0hC3tULpwRkHUkW8FcTNvUZvyxZyHexfO2R2jIJZ/5c75SLiLyYLsw2zFZ
         qF5d3bId4UgJWpPoJk+dwxe8zVjtOP/cyif/qJVrU4u6U/O7mz8zhxO4cXVaUKBHOoMP
         8MKw==
X-Gm-Message-State: AOAM5313z7is9DqJHeH+PdOffh+1v5epqjqPGyn0TSMuEwdg1dWPemid
        fhDQlsJUP2z2TAZ9xeeOyrkIgkCWceSrlQ==
X-Google-Smtp-Source: ABdhPJxxFjRVWuq83OFODlvvJ47EZqnHJ7jWInqu01/RmHPuP7AH65Ivi8PrKswn/e9WYRevJu0b7w==
X-Received: by 2002:aa7:96d9:0:b029:1a1:c2c4:bdb8 with SMTP id h25-20020aa796d90000b02901a1c2c4bdb8mr13484194pfq.72.1610728052652;
        Fri, 15 Jan 2021 08:27:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm8369262pfn.52.2021.01.15.08.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:27:31 -0800 (PST)
Message-ID: <6001c273.1c69fb81.d0272.5510@mx.google.com>
Date:   Fri, 15 Jan 2021 08:27:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.251-25-gcf38131e4e86
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 5 regressions (v4.9.251-25-gcf38131e4e86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 5 regressions (v4.9.251-25-gcf38131=
e4e86)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.251-25-gcf38131e4e86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.251-25-gcf38131e4e86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf38131e4e867d73e0e578d643b7bc82a8f2f5f4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60018d12288fe8c9e0c94cbc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60018d12288fe8c=
9e0c94cc1
        new failure (last pass: v4.9.251-9-gaad962dcf3ae2)
        2 lines

    2021-01-15 12:39:42.399000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, swapper/0/0
    2021-01-15 12:39:42.408000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60018bce8b9e7f7c87c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60018bce8b9e7f7c87c94=
ccd
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60018bceb8e6daa03fc94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60018bceb8e6daa03fc94=
ce9
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60018bd286c4d7d253c94cf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60018bd286c4d7d253c94=
cf3
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001a2135e3e4b9f14c94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gcf38131e4e86/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001a2135e3e4b9f14c94=
cee
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
