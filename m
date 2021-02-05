Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6AB31103B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhBERC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbhBERAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:00:11 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1DDC0613D6
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 10:41:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 8so4005951plc.10
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 10:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WqR/kg7dxdyJ4YBqiHKQ3nk6cqrzo6YBG5J6eHUQNjU=;
        b=Nt7Oer2787maq12QDXsxEoOcmhuGzal/VtOZkqyftcmc7Du/HSd6TaSL4MLESCe/h0
         tU+Vfu/oUkx76wZ3WaVjcoFBB5jSb42Bu4h2tnw8QoBglXdkVjDZy81nXeOAQwmUWBTX
         6XBmMVddH9QWPEz9D3RrYXNLmXj/oo60jeM3L4IAsOpXRNkHmRFq32bFE70LKcKoYPSq
         bd1SFu+lvFHyT0MPIImDUUSUMm4w43HsVAO6paRIX0/3kQDgXeJ+QyiA9Hbq1cGS+7iW
         Gl29buunNcw1PiITnouTAcWhYkcXf4Amqvh7WIOeYxC4MMxJMO8XJjZx+Uw5VzHdUMm/
         hDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WqR/kg7dxdyJ4YBqiHKQ3nk6cqrzo6YBG5J6eHUQNjU=;
        b=bAJBpyDDwwT0/6lOAv5fsqxETljXTj25LvR7Ef8tFyySWmmJUPWGBIyVqah9BHGWgl
         ltOM4JZbGYwYLKNqxSC6xIxXT2k0bImsruqQwOJcmS7BdI8it8/0dJ9zfCnpVNiwTTKj
         dEkU0ncZ6HazsjCga+UoI4fTVyjir2a2DwF7/S8XxgtfsEydC+UW8lu44G2Fc4k9IcdL
         0frkexQPGumhi1Hu/fhlObVuW6NXMYAslL3lsxqsuQddWPuMLdN7UbTLAl6PDeu2DKy8
         G4NjgFZpJwtnA3zo+6ZKMRDi/AjkxK4TaamwoyeD3elg6JwRhitGzQFRuTs7pDoPBGyJ
         L3WA==
X-Gm-Message-State: AOAM5330jhGiMhiShlDdgI3DwWJ+zxed5AkIg8ILL3/4ahdCtPzSW35R
        xaDhhVd2Glr8FPmo60IXYLddM481LoatoA==
X-Google-Smtp-Source: ABdhPJwhR7XMGhFoxIoAKmLsfw9n5PYrvCGnsNp7yoteViaz7EaWULvCNH3E8gsY970q3rdzTsoEZg==
X-Received: by 2002:a17:90a:1f41:: with SMTP id y1mr2389389pjy.90.1612550511829;
        Fri, 05 Feb 2021 10:41:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p1sm9803454pfn.21.2021.02.05.10.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:41:51 -0800 (PST)
Message-ID: <601d916f.1c69fb81.b0ed0.535f@mx.google.com>
Date:   Fri, 05 Feb 2021 10:41:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.256-15-g8daa51cc2c986
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 85 runs,
 10 regressions (v4.4.256-15-g8daa51cc2c986)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 85 runs, 10 regressions (v4.4.256-15-g8daa5=
1cc2c986)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_x86_64         | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.256-15-g8daa51cc2c986/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.256-15-g8daa51cc2c986
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8daa51cc2c9869f4318875ff8c59ff4cd7280642 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d57f5fe76b2839a3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d57f5fe76b2839a3ab=
e63
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5c76c68754e3be3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5c76c68754e3be3ab=
e63
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5cfe19929503a03abebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5cfe19929503a03ab=
ebc
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d59b2fefd653e423abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d59b2fefd653e423ab=
e63
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d585129eb853cc83abe97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d585129eb853cc83ab=
e98
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5cf519929503a03abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5cf519929503a03ab=
e6c
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5d71472697c9523abe87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5d71472697c9523ab=
e88
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5b74edc5de7a0b3abef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5b74edc5de7a0b3ab=
ef1
        failing since 83 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_x86_64         | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/601d58f44cbe7e31b73abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d58f44cbe7e31b73ab=
e67
        new failure (last pass: v4.4.255-2-g60059b02327e) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/601d58dea0b55da83e3abe6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-15-g8daa51cc2c986/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d58dea0b55da83e3ab=
e6f
        new failure (last pass: v4.4.255-2-g60059b02327e) =

 =20
