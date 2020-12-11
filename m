Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B342D7CEB
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 18:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395275AbgLKR3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 12:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395286AbgLKR3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 12:29:40 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69092C0613D6
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 09:29:00 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e2so7579615pgi.5
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 09:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2hQROu/nCIKC686Se68H96J5QVF2MgvAOAIwZ8+njqQ=;
        b=AIWQBw8N9j3WFXg38b0DIjVxdbqtoQxj3fuGxtIYjQ/0RYX4SKa17PPEvFfqo/x+7V
         /7LYaTyCOZCr0IJLW6HOjDQFCcEmse4uZ7cJQtvvzkEDgzosHWZxEcGcKgtoM2+nU+YT
         in2W6k+EenQQFSuLz937Xk1UklKHj4LuH1/9C+a4jyt4dQwQ/+7YLZY9Nmned7CBj48B
         xLjOpLcsLGqtryuqdOf2d8QEg6hzQmKGwMHibnn7PE0OU1azy9XO7DyMvgvxUqtAYGtd
         3HYIad2/9tTrtK5vi079C7xF5oIEyN8+aFxpR4/Vc0Mqw12y84ADgvF0oFyKHT24MZ9v
         Y5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2hQROu/nCIKC686Se68H96J5QVF2MgvAOAIwZ8+njqQ=;
        b=U1TahpoW4ic3izKj+LM2WfMjL0bsUbgEZZrpa3SpLCwNmoOVSUrtl3yfFeVnsgFDvt
         L7D4fx7rl/xTbpGljti66Go5hOqp1nqe+WXgeMMxhMA/tVwmZnxHMJr3QaLW8V9Pd0bV
         ONRaXIx3+kGKFWIi7xPxyGjZBreWP5+naoCMC3OgolB9c5NHvWxS5Mx6jO9FASnjBZiF
         VraUP8zxiQMPB1WBFoMgAbH1izmss6QUMdgzkXe/pxEK/71z9+PVmqDapxXQ0qJph7Hr
         hcO9db450YV42e3Fp11pLhFCKoOaOJ9jc7HCcdOVoXM4sArbwzf4szacVQjYe7OMBGGW
         3Bpw==
X-Gm-Message-State: AOAM533tSu/B/0jj9h/e8f5pqVir4TdGOW+3sUqGe58a6sfaUz1HQbE6
        1Z+kXQREZic6ncVhRLt/1SrW+YD28FVyYQ==
X-Google-Smtp-Source: ABdhPJyQ+ycn01eI6ktdJC0D5W4txNG4xglnXKMnVQqRFcGis1nBkP06CJOGg9ey3W3MhKnbvjdseg==
X-Received: by 2002:a62:184e:0:b029:19e:c636:17f9 with SMTP id 75-20020a62184e0000b029019ec63617f9mr7606307pfy.23.1607707739541;
        Fri, 11 Dec 2020 09:28:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15sm11051982pgi.40.2020.12.11.09.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 09:28:58 -0800 (PST)
Message-ID: <5fd3ac5a.1c69fb81.a9229.4697@mx.google.com>
Date:   Fri, 11 Dec 2020 09:28:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-44-ga4972c20c53e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 130 runs,
 6 regressions (v4.9.247-44-ga4972c20c53e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 130 runs, 6 regressions (v4.9.247-44-ga4972c2=
0c53e)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386-uefi       | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-44-ga4972c20c53e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-44-ga4972c20c53e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4972c20c53efa343274be64f544571145ab61c8 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd378ab4d8b86f5c5c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd378ab4d8b86f5c5c94=
cbf
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd378b25714cd211ac94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd378b25714cd211ac94=
cbb
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd378b44d8b86f5c5c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd378b44d8b86f5c5c94=
cd3
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3785b5eadf33875c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3785b5eadf33875c94=
cc1
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd378612004348afec94cee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd378612004348afec94=
cef
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_i386-uefi       | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd37a3bfc1f4e694cc94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-ga4972c20c53e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd37a3bfc1f4e694cc94=
cd7
        new failure (last pass: v4.9.247-44-g2e0dfc09419d) =

 =20
