Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CAF32E577
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 10:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEJ7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 04:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhCEJ7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 04:59:00 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCAEC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 01:59:00 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id j12so1629219pfj.12
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 01:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LOirqbJKlydSdBV66dkbkzfdWcxoo4854SZmy8f2EeE=;
        b=CwRxUiIzoaWyBJUZ2TcHamZN0exWq+qmoeCVuVxYMA8n/dA2tp7LwfrcOGArdpDIpJ
         Nd7JWn4O9Yyy2lBWdjwGr1/3kuZ84sFYDcNJsh16Xst6deXlO/7qMT9UDLkiI/GXtzUl
         FpRZkmbmI3glIfzkxYd/IFv74gSmARqq7MsAW7En6lwu/xjQ2FzdO01eZpzlqfPIpJlE
         Akf1VJOmEHEiXc9L93dR51urPXW8EeeKm6G12apDUw6Gjjtn7KS9uxqkATjsHdoYpvVU
         BYRy3ZHNrflECNRglInXjm5oWsqb0U14PrgT3Mu9CMQNNyKCrTnSxZT6ZwLiHzYunYBX
         003Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LOirqbJKlydSdBV66dkbkzfdWcxoo4854SZmy8f2EeE=;
        b=KyfX1YZwlvYhB5fpkcBPiXzSM+tVgiKaYkNfYZ75skdHJHJiN90mSTSv4a4CDSIyZN
         +0im6FIsvr+JtCexMIUrJukqpc/JCgOKLswvGYjFanBSjRLO/xGb+CbJyUILd1WCb6Me
         EyeOnNd81lXgKpFOZ8YuZ2aDHcrGm389iY4ZMhD9Gvl24MQtZUZr/n5RuFcfSrLDTner
         6Bk8bR4+6dDoW05lrSh20oJF7Ezd0040Git8YKuES/9aIIPp32bVEiYoa0MKe1z8WbZi
         76ZKbGokWsOoGbZPVYaXqQs3JTaqp9nPAfrq5DpgCLv4CYe2hf/LUx+uRjXp8C+bA7ui
         PC5w==
X-Gm-Message-State: AOAM530UTjyE9xiz9OTtfqRtf44kHc9gxe6x3NDNlVt/EnnlhQyySwQI
        DaDei6dENvROpRsEEe7vgMI/1/rGtVkXrdeX
X-Google-Smtp-Source: ABdhPJwvZDuGn7kf+eYAsRRKt1UOoTRT0vjHZTWtdNxJvCOBb9m6smOWB5nVdV0u+wtjOcmjtMx/lg==
X-Received: by 2002:aa7:8ad2:0:b029:1ee:16f0:7c70 with SMTP id b18-20020aa78ad20000b02901ee16f07c70mr8074424pfd.58.1614938339518;
        Fri, 05 Mar 2021 01:58:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4sm1790847pju.44.2021.03.05.01.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:58:59 -0800 (PST)
Message-ID: <604200e3.1c69fb81.bf940.515d@mx.google.com>
Date:   Fri, 05 Mar 2021 01:58:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-60-g733b10f093f3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 115 runs,
 4 regressions (v5.4.102-60-g733b10f093f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 115 runs, 4 regressions (v5.4.102-60-g733b10f=
093f3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-60-g733b10f093f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-60-g733b10f093f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      733b10f093f3cc7c9944eee46486a354a64fa632 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041f2285b035446a6addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041f2285b035446a6add=
cb9
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041d5d59ada802b01addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041d5d59ada802b01add=
cbb
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041ca3227b07c3263addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041ca3227b07c3263add=
cb2
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041ca5573a6fe3c8daddcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
0-g733b10f093f3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041ca5573a6fe3c8dadd=
cd2
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
