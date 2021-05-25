Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A63907FA
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 19:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhEYRmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 13:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhEYRmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 13:42:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFFBC061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 10:41:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so13601263pjb.2
        for <stable@vger.kernel.org>; Tue, 25 May 2021 10:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1FI/apZQ18MpjFssslBEYWwdVM5kq4Ju5GBQKO1Tshg=;
        b=D1RB3fw4Za9Se84tYL093gEgnT1fokNm9ZX+Gu9dM3nfx/oKDXyItngIYvkIY46LCA
         j9W/BKjdpFhgTKPCEHqqTd+HoKUICHEzBfenpDl3vPc9O/DEagR2y7gnPwyP6if/qvAe
         fNxrLf+P0iROkeLDMqT9yLWlAHQTG0y8MmZsPRBBcxkOr5qU4PHOGaCXoUpmcw31K9gO
         u7xgNCZFK49s2YYfLs3yIuFrromjtzXNmowNBkjBd9PxOO/TlCN0G62ct49Yzsd8zqcA
         fL4I8sR+XInN8VKne2vJBC+larXXKEVKwMJYUiOUUgxlPfR1eD7kJ/YT+7218EM94iVa
         EHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1FI/apZQ18MpjFssslBEYWwdVM5kq4Ju5GBQKO1Tshg=;
        b=tKVML8/eo3uMnGTVrHjRFhV+YMRvKY7c5UtBPx0ycb8NNMyzLJIuLbY4H99A4x1joD
         9C0x9QK3RkkQsfEFXx73k+RYht7E4EvG7VDluIReL4IlaMRJge/WOkjVmdFASS+Wun3q
         3VKq1gOxKRn3kBaI0W3JO7iaxIUMBK2YUikp41hoWstlxGXJJ+7WpyapDLsx+da5/3fq
         Pimn/N1usEa6OuFdJcovtVUDlHkfkSJokNyMBfZQE6BJQ76ZKlzxVEnN+hjKM5fDpwVu
         Fn3u/lTeQC/ibwjJfnXjZdrZFeBEtOHwm9KNeHQYIBJBTI9tELjeSfx+lgYPE8luRWrA
         CXFQ==
X-Gm-Message-State: AOAM532BtY+h21RiH7eYYclRpbSFFwAJ07QDLb1IjWINEVocq26xzz8F
        IxMkasuqEDZdB0RP3DQJS+YUmAOwZCyLqKkq
X-Google-Smtp-Source: ABdhPJzudafhaYKTfShRg0G8ty6CBsmQbwQ1GUJho2a3kVBdE00b9Z0MWSdFKFom+NddRPb4EYioow==
X-Received: by 2002:a17:90a:b116:: with SMTP id z22mr31141832pjq.113.1621964473676;
        Tue, 25 May 2021 10:41:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k38sm14124721pgi.73.2021.05.25.10.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:41:13 -0700 (PDT)
Message-ID: <60ad36b9.1c69fb81.9c1f3.deaa@mx.google.com>
Date:   Tue, 25 May 2021 10:41:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.269-30-g6802178e898b
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 87 runs,
 9 regressions (v4.4.269-30-g6802178e898b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 87 runs, 9 regressions (v4.4.269-30-g6802178e=
898b)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.269-30-g6802178e898b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.269-30-g6802178e898b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6802178e898b2b3b8f3f9426abb9e98339a206d2 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad051b1c951558fcb3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad051b1c951558fcb3a=
fb6
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad04285b6fbb6418b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad04285b6fbb6418b3a=
fb3
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad068a631f7985b8b3afc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad068a631f7985b8b3a=
fc9
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad039ef2acb4bce8b3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad039ef2acb4bce8b3a=
f9f
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad0452ad899edab3b3afd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad0452ad899edab3b3a=
fd7
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad03c78808ceaa04b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad03c78808ceaa04b3a=
f9d
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad061c837d44782db3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad061c837d44782db3a=
fbf
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad039d1edaf2b86cb3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad039d1edaf2b86cb3a=
fb0
        failing since 192 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad02ff47c6ac3428b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.269-3=
0-g6802178e898b/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad02ff47c6ac3428b3a=
fb9
        new failure (last pass: v4.4.269-31-g8aff2b5b3329) =

 =20
