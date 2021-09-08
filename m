Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A585403A86
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhIHNYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 09:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhIHNYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 09:24:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63463C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 06:23:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j2so1319904pll.1
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 06:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tA0GNbZOehPjpT9UF7+Uo7Ti97+Il5cjQS2vRLrGmJo=;
        b=oqk4KvbkqqfD8xw0frb0HwMkvLJaERL1A5Zt5cE6Wf9HO+Tt5SM1NapQDwXhRVH9D/
         VL+zZ6+SEeigIBoCpPV4tEntK+B/qwdQv+9eDU5C5xj6e261rPstqVH7pICAqHJs7FhK
         AXeIRIh5AM5kanFBaLm0yOblXs8hOMr6KWqnvwWoGCZN2qg4nibQ/eNICf/nqT074B9V
         oWj04GywvTCYXHtaJNc8C4w5uktEgVq2gt8B35LJaCd9YqcmZ8ESgGGnfP48Dzi1DHQd
         vj9OSF4IcTSzGAnNWbwGKtsCrS97yNvxAbL/dLbxIJKK3jDyC/f7NHkHHMR6Io7lJSwf
         tIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tA0GNbZOehPjpT9UF7+Uo7Ti97+Il5cjQS2vRLrGmJo=;
        b=KDXhUzuTMv44E8G5c7+5OkLFDizaOsLpCuspwXzA6TR0WqpW6ktpJMdDf2/owm1unq
         zY5sI0uo7zTn3Swk9MQCaIDEhTrE9XwpJ7MdQQnH26PqXA7ba2hUs7bWkeTS6lncUU8/
         NS5W4hlKZVvPt89ccoYA3OpZFmFS76nCURHn6W1iguJu29IXFNnOS+ZAGu/FYJ0PSY4/
         qP04djnWen1WqQ2ker6vm5fc/kzzdK113PsvZp198v5uxKnVSmnzmQ6YI3vmealyx8+J
         g5Cj6ivPu2M+t51nyCiLh7OH6axg0t9W/y6R7JiKcEQoyFzwUZDzXHNz+sNjIxi7FTm/
         hp+A==
X-Gm-Message-State: AOAM532N55dQFLBmanpgty3bNYiK39Xsyn0OD2CZg6m8+KreBy2Ia+MH
        vNW7PC/qELBEhuW4pYc9ITeAqVCUw25c2mjD
X-Google-Smtp-Source: ABdhPJyihTg12Qkh5YfDFwGFeObrurpkdqnQhrhYq3SEOGrUuzdPkCZKZLUrC4OsG9U2aFsOSTd80g==
X-Received: by 2002:a17:90a:1b2a:: with SMTP id q39mr4147050pjq.219.1631107403694;
        Wed, 08 Sep 2021 06:23:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w24sm2386845pjh.30.2021.09.08.06.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 06:23:23 -0700 (PDT)
Message-ID: <6138b94b.1c69fb81.48235.6a9e@mx.google.com>
Date:   Wed, 08 Sep 2021 06:23:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-15-gce3c8ceec498
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 147 runs,
 4 regressions (v4.9.282-15-gce3c8ceec498)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 147 runs, 4 regressions (v4.9.282-15-gce3c8ce=
ec498)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-15-gce3c8ceec498/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-15-gce3c8ceec498
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce3c8ceec4982272c7fe91fe47c33d33d00540e2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6138879f537881f766d59672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138879f537881f766d59=
673
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6138972420f4a213e2d596c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138972420f4a213e2d59=
6c6
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61388cabd15daad0b2d5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61388cabd15daad0b2d59=
66c
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61388e69d2c3669474d596f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
5-gce3c8ceec498/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61388e69d2c3669474d59=
6fa
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
