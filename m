Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8D348152A
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbhL2QlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 11:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbhL2QlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 11:41:04 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45108C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 08:41:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so25194253pjj.2
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 08:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tKGhwxZiB36z9TTmSU2+qYn2p42/0I9Z7AFB2gP1hWE=;
        b=ZfzqIE9sjXA45y8NKisCcE8TldYcQnfPkI3sKbQOJ1t3YuH0Kd7xUeGcHFFQYl0k0+
         pzEjKPKgebkhjHH/MrVf6c/xhDArCDJw5rxJ893ClnLWj7PNKT6QUoyzBEh3qzQqv5gi
         AATaoWOl/sgh5viDN2sIb4MhHisD//WKWRuhJzyiMD2mYrmGRYYyn8CvrwUPnFoNMMiW
         S/hM6voZ7XNIUgOO/vMtnZsJzWqL4y8FfRh/qSKRphjzvzGSf5qFjMkDWy9oz8Fzes4u
         8gGW9D5JlYmMl2ECGGqGScQwPkndLQWZDkDFNziMt7bYony4VD6iTCUiJebW7EPLQ0Xj
         Y1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tKGhwxZiB36z9TTmSU2+qYn2p42/0I9Z7AFB2gP1hWE=;
        b=oYt3pcUp3uYt0OYNN5Cr8YG9N67CUzKik5Pxy9LQscy8ZmaRVw6AqWNRZklWnPOHAM
         T+lLwLxtIyFTONSs8GB0+6hbCVh+X8XteUcDYg5HC0mQ02vZhZ02ldP2kpRiII6B6I5Y
         DQLohi99bdK6BvEC2A0dXhp67c80qDNg3eynQmbTVXJvCGfYKFOmXvd+wrO8YNDtpHae
         tu4HS0J3pgX6QV1d/FRbgRzfUhDJq7Jtj9LWHGKR0X9ayP/XHuw2wTIiggsWk4Boskei
         TXjkA/f9eYfcTaxpqc2UxB2pGI9F585AgyEii0u3MdnizrSX80yADvxYhHyeiYAic8Du
         N/gQ==
X-Gm-Message-State: AOAM533HZApN12WQwvvfCMnb5dY1oV62TM1GfxddGHgZDFCpuDDoaOVR
        7u9erue7X9K+grfxEeFaQlAJvMaRqNHcXxEa
X-Google-Smtp-Source: ABdhPJzxYFjrOidHC8h6vhldbNVRSeujYYFL5LoVOihf+HaS5E4Lz02xXl3mCgqVBge9W4GXFZ9VMA==
X-Received: by 2002:a17:902:6b4b:b0:149:989d:c723 with SMTP id g11-20020a1709026b4b00b00149989dc723mr6116203plt.39.1640796063582;
        Wed, 29 Dec 2021 08:41:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x11sm22082041pjq.52.2021.12.29.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 08:41:03 -0800 (PST)
Message-ID: <61cc8f9f.1c69fb81.43c48.dbee@mx.google.com>
Date:   Wed, 29 Dec 2021 08:41:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.169
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 172 runs, 4 regressions (v5.4.169)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 172 runs, 4 regressions (v5.4.169)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.169/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.169
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4ca2eaf1d477ce4316989b22e765fb915652b86e =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc57cb36c9737ce2ef6745

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc57cb36c9737ce2ef6=
746
        failing since 12 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc57ec5f5714f5c4ef6768

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc57ec5f5714f5c4ef6=
769
        failing since 12 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc57cc0642c8b44cef675d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc57cc0642c8b44cef6=
75e
        failing since 12 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc57ee5f5714f5c4ef6775

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.169/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc57ee5f5714f5c4ef6=
776
        failing since 12 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
