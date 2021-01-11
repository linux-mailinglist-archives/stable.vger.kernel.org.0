Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A4E2F1641
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbhAKNuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387869AbhAKNsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 08:48:17 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB81C061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 05:47:37 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id i7so12555607pgc.8
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 05:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2AVeapkT2wIqlT8aSvxkfOKr+VqtQbIgZWNjLfHYA6g=;
        b=OOOuLHs2P9XA4wrns0Y4oxuxd29jyas8ByqrcfkVDOnGHxbhGdCV+vALULnyEu+yab
         aheH8kZMmPiSzvu3kwgBZaeksg+qFAmZJAmEtPYRsBysxnWRchYunOuz/QUqh5o4hujK
         yySA4L80osR+BLQPep+DwQNZlccMhfDnYYy0bgCXeif/4ildyPR3m8s1pBgGDJ4bR+P7
         7S88mrZnAcrveMEAMUd6bt4De3GKFqowSOYzYL2tpmDljqDo8/VJTmbjCDtcENnVS6J6
         qe6cNTHXfDPh3HIgkkRS0NREp/tQz0U+PIla+w1frbNGWeeYd/WQ31+TwGcgEuEI0mXc
         rZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2AVeapkT2wIqlT8aSvxkfOKr+VqtQbIgZWNjLfHYA6g=;
        b=IJ8ST3EbG7gRJCPJgA0nWHGLsrDkWVaulzp9Jp1EWqPnyZMRecDp4/v4eaY2Q1PGrJ
         3OYctacDLeQn6u30PEIo6WwyXh22hsQLpmN5kOw9syYsvMao+YfEzCtuuOc2lywVdePl
         aaLpvHHBKgdUj6oQcXJYal0I9r0ifM9zfWP2Pu7fIldGPssBIZ9SZ0R8GAGW8LxSNC1v
         09kiSESOQ4BrC/Lpxzjk1RTgLm2/Hfr94vMnKody20bz0IuWWYZhYXYd2G7oSgkCHIZL
         83JQPDnyrHoooOGxg1iDR3nFx7Xw/HfIxdEH7ToAsPs8FT4NViBeJJMPzI2sv4zzKNW4
         dFJw==
X-Gm-Message-State: AOAM531JeXxI+MkRLp0A3bTSkjm7wPHD5pUDUqiSpvd5k6TWW5x8EeDG
        xXW0ZdNUJPDlHyH62xshJuUMlkDkj0Qc5g==
X-Google-Smtp-Source: ABdhPJzwry/TX4+eg5UbbvoMOxY33YjSKBiNKsMPCgYNQfzliMBhb5n8uf3ppyLJZmJnfdQMJr5c7A==
X-Received: by 2002:a65:64da:: with SMTP id t26mr19557317pgv.145.1610372856430;
        Mon, 11 Jan 2021 05:47:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r20sm20431183pgb.3.2021.01.11.05.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:47:35 -0800 (PST)
Message-ID: <5ffc56f7.1c69fb81.9693c.b67d@mx.google.com>
Date:   Mon, 11 Jan 2021 05:47:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.250-42-ge31725477a1c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 5 regressions (v4.9.250-42-ge31725477a1c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 5 regressions (v4.9.250-42-ge317254=
77a1c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.250-42-ge31725477a1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.250-42-ge31725477a1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e31725477a1c1befc91890c00205c372ba554159 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc23e8fd36c064d0c94cc3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffc23e8fd36c06=
4d0c94cc8
        failing since 0 day (last pass: v4.9.250-3-gad22df8e1d0e, first fai=
l: v4.9.250-4-g5c199034ff75)
        2 lines

    2021-01-11 10:09:40.545000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc22d3e2c6aedbbcc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc22d3e2c6aedbbcc94=
cc9
        failing since 58 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc22e6803966e6d1c94d1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc22e6803966e6d1c94=
d1b
        failing since 58 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc22cfe2c6aedbbcc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc22d0e2c6aedbbcc94=
cc4
        failing since 58 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc24ca424d09433dc94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-4=
2-ge31725477a1c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc24ca424d09433dc94=
ce1
        failing since 58 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
