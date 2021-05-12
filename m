Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1337C18B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhELPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhELO7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 10:59:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF42C061345
        for <stable@vger.kernel.org>; Wed, 12 May 2021 07:55:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b15so6472708plh.10
        for <stable@vger.kernel.org>; Wed, 12 May 2021 07:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jyCAB3WsMvRTLQfLIATeSyi27GyOw976+tKFJGqMIsI=;
        b=0YAv560ZhxXrl/V8e0N4hjLsUxPn+EBvJERkY4i0ZhEN1a9Jtz2yURw9kuNtIQ/wuj
         Kixnx6FPY4ApY8oEHIxRym5mbTbFC1jc9oa/7Khfz2+QtBsnutfMQqgc9XIDAe6JmBKE
         /Pn1+6S+on4BlC4TIfibvRow7kuxluQ0+bgH4ceNeYir+BVJlAzXn0OjYL0V+dREN3fU
         tr3HaPCQ41+OXuKQ//7BMK1vLidytPShFlrZdZaqOf1nbGbJWHFqXeypW436E6RQcvjj
         1CuUYsrbv4iLqhR/OCEB4DbYRx0muM5weeILl/mG2YVu0+vlwpE6/EtptYTY2wXGM8AH
         f9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jyCAB3WsMvRTLQfLIATeSyi27GyOw976+tKFJGqMIsI=;
        b=dzWGn9fwxuboI30bj6GKrni1BYWajRyTWkRDYegkAcyIbP4xFnqENZYdaYE8Q7kJNR
         Fe+zHZ7efZj/jG5D5q8QnEqmX+CN9rdlFi0/c3LyTDPMksEMlz5yA1m0ZpXeZoSI6nbM
         WsCn1qUJf17dwEvMQQ8DioAFNN+POrlDHbZPj9RPLqyx7hDU22yR8178azRRGXjYx2k6
         Vkd9beR1mrWrov5C0Zv5AbHJNF7Vl5cvrE40N01bJdHgU3TnYQaXIs2/QjW44dMV9Qay
         jG8IH8VvZTwOslUDPaef7IxZPsDIPvkCgOwiVekd8hyg6ZDnFptjwlWchZA+vGySgMNN
         fwSQ==
X-Gm-Message-State: AOAM5317sDmhzVkCjkti4IM9ZouHh5S9hImdLolH2MBOXrnCEJLJOzva
        LcGr5f7VRyFxn+5wNhs3lsC378gCsvVa1kmX
X-Google-Smtp-Source: ABdhPJyCdH+yJCkc0WqB3yuPTDTwTfh+nu54lPP4caz96ob/6g3Lcy4S2/rvqHHBGHizmFRAM0iWNQ==
X-Received: by 2002:a17:902:9a01:b029:ef:11d:4b77 with SMTP id v1-20020a1709029a01b02900ef011d4b77mr31851313plp.51.1620831335270;
        Wed, 12 May 2021 07:55:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u129sm151345pfb.8.2021.05.12.07.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:55:34 -0700 (PDT)
Message-ID: <609bec66.1c69fb81.ea44.0749@mx.google.com>
Date:   Wed, 12 May 2021 07:55:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.2-489-gf332a5e050fed
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 180 runs,
 2 regressions (v5.12.2-489-gf332a5e050fed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 180 runs, 2 regressions (v5.12.2-489-gf332a5=
e050fed)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-489-gf332a5e050fed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-489-gf332a5e050fed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f332a5e050feda515df399ab005aded5c42a65a1 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/609bbbf3080366753fd08f32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-4=
89-gf332a5e050fed/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-4=
89-gf332a5e050fed/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bbbf3080366753fd08=
f33
        failing since 0 day (last pass: v5.12.2-383-g508b08e40956, first fa=
il: v5.12.2-383-g4da1b11242f4e) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/609bc9ac1b6b4f6872d08f93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-4=
89-gf332a5e050fed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-4=
89-gf332a5e050fed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bc9ac1b6b4f6872d08=
f94
        new failure (last pass: v5.12.2-383-g4da1b11242f4e) =

 =20
