Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8107F35F9B6
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhDNRWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 13:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350246AbhDNRWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 13:22:17 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC4BC061756
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 10:21:55 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u15so1956423plf.10
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 10:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y2VIvGy01PuqGzKanAgbXqmfLABjxxZrQcSXKnOqOcU=;
        b=oUTM65XxeHLSj4E0tPu9P7Se//E3eETiDioy2S0efim+nD1JPEUNlW/m8EL0ULi2UI
         E0BB8vrN/gyb0jHhsZ0sH28SdNdWb5HvEPn0/0UYdO/PAsLrOFCo2UaaJKJZ01g1JW/u
         yOgVm+84D3qMy+S8vNbVDpT6LdbmUg0hhUHme19Lp9Rho79HaZkYJqUsPYdpnIJp3Sci
         4zTS3IYvgCh3+8XDWqVHafnxeawwJFMV6LGwpJxl37mGHzpMHMv+5VKgIUsTRIGyJnQ4
         fbjZw4yrYp6/at8ij71tXRdN+Xe4c22kVcAP4oMDYNplKU0SWMP7X4uTZ2vVH1GLmmjJ
         2wIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y2VIvGy01PuqGzKanAgbXqmfLABjxxZrQcSXKnOqOcU=;
        b=s/tFFR60bHGyKuUu7w/2abOVASUdTgaP/Z6EWnZ7KAUlcH5i8xEcslrAb3yQ0BfOof
         Ob8bWeTAJHRbJAexe9lLJOMjfFrQ4f+ZwfUwwFpI9H0yUHBWU7Is/Ao6Tbtp5VpcANnq
         GQUX3GJQSWL8Yo4/2jCU/cG5WEfnkjPwD1AhBLW+oFs4KC7t8aXkHdRHbPUuTVe31PXk
         GSc26Xj6iDb9Jc4bnhZFp8gijGq5XoWRwIR026NVzaX6qN8V6YjRX/pQrOWvd1WG8345
         DUJD5tu8aTlw7ddoFNHd7AeWDc3iVZovLiQGWK4JBvzFF0snoFIwzDg60eW82i4vofcX
         F6JA==
X-Gm-Message-State: AOAM532y5u2+kOMT3lOk0F6DSRFPjS0iRVLYQoKDDOjR8DhBuruDZKvW
        Idvkn1PyMRimWcdhmeVE3TTZe8/bszZ2qA==
X-Google-Smtp-Source: ABdhPJzZnLo4Qs1iCIfzseH+G5Rt9/CHyNIdWyZeuI6G8xoofoMI1NI2EoSoT/ujzCbDu6Jki1/Piw==
X-Received: by 2002:a17:902:442:b029:eb:4016:45ec with SMTP id 60-20020a1709020442b02900eb401645ecmr7188502ple.68.1618420914879;
        Wed, 14 Apr 2021 10:21:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10sm157080pga.8.2021.04.14.10.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 10:21:54 -0700 (PDT)
Message-ID: <607724b2.1c69fb81.5d10a.0900@mx.google.com>
Date:   Wed, 14 Apr 2021 10:21:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-59-gd3bd1bb369814
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 106 runs,
 3 regressions (v4.14.230-59-gd3bd1bb369814)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 106 runs, 3 regressions (v4.14.230-59-gd3bd1=
bb369814)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-59-gd3bd1bb369814/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-59-gd3bd1bb369814
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3bd1bb369814fd5868d7f4d5e3df97ae75c86f2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076f04950117158e9dac6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gd3bd1bb369814/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gd3bd1bb369814/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076f04950117158e9dac=
6c8
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076f0366eaaf92ee6dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gd3bd1bb369814/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gd3bd1bb369814/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076f0366eaaf92ee6dac=
6b2
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076efefcd1bef4291dac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gd3bd1bb369814/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gd3bd1bb369814/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076efefcd1bef4291dac=
6be
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
