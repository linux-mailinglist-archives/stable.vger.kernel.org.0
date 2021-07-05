Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004163BC258
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 19:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGERmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 13:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGERmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 13:42:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68E6C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 10:39:22 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i13so10565108plb.10
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 10:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6OzuCLUw1NhqHUjLiGtz7xZKnBohlRC4Gb/P8IJ8Vgs=;
        b=Tc03+VH8eqIVmMztd4yZML4rUlabzBXWCg0w1IHC6Xeat1Xa7Qqhd9axknpsv2dL0l
         L9S9AR1f8vsdUhN7IjmoZT3MVDegG3QaNmF5KMKmJTIpkQWMm6VvjoyoZNggse0zGn7O
         ZhsH7kPUGD6gtXFVT7K0CmaE10eDB14ePvlH8bHITH6nkaLzOhav4w25J/gLVwbHZF3R
         nbHgKAsZCsyztVbUxF1V+z9aRyzMXWe4cA0pp3mEfM1Fer4DZa8uVb5ahcgGe2lFhGl0
         WOVIGcfxhftiwFpRHs3FZwGHlYD/Df+dG17A/QwcxAiQJGopIC2BJvNAE5HaQHW4Vw4N
         VO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6OzuCLUw1NhqHUjLiGtz7xZKnBohlRC4Gb/P8IJ8Vgs=;
        b=aTI3fjr7aNoCjukYgxW2jFvU8w4QCbpu4TnD5ms5x6dUITYTU6YdBEeuOpSDWlfTUi
         SGucuvJ69vf79K6HTGMsj/saPR1osy2P6BNUNujuDnRhdH3GFrwvKw0kLg4xkL4y96rY
         6foa8wHzMX2bJ23E3qZzDHZGMMVB2WBOBUzSCqtPWb54QlXN6WovW5Z1RFEkBnu+EcqE
         bPk1lU7GmZ8nP9AQv3q2E+I0Iyg/ufBcV7nJhau179KVR9SDPDC8JWwFUoKAx9p1nKYu
         Kw6TwytquRzHnmCwBjGg1VGNSrnjo/HoLh6DnvA/K2pB15cf3ruM5yyQ2nzS2L/xfhOs
         y/GA==
X-Gm-Message-State: AOAM531ssgbVAIb9Au2ODsjrJNyhIG7BXUvEuHmLCiYuw0wP019ijDa8
        ax8DtuXsrzSHjWerbWbgB890qknnI45xfSHE
X-Google-Smtp-Source: ABdhPJwQeoBGbI9RSapQ8gBIXeadyaxLvM+VJphjz9zKiQhLVV8PgkqHZBeHKaYJHmc9zgElTGr5TQ==
X-Received: by 2002:a17:90a:2f62:: with SMTP id s89mr13148416pjd.107.1625506762337;
        Mon, 05 Jul 2021 10:39:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b67sm15570221pga.37.2021.07.05.10.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 10:39:22 -0700 (PDT)
Message-ID: <60e343ca.1c69fb81.fb629.e084@mx.google.com>
Date:   Mon, 05 Jul 2021 10:39:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.274-6-g62fd37d1f3153
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 123 runs,
 4 regressions (v4.9.274-6-g62fd37d1f3153)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 123 runs, 4 regressions (v4.9.274-6-g62fd37d1=
f3153)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.274-6-g62fd37d1f3153/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.274-6-g62fd37d1f3153
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62fd37d1f3153b83b98a4a5ee823fe79e3ff6df3 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e311a6b3e976891e11797e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e311a6b3e976891e117=
97f
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e3121303c7f84bef117976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e3121303c7f84bef117=
977
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e311a6e53233f0d711796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e311a6e53233f0d7117=
96b
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e31506f06f0971541179a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g62fd37d1f3153/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e31506f06f097154117=
9a1
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
