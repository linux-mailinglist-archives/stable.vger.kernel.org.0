Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8E2B74E6
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 04:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKRDjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 22:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgKRDjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 22:39:55 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA82C0613D4
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 19:39:54 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g7so555966pfc.2
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 19:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nsMOldFjsRtvRScrTjU+d0QiVLcIvKxyduljifGgX6k=;
        b=GOjIF1pt8c4K0XaAbHPImAi7QM89YYiqhWHWoiCGJE7JGq3kC+3BuNo8S+QhNCKH/g
         EOPQL7x4o49PHwah9xfdapqKXH+sw+nXVpFVUza3vCjD9IRGhc7uI71kQDXDXhyr4TIh
         4AXwpmG/EQW4mJEm3fJAgOx5V+Ab+LZPUVCamq7tBM9DeRurlus3yVLu5RBi1uvxcgal
         6XeftQteG8hGF3pIgsK9p0A6S+ZeiS2AP17bmFtA1oJM2NEuB58Q2ZsYz0vFkvJ9fy7H
         6GamIbxSX44P7gBAJhtmoVG6XqwnTt9CbO+Qz0FM8+iPzknBb1xI/r0vQ5JKThBR4Zb5
         KigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nsMOldFjsRtvRScrTjU+d0QiVLcIvKxyduljifGgX6k=;
        b=BdXxksW/aAaWjTMkg5hbVcwpamZ20b59gMiJB40R9YO/uE2gJDA7pBTQTgDSUI7K0X
         dshoJ3kL7B00REehlU6fOjgX71sr7TAvelnHIWn08OVCareXst1sTkAz0052HdAGMbL+
         lw+i5ai36Vy0DNNLXshxvtrT3LLg6V1mYjHY96fqYzif7wwZz/pjLQ2AWmiuUhdWZM+6
         M1azq2q3OY0rWW+cl0NjpHl6qoTdHCWugZZ4t/jJpmnhbIF1zDWArxz1AEKjULU7kA0E
         DEhcho2JqfIen6TK5NvE8NWni422esC+znhCADFgN12ilJoNOIW+HAY+4ekjKfi9jBZH
         J1SQ==
X-Gm-Message-State: AOAM533ADTxVA6ZXuIOs/qme8jatnefyRt7P3QVUUgEBvoxC6r74l32J
        wx2Zdfw1GGwiJAR161rWylfyCLn9eJ6cLA==
X-Google-Smtp-Source: ABdhPJwXZYrn62sWX9OFFFy4MRMNmqr6lZTr27Qqw8ptGN5Nvd+vxYdIhUP2b69EtFdXjxVDB8upcw==
X-Received: by 2002:a62:64c1:0:b029:18a:d791:8162 with SMTP id y184-20020a6264c10000b029018ad7918162mr2777417pfb.24.1605670794069;
        Tue, 17 Nov 2020 19:39:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11sm23341272pfq.156.2020.11.17.19.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 19:39:53 -0800 (PST)
Message-ID: <5fb49789.1c69fb81.67276.482a@mx.google.com>
Date:   Tue, 17 Nov 2020 19:39:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.157-100-g2223b66e52e7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 162 runs,
 4 regressions (v4.19.157-100-g2223b66e52e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 162 runs, 4 regressions (v4.19.157-100-g2223=
b66e52e7)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.157-100-g2223b66e52e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.157-100-g2223b66e52e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2223b66e52e7b0ff6f293fb6887945004437564a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb46337d94d7a0158d8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb46337d94d7a0158d8d=
912
        failing since 4 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4635c57ffc50f3fd8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4635c57ffc50f3fd8d=
912
        failing since 4 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4635f8f8acf6604d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4635f8f8acf6604d8d=
8ff
        failing since 4 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb46ec6b7498f1479d8d940

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-100-g2223b66e52e7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb46ec6b7498f1479d8d=
941
        failing since 4 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
