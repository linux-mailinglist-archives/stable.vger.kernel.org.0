Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77BE390038
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhEYLn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhEYLnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 07:43:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F00DC061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 04:42:26 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t11so16681084pjm.0
        for <stable@vger.kernel.org>; Tue, 25 May 2021 04:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hKMPj6y3pFUxPgqNSqeL9WpZE10C0pwA62V/W5MCpt8=;
        b=rBWgG34LstAcuJ2ZmM+KHd1LTv1+LhepPDTRmLF+Uj4QmVx+8UDQz14axKSRtpN1Hj
         5jN8eWQmv3bgzrwOLkjxDzCzSjEAOIy67xlqOwZ3qmLyHTHdyJ2gjXafZh0rgVrZR/+p
         8AvBG0dEATAe9pdcU9Ryf1NN/HltaCCv1X+IwZYEDQMlIQzbrg6RHcU+yzUd0MttxlX6
         mXzmX2+nR9w4+bofdy8YNy0u4Hf2tYanQT5F6Q1jZhdThF+HgU7KioyYHHGBi0rA5F8z
         KnoTZ7YmUBMJtvRRr6zueXZ2qmghV6VvgoBsHZjc3s7DlsderDj9jDtfLkXEQNLwEkkr
         gPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hKMPj6y3pFUxPgqNSqeL9WpZE10C0pwA62V/W5MCpt8=;
        b=Hp5O9aheB4+mqxKsoP7tBrMrXDftPiGQKJIMJXC3BmKZvFmMulFnJY+0Ni+NuvyqgZ
         IerCmAFWr4nmmv2I7nI9+eOPxogopLWQklDmwc5XNoujcBT85igt0luiJPKxHf2XGzC6
         hrZA0UAdqpMeEJCiL/YoOX5hj5vMWNQr6eXRDPPKlUYdRgu9wpB4MPc4Dyuu3Ib0PFF0
         LDt3y49mmpKBGvM+9oNR+uo6jKYivsltoriSk+rIeW6OkBStDkyopPCjd6Tcv/NU7vJd
         EcXxHgg5QgpjxatiaKZzeryJdg+pw9QefHDwXV0N5tQTQR8fMyVz1BEMSoHB+6xm/TKQ
         plXw==
X-Gm-Message-State: AOAM5308yq4T8LATrVSt8TFKI6Mpf7ZToFuenzfc/SPGS5IIArelClEO
        Hzdz3pk9IHUrOaUwB8iL+XqbNw5lifvIUA1z
X-Google-Smtp-Source: ABdhPJymL8T6S74qPXBXWw1sEnCbYYiOv4uRmyQH1EEp4v+I1EXDYbEX/upozqsFk/bm7HrevW3LlQ==
X-Received: by 2002:a17:903:1c3:b029:f1:ecf4:f971 with SMTP id e3-20020a17090301c3b02900f1ecf4f971mr30253600plh.6.1621942945634;
        Tue, 25 May 2021 04:42:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h26sm13723376pfk.19.2021.05.25.04.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 04:42:25 -0700 (PDT)
Message-ID: <60ace2a1.1c69fb81.3ca0e.d04f@mx.google.com>
Date:   Tue, 25 May 2021 04:42:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.269-31-g8aff2b5b3329
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 87 runs,
 8 regressions (v4.4.269-31-g8aff2b5b3329)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 87 runs, 8 regressions (v4.4.269-31-g8aff2b5b=
3329)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.269-31-g8aff2b5b3329/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.269-31-g8aff2b5b3329
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8aff2b5b332982d58679ea64beeb18b5add9f3f9 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acb49091fa5cf074b3afd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acb49091fa5cf074b3a=
fd2
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acafdddcc8adfb24b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acafdddcc8adfb24b3a=
fba
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acb36ff654aacec1b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acb36ff654aacec1b3a=
fba
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acd0fd9c15f98ae1b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acd0fd9c15f98ae1b3a=
fb0
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acb4a5575f535005b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acb4a5575f535005b3a=
f99
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acafddaa206d03f0b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acafddaa206d03f0b3a=
fa4
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acb4d10af5d21bbdb3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acb4d10af5d21bbdb3a=
fb8
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60acd0fe4bb413d62ab3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
1-g8aff2b5b3329/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acd0fe4bb413d62ab3a=
fb3
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
