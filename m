Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E3D2A8A2B
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 23:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKEWwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 17:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEWwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 17:52:37 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7318C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 14:52:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 1so1508641ple.2
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 14:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wdgY6bnyEZoFLLbJwx5AaBqw1i4X0iwagz+zeZzU6P0=;
        b=FuYi7YKp2kpLEWV70I3HlSNz6JVY/KB8IKnsNs/qmfMrY+RN7Nx7fmojDaX1ATBIuh
         ovjFOf/Y29u0W8mjN4PzDizhvQZ76NsbLHFJm0vhK+7xegjYjH74RXHZKEnypI8DgNMK
         nqsBk+yD9Kfqds/dDKVhxrbkxUyMWVD/6T1MlvhDc6Ad+Ge+fhGWp5HnPPUCwk0S88q+
         iy6h8bIDGIGbo85alkEYNDYFUshkZqXoBkfDPIHuOMnuSIUwsLkG55UbzNZ+FR3Xufaw
         4yhIymCqXzJJDJ3sfx+8kuQsxZK/Sau24tOMXUv+tF5E39OaV82HAx7oRGqPisl33e8V
         s8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wdgY6bnyEZoFLLbJwx5AaBqw1i4X0iwagz+zeZzU6P0=;
        b=ec/PGS3VMsiGWlR7tTiZ447k0184Zo/jYrLvN5MQX+AMCeDUCOyIl4tWrNQfjZHwVE
         qIN74N8Nh8SM3TruONuAT7EKpQDXKPnZfXJYTHWnl/2AwoumRxGbAFQ+8M1aBQ+aXvA4
         HHVkq/cc4s8Z083qz3P68Z0qegPXVKi9ZPR1kb0w1sXFWWZy3lfIdWTjrHSwaLbd5lXI
         aOoL+Wr0osVVnybmCgJtYb30HjBg18mWmP3RnTQFG/hBawGtPUKXdHqGoLglrB7+lwO0
         OUjylSeuHG8R3kBF7g6CIjFYQLwthj2nAEcMtC/my6fCEiAbj+3fhd01imGX13oOdCZJ
         BJxw==
X-Gm-Message-State: AOAM532g9rgIUBzmcdNp/e+heuaINPQs1bqPSYyNv8UFMj0UBv6lyl0L
        dTbpdqxs7AsbYYPB7en3oBxGfMS5Fbf2Jg==
X-Google-Smtp-Source: ABdhPJzw9J3TXRpI9Kr2hchES0rBltbIWaTAPB3mdxqXJd6H3SPHPBpVOkL9elCAMdkn5rImsTrnIg==
X-Received: by 2002:a17:902:7405:b029:d6:fcbe:406d with SMTP id g5-20020a1709027405b02900d6fcbe406dmr4164670pll.74.1604616756930;
        Thu, 05 Nov 2020 14:52:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm3609941pfi.208.2020.11.05.14.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 14:52:36 -0800 (PST)
Message-ID: <5fa48234.1c69fb81.c228d.721d@mx.google.com>
Date:   Thu, 05 Nov 2020 14:52:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.204
Subject: stable-rc/linux-4.14.y baseline: 166 runs, 3 regressions (v4.14.204)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 166 runs, 3 regressions (v4.14.204)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.204/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.204
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b6446efedb27c2766745a04f9b5d4449f51391d =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa451ccfeb0d297c7db8865

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa451ccfeb0d297c7db8=
866
        failing since 104 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa44ef85afb118cc7db8882

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa44ef85afb118cc7db8=
883
        failing since 219 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa450c6a78bde9598db886b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa450c6a78bde9=
598db8870
        new failure (last pass: v4.14.203-126-g8c25e7a92b2f)
        2 lines

    2020-11-05 19:21:38.557000+00:00   mmcqd/0/60
    2020-11-05 19:21:38.566000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
