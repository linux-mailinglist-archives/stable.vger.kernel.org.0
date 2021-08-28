Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4223FA3F2
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 08:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhH1GHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Aug 2021 02:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhH1GHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Aug 2021 02:07:00 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634BDC0613D9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 23:06:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id e16so7201334pfc.6
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 23:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VJSd/y0WzGanWoDAErR1t596b3acbui4dZsiUC7T5JE=;
        b=RT2zxQ324yAYHNVtZ3XVrTFfKJqzVxehIiOFYptooVkI/2QlegyyMlH99ChaQytIXi
         lke3WaijLot33IFf/LI7oHmhQVgsgY460r3GF9bVYIz5ldet0UOWPMemgdyMiuU78X2E
         Z4LYm73tBxZhklILqFz573rOkkR3W251kH89zieg873OU6ez+S1OC0YpqBFeyYFpPJXK
         tQ1DAt64b5dMf77e96bWffhzuUqbyaZurmOzh3F+Gl2t9lSknX9NpKrqIyN+2+2JSjgO
         x+hXv5jCLkE+iWSwKUq46TCxWtf1UP3xWuRDSFJip3KarZ8tnhJmd0rUg8qNd0WbsrSg
         de6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VJSd/y0WzGanWoDAErR1t596b3acbui4dZsiUC7T5JE=;
        b=T3J6MAkwWBUy/v0YjFRYUyKxidd6D+vvH+OWxedkXyg2dlYRkNcAkeBdzcfmR10vj9
         QGh8XPhsuqi1a15VynTIIdvOgtvYB7dKeYkjPBdEpFyRz5oQ1BbxYyaKjY8yh1EAB7WF
         ZJLd2PQbvRGJrntdNf9ymIKiKNXAUUs1N3qsO3GYq8ep7/i/NrRETRn/nswXB3tSBfn0
         f8W6iwp6HDfWDzTm9bV0RdUmEuZtMN8bT2US9F+nVZwVkQhVb9XTHAi1x7Ge/FhGGk4i
         bM//ctljASF1gxYqvXCPiOgdpQyFWOUZ8QSMBHx2uQ1fzLJ5KZaW52UALyztlQQPMVmG
         Pcog==
X-Gm-Message-State: AOAM532kWZQePbVhXKuafcOjz1GO748+uo6KfdzNGTyLed3okHliEbWE
        jJdUpaGaQJtsN1OGAdD1Pi/BzAUadGrMlsP7
X-Google-Smtp-Source: ABdhPJxO9i2jQNaU/tAYHdIN2FuipuvDjB9fappHLscUxm4g4piD62mN0xdxZ3Hi+Koo/oa6Kt8Dwg==
X-Received: by 2002:aa7:84c5:0:b0:3e1:16bb:6e22 with SMTP id x5-20020aa784c5000000b003e116bb6e22mr12626692pfn.32.1630130769575;
        Fri, 27 Aug 2021 23:06:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s5sm8913285pgp.81.2021.08.27.23.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 23:06:09 -0700 (PDT)
Message-ID: <6129d251.1c69fb81.1fd30.942d@mx.google.com>
Date:   Fri, 27 Aug 2021 23:06:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.281-1-g408baf10622f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 97 runs,
 4 regressions (v4.9.281-1-g408baf10622f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 97 runs, 4 regressions (v4.9.281-1-g408baf106=
22f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6qp-sabresd       | arm  | lab-nxp         | gcc-8    | imx_v6_v7_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.281-1-g408baf10622f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-1-g408baf10622f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      408baf10622f16bb098e675b9f104b5061fd8b8c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6qp-sabresd       | arm  | lab-nxp         | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129ab2c1bc24c1c988e2c81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabres=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabres=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129ab2c1bc24c1c988e2=
c82
        new failure (last pass: v4.9.281-1-g541bc8044fa7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61299f52d3aa79b6d48e2cae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61299f52d3aa79b6d48e2=
caf
        failing since 287 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61299a0c6b31a5d7288e2c94

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61299a0c6b31a5d7288e2=
c95
        failing since 287 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612999a46d3d444d338e2cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g408baf10622f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612999a46d3d444d338e2=
cd1
        failing since 287 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
