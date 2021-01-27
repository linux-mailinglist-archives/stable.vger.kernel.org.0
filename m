Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754F33060F8
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhA0Q0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 11:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbhA0Q0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 11:26:46 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C0C061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:26:05 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z21so1922871pgj.4
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kns0aL+9W4WAJVwwpAJnwFUkBkQBdjQd5YubgglYaU4=;
        b=wtgwGQZ8B7m1EsZPgJDoGO51NOmIzuG5x845DjwmFWmrrURBO1uoiKuVV1A/OKZSmc
         0Fe6ZzFurf4nTqKKloCBhYpjzRnfxOdwZjULo5LzYQ9AzRk/eVnl5kJ70HrIhrJGczi6
         KCpL4CZ+5PXWODXvl+n2Fb1dkvo1op2yId74s3i5iK8YkzSQ92w+aNfi0RLUg38ovq2c
         W2VmvE/35M3PsMkjg+Vi1GEoaKt+CKs4WwH9zQfnZb6JIOj1Qw4QLRaE8ZVgDyCh4zKZ
         hfDf5Eyf1MqaQRwzqR334//dMnkRAc9ww/amwwCYmfAhtANd9x5tlvWfRIaeEJwIMcyG
         6iRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kns0aL+9W4WAJVwwpAJnwFUkBkQBdjQd5YubgglYaU4=;
        b=AnxtU1KZefckQjtHxJE/HOWXlu/LZcza+z5aqVA55sMz3B+xs2iV15Lz9xFcoiPI30
         3brO7P4ClzdUcZYbbdxUWuOaGlQmiL243fYnnmwl8Lg3az+2YbzUSstYidThxBqimqUu
         AgTtTTXRbwnY7jgTnu8kURKGZ6b5U0u7fHTWUV1IsE1s2bh5nuMJcce2ZE6+Xv674L/s
         I0ptHyrPIWZ+wJUPiFCZFxs8NX3RycWO31s54zZe0GNdFnym7AZ3cxVNnbTlJTJW0hTn
         mqcs2NL1QIIvJBeEL8S3DKBILwUYVvK7PPUX0brqfqlybJuJ9Qw5rtkVIVWdiGf1Vptc
         FI/g==
X-Gm-Message-State: AOAM530tqceIpPvNhiB64JucROZVcTdnOSRRZcMyrDkjKHa1bXwTns3/
        HxI148ugsdgYUjxjYQH+KxCjJlTprmj55fBb
X-Google-Smtp-Source: ABdhPJzLYCijPKNUzUygCaIImG5EWKqX3RM/Rc4zaqn1aGeFK7YqvRTOf+rHzpWXMhaHOcQIT2yquA==
X-Received: by 2002:aa7:8f1c:0:b029:1c0:60c7:f7c5 with SMTP id x28-20020aa78f1c0000b02901c060c7f7c5mr11473215pfr.59.1611764764944;
        Wed, 27 Jan 2021 08:26:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d76sm2983191pfd.193.2021.01.27.08.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:26:04 -0800 (PST)
Message-ID: <6011941c.1c69fb81.391c.6d7b@mx.google.com>
Date:   Wed, 27 Jan 2021 08:26:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.171-11-gd6c7d50dfd0f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 159 runs,
 7 regressions (v4.19.171-11-gd6c7d50dfd0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 159 runs, 7 regressions (v4.19.171-11-gd6c7d=
50dfd0f)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.171-11-gd6c7d50dfd0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.171-11-gd6c7d50dfd0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6c7d50dfd0f4e3866eaed134e892972b502935b =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =


  Details:     https://kernelci.org/test/plan/id/60115a2732d4161ae8d3dfd1

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60115a2732d4161=
ae8d3dfd5
        new failure (last pass: v4.19.170-58-g2da77944b6386)
        8 lines

    2021-01-27 12:17:44.826000+00:00  kern  :alert :   ESR =3D 0x86000006
    2021-01-27 12:17:44.826000+00:00  kern  :alert :   Exception class =3D =
IABT (current EL), IL =3D 32 bits
    2021-01-27 12:17:44.827000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-01-27 12:17:44.827000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D =
0<8>[   16.545100] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail=
 UNITS=3Dlines MEASUREMENT=3D3>
    2021-01-27 12:17:44.827000+00:00  =

    2021-01-27 12:17:44.827000+00:00  kern  :ale<8>[   16.554313] <LAVA_SIG=
NAL_ENDRUN 0_dmesg 638573_1.5.2.4.1>
    2021-01-27 12:17:44.827000+00:00  rt : swapper pgtable: 4k pages, 48-bi=
t VAs, pgdp =3D (____ptrval____)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60115a2732d4161=
ae8d3dfd6
        new failure (last pass: v4.19.170-58-g2da77944b6386)
        3 lines =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60115b4428a5ae362dd3dfee

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60115b4428a5ae3=
62dd3dff3
        failing since 9 days (last pass: v4.19.167-43-g7a15ea567512, first =
fail: v4.19.167-55-gb4942424ad93)
        2 lines

    2021-01-27 12:23:27.789000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6011586c63c4653615d3e000

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011586c63c4653615d3e=
001
        failing since 74 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6011587363c4653615d3e01b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011587363c4653615d3e=
01c
        failing since 74 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6011587d20350be0fcd3dfcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011587d20350be0fcd3d=
fcd
        failing since 74 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6011582dd74fd5f590d3dfea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-11-gd6c7d50dfd0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011582dd74fd5f590d3d=
feb
        failing since 74 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
