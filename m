Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA403B399E
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 01:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFXXFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 19:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhFXXFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 19:05:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB1DC061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 16:03:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id c7-20020a17090ad907b029016faeeab0ccso6828616pjv.4
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 16:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PD9rkfte+eW3/3wafgX9th6cb6sJyHS8MrqpYbSiD08=;
        b=f1U2FGuk3S+FOnn1inDq8os+YsT5Y1EIvYd9bqHDgrn5pOC3xNOQ543OCJiOpkRHhP
         1dtstV6WiaHOYXfgcVVAg2CTBEi8UURP/2it/FCz50dUDkDrVreb4XT9jgKKBrw87Buf
         UWUj8mWUsIR4gfC3U+z5haJQin7oZhUi3tFi0i+ElbD6xTdZN+WsrT46L17zN1ksA/RP
         M95+QyHzdfjmddyi5hysb9cs+ynh0DT6NQjJFDFIXV7ym/8DDhuHYIa7hDTFWRxxBOdw
         Iy2ogHMd5qv55sF6Mhz9tgkuNC2foPwFUX4PP1AQWNqnIPOEOE9pd8iUyXMNFWf6kPQE
         alZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PD9rkfte+eW3/3wafgX9th6cb6sJyHS8MrqpYbSiD08=;
        b=VgMpHeEfsNMcKh3BzasoMeITPOUxGVDWNajjvUmuOl2cZDIuAc+WVdDzOk1SiB0KKC
         ldwE4lDnj3odxuL2+QDXV8dozw58bDa0j/F2G9A6EEk5WExzF6MrWFspkEOwmKwjakfI
         0JssynX3GlxvUcQnrHf99AAgfLsNOPR/1csjgA5+Y+IDBio48Hjoke82ixS0Jt1FxeZB
         ofdJn3XfZzCFRM2jywYzfEd9BqHF7Nrr4yhUhjCAUrQnQiELFg4u2YJGre8udetn+hjw
         P80BHoYlq6fR+3zgQhqWOgfkQeiBRS21oP/ckV9uk+XOTPH5wvy2OKErIVvkEMMzkglK
         k9/w==
X-Gm-Message-State: AOAM532jtyfdZq17jhY3GrdHN+BV3ZNW0Yqw8SbXO8RNGaZ0m5G8fHsW
        O8Kk9I1wXFBPnurWYgsw8dPe598WxC8GvLrq
X-Google-Smtp-Source: ABdhPJwKmrjo4bF0p8pUYQeIdZS83xOl+oskg4a+qNPyT2kUD3l6YFC8UlUjh2JUW5Pe6WUfR4jaMw==
X-Received: by 2002:a17:90a:20c:: with SMTP id c12mr17293138pjc.7.1624575797864;
        Thu, 24 Jun 2021 16:03:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm3892429pfe.49.2021.06.24.16.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 16:03:17 -0700 (PDT)
Message-ID: <60d50f35.1c69fb81.ce5f6.bacb@mx.google.com>
Date:   Thu, 24 Jun 2021 16:03:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-83-gf86f3d969f79
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 4 regressions (v4.19.195-83-gf86f3d969f79)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 4 regressions (v4.19.195-83-gf86f3=
d969f79)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.195-83-gf86f3d969f79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-83-gf86f3d969f79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f86f3d969f79f86b06b3f4deb9dc8d905db10c2f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4d779ae5622fafb41327e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4d779ae5622fafb413=
27f
        failing since 222 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e0665f934b21c2413278

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e0665f934b21c2413=
279
        failing since 222 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4d7916b3c68b1bd41326b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4d7916b3c68b1bd413=
26c
        failing since 222 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e1b83735587802413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-83-gf86f3d969f79/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e1b83735587802413=
275
        failing since 222 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
