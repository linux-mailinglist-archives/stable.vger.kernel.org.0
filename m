Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE133AA6AC
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 00:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhFPWkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 18:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhFPWkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 18:40:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CB8C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 15:38:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so589247pjo.3
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 15:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xwORf84PE+jwQ5VMLNcWREqP0X3ZLdjb014Q4MlkV7E=;
        b=FLd1cNcNfeTkBsFSyk2Y+yQkLiLVGXQyOzXWwETVC5FklqzxzZkA65OhhXaxZ1lUQl
         SndyzS75OTw0YpmbG7rlWGbaA/JD1+Gw/g9d9zuqW6LEBqsr+yisoubq4SLsNQaBDA11
         oE3r4EarSG0/Lt5DICPh3fTVb09dd3Cl15uz3h+L4pR+Rs8+Hr/S9hApZGt209dj/ccS
         7H5FOfprXO6Kzhr5uGJeZ1IZUTJ4e6NSmnRDKtv6MXvO5M38zAar78FWRFaFgufhaS8n
         Yb8/mzir2p8vz02i4Q1RkUTA2X2QTdmum0CAUVm7dDAdu1JNY69CzGD/RRGBaE0Mtv5o
         T2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xwORf84PE+jwQ5VMLNcWREqP0X3ZLdjb014Q4MlkV7E=;
        b=ubfOgkFVL2+t0Xqqd6hSXcgjC2e8l1SWXZqcjnrbCbsQKyFqlZdtg6VTg+qwaIm61z
         6tOmxwJhBnJo0S2r3cEx6sUEGH2bFpD60Yap483pxJvH7HbHdVx4osSA2fCfDfdvnhXS
         PpPee6A++e5v4Ni1rbO+Zn8lTHwn92txoOZ8jad3sSgG+0aD3bFxTIsxm5h9JdW0Jsaf
         LWNti+cmSnG/aHNjTt//iyL+7UggDCAgGM4wNtJXVdTE5wiAH/D1KzpWAmpMdM8Z0AdL
         SEO6ubK3McygZDMz0DBENuAD3VKYzlPdAAZBYS3Vvr1evWQ9xBSC+4Qf+LIrwsYhh6xE
         hSvw==
X-Gm-Message-State: AOAM533IlidOR+RvwB5ZuikYTNNP5h6Dvd/77OgryNPGL1/rGm/3nIVu
        /bYRG1PL5Zf+dc2tLA9T9MWX4PehCQywfwm8
X-Google-Smtp-Source: ABdhPJwvl8RLhh6vCCLNxaldJOVIqYyIbkPtv5AwFRqlryN2WJXTyGiyWkdXPggQU2DJIhFa4aT1rQ==
X-Received: by 2002:a17:90b:1295:: with SMTP id fw21mr2182101pjb.147.1623883115539;
        Wed, 16 Jun 2021 15:38:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ge13sm6155024pjb.2.2021.06.16.15.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:38:35 -0700 (PDT)
Message-ID: <60ca7d6b.1c69fb81.5e1a5.3d25@mx.google.com>
Date:   Wed, 16 Jun 2021 15:38:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.273-14-geeb2e2f2ab09
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 60 runs,
 7 regressions (v4.4.273-14-geeb2e2f2ab09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 60 runs, 7 regressions (v4.4.273-14-geeb2e2=
f2ab09)

Regressions Summary
-------------------

platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie | gcc-8    | multi_v7_defconfig =
          | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip     | gcc-8    | multi_v7_defconfig =
          | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie | gcc-8    | multi_v7_defconfig =
          | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip     | gcc-8    | multi_v7_defconfig =
          | 1          =

qemu_i386           | i386   | lab-broonie | gcc-8    | i386_defconfig     =
          | 1          =

qemu_i386-uefi      | i386   | lab-broonie | gcc-8    | i386_defconfig     =
          | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.273-14-geeb2e2f2ab09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.273-14-geeb2e2f2ab09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eeb2e2f2ab09a74225c0ea2a481c87aef3557245 =



Test Regressions
---------------- =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5e1191ea29229e4132a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5e1191ea29229e413=
2a2
        failing since 214 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip     | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca4dc69ce487251241326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca4dc69ce4872512413=
26f
        failing since 214 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5d842a0a3b9877413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5d842a0a3b9877413=
286
        failing since 214 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip     | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca4d4e0a103e132941326b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca4d4e0a103e1329413=
26c
        failing since 214 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_i386           | i386   | lab-broonie | gcc-8    | i386_defconfig     =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5a79da436b8ac741328a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5a79da436b8ac7413=
28b
        failing since 1 day (last pass: v4.4.272, first fail: v4.4.272-35-g=
c652289a55a0) =

 =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_i386-uefi      | i386   | lab-broonie | gcc-8    | i386_defconfig     =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5a7ada436b8ac7413296

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5a7ada436b8ac7413=
297
        new failure (last pass: v4.4.272-35-gc652289a55a0) =

 =



platform            | arch   | lab         | compiler | defconfig          =
          | regressions
--------------------+--------+-------------+----------+--------------------=
----------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5c94f41cc11d6f41329f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-14-geeb2e2f2ab09/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5c94f41cc11d6f413=
2a0
        new failure (last pass: v4.4.272-35-gc652289a55a0) =

 =20
