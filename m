Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A1E34B947
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 21:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhC0UPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 16:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhC0UOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 16:14:54 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526CBC0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 13:14:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so5828974pjq.5
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qVRFaomeiYSccIa6LajXBJ8+O8I/XiMXsPxv+vhH66M=;
        b=bPH1wG3kIRh3diacXt5St9KQf+zisvlf8J43eJu66FR2QD2FH2puADoOystNgVwCAZ
         tC9oayJ+RgEKzxquD4gvug9kIl1rdomcQQ8PbD+AVIuZlvWlRT6Xqanl4UAcbK2Wt7Ih
         /TF/hhGYasFHv2JE2Eu5HjJoWnuNM0gYH2gGlA9nyxs0XXW8KzQEo+OQHRcy4hNa4bs+
         u/WULZktF7H44Fqz/BCKKhVbPGIdyOEBc1qgAVlzFa57gdOlqDZmcCsYUYKR7OXp5KNv
         G4c7fIYZQccZ1Y/FKqmrZNPK++AoxU7rYPPhM0BQq83oYnwVH+1yPPwkiEujmAmu6+7L
         jjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qVRFaomeiYSccIa6LajXBJ8+O8I/XiMXsPxv+vhH66M=;
        b=eIalZ3wz1BNNbKbkR+NyUwC/AK7ja+VjIVaKh+ojJKZ8xZ1+P6VepxnmMNUgIFsgUw
         o3FbTuOhEVKHFTid+J8T1G/7BHNdVxpYw9Xhp0GxVDdchwdpq16WVWb6cxoX3p4IaLct
         0behjJf4gRWK9WZtW5V1xno1XZbM07o++Q1AltNfG9T2F/IxEmIqzEFEmb/dP6AZwRNL
         OAKy4eQEZKbVl/aJV9GZVKS023cGM6pXjEKCBISqhlemqcWSQllSrUKG4tNksyXOVKMQ
         JdF2kgpnC90ErVdtYaYTInfT8+/eq20vCAd8W1rMBLjjQjV2wJ2SJwwmjLHJVnLtfkqR
         fiAw==
X-Gm-Message-State: AOAM533M1Fkw7vrM7zVszmYR0rAV9QXjz2GfHdTy+qlaqa75u8MUUoee
        zl/uspcIXau4nOr7jIA74bxdG/oGYtnHoA==
X-Google-Smtp-Source: ABdhPJxPlGhS7EhBF+GWEUWD97bybBjFymbmfvLykGYuWXa0boXSETU99H4SshKg89hHJ0V00jYO0w==
X-Received: by 2002:a17:903:22c1:b029:e7:1f29:b848 with SMTP id y1-20020a17090322c1b02900e71f29b848mr9151072plg.53.1616876093425;
        Sat, 27 Mar 2021 13:14:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20sm11173239pjn.27.2021.03.27.13.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 13:14:53 -0700 (PDT)
Message-ID: <605f923d.1c69fb81.22866.bb0f@mx.google.com>
Date:   Sat, 27 Mar 2021 13:14:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-32-g34b1821855ef4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 87 runs,
 4 regressions (v4.19.183-32-g34b1821855ef4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 87 runs, 4 regressions (v4.19.183-32-g34b182=
1855ef4)

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

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.183-32-g34b1821855ef4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.183-32-g34b1821855ef4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      34b1821855ef46464425b4a322cc9111e95fe3a5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f59f6aee7326f7aaf02cb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605f59f6aee7326=
f7aaf02d2
        failing since 1 day (last pass: v4.19.182-44-g44d418614856e, first =
fail: v4.19.183-23-g2029c0e11438)
        2 lines

    2021-03-27 16:14:41.302000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f571e3f735be551af03ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f571e3f735be551af0=
3ad
        failing since 133 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f57110e1c041d9baf02ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f57110e1c041d9baf0=
2bb
        failing since 133 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f56ccabaf645a5daf02c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-32-g34b1821855ef4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f56ccabaf645a5daf0=
2c1
        failing since 133 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
