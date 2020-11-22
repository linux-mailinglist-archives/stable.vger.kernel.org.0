Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5527F2BC69C
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 16:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgKVP5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 10:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbgKVP5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 10:57:50 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD739C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 07:57:48 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 34so11885305pgp.10
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 07:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AnDq8d91nuIzEKovcXmwnlvwaFkSOhIma4jr3HILGz4=;
        b=Hbvhz8q8DSVSPiOzWuGWXohcPCHhF73f45aNr5kKj6lmZOeUcE2PdLOhAr6nn+0s+F
         XWeiDZBpLWjcK9stVs4rWBQRvT1MapMnKomzE9ZJOFuI8AGwN7YCk4oXvshjY5k7NhN2
         pbsD1lWn1pCJoXtSDZcN0xmO1B9Hsryx4SQ5wB6c2cixpCCHNLDyNUckyCVsFrMixPWk
         HsubRzJhV5aGTQY7Si/+wcWXf0GVx/vAWO/3t0LDIUJFPbRC0+s1B8l9qLSTmZ7Nj2Op
         K1WycgJEVv1Tseh1W8/HDF6tyk6dX2SQ4T6XjWv6iVTqK5JRP8gW6tY97zLQVYxQbEl9
         1lKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AnDq8d91nuIzEKovcXmwnlvwaFkSOhIma4jr3HILGz4=;
        b=b0Gy/imACYVQr2jiOfifKUP7nEl2GGYFj9VIjJFxV2mFGYnMaqFntiHrk1PgEM0w9l
         4mS+FpesiFDwqwG1EnCwOdt8gubgySTJNM9jpTWjrPiaFzm2VFZx9TZIUFq0Y4yhfbUq
         ELyt4EdTB5CVTZx/7cXnj1qfZjfo+9ML3U8dUPVni+QQ1DmCLOgLoucrryV3Hgmtmzgj
         LplmtkelG9zV65iEh1OFvmIn5ggi6kpcAMDnXlVJws8lojqL+fiCRSdpSm+Xp7r6byv+
         X2jGzkXXyT0ZMbyrnmFS1u6Ns8MhfmXOdY0qEKYnVvrpvvUu31HhA+1dZQ/u9YF2ZCsV
         FzTA==
X-Gm-Message-State: AOAM530vqrHJCeVIsynT7WCrRnZNUb0kV1+FzNeAcplms1S9MjvDLV0t
        OpBp8+X0gY3YHs3Nh8ubywBkWGAwO4yBpg==
X-Google-Smtp-Source: ABdhPJyv5fO9PA8bLS91SeNkre17RCPmf+cUSGVB0RDj6xSmPJOGdXuKLqayhkwriyQpUs8W+NThHg==
X-Received: by 2002:a63:380d:: with SMTP id f13mr25081178pga.105.1606060668054;
        Sun, 22 Nov 2020 07:57:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 65sm7177298pfd.184.2020.11.22.07.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 07:57:47 -0800 (PST)
Message-ID: <5fba8a7b.1c69fb81.e84af.ec7a@mx.google.com>
Date:   Sun, 22 Nov 2020 07:57:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.208-20-gcbb1be1f4dc6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 147 runs,
 5 regressions (v4.14.208-20-gcbb1be1f4dc6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 147 runs, 5 regressions (v4.14.208-20-gcbb1b=
e1f4dc6)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.208-20-gcbb1be1f4dc6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.208-20-gcbb1be1f4dc6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cbb1be1f4dc6ca38d309facd651ab6d5cc311341 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba597bc241f3ba08d8d927

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fba597bc241f3b=
a08d8d92c
        failing since 0 day (last pass: v4.14.207-18-g5602fbd93fec, first f=
ail: v4.14.207-17-gc8bd4f3bbcaa)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba57ba35c30e65a0d8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba57ba35c30e65a0d8d=
90d
        failing since 8 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba57c2f84edf3574d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba57c2f84edf3574d8d=
905
        failing since 8 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba5832391f8db79fd8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba5832391f8db79fd8d=
922
        failing since 8 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba5771ae7afca5f9d8d93b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-20-gcbb1be1f4dc6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba5771ae7afca5f9d8d=
93c
        failing since 8 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =20
