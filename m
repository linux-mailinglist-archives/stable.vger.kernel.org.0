Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55F02B312F
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 23:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKNWfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 17:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNWfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 17:35:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E64DC0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 14:35:54 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w20so2157626pjh.1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 14:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E77k/do33GDntGeaaV9lnsBPp1Td4PUF0ah4RmeU62A=;
        b=RV8eMlq54JNgbjB7JeIYlzTTBhZI4OA7kJXENXnYLiVy5B+IDjUHyXskhBnF4tZOmb
         Pqmg0pR/T98504gCDLqYRh+RoOqUQgNXXC7eJ5meQgPRHze764B5k2ozhx/BUr9Gd3Sp
         6ma7j2RydkjmsrMbRcDZWsBdLheK+AScjlVYxyipwEnvR7ug+v9IKHz28o655GGwufRd
         S6p6gjqpkBXhlq0HA8ScYufCZBxY7LW/GT5Feb77uw3QkIiFn46yB2Rormb5hAsRU0Wx
         kr2DV78fiLqt7FFvwmsxgqQ79dmeC8dJK0pPdj5cPvZ5SaMWk0Y8kJVnVEgnRwrMNT+6
         KpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E77k/do33GDntGeaaV9lnsBPp1Td4PUF0ah4RmeU62A=;
        b=Oh93KuXrJ5/qxZsHO6BWFw3NqimlnhOPeFbKT6Iz6hCM2ON/IxlvUb38Q1yo3coWRt
         h+OEb3lvqRUuCMDPX1/94uUvhL7/DAYRXszMifFB5eEoJWMRZepFI3I7Goy9YVKrSHaq
         5wv8giDmDYgB/OQeFVPI2kOOq2Tp+Z/bz11kjDcqNRQoFlQplDOnn4xBp0xHfjYmSCdQ
         47t7VblaoWtsZ1eLdorWVMAJapKWfPmj6CgqkoulRsvIXBJPwd1v7m/WgHP4pWT7Wp5x
         PdsAnJLp/CoZHqHj5+l0bWnJDdE3HKINQICFRr1GdkPp4RBJG+SA92Q2SYAmrZ3shlp/
         I8Ug==
X-Gm-Message-State: AOAM530s4kUczHcB3rVsU4yHqmvKIsf1Cp28K5QCdrxrOMoGS0PuliJq
        eBWEqHyvGwtvj5lqnOE3LleHCH8V9VZFzQ==
X-Google-Smtp-Source: ABdhPJwuPuJ7xMDLofTz6sc5YTTdlFW+2LZlrRlxzXbllnPgcEeXbaqBBUtO0fB5QcNb8S78BdIe8g==
X-Received: by 2002:a17:90a:c693:: with SMTP id n19mr9622625pjt.69.1605393353387;
        Sat, 14 Nov 2020 14:35:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p127sm13715011pfp.93.2020.11.14.14.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 14:35:52 -0800 (PST)
Message-ID: <5fb05bc8.1c69fb81.39b47.e125@mx.google.com>
Date:   Sat, 14 Nov 2020 14:35:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.243-25-g69ef4fdb4e94
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 5 regressions (v4.9.243-25-g69ef4fdb4e94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 5 regressions (v4.9.243-25-g69ef4fdb=
4e94)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.243-25-g69ef4fdb4e94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.243-25-g69ef4fdb4e94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69ef4fdb4e9441ec8332f5552cca3f89f76f4016 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb013f5af4bbf43a679b8a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb013f5af4bbf43a679b=
8a1
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb013f4af4bbf43a679b89d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb013f4af4bbf43a679b=
89e
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb013ef529ebcdbf979b89c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb013ef529ebcdbf979b=
89d
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb013b62551777c5e79b89b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb013b62551777c5e79b=
89c
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb013b02551777c5e79b897

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-2=
5-g69ef4fdb4e94/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb013b02551777c5e79b=
898
        failing since 0 day (last pass: v4.9.243-16-gd8d67e375b0a, first fa=
il: v4.9.243-25-ga01fe8e99a22) =

 =20
