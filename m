Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A134D5FD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhC2RZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhC2RZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 13:25:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36166C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:25:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so6279258pjb.0
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=09bbmE+gt/WqqyBty2pD1ekRW+cZQl+J+RtMIK/AoIo=;
        b=zGhiAj9BlVNkMTa28h7TLqyiQ+EYAJyRC1fhfU4NuxQmqJdnp4dvJfq5cbKT0fZCTd
         0KGeYFOh/ZXcWRHeNTAqezlBfSX93rxlGEgYIn7pSQKOk/39jB9v1eb4qMm4p/brJ2RN
         6lMLZpHIbYaRbhRI/nK8Tz6g7NHESgFTRss3QSq7drfBsM6lQyPHBqzwZd9ZfhQQM0nT
         AKmR0HcZmCvnYAf1+KRG5Ufs89Ys67XP/4OyPHXlbqQZlG8nuKTR/V5XIFU3gpLwgZy4
         zFXwRITkddKEtYQ66nuIKqyuqNrCM119+dOqFR4Tgk6IQkmV2jOM6guI7ODeT4HpHV6R
         whEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=09bbmE+gt/WqqyBty2pD1ekRW+cZQl+J+RtMIK/AoIo=;
        b=DvOe6BCpJXiMGu71xLSGAJ1w3b8F/Ou8V1243w8nWZDJS9Eq5NL/7hRmDrtjrUd9GQ
         HecYAslXXqED2ytShZ7BgEVjMuoqpFQA1dLtK+gezC8QBg3IZ1lReXQQsEvELN3O3dYW
         O9t6e9oJuSZEixnK7X0FMjHUw0Dg5QAtxYHSrC7H2voLY8Xt+a5mRG4mOTx+USQ+f1OX
         bRiQTQFVVNxnXh07miLgh0ZtJVA8OB6cWNOpp+Njpw5nZhd+cfq4dFF6Tiu4mG95Mu0e
         faMYdFpoi6OitiCUkQ16hCPZSCgYbmrmwpEbSTvKcA8KBb+VNcFJUNSDSUgacXZQLCYi
         MDsw==
X-Gm-Message-State: AOAM5302NIDKOKlFc3P+dmugQtJwK/uYvAgIvDJu6OHWW1sw2mf225Lx
        +ougwplGXaNMMcRVRGCMFWAzfF9SnJhafA==
X-Google-Smtp-Source: ABdhPJyf/rAJ2OzXPISYFcROjsaRpfOc6dfGEBA1Ycpx5c4fM1wtL+dSNuPRwlXsTzNoIBBO03yGow==
X-Received: by 2002:a17:902:edc7:b029:e6:f01d:75a9 with SMTP id q7-20020a170902edc7b02900e6f01d75a9mr30422843plk.63.1617038725473;
        Mon, 29 Mar 2021 10:25:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r16sm17541946pfq.211.2021.03.29.10.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 10:25:25 -0700 (PDT)
Message-ID: <60620d85.1c69fb81.83ae7.b2d9@mx.google.com>
Date:   Mon, 29 Mar 2021 10:25:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.227-60-g4cee23773c6e6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 125 runs,
 5 regressions (v4.14.227-60-g4cee23773c6e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 125 runs, 5 regressions (v4.14.227-60-g4ce=
e23773c6e6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.227-60-g4cee23773c6e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.227-60-g4cee23773c6e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4cee23773c6e6701bbedeed75e7d4dd2fe5bb8c0 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6061db674f89549c68af02b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061db674f89549c68af0=
2b3
        failing since 4 days (last pass: v4.14.226-44-gdbfdb55a0970, first =
fail: v4.14.227) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061d467cb48ef9a00af02b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061d467cb48ef9a00af0=
2b5
        failing since 134 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061d44c07ea198464af02be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061d44c07ea198464af0=
2bf
        failing since 134 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061d4603db3e462baaf02ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061d4603db3e462baaf0=
2cb
        failing since 134 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061e553b837ddf372af02b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-60-g4cee23773c6e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061e553b837ddf372af0=
2b7
        failing since 134 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
