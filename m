Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666C149762F
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 23:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiAWWzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 17:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiAWWzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 17:55:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0752EC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:55:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so14737946pjp.0
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VBVbwwNu0wPZbvJE+D6hLwQsaHPchllgakmwi+C/xbY=;
        b=jgoARAaBKD29PZOaxDEa1xqv9HckpKFfrAgt2wd7peTdyQ/BBb654OjqI+l5/07GPG
         2hlNWN57EdROu0b/F1QZSVO8+I4CdIeCWnAhaOu/DajkxIy5qQm//VutQ9xPHEqME0ry
         BUODv0dS0RobND61lKXx4ZPX2gydGRjzBXpPG4dg0+7s/alNoODT3fV5h83HeMABUS+d
         DN5hh077IIok48kAVjzU7OqxA3DboX6lhcILKh+DQ4Prv5lgOcK/HI5ukjF+Vkyn0QAU
         yZk8YU0CpqgVhWAsqXK+QKQLAMEo8lIhx/oQyaE7WGfaIN1mAdHb+XvVhF5vJCr45S9Q
         zQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VBVbwwNu0wPZbvJE+D6hLwQsaHPchllgakmwi+C/xbY=;
        b=ukYzxzef1L7rAhDxjJG1RfEvOmbitgx6Qast7cRXDdKc4ku+ks/mR8IKmGigrAOFUE
         eobncKN3vb2fkgfbP0hL8vTnYaDA/NNQN8PxPwXvLFJAZ6Sd7tx2Y0BVLFPSaHDJQkpv
         32H/gmzG1UPad3mR0lJCnvBlyoehpP4aMzQhF4FkCGRxzNLpN+0AScNzBCBlAHZpYTcn
         s30qvnofVe7EUwMTCK6aVMsNccO3h8DVn+fm5OqjSYxUNmrlUoD8kiAX6xveC9xRHPeL
         qqacva7MnGN/EC8tlXNsNgOevD+c3yknnGSqMYjGRD7D0rSbx00HshtzTFKvtHb4Sd07
         BPMw==
X-Gm-Message-State: AOAM533oC5S2sjp5CQIhEBQQ6ruy5XbcqUdDdHMbVu2mbScaGEZfor1c
        zkF9hYa7nvrmM86Yr3kbzJjhbS03QzH9R7n8
X-Google-Smtp-Source: ABdhPJwzrbTDc6hkZEuQ536nHvXZ+ynDEzbH6N0uymXfsqxMB+Kw2D9mM+Q+73UwMbkzfdWSB0Fomw==
X-Received: by 2002:a17:90a:bd01:: with SMTP id y1mr10428868pjr.33.1642978506338;
        Sun, 23 Jan 2022 14:55:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t17sm13945656pfg.207.2022.01.23.14.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 14:55:06 -0800 (PST)
Message-ID: <61eddcca.1c69fb81.22861.7415@mx.google.com>
Date:   Sun, 23 Jan 2022 14:55:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-269-g0114f32cf068
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 161 runs,
 4 regressions (v5.4.173-269-g0114f32cf068)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 161 runs, 4 regressions (v5.4.173-269-g0114f3=
2cf068)

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
el/v5.4.173-269-g0114f32cf068/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-269-g0114f32cf068
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0114f32cf0685ff844bc3450593a4251207d3408 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eda348ec2d63ccbdabbd25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eda348ec2d63ccbdabb=
d26
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eda35664c2aa4d90abbd3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eda35664c2aa4d90abb=
d3b
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eda349ec2d63ccbdabbd28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eda349ec2d63ccbdabb=
d29
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eda35764c2aa4d90abbd3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
69-g0114f32cf068/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eda35764c2aa4d90abb=
d3e
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
