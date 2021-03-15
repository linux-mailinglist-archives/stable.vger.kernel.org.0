Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4301633BBF6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbhCOOVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhCOOVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 10:21:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE0CC06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 07:21:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n17so11828801plc.7
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 07:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pp0/6lFSKn6S2SzCnS/fP41BAWdf9okipe507/0DuZs=;
        b=VsPqiD4s10bwn1DOwf+GOty2d6VMe1wMc5wEtTK1I11U0PtZKDJnesCAA/eHU39Q6f
         HrUwSCpIyRoC4o3jl+LzGInHEq2KKl4Ajmqj3hheq8uomdFVJCKCW1IVr4G7qvL87nhZ
         aaFJelSmhHkqyY/c26aB3Ky/uVE4N4gPSNUYVhCGA6BgaKQPCDK+BkFnXzLHBYYZQJte
         1KXOJyEJ/JcKACtj7vVZciyc+z/boeiI33okW6jSBjj6OrEMP47Mq5RScYaEHtKeHKhf
         VpYOBRgE05NkiKu9eHFm589FKp/cPl0Pz8Ee9p2uNvAtuQtb2O5gF4odDy3Ny3Eh/uzb
         S6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pp0/6lFSKn6S2SzCnS/fP41BAWdf9okipe507/0DuZs=;
        b=EvUbT/PCow4irsRMhtXN37fObaWq2nQAH0wgOhwY8m4GKFv8A5hQ7HzWe8yu1M9v+v
         wTJtbAQfkFaRmJ8b/m8zxsK+aq4DbnoUtGqdtZx1Ln63ECHjEjBO/zO/J+/g9ACM/4Kh
         ZQEouVGISYVzjutGd+GB6TZN1Sfs5tf3wWENgRAMCUCNUIDWuuo7Rb1lOX3p/aJwO7iC
         C2QcJfIz0FDfk+coIi8qiYwTP9dSxKU8gOMi3FP8B1hpCttn/YlJJu05BqK7dYobsxHA
         XlaP1XZrO56XDCTdEB2cLIyaxl7U7I1bB5jLbrR/EAEbi8eF5tZGj/x8W/T+UR2dRuTq
         1O5g==
X-Gm-Message-State: AOAM533CuatHaOXu/HKfao1GwL24/rYHaR9jNu6nAXYitTd5KzMdu7A5
        vsE9bcB28D7uvuIpoeqNvZe6EnTl24t3TQ==
X-Google-Smtp-Source: ABdhPJyZ0QYz5i8JS7OmOwwYEU3p7p+mrMtVCUW+EzcLRStcjmTyzhuzjLxny2BIRadFkddTAdCJQg==
X-Received: by 2002:a17:90b:1090:: with SMTP id gj16mr13050328pjb.57.1615818093427;
        Mon, 15 Mar 2021 07:21:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r23sm11670821pje.38.2021.03.15.07.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:21:33 -0700 (PDT)
Message-ID: <604f6d6d.1c69fb81.2ba06.ade0@mx.google.com>
Date:   Mon, 15 Mar 2021 07:21:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-116-g4e76c9761792
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 105 runs,
 4 regressions (v4.19.180-116-g4e76c9761792)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 105 runs, 4 regressions (v4.19.180-116-g4e76=
c9761792)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.180-116-g4e76c9761792/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-116-g4e76c9761792
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e76c9761792a45a0d001137ec6662971925fb2b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f37e737f9d427cfaddcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f37e737f9d427cfadd=
cc4
        failing since 121 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f3eae5a26949606addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f3eae5a26949606add=
cbb
        failing since 121 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f378f84c982170aaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f378f84c982170aadd=
cb2
        failing since 121 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f37aad1333e6a1eaddd0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-116-g4e76c9761792/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f37aad1333e6a1eadd=
d0b
        failing since 121 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
