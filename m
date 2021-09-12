Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE61407DC7
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 16:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhILO2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 10:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhILO2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 10:28:01 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB37BC061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 07:26:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v1so4168611plo.10
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 07:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jbhtf/Y9PoSwSWkr3MJaRTYRro4c6oyHhkR9c6rfzaU=;
        b=z9tu9QutBs34m9Dp/fbJU40f79zkJg/xEvzG6cEJXvWq0HExb7UKJ3+ye7ZkQMNswK
         xul+MGkcSC8PmYVrYR6/aJZTCDvc50/kGlKazADy7b6tMkKgzU8JI6c8UZbdIBvK+Jz+
         ZPPYQyJem0iMi6T08i+JEvLdchvazawTpyZRMTmH22QtBpnXZD+bcbcZDVbXf3MG8Nbu
         OuoU2UR7FUL7/NE8+pre9+FviCsXX0DpgRAbZZ7z2kDsLkVZ9WZLQYY3wzkNqV5eOQ2G
         4EH9KPF4pqB3tsEkUfv0tasag9npUvawa0yFSimOWylYs3/1Q3njfSQezaUfsLf6Xp0l
         U9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jbhtf/Y9PoSwSWkr3MJaRTYRro4c6oyHhkR9c6rfzaU=;
        b=mmoTM+zaSZmbctC+YIjslyTmLYZvwr1EOVbqdlqO69TDLNyeUJYGKMYOhjY77rmkdJ
         HazmaO9rsN+5Vn1n57cHJW5H8SU+eTMxLaw5SltGvALzYvZTeqt8vREnd/AUc4TLGxa6
         C/iyPfUeSHwCWaHQnFZsPi9Qe8Htr38iivn1xGpWnXYU2M6SWl+l4bfR4L34EMo+RN7K
         qH/6e2jV5MMtBBHB+3Yz90BpJ9QV952fyNQpVfySNgNCDtQ3hYkcogdw41GTPGJedyJg
         oT1ku6HnUaGkjPmvZS091HdizZuhvRTsEFYBQSgl7nb9iOgjny7czSQXjN/5++mKkMs7
         q6qg==
X-Gm-Message-State: AOAM533jRoI38LXlnEp7JVYk4Z7k0HelNreoj5szq1D6D2HVRlx3o3pc
        hdwmM0B405I25dI3otJEXXTFSCA6/M22Eu0m
X-Google-Smtp-Source: ABdhPJyN4nQVGppPwzhysNvuyZgVExVo6FFNMvWqpKIFGCdIWoE0fzVbM4SWkyc/WXrJ0N6tTYykCg==
X-Received: by 2002:a17:902:d383:b0:13a:972a:3a44 with SMTP id e3-20020a170902d38300b0013a972a3a44mr6379224pld.65.1631456805836;
        Sun, 12 Sep 2021 07:26:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm5291170pgn.36.2021.09.12.07.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 07:26:45 -0700 (PDT)
Message-ID: <613e0e25.1c69fb81.19b0d.de31@mx.google.com>
Date:   Sun, 12 Sep 2021 07:26:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-34-gb6f4e2aed4e1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 151 runs,
 5 regressions (v4.9.282-34-gb6f4e2aed4e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 151 runs, 5 regressions (v4.9.282-34-gb6f4e2a=
ed4e1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-34-gb6f4e2aed4e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-34-gb6f4e2aed4e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6f4e2aed4e1ee8fe8e91f308b21d5ede933371f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613ddafd37a4b2db82d59688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ddafd37a4b2db82d59=
689
        failing since 302 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613dddde94843487a6d59682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dddde94843487a6d59=
683
        failing since 302 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613ddb299f6955c6d7d5967e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ddb299f6955c6d7d59=
67f
        failing since 302 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613ddb4e7d82f91c3fd59671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ddb4e7d82f91c3fd59=
672
        failing since 302 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613e0167e067e9d38fd5968d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
4-gb6f4e2aed4e1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613e0167e067e9d38fd59=
68e
        failing since 302 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
