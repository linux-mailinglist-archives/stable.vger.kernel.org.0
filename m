Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6746424D41
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 08:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhJGGZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 02:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240276AbhJGGZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 02:25:19 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABBBC061760
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 23:23:26 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 187so4433149pfc.10
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 23:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bw3afuWabx6JXG+Kf5Pm6wzqGV6dVrnr8jwSRsN80Js=;
        b=HTAlpjfXjFD9c+cuDKyXIy0haVTb/OLrTlUMQWPdiBO+9slHzBvrJYJiZILDrXR9sA
         OmcetF91wTYDUiAwQHSZ20qlkzAPBh37tl+53IMd+fhtgzWQQww8/BNnoqjR6REWlt+n
         S1qv75Z6CYqXN8oaioxLlS3+c18uaEfs8nj8zl8wjE6Wjkq7p9Qg9OlxkS/JFybEgC5L
         xj5MJmFyZZdLsiHJKQzvogOKvFsfkGd0Ex0ETmH/dLM8q74QrykXokVdYE7L/tEtI6qy
         ayuPYu6ER86Aew/abnLZ7WF0tT9MG4nzM7JZiIXWKB11PUY7PwKlOzwGyiJfXXaV6yuu
         A7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bw3afuWabx6JXG+Kf5Pm6wzqGV6dVrnr8jwSRsN80Js=;
        b=Ej0wjskHGBDoqCo+xwV+L0v+UDaVRm70ua6O99Kwb/J8cggELsx/+iSm4pROkqWpjX
         GL7QRP03toF61SG5izp94FHSqPoJNFyLkzUa5wZhpuiTxcGNpIHBt3gOlusiqfZQgZNE
         gTByIdAEh98KBKKh8Wg3GokT8LWGf7jzzeLrKEU1BKTvM1zOfn9c2on47r7eu3BGrQOO
         tC80e80n8sJSZMGCyQsOr0KOdDOraCZHiA3Cr6agUMYIr4EolScT8KuFaUKbMGhgXKQf
         6kCHcp15wUABw5A+1X/2oJcHEi4BT/QiDyV34y5GlDgMF4aQPfxGGpygvBfytiNHnXxL
         QgRg==
X-Gm-Message-State: AOAM533NPLCDMMVu2qWB0VG8ubq7XRcXiWyDLEDQDbDvNC7w9GfJZypJ
        XXXDwYVCdFItU1XFaK23T829DGHUH2HbgATQ
X-Google-Smtp-Source: ABdhPJx2/0qsdjXUh5cwRW/mRT+jGsj5ezz1P4UusV1KoxjCXpf2gLiPTT+UwayzHcL/cC4AI9g4Xg==
X-Received: by 2002:aa7:8042:0:b0:44c:78ec:c9a9 with SMTP id y2-20020aa78042000000b0044c78ecc9a9mr2296475pfm.45.1633587805625;
        Wed, 06 Oct 2021 23:23:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 23sm24565476pfw.97.2021.10.06.23.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:23:25 -0700 (PDT)
Message-ID: <615e925d.1c69fb81.bf7ba.8cf1@mx.google.com>
Date:   Wed, 06 Oct 2021 23:23:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 91 runs, 4 regressions (v4.9.285)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 91 runs, 4 regressions (v4.9.285)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.285/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.285
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      af222b7cde477ac2c3f757520bf7e6b7625a380f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615e5a0c4a618194f399a2fa

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615e5a0c4a61819=
4f399a300
        new failure (last pass: v4.9.283)
        2 lines

    2021-10-07T02:22:47.927481  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-10-07T02:22:47.935887  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-10-07T02:22:47.955617  [   20.579986] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615e5881ab4821182099a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e5881ab4821182099a=
2de
        failing since 322 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615e58ac4198d5157499a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e58ac4198d5157499a=
2e3
        failing since 322 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615e5826fd9c69e2f499a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.285/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e5826fd9c69e2f499a=
2ef
        failing since 322 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
