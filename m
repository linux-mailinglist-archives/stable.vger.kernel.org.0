Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B585C4926DF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 14:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbiARNOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 08:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbiARNNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 08:13:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404ACC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 05:13:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id a7so21563735plh.1
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 05:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6PpGwH5VFnGJXgQVe/yvjloIcyPdroLpH/CpQBi/wm0=;
        b=GzUnh4XTDrkha+vpnidlT6lC2CmrGbMWKLaEotSaLedOOH++hYNjHVUhXHzhQb/L7l
         Vvz571CJUYjHkcAgzeJ+EaO3+fAeq0uZhyYkkTTqikYCQ/96GSm8Swpq8PWiwcmGsH9d
         4/qoGGMuTLvHiXuOJW7ERTU6+XhHUHu4gFeGvEncK+FaYUT6kK5jtv+NqKBN2fHSXMHR
         mwGFkW8bRgmYR23fjy3+FPOPWlBjHeqaSIX+awKS24orR1qStjI3L2Y0RLu+6mI03MjZ
         8JpkTjsmO62bwECtVDMKCVHoEL0ulYFdm/2aO9aU5yzczU6zsX6y9rg4tuH8HSym40Zj
         Zs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6PpGwH5VFnGJXgQVe/yvjloIcyPdroLpH/CpQBi/wm0=;
        b=3vKoRKTOvGDz/pW0BddTnaTshiX0UbcAbMqX4TFibhk2J7IhzY1u67gpiA0eylMajm
         YV7BT8OvtgvT4h5TxpYf/N8D1Tou5sHnB9HyP8/Qis1azJC5jh810PgyIgIZD6YfxVxk
         YDr1fZQLpoTC3wKoSvlVAojxlIHrrYTXdSTqVB2z79+zmf7SdiPhxCv94j/mfxQYQW7x
         zBwkO3pljv7TluuBvWzjxYMvQlQM2ioEQ9y5MaZ1uZh+OMx1QdC4CPvAKtqd3S7iE/rb
         GlkzrSGXv/QJK70BMG76d6uyQfFZCACl/XYfppBJPIAv4zpz5ltiG/g0XeARNvNuDlSW
         xGGQ==
X-Gm-Message-State: AOAM531qdtOqLA/V4yRilY/cJyFOpUDkD0jMfpA40hOR/lY1iyPUQX0d
        npbkgGca5RfGIgO7bv3I2LFI2FTGdVQoLLbn
X-Google-Smtp-Source: ABdhPJx0s3GDfzJ1XOEvxS68Q1gNL32P3KLKF8OsYKIFM3jNJ4CsI7cam0L4jxvjTGwIwhDfAs1p9A==
X-Received: by 2002:a17:902:8494:b0:149:8a72:98bb with SMTP id c20-20020a170902849400b001498a7298bbmr26677541plo.0.1642511630616;
        Tue, 18 Jan 2022 05:13:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm2179641pjs.1.2022.01.18.05.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 05:13:50 -0800 (PST)
Message-ID: <61e6bd0e.1c69fb81.4d1ef.4566@mx.google.com>
Date:   Tue, 18 Jan 2022 05:13:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-21-gb3d891a5cfbe
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 4 regressions (v5.4.171-21-gb3d891a5cfbe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 4 regressions (v5.4.171-21-gb3d891a=
5cfbe)

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
el/v5.4.171-21-gb3d891a5cfbe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-21-gb3d891a5cfbe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3d891a5cfbe368bbbae5129db5a6e179383e640 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e686314ae529f2b4ef6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e686314ae529f2b4ef6=
756
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e686432073b785a6ef6758

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e686432073b785a6ef6=
759
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6862f4ae529f2b4ef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6862f4ae529f2b4ef6=
753
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6863fb6722452cbef675b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
1-gb3d891a5cfbe/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6863fb6722452cbef6=
75c
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
