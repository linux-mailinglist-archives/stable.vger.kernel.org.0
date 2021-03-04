Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2A32D50C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCDOMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238666AbhCDOMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:12:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2D4C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 06:11:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s16so16197093plr.9
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 06:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rA7KDQDXgmg/uOQsRJOA+jd2XoDGPfFFdjJpBynavBE=;
        b=Gb2SF1hSmY4NunFvuNRSheX80qO3NRCHRZiZhKFg3EJA1D/jk02ExIeOTgvuirocJO
         n+wqwl3je/0BOHkBl5Q2MrzGrhYDGnOQzDzAwGAOx2HP9g7Icyipjq8RUKwbIsECCWB3
         8E5bskN0D07c0rWePjghQ6gbWuffDbZS+s9fEkbRV0V6Vd2GMnvDNSwIjQabNAUnj5RW
         eadz8AMu8y40bqpC1L4DLZpU3rC1tMUUSHr7GlxVR72xLbrw0znzAsAxmH6G4kQCwh6E
         xyh43Q7RYVLq2nfMQjwp4UpxfsGS4EbJHl/HLoSYEhooiHaMSUJPd8hf/yVyW0k4Yzua
         UwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rA7KDQDXgmg/uOQsRJOA+jd2XoDGPfFFdjJpBynavBE=;
        b=TGxqRO5/qdHL+vyh8z05pb3dW6sx7JRizM6gXvS4VGEPyAd4xTnyGsiRw3HAvFirsX
         k6umyNQ8znnlX0irErqOsjtw2R6fl/ce2EB+V02IWM0skCR2PhntSJDZIjSr7ZZElcAo
         abrWdx5IsjGOzHe9oswHzjb7b+056Ug83dvFuX1te4byP0vkzjkXjA4XpEJMgurCQs2b
         YXnCbGWTO9t06FRMtXwgyOnxRiQa6fDaM0jMWRRaQ/vYhJvl2/EI4VYi5pKvOfxAyT5l
         0lMAioKykowWhzsNTGLtPVxgDarpRNHl6dSiwQs4sMc34twLcZXpT7xVH16EkOS5TnJA
         CIcw==
X-Gm-Message-State: AOAM532NYKRezLh+y9TBgG7JxK5taUhi8Cxgxz9ZuOQuydlq6cjoESeC
        zm0ky99OSkb0gM82vctFtGti9EV8iCKw2mgJ
X-Google-Smtp-Source: ABdhPJzY9WOzVW80R1h6WYh/aOlWCcl1PVQoExXiHUopRBsHIymslJqFds0nVbrySwKZQIhHB/D1DQ==
X-Received: by 2002:a17:90a:e616:: with SMTP id j22mr4730570pjy.190.1614867097234;
        Thu, 04 Mar 2021 06:11:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y72sm28417053pfg.126.2021.03.04.06.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:11:36 -0800 (PST)
Message-ID: <6040ea98.1c69fb81.4f007.10b3@mx.google.com>
Date:   Thu, 04 Mar 2021 06:11:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-337-g4332e4b9e2ec3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 5 regressions (v5.4.101-337-g4332e4b9e2ec3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 5 regressions (v5.4.101-337-g4332e4=
b9e2ec3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-337-g4332e4b9e2ec3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-337-g4332e4b9e2ec3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4332e4b9e2ec36e9f2077ea42595f2299d0b6004 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040b4cb568a897d48addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040b4cb568a897d48add=
cc0
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040e879f2f22d04e4addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040e879f2f22d04e4add=
cba
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040b59fba915d39d3addce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040b59fba915d39d3add=
ce4
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040b5427dde3befa8addce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040b5427dde3befa8add=
ce2
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040b46b2af702f2bbaddcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g4332e4b9e2ec3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040b46b2af702f2bbadd=
cde
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
