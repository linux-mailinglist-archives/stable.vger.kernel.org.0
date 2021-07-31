Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFE03DC731
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 19:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhGaR0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 13:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhGaR0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 13:26:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6EBC06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 10:26:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a8001b029017700de3903so14892690pjn.1
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 10:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=myweHXOQLFU5bYtjIJL1H6MT/QD6wmEHGq4ZUi/SMg4=;
        b=hDfW21bCjkrUCSB6ncxYtPq5qmjtAq4LqIXGinnC54sDx2Lb0vxk/F65JCm2y+HB99
         lwxxObP/Bqyl6MQA1+VVquPperVlURcPZRw1OvITtZ7wEdiHj8DTP9CatsxCg1Cm9Pwr
         SIrC3Nu47O6SBHU0VuyHmGsV27LcCUM1bDhMZJBxnSUq83f6gMvduAUyTTddncnuMv8D
         bbBp/PjXfur9KEbnjaYu8DVZ1fYxkX1x3sG7LB2oStUf/PuPRRgR30RYBrR6AR4Bo2vn
         CM9/NzeTOssgm7pBNXdiilgaB8lYmZ7e94pK7U2bgnydnNkEs/2nr02thfM5Wu18SGOm
         Bb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=myweHXOQLFU5bYtjIJL1H6MT/QD6wmEHGq4ZUi/SMg4=;
        b=GV3DQiBst7FQq2iiuvOMcdd2nuY7MZaPRJPBka66FEuz7dqOQ+qWVw9fp8NzW4wFQM
         z5afuBaBDZnfcnN+HRZUt/O3kKjQ6A2xHFQripb8JX3grbRToTCSGb1p2jyAHAbhfB8c
         opNIFa2Kf8EuI8ZVkNP3tIN29ig4NiIdBCLGWuEdBKeWewnrm8iHAUFsOlbyiOsWusSN
         9lFILxBCwEL48gXpma1dJ4whNvSdzTxINz5UU17ksjm2CSUBzKbdGfbMElHT7enkqm6q
         +ABEM7rX365PzwucJRpAMPYE9PsDKaxiCxwGJYQkauVD9aD6Ngr7e94N4+GSixP0bmaN
         7a9Q==
X-Gm-Message-State: AOAM532/7NC56lb/F44FIfeQXp3X1aotSQ3QXNrNnWpQe6Xl3epj8CKP
        0Mti0gLGOG5OFrDQj4uYTMIZiyCdfKJLchic
X-Google-Smtp-Source: ABdhPJx8OWRmSuD4Z/e8ivz7tLZeEqaQHFs5VR5ZdbCwSu1H31J9/OIWfJ6oZTCIoT8dXW0E3PZXrg==
X-Received: by 2002:a62:5307:0:b029:3a3:9460:2ed2 with SMTP id h7-20020a6253070000b02903a394602ed2mr8756359pfb.5.1627752400837;
        Sat, 31 Jul 2021 10:26:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm6711561pgm.15.2021.07.31.10.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 10:26:40 -0700 (PDT)
Message-ID: <610587d0.1c69fb81.ab68e.2552@mx.google.com>
Date:   Sat, 31 Jul 2021 10:26:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.200-15-gec02b38ea5e2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 2 regressions (v4.19.200-15-gec02b38ea5e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 2 regressions (v4.19.200-15-gec02b3=
8ea5e2)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.200-15-gec02b38ea5e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.200-15-gec02b38ea5e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec02b38ea5e2bebb6ecadd30a3801fd4725857e6 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61054eb1b49f9a998685f467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-15-gec02b38ea5e2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-15-gec02b38ea5e2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61054eb1b49f9a998685f=
468
        failing since 259 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61054eb1fd7b52ad2e85f46e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-15-gec02b38ea5e2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-15-gec02b38ea5e2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61054eb1fd7b52ad2e85f=
46f
        failing since 259 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
