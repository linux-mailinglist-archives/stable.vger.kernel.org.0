Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5DE34BBBF
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 11:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhC1JEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 05:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhC1JEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 05:04:42 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73022C061762
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 02:04:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 33so1627659pgy.4
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 02:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vXsEc8lawLZbon5D3TtmUMX2tiOl3MsPQIrACh2G8IA=;
        b=J58Xod7+sJVjVlVwcN0cw9H83JpbDgbrNcxhx9IKrL+ilNRsC011In3ytWzaPpvQgq
         ltUZ3wpeZE+9h2ghT6qSs6lCorjsipeAfYesQXYUzJM1CAkaO41Q700HtIaVqdbsYCSA
         XnaI9t3+UNSDRyH4Z5/OtxzXGG6bjcJu6sNYJmuIoS87YCi++vW4Y0HdsTx1e3BaPgjE
         mAIxseK+io4oMgA5SBsUAzFpHTSNAw7BzO3rJUBafKMPcY7PkCwN9cDmmB3yEo+pVMay
         mjfKm/ht0L69wvbScnZaz/ek8wihxVWz1yt49W4FASjwpSLNxU9eVmOGUbDgKVqeKpJP
         SOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vXsEc8lawLZbon5D3TtmUMX2tiOl3MsPQIrACh2G8IA=;
        b=m6zkca62dkj7R8pp+6s2gKMGGexO1L1fsiUf1jEjAj12kcVhCq+tO6eUBYEbGc6rBd
         5gizjJJkRfsjsCgJKC1EYB/H9d6/vb0tgHjKv3xt+UHW0ZVyEmemQtzip4vOicJQXmRs
         p2cGx5XxP54if3ZBoqpTxHW9mDJGXxPjCZRIeiCnmjqEcOq0tavpF+MV3BEwX/qCcICp
         pmEwQz80LbetW95WLpHxVYPceyAc6cbF5ZyZVc7fSs4u6GIfuJsTFLB5hbOPihjeIe2f
         fSXdSzLco/AXDH84vP3dTdqlIubjYcjh2/EJjY7pVKm/7G+3Lerx6zsfTvUDleoz24Mt
         BDJA==
X-Gm-Message-State: AOAM533N6S3EZmfU1+HCbyAJ4gRd3H9B5+vqfbKcKlF5+FO9cGfJC+H5
        K7VmWKxjGBeGUZNH+3m6ZwC41KE4fWM0mQ==
X-Google-Smtp-Source: ABdhPJyxbwslyOAtzzGhIzr4GP2HZ7qe4BxjWeH4Mc3vUwpyCHEUhsE/XD/Y6D7j55Z7VnDDT9hhOw==
X-Received: by 2002:aa7:9910:0:b029:1f1:b41b:f95c with SMTP id z16-20020aa799100000b02901f1b41bf95cmr20277662pff.5.1616922281821;
        Sun, 28 Mar 2021 02:04:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u84sm14477438pfc.90.2021.03.28.02.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 02:04:41 -0700 (PDT)
Message-ID: <606046a9.1c69fb81.ffb0a.3c88@mx.google.com>
Date:   Sun, 28 Mar 2021 02:04:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.263-32-g75094eb3de1a3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 5 regressions (v4.9.263-32-g75094eb3de1a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 5 regressions (v4.9.263-32-g75094eb=
3de1a3)

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

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.263-32-g75094eb3de1a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.263-32-g75094eb3de1a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      75094eb3de1a3be556ee742db233ece9ae9a2285 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60600f4ec6ab290e6baf02c7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60600f4fc6ab290=
e6baf02ce
        failing since 2 days (last pass: v4.9.262-25-g6d1519a62408, first f=
ail: v4.9.263-17-ga851361607f1)
        2 lines

    2021-03-28 05:08:27.142000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60600e09f327b6834aaf02d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60600e09f327b6834aaf0=
2d9
        failing since 134 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60600e0ae24e53ca63af02cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60600e0ae24e53ca63af0=
2cc
        failing since 134 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6060126f69baff6120af02af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6060126f69baff6120af0=
2b0
        failing since 134 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60600dc792431653aaaf02c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-3=
2-g75094eb3de1a3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60600dc792431653aaaf0=
2c8
        failing since 134 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
