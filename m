Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00103838AB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbhEQP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344747AbhEQPy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:54:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C30C08C5D4
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:40:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so3832176pjv.1
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B9ZBWzWhh7CJhMcWxx1m72iUyKDRYntps48dOZLx/cA=;
        b=kyPn+grmIv+EtljMKF7pyof/3PSqumRR/m25QaMHaAODAQ3u9USyTKxokIug5E0vBi
         5FgstfczQMRK8it+sJwEdZ2QcHfJDvMjqPq1EPKofxwXv4kiKTAnY4uELRKbF6rYqJ90
         lg26xdcT0ZxY3Wg6RArnP2vFligFatAVJF1htBa2a7f4dDH6JIXkFQ2qT2TCs3nUm5B7
         VUjSzGw2wH0F+2l5MnAWmbGotPQj9uXpygL6TqUJME7ZOQzQP/FUyjkUf5es85u+YjT7
         hV0FkVER/YJWI0p2/68TzHPy5fDRcawXvlgxqA50UsunupINweuWIZiIMnMvx3DHbEip
         +6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B9ZBWzWhh7CJhMcWxx1m72iUyKDRYntps48dOZLx/cA=;
        b=Y3zeDxIgeY5NqYMk3a8Gh7tNQWg1QNqI5h2W9zxu+hsBWlq4rf/MwKOuLrZWlOuEw4
         LrwHE1cpFlXdepGpZAjUm3M7m2eEW0XdnvwsBpzng21IwTp+2Sv3NMZ8js8E55yB2TWb
         Q0jgtI7+Nv6Yds7BlItuoJAo5KJsAeOg3gpLqpMtPWK4ic+1qfhnxVdaAu5bvOhbvX+0
         7L+JUocfBGpjTLTXcfBwhhT/zod05Jv23otWd0kqzeTkq6I507WcLAJ1nz6SNMXrna/g
         Zrpb4NqMoCqZ3AqHma+O5CYqm9HRdQ3eS7A1vMJPcjT5R9lIL3SNHKIbh/47umVyFe4u
         Ep9A==
X-Gm-Message-State: AOAM530syc2rSY8Ob8q/87+Q19u5hX7mqxBBlMS/GgMqnWnGamy+ZM64
        83MgtECQkBeO5sntHNXN3mNbLpArZblXTIsq
X-Google-Smtp-Source: ABdhPJx2J0BdbPJ+rf31OAa+viTqUEFuu2NqQnWXCfFKusr7SwDebRIfKCKTizGuwzYvbTUs+hSntQ==
X-Received: by 2002:a17:902:7e4e:b029:f0:d949:8ab3 with SMTP id a14-20020a1709027e4eb02900f0d9498ab3mr348948pln.40.1621262433439;
        Mon, 17 May 2021 07:40:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n21sm2680096pfu.99.2021.05.17.07.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:40:33 -0700 (PDT)
Message-ID: <60a28061.1c69fb81.a119d.7b6f@mx.google.com>
Date:   Mon, 17 May 2021 07:40:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-385-g23e4aabd94bb
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 3 regressions (v4.19.190-385-g23e4aabd94bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 3 regressions (v4.19.190-385-g23e4=
aabd94bb)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-385-g23e4aabd94bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-385-g23e4aabd94bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23e4aabd94bb811d53db02db9a6e4dd2163aba6a =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a24ba9c041e51c21b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-385-g23e4aabd94bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-385-g23e4aabd94bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24ba9c041e51c21b3a=
fae
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a24baf00ff5158d4b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-385-g23e4aabd94bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-385-g23e4aabd94bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24baf00ff5158d4b3a=
f9d
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a24ba6e71b71fc38b3afdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-385-g23e4aabd94bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-385-g23e4aabd94bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24ba6e71b71fc38b3a=
fdc
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
