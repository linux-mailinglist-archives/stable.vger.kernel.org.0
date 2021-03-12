Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C1C339042
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhCLOqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhCLOqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 09:46:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A6C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 06:46:39 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so11160580pjg.5
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 06:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Asj9gRGfe6N74WWsG4+SbaeArPHgVuOzIUNtIOKQKfg=;
        b=cg4rvVwXpqwI0t+pJC4e+K+1zVs5ulPYfs8HlR47i96M+2dbiRpB4jfpTTrMIkMiXf
         MDIJEfM5+sBRKYTQVjustEet3UmHmH7lPpf/1TBtn1XCJq/NQgStuijca4XR8PEWfWHF
         QPm2COPExDU/6VQnKgHQIqrSenFoKJsbuUnLRyX6wqrf3kza9jDPsXzEUP6a7UHHlcKK
         UkoPsBQAOu7W/a28Zpt7X9NRPIqrkZFyCmITLQmwxHQQqYEwLm1tfzF86a/gA9G8LhC7
         QOkCNzHcG9J6ZnvK17ntwMzVcCeOWydZgtQn/bofseqS1UcGZhc3DevwrkILEMF57kZi
         pVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Asj9gRGfe6N74WWsG4+SbaeArPHgVuOzIUNtIOKQKfg=;
        b=q/J1MuvH5VxUMl6L7U59Yqrk7lLodVHEv0gA9r2SNquHpLNOScVnUGPnaDwErg7ZIJ
         EvOIpYgUFc/8b18sOGab6M8eAaq7/Uke5lAvv7B3KbeQ0GjxJjJJRyVVe5f0ce9F3QAU
         BO0Ny8idIRJNTjt6ZufjDYULGmOWBbhxJWhbxXi/FZkEf5y7m7eQ9WPcyuJkjFfwZx9z
         wtqzYSYnwmnTOLjXvJ1SpiVDmK66/ulGaSAq2j8DJ1wE/wnRp3XRaM6gfYzLlLW3SsyQ
         ogR5BDmTIwm1rwLJYHU+LzUo592HdQHg7lWKNdfy3H5gTEGq7o1S3LLstNqSrIQ0qQ/O
         PVFg==
X-Gm-Message-State: AOAM530h65VIJ87DtKN1G4rayQjrxL1rxmuPhMKR/hA9qmmAuSON+i8n
        MuEnY9g96a0Ma7UtazOCpXGxLSHXbSS3Fw==
X-Google-Smtp-Source: ABdhPJz7ozPdzRW5pnOFDwdUEw3lweClSNhZil6O3R3b0uwllkuKfYyemesLTPzUTp5761jRbddsOg==
X-Received: by 2002:a17:90a:c201:: with SMTP id e1mr14380411pjt.30.1615560398424;
        Fri, 12 Mar 2021 06:46:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o13sm6016086pgv.40.2021.03.12.06.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:46:37 -0800 (PST)
Message-ID: <604b7ecd.1c69fb81.f442.fb16@mx.google.com>
Date:   Fri, 12 Mar 2021 06:46:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-18-g4334f738815bb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 80 runs,
 4 regressions (v4.19.180-18-g4334f738815bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 80 runs, 4 regressions (v4.19.180-18-g4334f7=
38815bb)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.180-18-g4334f738815bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-18-g4334f738815bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4334f738815bb70bac655ee0831e20fc4110dda9 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604b58e2bfb1917448addcd2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b58e2bfb1917448add=
cd3
        new failure (last pass: v4.19.180-12-g6a32fa6ca6b5) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b4a47120ef864f4addcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b4a47120ef864f4add=
cb8
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b4a85ba91a0789aaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b4a85ba91a0789aadd=
cc7
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b49eb56bdd00190addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-18-g4334f738815bb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b49eb56bdd00190add=
cc8
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
