Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C60348420
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 22:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCXVty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhCXVty (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 17:49:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B5FC06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:49:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ha17so185654pjb.2
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wQG4qZ72ouIHt8FChpWL95zxcKNkTkjNl1HQgaFd+tA=;
        b=OTS/n+X/ge/7p4J1SSkBcqC7lr+OjA7+Pm0Qoz6ANlILc7waFCS5IoVpGge7EmPhXU
         a8U7zTqvWOtlzfASVNKNBlB2yoiYGLZcjCXcmZJxTOzhpFndpwgErOFdumoRUVyTK6Bd
         PqlQZEeN2DIYBkRj0GFijHZaAPVgjsc4Fr+brsazV9KWSO3fc8D2Qle8XhATz29MlvLm
         H2Gh1zQoGmo4Z+UO4aSeJAdspCmZZXFncUV1jRjfRXCogcyXWSjvgOPamUGtXYz/uDmM
         vIDflaui7eaFEqXVniG30eY2WmBr9nP456kk/RI/1qVtIMSaBJq6pPk4IUJWdYWM/cju
         Foag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wQG4qZ72ouIHt8FChpWL95zxcKNkTkjNl1HQgaFd+tA=;
        b=agoBhML51b/pUsNLdbkU1welfjovJOtPkuDt/Xk/xQ+XuW2lvumKgyP1BcnmCvtQ1q
         RBsRnWEj9rHLeFa7OIq4qRwVMej7fFxYmQ1Iid106BBwVDAow3uKQ067s6XTqgsS8Nsp
         acznuqwq3ex+9z50ar8BGR9hHofr58gLzzhqmH2sWXH/tZeqGBGdo19JeAAut+XVHoCW
         F8E0C+sjU458DqVZEayDCtgQAbyJwtwfdkJlbqhkU4vmZfL27NaqhPtYe9AeKl1FueTj
         O7C3GvZUWWBPwmxSCQ8V0Hh6C3AWfuPCROAKBLxsQtTGyDRLZ5lxkr063K5ngHELShl0
         FKsw==
X-Gm-Message-State: AOAM532wbh2KfCKU2b7KYmwnxEBYI2j71vV/LM7Eon7cLB+zJ7Rxz7VF
        Eunn33f2pSJ2x1c9PXoNx1TrxifIWe4S9Q==
X-Google-Smtp-Source: ABdhPJzNVv4y9Xby8cA7hZrcFVj2vzD9+t37VPJV1smDGpa6MokTTLBuHnyOFqxEVSaoh9HsVtGsvg==
X-Received: by 2002:a17:90a:e614:: with SMTP id j20mr5366666pjy.184.1616622593296;
        Wed, 24 Mar 2021 14:49:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q22sm3245339pfk.2.2021.03.24.14.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:49:53 -0700 (PDT)
Message-ID: <605bb401.1c69fb81.15af7.89ee@mx.google.com>
Date:   Wed, 24 Mar 2021 14:49:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 148 runs, 5 regressions (v4.19.183)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 148 runs, 5 regressions (v4.19.183)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.183/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.183
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      78fec1611cbf7b0bdaddfdbf174a3a2463663bff =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b7dd7c2a021271caf02c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b7dd7c2a021271caf0=
2c4
        failing since 125 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b7dabde13bb0967af02d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b7dabde13bb0967af0=
2d4
        failing since 125 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b7d9f507b526a9faf02d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b7d9f507b526a9faf0=
2d9
        failing since 125 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b7db7cbcea68af0af02c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b7db7cbcea68af0af0=
2c4
        failing since 125 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b7d6af588adb483af02ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.183/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b7d6af588adb483af0=
2cf
        failing since 125 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
