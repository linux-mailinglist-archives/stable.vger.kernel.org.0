Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987562C0B85
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389152AbgKWN0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389150AbgKWN0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 08:26:05 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3597C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 05:26:05 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k5so2395988plt.6
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 05:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iFxMHb4u4j/zs3Eby0IW86G6RzlXmosuV9HK54D7oVk=;
        b=C/q5QpvOY6jCKuO4TCbdC9Dsz6Ecf2Ci1PaT+aT7hJT5zysYrN9QbcXiJ6Hrv/Caul
         2T8AFTtQ68ajd87jcOrYPI+i3XRPGI+Su50f6+fH8xmxPIhfmFcsYxkXV+IPrPY/TYtp
         Sds/MXHTWgVDo9B4oSNpCP9DfFnFfkdBV27oDpEV9ab0asl7zQZ76gRn2MIuv+sv0EF1
         0XOdITQBSHlSH0vq7wZOfxN1xK7MVMgR7KhiZNsJZPJerGOd5MXU6b1UZlb9ts9IHk84
         v/ysUQk+I+n5o0hG0kvQuVio1diDhftOOilB7ATi/3ygkEqKO+xYiGPnH0lbxv6M+xZc
         tmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iFxMHb4u4j/zs3Eby0IW86G6RzlXmosuV9HK54D7oVk=;
        b=pkxiY9NDXGnz0xT+ArLQ8o3cLnGxRMV7BV+ttF2hmHVoygbJNiWZOGgwlpMS6bPx5p
         UnrApFpZ/9eQVvh+QwXa37zQ3On9iXRij46pe57Nedd9kObfraDeiyrO1iEC/b4ccwQb
         QxsLTenQ87SQZG0wZPEVu0kdUjF9zcrG+HK/zZ/wjkJSUPQv69QI5qq5GpvMfhQV9IbR
         kn1aL94IkfOkCG2c8m2oNZXQ200YSmJ7yNZsQBf3z6gYvwcT2sFUMBSb8c0p5VIpd2JW
         BzGBqDoZpT7FqpSoeElFf0aWtESmjItgTIm04xsNVAhrZmwiR6sVaf3demAhZ0vQ0RNN
         1G4A==
X-Gm-Message-State: AOAM5326Gry+DsziTzMu/mL8bhTsawIeJIym64KcwE3QcK8PZHSiWLDS
        Ym5kxi4CZQAR9Rm8PHqTSwGAd0fxANw3xQ==
X-Google-Smtp-Source: ABdhPJw27v2MMrmdPPqXb2b1Ihs5ZY+d062BmIKzxQ7rJBnXC6ME5B3smF/zf0+BLHM5p6cT+29IDg==
X-Received: by 2002:a17:902:fe95:b029:d9:edc7:2440 with SMTP id x21-20020a170902fe95b02900d9edc72440mr10952379plm.74.1606137964857;
        Mon, 23 Nov 2020 05:26:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm12500163pfh.9.2020.11.23.05.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:26:04 -0800 (PST)
Message-ID: <5fbbb86c.1c69fb81.5a8f.b653@mx.google.com>
Date:   Mon, 23 Nov 2020 05:26:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.208-53-g6539b73c949c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 150 runs,
 5 regressions (v4.14.208-53-g6539b73c949c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 150 runs, 5 regressions (v4.14.208-53-g6539b=
73c949c)

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
nel/v4.14.208-53-g6539b73c949c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.208-53-g6539b73c949c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6539b73c949c88a164718e00d3e6cddd90c62066 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb86ccddf7bebac5d8d91e

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbb86ccddf7beb=
ac5d8d923
        failing since 0 day (last pass: v4.14.207-18-g5602fbd93fec, first f=
ail: v4.14.207-17-gc8bd4f3bbcaa)
        2 lines

    2020-11-23 09:54:16.128000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8448a3e365a83ad8d945

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8448a3e365a83ad8d=
946
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8467b98413c933d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8467b98413c933d8d=
902
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb844ca3e365a83ad8d960

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb844ca3e365a83ad8d=
961
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8408c1fac1a8add8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g6539b73c949c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8408c1fac1a8add8d=
90f
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =20
