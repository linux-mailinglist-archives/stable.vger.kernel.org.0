Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC3B32FE0B
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 00:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCFXni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 18:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCFXnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 18:43:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E7BC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 15:43:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z5so3184946plg.3
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 15:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r6oYXZUxK+REZdSjSGV5fOIX3afkqh4DTjdH/Cot22M=;
        b=qH8O6qPsW/6EnmQCIKnRhH3lhm6BsqVM60qHttA9KEl4eSLUQSn8udmyMfqihnArPd
         V0Zvm2oR8K/F5IhbEFLmzU4bcllvOy2qu0eMaIKUcdU2+cGXtNjr2ctSn7U+bG3f8NqI
         pfCZdUAQ6dipnwNxCXWW0bRRn/bncuzkbCGoOEPOBrXO4MJ1kYJXiZqniDrFn2G/xu5/
         1t/CgkZYkw5zhbKnQp3UnBpCGYD25qHT5ATeqM2EEigSnPYp6lUI/l/YSASgo56h7OJx
         CjD82rE8ruBQbXfdvntwDPRCJ3CEP4O3JZCPwC8VY8BkJgK3chd0YDp8A5DwS74Egw7B
         i2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r6oYXZUxK+REZdSjSGV5fOIX3afkqh4DTjdH/Cot22M=;
        b=dlfKU54SDJnte94LPqLGC7KuY1aDxSTb5uYoZNshQb8S5fgBp9vzQXmAY4HQNiZk5Q
         gDQ4u75ewrtJ+JkTIIsNCiYaOdIB1NZbCJC01htF5zGTZd33uDek1rszQfaJfbigIetj
         f+NQfo5TDh1nOkbcV4zhBxWCN1P6b/HBpOBF6sjEBwM92uXyvGy0HOQORf8gFTh53HUd
         n66UBpuwNQBCPdYIsisGhCoLWqBuKmLf1Dfj304eQ/JZ4KoiOVYKRJ5bDz9oG7anAyWm
         ovWReR16d8Zbmp89UACSn4xl6rFwG2APl4rAFKHoldWjAdOwPbxTn5dtQzkRq4+lItMx
         sFDQ==
X-Gm-Message-State: AOAM530N/jZlwVEsWpFaggd6SE1CcTB1OQiP2XRnapTivvstbWujQIdl
        2UqZo8WjB0q+uN/4SRCu1yFxb2vMuXFFYg==
X-Google-Smtp-Source: ABdhPJy2U0LkHqICeo/shR2Brxgo4cPBwJmlBGVaSYaf+k5JDrQRKNV7cnpVA78a/5MmW4t6ZoXuig==
X-Received: by 2002:a17:90a:3b0e:: with SMTP id d14mr17789566pjc.198.1615074201468;
        Sat, 06 Mar 2021 15:43:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z68sm2730798pfz.39.2021.03.06.15.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 15:43:21 -0800 (PST)
Message-ID: <60441399.1c69fb81.3af8f.5ee9@mx.google.com>
Date:   Sat, 06 Mar 2021 15:43:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-71-g28d7d500338ce
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 108 runs,
 4 regressions (v5.4.102-71-g28d7d500338ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 108 runs, 4 regressions (v5.4.102-71-g28d7d50=
0338ce)

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
el/v5.4.102-71-g28d7d500338ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-71-g28d7d500338ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28d7d500338ce1fd3867dfac360f9fae12a471c9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043e059242de3a169addcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043e059242de3a169add=
cdb
        failing since 113 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043e49befdac6181faddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043e49befdac6181fadd=
cb2
        failing since 113 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043dfd4f3459c9f94addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043dfd4f3459c9f94add=
cb7
        failing since 113 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043dff36789c9fdb1addcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
1-g28d7d500338ce/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043dff36789c9fdb1add=
cc9
        failing since 113 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
