Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4D6489B8F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 15:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiAJOs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 09:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiAJOs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 09:48:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F394C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:48:59 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p14so12168409plf.3
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=STUgNlw9yFF/Q9m0YQIavbiDkCDComvuc99Q1uGmfdo=;
        b=il7ctYnrjIQcv0Dj/EtqUSxhr6vYNRvyTulQ3mHcpJBBSwBMoLgVii6WUFglcg27/a
         sLdmvQyO5rz3ik2+yVukiFfzfZNhOICcp0AKKQ0/nB28lo84/d9LbZ1LKfMfpH7QgvbB
         Jw4DWfXBpZ7gXHtWLGdGg5m4nwO0/lN6rk80qQxU5IsK7woZpY7q3guHDILHkSZhFuUG
         UKqi8T1r9QCxFsmL/avIuPKSZve1WrXEBEhSU/tBxVd/hald7W2Ue8QhW4spihqDnsgc
         UA9flhKSGdtY+TZqmovu5tR7XR2wu/+HOTqHsKS4BAwUwe8r6z8ge2AgmPHS2soNxe12
         mQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=STUgNlw9yFF/Q9m0YQIavbiDkCDComvuc99Q1uGmfdo=;
        b=jxZjA6HTkm/gvgYG40ZUC68j98IKrCyuLJzX8xt3bzvZmIy/0jgSSgfTwXr4Fe1hZT
         lFyF/fMHNN5BVFe1V9IvzO0X7fE3sVOMK4HbBYbewXn5+FzJKfG2EcIQNh1gjmfoCY7i
         abaxqcgx5eoHrRxcQ6wsEtzHWbvxhy02nlW+YYUK8s9hfGID39FkJ12839SZa8wrq35M
         v4ZdaPGz6edLwZ+ugOB+54Mt4ukLB7h4FsRGds3FVXL+5BSyOnJZfefJ1/FN1XoaikGQ
         sV7T05kTzspPouTwt1B58JjZ3ww8YnAEIPRueL2818xDHmljM1F6/MJ6ygaG7IxHrM0K
         sAcg==
X-Gm-Message-State: AOAM530RYHcfZ09BeSgdMdXt1UB3YTJ9dClFwg6bjy2q2EjPf0J3tU1l
        FYD3cmb/ztnzkMWesT7WDSLpqcYl0IfCf3ZU
X-Google-Smtp-Source: ABdhPJy5kjaejYNruhYIxhxOSeZSEt3rSlc68YzK1+qwIn1JkGHiAYSye9sIvvl5jGA1tTxtCaQmMQ==
X-Received: by 2002:a17:903:2448:b0:14a:2303:2f67 with SMTP id l8-20020a170903244800b0014a23032f67mr33561pls.28.1641826138590;
        Mon, 10 Jan 2022 06:48:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2sm5856841pgo.2.2022.01.10.06.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 06:48:58 -0800 (PST)
Message-ID: <61dc475a.1c69fb81.e7b66.e1f9@mx.google.com>
Date:   Mon, 10 Jan 2022 06:48:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-34-gb4297c592d25
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 129 runs,
 4 regressions (v5.4.170-34-gb4297c592d25)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 129 runs, 4 regressions (v5.4.170-34-gb4297c5=
92d25)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.170-34-gb4297c592d25/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-34-gb4297c592d25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4297c592d252fa7d72f33ee2c362f3fa3522b3b =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc115ab544951eeeef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc115ab544951eeeef6=
73e
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc116a4aa66f6563ef67f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc116a4aa66f6563ef6=
7f6
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc116fb544951eeeef675c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc116fb544951eeeef6=
75d
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc116eb77b3a5323ef675b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-gb4297c592d25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc116eb77b3a5323ef6=
75c
        failing since 25 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
