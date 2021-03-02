Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FBA32B22D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbhCCAwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351759AbhCBRt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:49:27 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE9DC061A2D
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 09:48:34 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u18so6265119plc.12
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 09:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=grzGJb4yJqAYhHaW3waovLEoXOTRMnm0oeXY1l63NxE=;
        b=I14yfEJ5LqBHCsUmlD57vTdZhZFy5Ia/O5TG+xXEAfjA3rWGC11B/JMODhhB1bT/zo
         qx7ux6WTYeJlfvHPlemNMxMwHUSg7K7BylGjX3FbId+AE7Aebl21aQpN8XEZfmrmLWSK
         aTf10uM1tAtUvZM1DWqe6sJPdWLiEBxwQLeiukAcelSgD+DGyLV6+m1MiB/De2FIit/H
         T+fwIIkGjZcM419p7G73bLSEk8PXw5dR2prLqiKLrYP4bvw+QUu8J2CSAiMG0jV8duLO
         1j8Z0mzkpjVZtFP8slUDMFaJRiCGn9FRoySN4HDFvPKChCJgZa5SujgQ7flNZTTIE3Au
         vz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=grzGJb4yJqAYhHaW3waovLEoXOTRMnm0oeXY1l63NxE=;
        b=BlWhKhLj7+ribSL6QXlffxqncpEf9g9zUQluBhpM1En/RR4lq3G7Ra3xDSPx2RLHsV
         IVprVDiaNnUskI5/dye8djSRytpWQ/t1LNpHFbCPke3hWmm0HS6ApTgtUqwGgFI9vYFm
         Hqjsri/uTimy1It5TiDZ5n7MSuqn0BCk5zj8n8djGKx+RrDJAoKIgQPMSV/1z1bXcRyg
         DU84CKge5hRQjhN+b+x9xWHk7WLojg/BaohqSWsM6j2Ij4KD9fxmnVWiZZwbq59y5ewT
         e3UuLILIOZ3TLiCYLuM7Iib2CdgeCckxRBUAqZk27/oVP8lquXiASVKDRoDPYZMOSBUZ
         MK2A==
X-Gm-Message-State: AOAM533U/sU4XgJKtNVtmw3jOKD9Om6RbeUqxPHW8AwLOCIerSGgitsb
        Z+1AYGZ5nQjNy/MO4aTo28zyUwDtsG2Rsw==
X-Google-Smtp-Source: ABdhPJxpgAZYWBwTgwmpyrHUFqrEJhB5FDht1MXZTTjpym2jcF41nU+4nzti/XsHQkgbpc/gefdSdA==
X-Received: by 2002:a17:902:ba91:b029:e3:fe6d:505c with SMTP id k17-20020a170902ba91b02900e3fe6d505cmr4611429pls.7.1614707313957;
        Tue, 02 Mar 2021 09:48:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm21749467pfq.103.2021.03.02.09.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 09:48:33 -0800 (PST)
Message-ID: <603e7a71.1c69fb81.7fb8b.1d50@mx.google.com>
Date:   Tue, 02 Mar 2021 09:48:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-176-g6f669f69c8c8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 101 runs,
 4 regressions (v4.14.222-176-g6f669f69c8c8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 101 runs, 4 regressions (v4.14.222-176-g6f66=
9f69c8c8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-176-g6f669f69c8c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-176-g6f669f69c8c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6f669f69c8c8140f24110d1d53bee825e60922fc =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e45a97e06e35b12addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e45a97e06e35b12add=
cc8
        failing since 108 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e45c13691044057addd1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e45c13691044057add=
d1b
        failing since 108 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e45585c00938c21addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e45585c00938c21add=
cbc
        failing since 108 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e7523a7bdc6e2baaddcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-176-g6f669f69c8c8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e7523a7bdc6e2baadd=
cd1
        failing since 108 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
