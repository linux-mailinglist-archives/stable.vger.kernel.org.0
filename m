Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65CB2EA3FF
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 04:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbhAEDoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 22:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbhAEDo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 22:44:29 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B582EC061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 19:43:49 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id a188so4944927pfa.11
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 19:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BcO4TPStnKl9IrjVCIOTzyBvMtP32qfyp8OMkmqeWXY=;
        b=edeLeY8a62TVv3rV1ckYbN6qH/Q8/REvoNMcOEjZgNY7nAz5uSn9Xu1+12DPTnZJwl
         8PjW+ypycYvhBTTE4PE38/yxyi8CDcOrYGRDvlok/5QYHwvMetKMyb48l/OSLdmbgNBK
         H6aKjCSYdBHlt80CdjfqQasb3gy0jlMfOUwXpttiGTL9Q5kvsbueBixLUvjsegxb9skG
         57RtKMmwfEix9BsRKwxMMN/wTbZDlOE3c9bzbjUaJvo/6xQmdOi50WZ6FvhbdhDCJEho
         VEJy5zcbhZCxj03I9PJCbh72Yd0u/Vxj1pMQ5YFU5EWUtylNGZTPBoWFI+tk59OkmL3E
         224g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BcO4TPStnKl9IrjVCIOTzyBvMtP32qfyp8OMkmqeWXY=;
        b=LVHv9VTOYj550qWWgrHTnv9M8wcMLVaz6NL24H3A5yavg34Ld1B2Uwn/xWH9w0EU8J
         Kv/hEqCwAbUgjXybMyBw3T9FUhQ8g3G2l+0Jql8k14fkGFHn3G2DmWTEjtXNPA/0pFsF
         tFhS0Lkfod57opuVRpVpxbdu9TCixWNxoDy4YEcyc9G67q3ChwnfPUAVFMitEQxS/NDz
         sXos/4jYoQapapLQdAxOMOxuQeXZWhHdy7hdf+5xHxEeUqq0qEb20iNmtf9tto/kBEhR
         Vl4ggQjVoScL2iSDXgJvXw0LwWoBSwBINmKcXEWg6TThQ6ybA9+FAVSoYVNgrtj05+mn
         3TRw==
X-Gm-Message-State: AOAM530MXDzacTycEhcVB32+vskYwOvIPEMYF4rzsRjzYsDXdlyj4YA0
        n0uniCqbbwVDrOSVpLQP7nnb2z0idsyyfg==
X-Google-Smtp-Source: ABdhPJy+K5FeBlYvayiUMtBAOMnCx+RR6NlgXQje4GLaV8WLUqY9cILqQUjnwWKD0aetI5pcluBgjA==
X-Received: by 2002:a63:561f:: with SMTP id k31mr3276475pgb.275.1609818228665;
        Mon, 04 Jan 2021 19:43:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 14sm18649373pfy.55.2021.01.04.19.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 19:43:47 -0800 (PST)
Message-ID: <5ff3e073.1c69fb81.51493.94d2@mx.google.com>
Date:   Mon, 04 Jan 2021 19:43:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.164-35-g5f495ccb1ff4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 154 runs,
 7 regressions (v4.19.164-35-g5f495ccb1ff4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 154 runs, 7 regressions (v4.19.164-35-g5f495=
ccb1ff4)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

qemu_i386            | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =

qemu_i386-uefi       | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.164-35-g5f495ccb1ff4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.164-35-g5f495ccb1ff4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f495ccb1ff4457e6f93a946c30eb77a16de7faf =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3af9d769aa2d85fc94d36

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff3af9e769aa2d=
85fc94d3b
        new failure (last pass: v4.19.163-95-g82ffb2094fbc)
        2 lines

    2021-01-05 00:15:20.380000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3ad8d0bbdaedd17c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3ad8d0bbdaedd17c94=
cd6
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3ad960bbdaedd17c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3ad960bbdaedd17c94=
cdd
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3ad8e22bcf5e8c0c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3ad8e22bcf5e8c0c94=
ce3
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3adba0422080575c94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3adba0422080575c94=
ced
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386            | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3aec4dc3a8bc6d4c94d47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3aec4dc3a8bc6d4c94=
d48
        new failure (last pass: v4.19.163-95-g82ffb2094fbc) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386-uefi       | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3aec79805433014c94cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-35-g5f495ccb1ff4/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3aec79805433014c94=
cbc
        new failure (last pass: v4.19.163-95-g82ffb2094fbc) =

 =20
