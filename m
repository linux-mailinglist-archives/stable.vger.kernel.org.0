Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69D942A0F6
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 11:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhJLJ1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 05:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbhJLJ1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 05:27:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CB0C06161C
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 02:25:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x4so13175455pln.5
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 02:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RLHY3xU0/Ws1Q2U6KBUvG8hRpJjBN/rFPbOmoty8gzQ=;
        b=h/xIKKKIWCQZ4NDItbP03iYpwTke3BBjzLLb/E6GlqOrvXHtxLQCWs7Ws5384JgV1D
         5UpXzo2nQwGd+GXJSuoNERojZEFW86osncdK9N+cz6LnJ0uh70tLfQbvlRspwvwT33A4
         ZXmoGwNLlXnhyL7v7WvQyuobSo5ppsX5KqFXRwJ5kQWjqUhCY/Zg9CLrX7lafbH2lStQ
         Ilp2DkqOkRejQj+TUahowuJ+BbR6NKHmzCQnFjbycRwpwwSpNF+RQUCyTRnh2/2e1r5a
         qimxuIPcT3vrlvvISpYMuoJi9eicwRc39NhY/fPk0b1Ps4EbtRxhm6X9dQ49BL46OfIX
         eSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RLHY3xU0/Ws1Q2U6KBUvG8hRpJjBN/rFPbOmoty8gzQ=;
        b=1MDcHCXKgSXivhHFG72bYmnevdO+1dBzDkr2S1z3F1Tv9CJutDNH2yNjleDw5we2zY
         QLpW9Hmm8u7mVKw4AJI9RwMLGWhEy4T4gzK2QMjmsb2LeOABt4165ceK7fsRV6m0zABM
         Z4JwGqo0k8ySqYHbADmlyzZ3uq4VahJ6mtcVi+EX9bxIBxadJ+D53GnPpv7wj3TUeS2O
         zt1zsGRAggqYpR1MFsANEMkgu/H6qvloAKLeTJPByiA0W2UxXJtuGvrot45/JfGuPWt7
         +jRF7rOOB3QcERvq/QH4wmZM244d30jMaNGIa2HYxEy7i/rl/ErLVH9crs2GBQjjCkmk
         qJNQ==
X-Gm-Message-State: AOAM530IQE/fywdDQU0hw2uPBMvEk2vR0auvF6SVsY7buayv69hbOXrR
        wNgdOtMSZiBa4M+c86PPsWjPDDymxwFm97+e
X-Google-Smtp-Source: ABdhPJxXTkFqupV2skiL25Ql4W6h2lN4fdmtdiEa91OfWqUIFkvlQbTVwZQ/Y8gQVdymAYdnxJZovA==
X-Received: by 2002:a17:90b:4a07:: with SMTP id kk7mr4687144pjb.37.1634030737070;
        Tue, 12 Oct 2021 02:25:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm2154237pjy.9.2021.10.12.02.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 02:25:36 -0700 (PDT)
Message-ID: <61655490.1c69fb81.9c159.6f1f@mx.google.com>
Date:   Tue, 12 Oct 2021 02:25:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.210-28-g780ab81b91b9
Subject: stable-rc/queue/4.19 baseline: 117 runs,
 6 regressions (v4.19.210-28-g780ab81b91b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 117 runs, 6 regressions (v4.19.210-28-g780ab=
81b91b9)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.210-28-g780ab81b91b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.210-28-g780ab81b91b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      780ab81b91b97d9ccb67beb96f25bbdd97af5c4b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61651c9a720ffc1e1f08fab4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61651c9a720ffc1e1f08f=
ab5
        new failure (last pass: v4.19.210-9-g2ca4e64e8c5a) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61651b413790cd63d708fab6

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61651b413790cd6=
3d708fab9
        new failure (last pass: v4.19.210-9-g2ca4e64e8c5a)
        2 lines

    2021-10-12T05:20:51.587902  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-10-12T05:20:51.596970  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cf4 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61651f8f4da9f96f0b08fab4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61651f8f4da9f96f0b08f=
ab5
        failing since 332 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61651f8fe09a9fd6cc08faad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61651f8fe09a9fd6cc08f=
aae
        failing since 332 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61651face09a9fd6cc08fab9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61651face09a9fd6cc08f=
aba
        failing since 332 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61654cb1ef6691b2a808fabd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-28-g780ab81b91b9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61654cb1ef6691b2a808f=
abe
        failing since 332 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
