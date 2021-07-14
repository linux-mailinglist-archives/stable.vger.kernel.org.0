Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BDC3C93E6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 00:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhGNWew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 18:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhGNWew (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 18:34:52 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC23C06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:31:59 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 62so4020035pgf.1
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JZJa1371g1Zd/v+i/r0L1vJWtvYsi6LGk5h4ynh4Q04=;
        b=z6qwV6tvT2S/njHGdgHwm8kehZ54hkC4ZmNjthT37PJro8fS774pDUeQsUscyQmJhe
         qaID1vQHptjlUsCB7VaYeVwo/TqAbXsay5Cpz1NaNCrDXurlzVBR9BJ16UnrkXReheYF
         d27XoUgUl6npr3LJblvSD16H2yAqoikLWsxRcqJEsqFWnh2o+IRUvSW5wBD2I3HabLF+
         K1ECD+gk7T7uv2bY6L4z90ipjz1x8dLuY5fNTk29I/YIt/FHOrq09rfCsBL4GPLslw1J
         gpxBJy01A/HX/jwJuK13Vg/Il+UeGNTzA4+X4ESkR1CxeMmiK7HdvbKyZnGl6TTvGT+q
         fiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JZJa1371g1Zd/v+i/r0L1vJWtvYsi6LGk5h4ynh4Q04=;
        b=jt6CuYb9BEulwUcA92Dkplq3qZJDxohGZdcxaS1HTl/aBRipaQbiJJES4oR9hwtLes
         o4332em9Ups7vDSBxOG8scsJlLovG0twiz0XWkUFIADtp4OvpJeyaibMzMs82RrbUoFw
         pkWQP2gmSun3BjaR2hQnCHp4DSTck3GaxzY+n/GQWwtxLJJxDQceXWu82EVxMCCq9f00
         ahOoT6mtlbG39EMzQL6YbeEENRe/rkcO0iGvo1BRlHQkgACJj8/631Fz1OBebjPeKjhH
         MscccbMqO5z9+EvqOxbdMcDsmbcIH9cuADQ3WjknMt6KpDGAUYYuOUFb0oNeQkLNSs9h
         qoLQ==
X-Gm-Message-State: AOAM532/CbQ9KumdRdPnBFvNJYQPQVkw00jlflJRgVZXtL0u/XmWNdTU
        QEHIFaRLdhEgo5CXX5j+q+/Ug5YERKvwCw==
X-Google-Smtp-Source: ABdhPJwEmfTVVEag2Uyki5ewisNuGPl8lOFORdu7Tf9ppqRwZxIwhyMMISSc/ET4xzhklT24JkTM/w==
X-Received: by 2002:aa7:82cb:0:b029:2e6:f397:d248 with SMTP id f11-20020aa782cb0000b02902e6f397d248mr238635pfn.52.1626301918818;
        Wed, 14 Jul 2021 15:31:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm3812340pfl.195.2021.07.14.15.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 15:31:58 -0700 (PDT)
Message-ID: <60ef65de.1c69fb81.12b76.c8a9@mx.google.com>
Date:   Wed, 14 Jul 2021 15:31:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.275-123-g351450a3e28f
Subject: stable-rc/queue/4.9 baseline: 130 runs,
 4 regressions (v4.9.275-123-g351450a3e28f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 130 runs, 4 regressions (v4.9.275-123-g351450=
a3e28f)

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
el/v4.9.275-123-g351450a3e28f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-123-g351450a3e28f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      351450a3e28fe2b690adff0ca001176a200150e4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef31d0a73f41f3d68a93c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef31d0a73f41f3d68a9=
3c1
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef31d6d105a05e548a93b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef31d6d105a05e548a9=
3b1
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef31d3a73f41f3d68a93c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef31d3a73f41f3d68a9=
3c5
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef342c77ca1a8fc68a93a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
23-g351450a3e28f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef342c77ca1a8fc68a9=
3a6
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
