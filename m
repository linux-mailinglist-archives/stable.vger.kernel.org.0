Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97F82BC7AE
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 19:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgKVSOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 13:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgKVSOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 13:14:40 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF216C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 10:14:40 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v21so12116510pgi.2
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 10:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DHCC5Ce313V3AJMeeqYR0ByMjD0W7vfZoGWl3BXaznk=;
        b=N7szdIVKwoGzPrPNJRl3jJ2Gl6BgfFaMOMoelGvQXsQta0EWAfWLEEqU3EJu5/zk26
         Er+vtv+1pT2v439PZ3qDjSBoReGlxCLMctF3+WwrhrgTqHyiETvALifmOgmfPyj1Z/NJ
         4rCe1ktowSnplpbZqnGW8YuJrYcHPPv4N89U1oGJeD5852gWe6bOh+r8o7SxN5zPu5rp
         Spaw12gIecTOwAXjgkurrnzsnyqLbzRNC0C2/3ehT8jgxlAcrBrzxRnWH3bRCq2vmuf0
         zzVDuWrH9IhWpZvK62oK3uqjPfiVBGl6kTTxjdzBTeruEqu9q8FDoUAntu/OZ23WT5Ds
         i3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DHCC5Ce313V3AJMeeqYR0ByMjD0W7vfZoGWl3BXaznk=;
        b=psUkN6z898SKWkR2tUSAQpqa1iMovRqXZ2VVzjDiVcbs54slGtC+wth81lEk13s1Kl
         MM0Y+e/whMMZXJOIF/0qIpDop1NvYLZHv7k9m5IKOWsj0kQK2uM5RcJ72cUbllJI0fmP
         Kf6rhvIUkJ2S+LYRYr7tGmilg3ksvFSGROjpy//BATk3uRw56KP6oRNQ1lX/3FaJTRnH
         blTk0a6JZ6JPcn8Yzy6OwAnQ+VRG4Zvj3G7deAqr6e4mTuGt4zGt+DDSmFkoDAvQrBon
         R0B0gFPuZqlNBJyippUCxeq2OnyRVQaqGSXU8dazMtFlBQetB2mWdgt1mKA8yOuZwJFn
         5Vxg==
X-Gm-Message-State: AOAM531lQyyd7VrTcPsjZymhPghR8Atxl4fJAih0V9HNR0buACHd3ZZN
        QT6gp//FgAIwM010fH2+2iW53aCcLVMYiQ==
X-Google-Smtp-Source: ABdhPJwasghgqFHmXvJoDM08L7qoCpZ99Pdw1e7aVZYPNUqnbvLzCnprd7dZQ0v0K6Q6mneTdCUdzg==
X-Received: by 2002:aa7:8c12:0:b029:18b:9939:9798 with SMTP id c18-20020aa78c120000b029018b99399798mr22352120pfd.44.1606068879859;
        Sun, 22 Nov 2020 10:14:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm8242361pgk.60.2020.11.22.10.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 10:14:39 -0800 (PST)
Message-ID: <5fbaaa8f.1c69fb81.dbd00.11a2@mx.google.com>
Date:   Sun, 22 Nov 2020 10:14:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.245-18-gc15c05b15d83b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 10 regressions (v4.9.245-18-gc15c05b15d83b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 10 regressions (v4.9.245-18-gc15c05=
b15d83b)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =

qemu_i386             | i386   | lab-baylibre  | gcc-8    | i386_defconfig =
     | 1          =

qemu_i386-uefi        | i386   | lab-baylibre  | gcc-8    | i386_defconfig =
     | 1          =

qemu_x86_64           | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfi=
g    | 1          =

r8a7795-salvator-x    | arm64  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =

rk3288-veyron-jaq     | arm    | lab-collabora | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.245-18-gc15c05b15d83b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.245-18-gc15c05b15d83b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c15c05b15d83b2c0459c7397b4891e40315aa971 =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba79cf9b54850d67d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba79cf9b54850d67d8d=
8fe
        failing since 24 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7a7a8e7d03e070d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7a7a8e7d03e070d8d=
8fe
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7883d8e908e9d3d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7883d8e908e9d3d8d=
922
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7888b2b2edf5ccd8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7888b2b2edf5ccd8d=
911
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba783cf3c560e3add8d905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba783cf3c560e3add8d=
906
        failing since 8 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_i386             | i386   | lab-baylibre  | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7a72e9b81d972ed8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7a72e9b81d972ed8d=
8ff
        new failure (last pass: v4.9.244-16-gff6d0f3a0579f) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_i386-uefi        | i386   | lab-baylibre  | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7a71a434cd34f4d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7a71a434cd34f4d8d=
908
        new failure (last pass: v4.9.244-16-gff6d0f3a0579f) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_x86_64           | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7a35a10979b984d8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7a35a10979b984d8d=
913
        new failure (last pass: v4.9.244-16-gff6d0f3a0579f) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
r8a7795-salvator-x    | arm64  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba75e560fb90ad90d8d908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba75e560fb90ad90d8d=
909
        failing since 4 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
rk3288-veyron-jaq     | arm    | lab-collabora | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba7aa5dee6190a24d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-1=
8-gc15c05b15d83b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba7aa5dee6190a24d8d=
90f
        failing since 0 day (last pass: v4.9.244-13-g7fb6fc1e8169, first fa=
il: v4.9.244-16-gff6d0f3a0579f) =

 =20
