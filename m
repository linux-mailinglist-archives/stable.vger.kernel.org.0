Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2D72E21D3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgLWVAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 16:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgLWVAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 16:00:16 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1685FC06179C
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 12:59:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g3so290230plp.2
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 12:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w55TC8566sKYPtWmGi+A6OyIeeDMdG/7HtOaxVRMIAE=;
        b=vvJD5vxxoHQ9VrZECan4DEb0mjwUDoQiWOLMh6YQbE2SND/oS+QJnLdD1pB2GZIlX+
         Mttf44tGpPjP94chZmqJbbwWe1XNctzY9KQg70rndImjdqF9Pj+xBtPLRQPJ60BCc8Q3
         qiprZM9PioBpNlhLf7GAM7rby3LRaI3Ik7cbWM89W72iBXsjoHrDbB8wwIVKMCFh1X9I
         HtnVpKsS4K4mDw+/Vin4CLI36e4HOWEsWjZvB3debG8fwH3iJBJuWpFN6DhM6wdFk+/P
         Jxe2yb0f+y/JQEy3JJWDDzW6DhOO436H/y0nj2Hdv8JDn8/ULIEK6JMbWn0yYqg2Iebh
         Be5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w55TC8566sKYPtWmGi+A6OyIeeDMdG/7HtOaxVRMIAE=;
        b=E7wWIqsWK8aIFDVyq6IOwMPjavPD4ahoPWd1xGUmhAODNTY1aguzqWghJoAZNHsBLK
         rqGEReJRfxxUi2MHHUF9RaQx6npkK9VvemaxJhMj7xJQDACqHXMiU6/qq5xzN+W1xkUB
         XRD7S6jIDaa9rvF87WjXqfKX0IbOg1m9hEM8VRDvDw4SdhQ6P0fS5FF2JrMr8Ay6GsLL
         6jdAADX46Foyj8Rca35CzRBdX2VT82Wah1+hKqxNXsUD/Kx/whhe85dbrO9P1GTdCF3k
         uIz+mea7iq7JngDT8+dANT0GysZO1vAhIyrFbr876OfHV1/Oy5v7DR/5hMbDGmrNL00o
         PQPg==
X-Gm-Message-State: AOAM531T3esMuzzoZ3WFYBZFjBbmwWTnFuDHQVTDS49oO0Wrsw5p7IAb
        LmH44uVmiFhc7cSI+rFGsB48+aT4ini25w==
X-Google-Smtp-Source: ABdhPJwSd8TZm0S6VkqMVbs17h96tjlNOtJRkHiiWwiTRPJ9EDxPIXvYnG+5mishNNp/EWdvVNrmKQ==
X-Received: by 2002:a17:902:5581:b029:da:a547:b6a6 with SMTP id g1-20020a1709025581b02900daa547b6a6mr26884938pli.78.1608757174542;
        Wed, 23 Dec 2020 12:59:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n28sm24490592pfq.61.2020.12.23.12.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 12:59:33 -0800 (PST)
Message-ID: <5fe3afb5.1c69fb81.f8a3c.2c31@mx.google.com>
Date:   Wed, 23 Dec 2020 12:59:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-63-g127b6f13142d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 145 runs,
 5 regressions (v4.14.212-63-g127b6f13142d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 145 runs, 5 regressions (v4.14.212-63-g127b6=
f13142d)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-63-g127b6f13142d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-63-g127b6f13142d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      127b6f13142dbd49ac0a10684c30e5f4fbfe78c5 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe392a257deac1240c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe392a257deac1240c94=
ce2
        failing since 15 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe37b78f0044a719dc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe37b78f0044a719dc94=
cc9
        failing since 39 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe37b82b7075d3bb0c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe37b82b7075d3bb0c94=
ce3
        failing since 39 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe37b812c99d1c665c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe37b812c99d1c665c94=
cca
        failing since 39 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe37c8cb65b2ef48ac94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-63-g127b6f13142d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe37c8cb65b2ef48ac94=
cd2
        failing since 39 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
