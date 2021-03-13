Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0B339BA4
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 05:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCMEDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 23:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhCMEDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 23:03:32 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CB8C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 20:03:32 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n10so17119123pgl.10
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 20:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p0bKFIP2UFCq9Vf7saBKhj1/3VnkgvuTfP9Zte/5xJE=;
        b=jid+5EKfsmMljTs9QOHRISFmCpl1lpOL0KnSxfB3lyUODQWKdfPHF6F4F4y7d4QpAl
         RKw0oMUTFIrwbyFhHhJwIyF03b8J7BcB3vCbLORYpwnX9PrfHU0V445N0xezRkGIDJhQ
         mczfPxcBp4KooeM2cP6DULZmYtRLjWyqOnA7vVjEKA9xTO44q6rflSpTTVFQ4fRUMqk5
         bbjlhUVIajPRi4NqT+pljKvKzE34CaCfX9Q7qY0Z1R3bLzj/yxspvwRD9IqOGlUjs+MM
         wgekVQ9ZpBcEJAfr+TqJBTpHrmG1JbLr+KAiGtvkayB4RS7YGqpU0D7IsUo5qJgR+nrD
         YA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p0bKFIP2UFCq9Vf7saBKhj1/3VnkgvuTfP9Zte/5xJE=;
        b=mx01MbKDH90sr3XGlcBAytiEKR8lMIJ4uxkL1p8eucdIJie1HWbjYOYDfQgwdbBDUq
         SfTjjs6KlNG15CoOpXLXWiOW5tIY3zuZdMelZiFn9wzUIs717zk/aAzG/ly8Ez6JFD9o
         X3PjCfHCPRTTNtJT/l6vE3d2NP37RyPq9HEgNOAhpJcu31m8X8ZCrir+iLFnK7Yrf15k
         E+9hyvZD2zzlmYZmCf5Z5iArPb+J9d/DcV1WSEWSugdkhZ2HSjqC2KS4y5baO1OkbO1K
         XGMLdkw9WL/tJgPjbcKOQoechFInyUchfNSCDCmCHD1SU1Wk43O+joK6FhDv9VURRM55
         XH4Q==
X-Gm-Message-State: AOAM532PPSADz6rZbZS8e0wLfHyRuaJhsnjI8F62SMJ101a0KuCGe1SW
        5otnyuBKmtM8vUE8mQ4aAY6qt0IPCkOkDw==
X-Google-Smtp-Source: ABdhPJxFkbMW2iTmgDZdRDj2TRa1+O7BBZkhxVfc5GXMuYGj0o1BOdGsZMVOiZ3ANsFr/7W+s9dG0g==
X-Received: by 2002:a63:4513:: with SMTP id s19mr14231004pga.229.1615608211828;
        Fri, 12 Mar 2021 20:03:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b186sm6958630pfb.170.2021.03.12.20.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 20:03:31 -0800 (PST)
Message-ID: <604c3993.1c69fb81.a1d55.3201@mx.google.com>
Date:   Fri, 12 Mar 2021 20:03:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-17-g0640bd71e2fe1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 90 runs,
 4 regressions (v4.9.261-17-g0640bd71e2fe1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 90 runs, 4 regressions (v4.9.261-17-g0640bd71=
e2fe1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-17-g0640bd71e2fe1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-17-g0640bd71e2fe1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0640bd71e2fe151eeb494c5c41a3ce22241b38ce =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c062bd3a3ed1271addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c062bd3a3ed1271add=
cd0
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c061cc1fd3b04ccaddcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c061cc1fd3b04ccadd=
cd9
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c05cb88cc4460eeaddcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c05cb88cc4460eeadd=
cb9
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c0f40f73a113182addccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
7-g0640bd71e2fe1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c0f40f73a113182add=
cce
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
