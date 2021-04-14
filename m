Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1552E35FE05
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 00:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhDNWso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 18:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbhDNWsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 18:48:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD88CC061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 15:48:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id r13so7238159pjf.2
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/MSbsfDo4Nf5y4rUU7ZEUFYdylZiJlstT/0svHI+Sko=;
        b=zqi+cAu4qI/auXfDm/1tLZlrYetVTgxM9RnB1+cbAYEyuwyJ2DEVxvvQma0vo2uLI/
         EkQLqRAT6dlN8MB76kbPGcjdUC/jhzaptEi5lQO/NMsY/rq8fp0Ed0ibTHoJusSVrrh7
         i0s/AMiHUzATg8tEagYWcE8NlDCuuz9V4iymntLPsST8WPOsDXTbdsWUD8aSVPQ+EJV1
         lq1MLmX/MLwg77onFAufW4JjFvsFEbxWTE6/ypFq+iaNYgncqg5I6sY0FG+Eby8RjT83
         dyDNBOcjYj55RAcx0FDW/DCOo6MFTRs6XKrS8vOWiBRfLR+EWdh0lpVvdsPmEW5DP0nS
         VVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/MSbsfDo4Nf5y4rUU7ZEUFYdylZiJlstT/0svHI+Sko=;
        b=KCzRm5dH0QIqNlCs3qGiwNkMxt66EZtVOOzfyNkj9vG6SaicXDJLb7vPQ6eGW5Mh1B
         mdBkEgAOtPEbmRYnxNEYBMLHxi3syxl0ckAE+bzrz2jxbGptsOioG6pTX7Tcr1Zqs++B
         79wAjW4wWg7nxGCwKCukyR1ftxK/6XIZuloXc60xsFI1tiaKsiS3KJvOY6aoi/Ohas3V
         wWiLOStNs6GwQKW92oKlaB32LXL4Nz3ggv8fxkBVkr2cVGDTjjM5e1yvYnpDFdB1/EUM
         4ppsqnRkeZRsqIs9srCUaCK6EE0WRmVk0hIdLXY6zLU/U5Cym/5vGgI6+6mzeQSS1D3S
         S+YA==
X-Gm-Message-State: AOAM531aqkrfbI/OKXmxVaYFnHC004JvFf3Hwizt/rHm2KaLgbNnO/Sg
        xgRqlIac0i9la/4ipZLXOIOHKCDlMpQuoL4h
X-Google-Smtp-Source: ABdhPJw+Kce/N2dEilY6nhrPWTyK1fUhFOOd1WfoYwULzkJC56SXhVZeDL1rnoUwTA7HesoMGd37jw==
X-Received: by 2002:a17:90a:a103:: with SMTP id s3mr448175pjp.158.1618440501094;
        Wed, 14 Apr 2021 15:48:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q3sm345136pja.37.2021.04.14.15.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 15:48:20 -0700 (PDT)
Message-ID: <60777134.1c69fb81.1071.1a5b@mx.google.com>
Date:   Wed, 14 Apr 2021 15:48:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.187-8-g39f6e0a87a73f
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 4 regressions (v4.19.187-8-g39f6e0a87a73f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 4 regressions (v4.19.187-8-g39f6e0=
a87a73f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.187-8-g39f6e0a87a73f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.187-8-g39f6e0a87a73f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39f6e0a87a73f5040bef4c34c3c06165c230f54b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60773b485de8a09b19dac6da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60773b485de8a09b19dac=
6db
        failing since 151 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60773b76763ded43a5dac6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60773b76763ded43a5dac=
6cd
        failing since 151 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60773afad0d5abef24dac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60773afad0d5abef24dac=
6b4
        failing since 151 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60775538b4f1f93629dac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-8-g39f6e0a87a73f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60775538b4f1f93629dac=
6c7
        failing since 151 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
