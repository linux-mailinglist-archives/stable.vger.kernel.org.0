Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC244488105
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiAHDKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 22:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiAHDKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 22:10:07 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3FAC061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 19:10:07 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q3so6819211pfs.7
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 19:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0CFPy1uW2jVimcuOLLoALBNu5hyNvGrr8mrWQrO11zU=;
        b=pEptHykKBUryUfTdtEohe37ipytKVcPaZqK/91afBZZO9onq3dxbueFdbPA0Y5E8FZ
         yM5ZE3lf+68Ef0MS5osp++YXqeJdtOJz67W/NPUM85oSS+n0Afgyws9TQyBWuuUiqZu8
         y8X8D2jJQ/hyh/V0jLp5J5tTogy8aZMpheDDyHzBA6g7dQOLl6L+0KXHhUGnnydzOlBP
         QpDNc/sb755yXClPj20VcLDqTKKw/fjriZtlveYmbLQghSVYo8fm/3ZrWLdGfehppT8k
         eI28lePkPjhU25sfRVnLYZJPWd6qVsLk313naGQZdE/EauVwVL16uQeWUGforS6oPxxi
         PM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0CFPy1uW2jVimcuOLLoALBNu5hyNvGrr8mrWQrO11zU=;
        b=WS1IPGivriRN4o9UinhZQ8qclMw2RolJ4JJ30gmKEurydCsd7Zz8oFF7aN4AKhlMT0
         C+VV28FEb04xdtUPWHEaM12ALomDSDZsmHr5TZFA/uPnqYpTcF+R8ayvcVefRuG19duk
         Gv73x9aSLS7KoNepadrQ/0Bz135CP+kNwDZhcRbU+EFQ3xClmMbpg8pBMRqg4Rcn02hK
         FTBHbk+lM4Vy3Tn7/cnlw5JbOAaC83t9wnS1lYBg3Tc8z/Z+Xquasa3s5StYNj6iYDNt
         hqvoEcMlACkZfOepuOylQPR/eW34zLaAFV4Q4q1lqu3c0cX8c6pBOu/OXE0DlWdcigZj
         smOQ==
X-Gm-Message-State: AOAM532lixAvuW1HVEpAgcW8TkXXWEfdEU+Xf3Utdd4R/yR8R3Sa6bpv
        W9cCsMTm4aosrKV+c6IwG7eU7bbatM5exr4S
X-Google-Smtp-Source: ABdhPJztE0zvCBrPCNy3xnUN28cEZbnOl5BE1VRD01GuWeofL8P78NDUNwH143SxSbJBs4OTzGelNA==
X-Received: by 2002:a62:c103:0:b0:4ba:75b8:cf69 with SMTP id i3-20020a62c103000000b004ba75b8cf69mr66690858pfg.64.1641611406321;
        Fri, 07 Jan 2022 19:10:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12sm242829pfv.172.2022.01.07.19.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 19:10:05 -0800 (PST)
Message-ID: <61d9008d.1c69fb81.a8003.126d@mx.google.com>
Date:   Fri, 07 Jan 2022 19:10:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-21-g557817edd0b7
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 131 runs,
 4 regressions (v5.4.170-21-g557817edd0b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 131 runs, 4 regressions (v5.4.170-21-g557817e=
dd0b7)

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
el/v5.4.170-21-g557817edd0b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-21-g557817edd0b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      557817edd0b78d1bfb9bf9beadc27479a086a5ae =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d8cd33b9d0b6ee77ef673e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8cd33b9d0b6ee77ef6=
73f
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d8cd48f3d94ecf6fef6786

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8cd48f3d94ecf6fef6=
787
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d8cd32dc554639d2ef676a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8cd32dc554639d2ef6=
76b
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d8cd46b9d0b6ee77ef6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g557817edd0b7/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8cd46b9d0b6ee77ef6=
756
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
