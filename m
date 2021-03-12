Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC2A3390ED
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhCLPNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhCLPNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 10:13:32 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872C6C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 07:13:32 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s21so2079978pfm.1
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 07:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dHM/+iLtNRbHZaDfprBlejJv1J5Yo35rQF+jHLFkdQQ=;
        b=IZ9UENh7m9sJo4TOa+WUJAhdvyGMWSKxwXvOQlMQ2gty5eW8Iarn91cgKIwSVYUFFz
         Xhv1VVi5HxkbEAL/+guER3i+1nojtFR0TSLY/t7FpaRPqAiWm460vnuxibI9tRffMcIt
         l2mCJ/qHN9fYKMDV3i65Q9g+UK0hWVqkXxH6IaJ7BcpiOBEVECXZN5CEWe3v8DaN+E7C
         D3KxTPEqqm4Ii9YnuBtWxdQEeWEQQB858zv2Fpn7hVJwTrVk2zViEmX0Ew22rAtc4O5+
         3IATjyho542ny7w+qegmsd0kw7yc0iOP5FCNlgxAkj7jNWbPvRHaCEx/AZGdvpIwWnK3
         /69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dHM/+iLtNRbHZaDfprBlejJv1J5Yo35rQF+jHLFkdQQ=;
        b=Ve5qvvFy1UtKptsLT6OM4RRAhEL6HoseL7ynGyyaTFVopZhzLQdWQCnKpESxDtotcM
         A2WM46N7x34vnZ6CvMLkSzXwJCaM+jIPBykITyFPpp2KjLznA9EkeKCWpfR362TV5QKX
         0iC7DI8AMlpxKNX+EX+4i5xeQcmL1rTQKNj3KO5hNnqX+lPAz17b/XbfWlVeyyh0Zp6R
         Qd5EqpsTa2y9bolD/6Vg1fAK4tUstUdpkY5cgvZTGY99rMtZ+bxFYim9FEUq3oQc60/W
         vvUT5zRVY+bWOreLgEl8jbDFAwl59RaTetwur49hcJRCAg+uhI3CvCAcfDB1ZeYQVin7
         EewQ==
X-Gm-Message-State: AOAM530xQzM9XAe9QJkNRWx92Fe1fzdeQNustbKxVWf3BAPsCgoPM+P3
        R5xS7j231zY7096RWNCRVq04fw3JoOWJpw==
X-Google-Smtp-Source: ABdhPJywZKrTHROfH4c82SUX4Lu0joeA4V3ArkxTuTIRW0ahzQOWkjiovoCDI25JGDA0YfvGh6lH1w==
X-Received: by 2002:aa7:93af:0:b029:1ef:1bb9:b1a1 with SMTP id x15-20020aa793af0000b02901ef1bb9b1a1mr12890397pff.49.1615562011886;
        Fri, 12 Mar 2021 07:13:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm5962281pfc.172.2021.03.12.07.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:13:31 -0800 (PST)
Message-ID: <604b851b.1c69fb81.4a472.fb9a@mx.google.com>
Date:   Fri, 12 Mar 2021 07:13:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-11-gcae1f9fdb54e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 76 runs,
 3 regressions (v4.9.261-11-gcae1f9fdb54e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 76 runs, 3 regressions (v4.9.261-11-gcae1f9fd=
b54e)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-11-gcae1f9fdb54e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-11-gcae1f9fdb54e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cae1f9fdb54e5abcb713a22a253080a0169025f3 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604b51dbcfdb63064daddcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
1-gcae1f9fdb54e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
1-gcae1f9fdb54e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b51dbcfdb63064dadd=
ccf
        failing since 118 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604b51d7cfdb63064daddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
1-gcae1f9fdb54e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
1-gcae1f9fdb54e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b51d7cfdb63064dadd=
cca
        failing since 118 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604b517e90bc60f362addcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
1-gcae1f9fdb54e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-1=
1-gcae1f9fdb54e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b517e90bc60f362add=
ccf
        failing since 118 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
