Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972D84153D4
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 01:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbhIVXWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 19:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbhIVXWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 19:22:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9231C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 16:21:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so3525761pjb.5
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 16:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZciUvdqi08qmNz0JnD5YZNVCe7w1EP7dVorODGDGWAA=;
        b=ZsdAgTBecNqD/rTucZi3iqrZVy2vXqJzMJlAdbJ7Sx1YSw3UbG7pf+H6mAjd2aNwz7
         U5vP6xwqMnstiX9uXuYOesIFEgZqPjY9Qp7N2hkWeTIcZz1UhSvNukUXOjz0Zkft1NPJ
         xQ92tDdKTKPHjoFPQsSsiQVX2vV6sMZMztfax5ziYsnKdMYWkW0uBJndWK/GG2UTWXJ1
         9RhFMmasdr+8t/RVdK6Gfqxvb6i4GRZuiW5pYntj0ZtAZkmY71tebpt39nrmmQPxpGQB
         O9+u9pQma74qgKjkkqbpxX4zhLWua07UzZecGhxuBfvJ/YW5kKqmKAGP7Lm4D6Qyr7gN
         DdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZciUvdqi08qmNz0JnD5YZNVCe7w1EP7dVorODGDGWAA=;
        b=pi1JqCtZB5OePNwvW+xYhJ2ojtAhBTnBez+IQ1yPvax7VcnUPmQlNQSmvpqFfzKgND
         NWLKoeu0Nl7L4W17iE+RbQFxg1w3ZkZlcfHzuOmeL2KwEpU+S5KzU/lwPu7LDLGNo8FX
         6FhmsHd9pi1qrLNqc78KQfISa25sdhlNIApPxLgGCxoCNipv3WpM8yPU+I+zVaXOfnm6
         0uZlTU3SFdiDqOM5K/GUGla98Kgd+HvtCRxSNlbw1PXeAixNJKZUUHlQ5USe9agPTAf6
         P6JRhJ9X8wiantOMLBF7IZ8v38YOsLR9wicdMv3xFWMWErPlOTqTX62tmtoqcEdDmACT
         UQeg==
X-Gm-Message-State: AOAM531tA9ZR3Aqg9Lw8wsMLJeiLGqODjBOmkT1ABW5E2bC8Oy/0VJeC
        O08Ht5ku9ymRfnNbvpxBBgrQo991bHWGV4LK
X-Google-Smtp-Source: ABdhPJy8CaExrtY0EwI3Zp4sunGQ3EzAL9w/cTQDQzRraEaxFpeoqGlpTHFlKQUHTDNu3NJmKPo3KA==
X-Received: by 2002:a17:90a:130f:: with SMTP id h15mr1729988pja.183.1632352877228;
        Wed, 22 Sep 2021 16:21:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n26sm3559653pfo.19.2021.09.22.16.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 16:21:16 -0700 (PDT)
Message-ID: <614bba6c.1c69fb81.398b8.ae04@mx.google.com>
Date:   Wed, 22 Sep 2021 16:21:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.6-177-g87f5e30b4e8d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 157 runs,
 2 regressions (v5.14.6-177-g87f5e30b4e8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 157 runs, 2 regressions (v5.14.6-177-g87f5e3=
0b4e8d)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.6-177-g87f5e30b4e8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.6-177-g87f5e30b4e8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87f5e30b4e8dca87e86e3a03a8b11eb6087e9b16 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614b843ae28cad3ff199a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
77-g87f5e30b4e8d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
77-g87f5e30b4e8d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b843ae28cad3ff199a=
2e5
        failing since 1 day (last pass: v5.14.4-395-ga49a6c3da2c6, first fa=
il: v5.14.6-170-gb1e5cb6b8905) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614b84b2911b11b25a99a30c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
77-g87f5e30b4e8d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
77-g87f5e30b4e8d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b84b2911b11b25a99a=
30d
        new failure (last pass: v5.14.6-174-gc4109bf2a31f) =

 =20
