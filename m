Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF846480504
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 22:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhL0V6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 16:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhL0V6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 16:58:00 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85181C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:58:00 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id u20so14569353pfi.12
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=am/REwiURls868ppBwZ0Zwi9Ek5ba4bt+RMnb9NNMF4=;
        b=CEeQbnDBlOJZZ0CP1/0kUHC/Crq+xhAQsLCAIj6CSTWDuLebybTMPamu3UBQbfFCW3
         Kg9iZACo+YvE9Wwuyqz15C8si42k+fTmfFn95IiU7nNkVbGl3JZt67za31/Qt8UG//Xp
         H1b+yZafoUd04xTr/HPvxnXky7veUS0r68z9YJE6uRHvDtglw27tKGDnsPPKpvsm/NLW
         yv7Hy22Rt8meIS/vKtxZwCzLya7BPJ7DkUuuUaYb5eQxL2G70I+pg6FAM7NQGnEQ2mf5
         OMlU0OubvKxK3n9bkquH+0m8+jz2ivGulgu1+t6fCY8/8CgITTVK5GBAwxGgpcM6Ui1h
         RhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=am/REwiURls868ppBwZ0Zwi9Ek5ba4bt+RMnb9NNMF4=;
        b=O81TT1r4QpyOx4giMGCCx58G1yCynz9oyeoL+6NDnd0gChZPM6Xygr4ixNC6ajTI2B
         i5ZWeSrxCzzOzY9Psbe4WiQld9sc6Q0uxrQgQKqj4znD1eCeogBro+AidiD6pKsKu5zt
         tm9bzMJ7XO6DAsJbyYS5X2GHXvFm4DME1h/GJOhf8h0/a/ZlWusY0HY8Or8qT1xnmOtq
         JVS0oBMwKfx0n7W+lDT4SbS5dOeaEw/Q9jDHDJcnQcF21eJPe+ysIqWowc2oeVgRFcTk
         b6PQsa3vDSuPDiCnfTo2o8gN1VkJzHFCxb9YNSC5GZUIk4q+E8wWdE+G8G8GEuq7YQV/
         YaWg==
X-Gm-Message-State: AOAM531Bz0zMaCfaCq+b78s8tekjSVLUSlkmhzcu4VdILjCPl02aucbq
        wz64goVQ1WIXRV1uqlyHDWlfNeVGWs+zIrmd
X-Google-Smtp-Source: ABdhPJz4EbEE278MG4V2GM21zl1QJRcDlM3qH95ixArPuG4ULshisL/+l1Vap0nnzLIr6OpU0o+zLQ==
X-Received: by 2002:a63:9902:: with SMTP id d2mr17318219pge.104.1640642279846;
        Mon, 27 Dec 2021 13:57:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm18361514pfl.121.2021.12.27.13.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 13:57:59 -0800 (PST)
Message-ID: <61ca36e7.1c69fb81.7bf6d.3df5@mx.google.com>
Date:   Mon, 27 Dec 2021 13:57:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.168-46-g9fba6c8097e8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 156 runs,
 4 regressions (v5.4.168-46-g9fba6c8097e8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 156 runs, 4 regressions (v5.4.168-46-g9fba6c8=
097e8)

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
el/v5.4.168-46-g9fba6c8097e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.168-46-g9fba6c8097e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fba6c8097e8cb1e08b0c5e87fc703fb3e6ebb43 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9fe6c326f3edbe5397140

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9fe6c326f3edbe5397=
141
        failing since 11 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9fe84ad031b999439714c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9fe84ad031b9994397=
14d
        failing since 11 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9fe7eb65ff3606f397138

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9fe7eb65ff3606f397=
139
        failing since 11 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9fe9827f43e6bc7397134

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g9fba6c8097e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9fe9827f43e6bc7397=
135
        failing since 11 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
