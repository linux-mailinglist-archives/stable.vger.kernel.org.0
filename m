Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EE2393270
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhE0Pan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbhE0Pan (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 11:30:43 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7929CC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:29:10 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id l70so216648pga.1
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DmVY0/YxGGlA+tfnmsbhXCRrcxExy+bPR4oeo91AObQ=;
        b=T+Gk7cgrzV1RQAH13Kr/5ZwKn4b5i+Nv8eo+nm7+DxDDMZv+BP436gNF10Bf25RFkW
         snRS5tI16rIU9C1OxvHxEKpHFkhZo0EUGas9i08Wk53Vzp8jks2HVD33GeulcS6xEfG4
         z7KP73bzUwZR7CsE43/k3+J/tgzRM0YIqS7fSpab9Tuy5TkHct2/vjWjBnTGzry47Evk
         NtJkS5PFqLC5RIGhO6w84k1qi8yMzyDsCsYuU5Pj7T2jt82s86x+UDp/7JJl3u2wmEbl
         ue83AVOtxwChepX+ocl4+inlDYrBOpOEEabh6Uu/xWzwyTuvpujABcmg9CHFiUnZ320y
         iGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DmVY0/YxGGlA+tfnmsbhXCRrcxExy+bPR4oeo91AObQ=;
        b=nTJnEi0I1aYdaAyE/AVziDj/gkBELk2MPgsvscHBpf82KVZjjYCx+TwiBoJ+vOm1gi
         FJTVhYXpO272bkiCv6CGQ5xuayGQFF6Wc2fU3hvCQNZKSDjTEm0E39xaCCyXcUYHo7ER
         lilOjfumX0F5YwUfl4WqIX7GRWYJ1kJnDeLcN6sIWw8+u0T0UPkiWwjZi9VaCVPC/ChJ
         1x5lhzKCOfcE3ZJi6ukavnPeVbClK+odB/sZ2Ed+UWYnaBpwAPZow26xjlKRtLKvvDjL
         Q+DIrxYPO3PPDgHqKcB0KlMEzGVgof+CK+fhHNuHSGKIsy+VrsqcFjccueoQj6tD6YFh
         ZvnQ==
X-Gm-Message-State: AOAM531HGfEj9peDHUSc/zaUIlQmoD/5cJjuqqd3B6nukaBJNBrJ8a/z
        Ig5oH8YcobnhWp2LF2yeVXbRdl35HUm4Cg==
X-Google-Smtp-Source: ABdhPJy5mqKCAnnKNpTNYKyM27chG2L1RP/DBcnaK4tdf++Zz4a+PpBJIpp5GYvayTItHjBRm5BYmQ==
X-Received: by 2002:a62:1d90:0:b029:2db:649d:7e6e with SMTP id d138-20020a621d900000b02902db649d7e6emr4178058pfd.75.1622129349708;
        Thu, 27 May 2021 08:29:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w123sm2173247pfb.109.2021.05.27.08.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 08:29:09 -0700 (PDT)
Message-ID: <60afbac5.1c69fb81.19a79.7480@mx.google.com>
Date:   Thu, 27 May 2021 08:29:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.270-4-g2103321d5101
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 106 runs,
 5 regressions (v4.9.270-4-g2103321d5101)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 106 runs, 5 regressions (v4.9.270-4-g2103321d=
5101)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.270-4-g2103321d5101/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.270-4-g2103321d5101
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2103321d51018879cb7dea3f2bd35f2276b65c32 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af81ae051fb4132fb3af9d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60af81ae051fb41=
32fb3afa4
        new failure (last pass: v4.9.269-37-ga1966856a76d)
        2 lines

    2021-05-27 11:25:30.439000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/119
    2021-05-27 11:25:30.447000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af80432aa7813c83b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af80432aa7813c83b3a=
f9c
        failing since 194 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af804e9054fb4e69b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af804e9054fb4e69b3a=
fad
        failing since 194 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af7ffa567a63558cb3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af7ffa567a63558cb3a=
fc1
        failing since 194 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8429f668bba2ebb3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-4=
-g2103321d5101/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8429f668bba2ebb3a=
f9f
        failing since 194 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
