Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8AA2D8284
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 00:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436989AbgLKW6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436984AbgLKW6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:58:11 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D902C0613D3
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:57:25 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 11so7906687pfu.4
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j/bJNFUWxVv+t/QZ2/Fezq9IbHQphw0A9NrmjuCZ6ik=;
        b=0sEQ2FWYXSUvx1ZcKF3W+cuWhebn77nn08Js60dTGOE7kQSQVwpJ6apYPzayp3NhDz
         RTexhimMTl7Af43Ds3VJ/lcd0h2UzO6Vj2Y0+2LaE9FsTc+rSDS3P0JqOJkXPjPDCWNO
         ODjsqo57mSWHuGPrzEWUzNYnCw5xjb1IwKK96wvUZIXbd8hTcVoLEuYznMyNcNQoUP2N
         Z1r8xPpr41QGgCtJ4btZkHEtE7rL3InQn8bAnNbL08hDzucEQb05+fUIhpjh9SMBfgE2
         lEUXQ+oUixf5Ra6QCi4xHpO8QsHM0DfuW57h6QTS6AoBWO4qRQznStfGEx6dlsFNQNu0
         E5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j/bJNFUWxVv+t/QZ2/Fezq9IbHQphw0A9NrmjuCZ6ik=;
        b=C09KKz0pfZ7Lxvc1UfCOeiPO+qB0IKAPRvk4ei3f+nXX7X17HoaHAxUx1EIjhfEVde
         Tco6E0COQoMT9rExqp5JGeg0zbYEYmjDthQnLjWhCpKd/c1AfXNo18h6mHVLQanpezA6
         hV7Vinspr1hyyp5b/aIiPSVxwf4vNeAzqoeaF2AGHxPaae9ukoQQWMGaJJ98zPc/Zamp
         t1d1s9q7bR4WWARtd4Bp4DBODD5ronf7hceX0WkqiZlIpGBGxvw9XbGoI2ByEvsArOj1
         w1EUx+6T0t5Rbug9yL2OstbNTsKXFRWwgIzW1vr6XZWmRNezUfT7TWKN7pUcL+Rw+JQu
         Hyug==
X-Gm-Message-State: AOAM531U7IAmhgCAMLuvAZJJkh9x5Cgk7gVF5dgehpEAzgX/wZaWWAU0
        7QJvSZBkMeSbkAz+2oQjEBpMc8AMoXD+Eg==
X-Google-Smtp-Source: ABdhPJzU1j3lnEoKDp4wM+7BWjjBpGxJcz6eOTElF/+spjQjJh4s/KOsM0C4yKRFZ81WRC5vM6orGg==
X-Received: by 2002:a63:fb42:: with SMTP id w2mr14001967pgj.354.1607727444899;
        Fri, 11 Dec 2020 14:57:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm11737270pjg.46.2020.12.11.14.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 14:57:24 -0800 (PST)
Message-ID: <5fd3f954.1c69fb81.15cb0.611e@mx.google.com>
Date:   Fri, 11 Dec 2020 14:57:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-2-gdd7d43e86851
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 149 runs,
 5 regressions (v5.4.83-2-gdd7d43e86851)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 149 runs, 5 regressions (v5.4.83-2-gdd7d43e86=
851)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.83-2-gdd7d43e86851/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.83-2-gdd7d43e86851
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd7d43e868516795f14e987a90375da8a139e05c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c49aaafeb1b488c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c49aaafeb1b488c94=
ccc
        failing since 21 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c53e6f150e698dc94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c53e6f150e698dc94=
cdd
        failing since 28 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3cba40ed8bf7953c94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3cba40ed8bf7953c94=
ce7
        failing since 28 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c5667b6f97bd09c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c5667b6f97bd09c94=
cc6
        failing since 28 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c5335b2a97c2cac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-2-=
gdd7d43e86851/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c5335b2a97c2cac94=
cba
        failing since 28 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
