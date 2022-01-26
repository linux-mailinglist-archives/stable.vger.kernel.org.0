Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D209449CEDD
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiAZPtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiAZPtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 10:49:41 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BADBC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 07:49:41 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c9so22816745plg.11
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 07:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FYclcLZPVrW9UpdzmH/H3l04Qjib4mVlIcTXJwuCA0k=;
        b=EptS2q+tYigO/GAqZlcPLlv3h7Y4YShszThahV1LT5aILX/G/8Qie4HIdnbSvnbXI3
         JUOP6fmolRk9/lG6aMbzI5MeDKpCvUzBUAHAZDC1JT7AfoHchkY7nIYgnsJvuVQsHm8b
         NxRfcagpccfLsBJfeWvBqJzc57df/0v1v2cgELXZQysHItclgK9J/a42USEHnTn+3O51
         SZpbDIi4F5tDjtHmzPAOhajMkym5IsEnoX+9Vjtd6SdOjc0j0ObNE6hi984NdLFWC6/K
         bSDIC5eD8hUcRZ6eikMAe+zfEsL7ORCMMwh8xB+qdVI5UNSY0pYWxXAPmzmXsca7Jy0v
         PZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FYclcLZPVrW9UpdzmH/H3l04Qjib4mVlIcTXJwuCA0k=;
        b=HAyd6kOKLA/A4QFsr0R2uFNAtokFT/pKagJrw/f4nRNdrdis0K8GbD/aH84uZkHPuv
         4XO2pw7h+4IHdXoxi7rd4Hg17BO/uNl+RQpkgcS4nzTUL9V9YG0qYDmKnkNWcYDZ74+A
         Pgbv1vi3ex4DDwl3ZvY5gaZ5dr5bpR3gSxQhu/W17l4+3X865LXXx4HHFx4rkINSIdeX
         14Q8rc4KDvvodk6c5hopOuT81Hu/K/e7vR85gqzIvUr3+y4ldu22DKPDPToMnjKSE+qk
         EcsIVQwdnFKfqX6c0Sp6loObGtERUPi0P/Dnn9a1ieVGJfEuxluGMnn0IHFBPPWdiY1R
         r+ew==
X-Gm-Message-State: AOAM533/kO2amVVc89tNdtWAgrqO8PX5WOuCZl00R+wh2AZzGfXDHoP4
        WP0vaYYFsTRp2Dpg+NOfZxcpCS7KB8Js5/Oxc1g=
X-Google-Smtp-Source: ABdhPJxZAM3Ut8zvFBmJg+1baayYZRywVo064VCOKF1CJUjrb0fPZAfxoj2FXEv7Q8/FekWpINLdww==
X-Received: by 2002:a17:902:7b93:b0:14a:c443:bb28 with SMTP id w19-20020a1709027b9300b0014ac443bb28mr10672451pll.94.1643212180567;
        Wed, 26 Jan 2022 07:49:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm3453812pjd.6.2022.01.26.07.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:49:40 -0800 (PST)
Message-ID: <61f16d94.1c69fb81.2b7f4.a536@mx.google.com>
Date:   Wed, 26 Jan 2022 07:49:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-315-g5183a50c0e9e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 182 runs,
 4 regressions (v5.4.173-315-g5183a50c0e9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 182 runs, 4 regressions (v5.4.173-315-g5183a5=
0c0e9e)

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
el/v5.4.173-315-g5183a50c0e9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-315-g5183a50c0e9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5183a50c0e9e66a2e6fb4bdfa6148647d6fba964 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f13894f2e66620baabbd3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f13894f2e66620baabb=
d3d
        failing since 41 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f138b8910eb3c6a8abbd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f138b8910eb3c6a8abb=
d20
        failing since 41 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f13893f2e66620baabbd39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f13893f2e66620baabb=
d3a
        failing since 41 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f138b514c5fb7188abbd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-g5183a50c0e9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f138b514c5fb7188abb=
d1a
        failing since 41 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
