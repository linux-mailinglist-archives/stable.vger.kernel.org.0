Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EFE32FBB0
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhCFQB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhCFQB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:01:27 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A0CC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 08:01:26 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n9so2492756pgi.7
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 08:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ap73AzTtL1C0yOOux3gNiUTMW+nAR5JImIEc/+rpnWc=;
        b=w6MoLGM2CuGaxrhRIKRJsPa/7NjKYxT+Vml2ccTWzwP5NKkOuhW7zk4fbLtqQumrnr
         tqsFL8BLmm3Lfh0T8Eq1dvbT1he7RR1xQa9R7aRDa/syZ/IuvUpLKrvLiJv7ei8sCOlK
         koy477cvCNK5O7jxs+4XhbcmCdq387LHWlp48NW3q9/BF9QRWpeetYCk1oOKSfac1gnE
         bUd/7AtDRp2oSxlqlDwsiw0JlCqVQ6VcAMY8Nb/EHc/m9E+thxTTBR29rR9ucj6UJ4v0
         6d90PVqW66ampY+73kv6vmdusj2ddeTu4yUvQzmhZ5f1onZ4ZmGOWe3O4jdZPhHd3Eka
         8ZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ap73AzTtL1C0yOOux3gNiUTMW+nAR5JImIEc/+rpnWc=;
        b=O2qCQej9zErZL7cWvJryrZk/fuUesWz3wo/SqEvW2ptXayC8ilO3Fv0iKCQwCNR/aD
         LnYID1iA39xBNRrbjkZtezWjjWc9ZyhhAiSua5ztRtvNp3/Y1YcZKYaKBlziyXkWsMMR
         BU3yg7di3JOX3eThHNE+MwwKTPj+NXE6uHCsldmEBZ5xrFNcxeaT2MUQEYVDoCYH0kyS
         7nA4bddX+3gBrQbn06q0GXKLXEhs+MqwUVlI4tRNHRe8+2SoxC8kGrsU+yNEQ1qs/PfH
         lw+L0On32DIQSkDhkQJtQODgn5aqMHtkCxfUbHkYZvizAXhphmKwMIllYe3TbmuuBNMm
         7Xeg==
X-Gm-Message-State: AOAM5319lC/MjmCv9feGEGI/W2m0rw+HnTBmH71LFwV81OlQ0P4mOEYl
        INno47hcEnFl312+GSsnbiI4w6a7YYED/g==
X-Google-Smtp-Source: ABdhPJynJfpQE4TLDF+mZIvDJtVnCKI4gdoTlTE2HOXjUFjaapCnwM94pmtMBUtBBaaF4LhaXRZ/Eg==
X-Received: by 2002:a63:cd09:: with SMTP id i9mr13743292pgg.407.1615046485941;
        Sat, 06 Mar 2021 08:01:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r4sm5442797pgp.16.2021.03.06.08.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 08:01:25 -0800 (PST)
Message-ID: <6043a755.1c69fb81.22950.daca@mx.google.com>
Date:   Sat, 06 Mar 2021 08:01:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.223-39-gddab7a93ed6a1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 98 runs,
 4 regressions (v4.14.223-39-gddab7a93ed6a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 98 runs, 4 regressions (v4.14.223-39-gddab7a=
93ed6a1)

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
nel/v4.14.223-39-gddab7a93ed6a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.223-39-gddab7a93ed6a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddab7a93ed6a14ea478771b1b94dfa2d3e9a2ec7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604375ed1949a80d7daddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604375ed1949a80d7dadd=
cb2
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604379330ec32678d8addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604379330ec32678d8add=
cbf
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043721e0788fb9f3eaddccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043721e0788fb9f3eadd=
cce
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043722dc2260bc06caddcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gddab7a93ed6a1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043722dc2260bc06cadd=
cb7
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
