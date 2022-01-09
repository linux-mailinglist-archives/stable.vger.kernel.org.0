Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E625488BE9
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 20:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiAITHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 14:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbiAITHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 14:07:33 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7CEC06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 11:07:32 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso18324420pjm.4
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 11:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ti0aYAl53FWnasX8+vP1txu4v9ENE08jhTQvuS46tJE=;
        b=VS+GQMQ2lTqUJGK2G8SGEAhm9iNXXXesm4jTLjplghBEXqcvKshDcjfZFNbZWQ+eo/
         9XX0oNpDwLdbZeyxu7gFT7R+8SiD+KzL6snNZT/bcr41qLxtLU0sXvyOEVop/9nlpSY2
         /XToXQcd9WBWqYsyRT5mlZhAoGdVegM1ch8/Ob8JJ+ufyztZBn7fHqWSP3L5UrFzULVT
         HA+bGy/PtbNz/Hr4VhAs5YeGNDR+nSh8Xp/ZX6QpDYmy69bvFef4dUbJLh4JYsTEmSiL
         ei+hV+WpXRHQ9QPGAavf21QvZL3zcQzHfFsCPUqIL/oKcsyGQ0+GWpCBl6XIKyLHiWNV
         RhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ti0aYAl53FWnasX8+vP1txu4v9ENE08jhTQvuS46tJE=;
        b=IUwjR4oMzJSbl/rrmTUOzlKyJBRt/TVbuFvxMIO1PEBNV3H31PnByWO6D8EegDp9to
         7vT4+uIqc9VtbR7rherXvhroAgoAKm87GEHI+jwJvuwNOYNFp+982Buf67cAaDL+RObZ
         jM+VdxenKdsbbSFndJ7dQ29cilW5djPtBiqqlE+l25n2yAu0vclCphk4LE+MZxMZFQ8q
         i93zUs1g97eT54Ww25EDKJNfq28kFa0r0i3osH0s0C8mHpaR/8sVhD8EHkTiXdkckpD0
         wUVGZfAvR0GbD/1MChuBy7chm4OCMCZ7u6gOzNn1zqiosPNl7ND1S4027vlKMyZCBnaI
         vaGA==
X-Gm-Message-State: AOAM531p1gzWWEwyD/5qHU3vpNnN021dmGY1FGJjS/FB8QgBq1GsHPQQ
        Coswl8tT8fj+GEVdcyZR8prUUbzp8Q/Wx8te
X-Google-Smtp-Source: ABdhPJxu/95WmlRdzjyd7FAXz6p2Ojz7WWCQ3dVkvjyAf6hmGoUWSjYfsF4etJeg8ZX0nXn95fdkzw==
X-Received: by 2002:a17:902:ee4d:b0:14a:2eac:8e49 with SMTP id 13-20020a170902ee4d00b0014a2eac8e49mr3500457plo.24.1641755252330;
        Sun, 09 Jan 2022 11:07:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e30sm3340169pgb.10.2022.01.09.11.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 11:07:32 -0800 (PST)
Message-ID: <61db3274.1c69fb81.dd31d.80d6@mx.google.com>
Date:   Sun, 09 Jan 2022 11:07:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-26-g37c081715ec3
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 168 runs,
 4 regressions (v5.4.170-26-g37c081715ec3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 168 runs, 4 regressions (v5.4.170-26-g37c0817=
15ec3)

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
el/v5.4.170-26-g37c081715ec3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-26-g37c081715ec3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37c081715ec3bac098bc652266cf0dcb61ca2859 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61db003398add88252ef6783

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61db003398add88252ef6=
784
        failing since 24 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61db0036581ece3579ef6746

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61db0036581ece3579ef6=
747
        failing since 24 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61db0034581ece3579ef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61db0034581ece3579ef6=
73e
        failing since 24 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61db0048db3d231979ef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
6-g37c081715ec3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61db0048db3d231979ef6=
763
        failing since 24 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
