Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E57481B06
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 10:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbhL3JRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 04:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237961AbhL3JRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 04:17:16 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4562C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 01:17:15 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m15so20981466pgu.11
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 01:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j8hRYtxuYT2hlstIPWhRZ4XegR0IGMtPi/UYDWxPIas=;
        b=oAxhsKSTY5xykzlvkYfo2rYaPI/f2YLaDgQt0+vNUd4jXPJ1DHLIYqJ6gWG11epOlT
         UBHbcHF5jGrliBCvTbglaUILZ0LmQqJfyzFb+qcaviqe+80zvXH289Ns1kDaH3rJbCz7
         3Ly/qBqzOD4qGE6JBzTvfqYpVvAGRdE83DMrUXwKOQH6myUi0D1gqKLuNqzopt0bTg1B
         T8sui9dgRHrraREDG0qRZm1R64o9qjcznBOasqjPrDEGLns/zUztyMRPLTcz258cFhEZ
         sh82vLvWst44CVRHtCwrgkdBDakVkMKE71SxpUIc+VRKDoqo5V1OpKoosNHvG3blQlea
         mm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j8hRYtxuYT2hlstIPWhRZ4XegR0IGMtPi/UYDWxPIas=;
        b=56Np/I3youfUHGZGQ9ff5CfMd9ZehF2SW5wih45Xd4h2pDFnz7w0owwKmZPbEu1+mL
         16z/IB+74m43yWiiCF5rnitnNQrkOyKWHIUOF1BFa0pXcb+DxSvIzV3kWdmH7+LEA+cL
         SUQTfibUtaHC6NIdINzCecozzlARE1hXcLLrgEVYjrrKUPh7AkHDGJc0ISmtKXFNFntb
         v1zs6iyTndgzKwJfk3x7OHbxQJ4b3PNy/66tqWXeT8tOx4Zc7aKH14goIZnkBdSjqsWv
         sDFYAS63Dkk9JufaG2YTUl0Wq1DtQOQfrsCMMzgynzsVfxRdrbGmiUkLH/SCcpDXs4+/
         uIyA==
X-Gm-Message-State: AOAM530HHUd5dKWcQbP5k3rQVaONZueY/e9Ft25Clo0ZZtz7LtEE+5Yq
        K/EKlrJJx4W2jVwf64Ge9aBsBJM44gYrHQUT
X-Google-Smtp-Source: ABdhPJxGUOZDgHLXV07wIILx2wyjwmmtM/99+EATuFO56y1Rk6mYFGQtc/I2Gei5IOoj1L25HSnkmw==
X-Received: by 2002:a05:6a00:198e:b0:4bb:2522:56b9 with SMTP id d14-20020a056a00198e00b004bb252256b9mr30772439pfl.22.1640855834427;
        Thu, 30 Dec 2021 01:17:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z2sm27617378pfe.93.2021.12.30.01.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 01:17:14 -0800 (PST)
Message-ID: <61cd791a.1c69fb81.12196.c21c@mx.google.com>
Date:   Thu, 30 Dec 2021 01:17:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.168-54-gabd29272e502
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 159 runs,
 4 regressions (v5.4.168-54-gabd29272e502)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 159 runs, 4 regressions (v5.4.168-54-gabd2927=
2e502)

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
el/v5.4.168-54-gabd29272e502/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.168-54-gabd29272e502
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abd29272e502022c203d80f5154268d5045adf76 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cd40c2a5e4d64810ef6753

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cd40c2a5e4d64810ef6=
754
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cd40c90e0be7f1a8ef676f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cd40c90e0be7f1a8ef6=
770
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cd40e7b1039da62def673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cd40e7b1039da62def6=
73e
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cd40dcbecf0bcfe5ef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-5=
4-gabd29272e502/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cd40dcbecf0bcfe5ef6=
763
        failing since 14 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
