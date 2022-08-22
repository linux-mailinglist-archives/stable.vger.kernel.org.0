Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38FF59CBCA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 00:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbiHVWyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 18:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiHVWyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 18:54:18 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5FE2B245
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 15:54:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 20so11230954plo.10
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 15:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=IaRpDDzZXdRFwx3a6btiTeIf49iNEFtCVMGbvlHYwkQ=;
        b=dXmf0yh6oJMAOcIghrPc/vAbal5b6uiIdFYDZLquT2HUraZCqbL53xaikk1R1W6x5q
         bnOQ+z2Iy5QlwXyxoxQSx2iNMudb7UzEFaIk7DjNb0CNySvK2iPuWuyfBF1HNlgPvDxA
         7aS9DEwJH9M4wh/ko+kBaXBqdU3x9zdI/PUTc5QyQtUp/e/a6e02VA3+p07roD1dHd5k
         y3fRyJDz7pwkQU7NnsBvuoztiSastWz85bJYPcBJAWiJD6Jy+clb4fRf0VXU8IUicM1D
         TxYjjSPVHy18TLJu6betnJY/tXrB9FuH2sOCFEbq91JpVKpAuIVvMWWvb7JDHtbZyqM8
         nd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=IaRpDDzZXdRFwx3a6btiTeIf49iNEFtCVMGbvlHYwkQ=;
        b=VGGtRwJ6d+YHVNaX9s4a8RG1aooWUGP2TWkv7QUxxffKvi9DcXzMmMI1UnRjQqlGvO
         p0PX9M56drXpHo+RTsCqrt4Is5mtQKgNkT4hI9A7Ctnr/raTBdT/XYqW/ALO3caIJ1nE
         wOKYSDoWkmHe2jNHnVbkENxlyQWZsvydVusadRVso98Wj3FmxuCTIgHOJc/wWY0fYxuR
         cktKcebtQZl+RwTinFQtPMXY/kkyocXJOf1Plvq1onBVFNqmS92Rk0y/knGngDYqNVMZ
         Wpyb4Z/7KqFXrx0k2OlfgfljtBoBXy12+DX7HZNBXSKyxy/yuzDjmGs3q1xGENUpcwkE
         mrdA==
X-Gm-Message-State: ACgBeo00NUkjM5xAzpqN1yEgBdWFQbX4f91xuvB9U5KWkNKh4XvipC+r
        xD6rygA0aAm8b6jdQibRFUEwyQ0mGyB8bOJa
X-Google-Smtp-Source: AA6agR4Tl7DalmpImClAragR8d6/ddpGJjIM3kI50vmZ3jDiV1CuSWljL1kqG8W6GorkN4y8hYPDOQ==
X-Received: by 2002:a17:902:b20a:b0:172:7385:ea63 with SMTP id t10-20020a170902b20a00b001727385ea63mr22142749plr.54.1661208856826;
        Mon, 22 Aug 2022 15:54:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a5a0900b001f3e643ebbfsm10682996pjd.0.2022.08.22.15.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 15:54:16 -0700 (PDT)
Message-ID: <63040918.170a0220.db870.2e69@mx.google.com>
Date:   Mon, 22 Aug 2022 15:54:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.210-386-gc9e43ee09ae9
Subject: stable-rc/queue/5.4 baseline: 102 runs,
 1 regressions (v5.4.210-386-gc9e43ee09ae9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 102 runs, 1 regressions (v5.4.210-386-gc9e43e=
e09ae9)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.210-386-gc9e43ee09ae9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.210-386-gc9e43ee09ae9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9e43ee09ae92e4a6b365b20096604e67302b099 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6303d4136c9c4aff09355673

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-3=
86-gc9e43ee09ae9/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-3=
86-gc9e43ee09ae9/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6303d4136c9c4aff=
09355678
        new failure (last pass: v5.4.210-284-g902835a13a927)
        1 lines

    2022-08-22T19:07:44.494795  / # =

    2022-08-22T19:07:44.505122  =

    2022-08-22T19:07:44.608713  / # #
    2022-08-22T19:07:44.617150  #
    2022-08-22T19:07:44.719191  / # export SHELL=3D/bin/sh
    2022-08-22T19:07:44.729413  export SHELL=3D/bin/sh
    2022-08-22T19:07:44.831322  / # . /lava-2398635/environment
    2022-08-22T19:07:44.841048  . /lava-2398635/environment
    2022-08-22T19:07:44.942404  / # /lava-2398635/bin/lava-test-runner /lav=
a-2398635/0
    2022-08-22T19:07:44.952992  /lava-2398635/bin/lava-test-runner /lava-23=
98635/0 =

    ... (9 line(s) more)  =

 =20
