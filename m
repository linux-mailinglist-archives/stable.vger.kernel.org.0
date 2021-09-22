Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD0414148
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 07:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhIVFkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 01:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhIVFkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 01:40:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C294C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:39:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n2so985938plk.12
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TbpK3TAKmxbYsAVdNDqkzGA9GfO297u+h6NpamKDWRA=;
        b=btC/uRkRfedcB6l1kvSs49AuA4JgtwH3Z3+JH54O2TgiQdkN7zDySuveLA6rbfcEK0
         8u45+spaEz4uIZNgKg9IZkItoNhQbnEXOdzaqboFNYvldk7tjB9W4d9UWKAgPT5fWOGt
         WvIWe8qu5NKS2Y/fvP7JxHNNamURkOaVsha6Zk5Sle8THo+kaInTFUrgMQ9MjH4olB+u
         4YpzXt1G0OB+AVn3sVKzgtArmHeEdY/KLsF37h0o3ePMNeKmza1JzqubG67wXbgLiYjD
         D9bDRN5c1OxdTvChRN+N1nk7kTKtHWPXBtw06kGkdLTVEt8dIuTg6AI/mkc3oNuA2D1F
         PDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TbpK3TAKmxbYsAVdNDqkzGA9GfO297u+h6NpamKDWRA=;
        b=ccNkaDxEEnwVgfPRv1ymbAK4XkSHYEqWEe0XgVCKkSOr7tnn1W9Ta+28VJINvfi9pi
         yfWTlwBghqkeYymi2G/Y5HOMLqrm7vcEhhLaZzBNpqjgzAaj/TZtTiu+n/6BdfLmMQn+
         8i60qQWWHai9U9c5FoJ3w5qv8smKwni78STe0qY1nWzdnKdIccSbp5/ujpbOM1n0Y3GJ
         4CmLU+nSKD+5z5LMj/Vo5dGCv9Ij4sclu1o3YQ3Hn1Vl77c5vat67Mi/WsRHES6EHdlH
         ZqvKLBr5PMyGpDF9HKCWuf+G2PTYmiIpPjed4aY2yGpaqy3Mdrkd/cQdd0e21ASgpZND
         AI0A==
X-Gm-Message-State: AOAM532u527YTaqQ7rnHLbji8lGnuyEwsQ79ZbN65Ure/Zz0t2vzyUmU
        tcBUe2cOx3+bIdt4XZoYGOeyfpep3vxNd6ki
X-Google-Smtp-Source: ABdhPJzbzLGI4uVqlWwpNhIp7DpjCK43gMMgRXBTUR5npnBwId+cSt0Oiz3QAz2Nkq2D05p1Rm/E5g==
X-Received: by 2002:a17:90a:e009:: with SMTP id u9mr9218691pjy.218.1632289145572;
        Tue, 21 Sep 2021 22:39:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm826881pjc.50.2021.09.21.22.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 22:39:05 -0700 (PDT)
Message-ID: <614ac179.1c69fb81.4251d.3499@mx.google.com>
Date:   Tue, 21 Sep 2021 22:39:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246-217-g21da330aa6db
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 79 runs,
 3 regressions (v4.14.246-217-g21da330aa6db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 79 runs, 3 regressions (v4.14.246-217-g21d=
a330aa6db)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.246-217-g21da330aa6db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.246-217-g21da330aa6db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      21da330aa6db14f0db6c57090f438542d6ff023f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614a930425212cbe0899a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-217-g21da330aa6db/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-217-g21da330aa6db/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a930425212cbe0899a=
2f4
        failing since 311 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614a8b531a92c8913299a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-217-g21da330aa6db/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-217-g21da330aa6db/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a8b531a92c8913299a=
2f7
        failing since 311 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614a90447640521cf199a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-217-g21da330aa6db/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-217-g21da330aa6db/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a90447640521cf199a=
2dd
        failing since 311 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
