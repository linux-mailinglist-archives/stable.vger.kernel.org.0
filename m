Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415202AE556
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 02:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgKKBLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 20:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732023AbgKKBLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 20:11:15 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EC9C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 17:11:14 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r10so267474pgb.10
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 17:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0neYHzbD9tPjdOIWUbeYxNg2OA6gxG2BkdxuYioCfWc=;
        b=tKFT9ej+U4gnhsMIypz072rzX2e3epWHttdxEWOAuR0w+vQkWQy2Jy84gITX1nDUz8
         bZuZcdzKG8LLQ+dfAob4q8r0gT2rakgH/kbcHGqwG34ekt1u7v2cj4w2qSbAKnGoJteN
         /xE0ov4QmZSVFFwdW7JlTuCZKVHP6nOv+Xk9nx3qYQ56u/3hXJ9IZMgaWcOoRJcUdaGC
         1NGylDeIq1sQp5ijERZsOqEHo1Vx4/LbBvMUZRbZ6b2dMxuj+GhD21kpTWuX04yO5qlh
         Dqg1h5DHV2r9kM8DfiM+KUzfePZvp0z3AOzQM0ODOVseIaAKNg36GDuJd5VTubeYv/eR
         gMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0neYHzbD9tPjdOIWUbeYxNg2OA6gxG2BkdxuYioCfWc=;
        b=R4euEg+gcETwxOtctRAiL1Vt0qus9SId5y+TkAEZWMBpgGVuJNih6WlbxtZs3/Pfv0
         ZEU5sJcfyYWJoyXCaIUqwijR1sTbYJvUnDDKWljdNtoT6/nMroL4PHwEG5pWTsqC+Oda
         mOM/BGbZ6AkHGFQM/VzMsoqZza7GfPU9Y/ZiuEL+/9cC/MfHTr2t6plJl7VWrC8ChZzs
         3DKgcvlUfQbr213Y9iHrPy96008b4n83gE8w7RVNqODy8lbTA6AV0f2LJNX6ukuc2Z7q
         wdMB1oVHmDqP79Wc2iRQgdUAO6BTndvgHsqmFtW0A7S93HYVT+nWc/7tXaExZ++areCb
         jLfA==
X-Gm-Message-State: AOAM533VngpCuAdlAGD7ndX1jWDsuPhLDoo+lyQd6ZvFuViD8Y0Hsd4w
        3S97x9Ej8l1yM1qvF5gYfjdqwCiFRjl1HQ==
X-Google-Smtp-Source: ABdhPJzbFHq4eVbpVONt+n7pnkfO8dYo7oOPKuRKgEJwFhgWG6Z6/ckC/KTYc7SFqE/IwqT9YHsgWg==
X-Received: by 2002:a63:ff10:: with SMTP id k16mr7865942pgi.328.1605057074045;
        Tue, 10 Nov 2020 17:11:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k26sm356321pfg.8.2020.11.10.17.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 17:11:13 -0800 (PST)
Message-ID: <5fab3a31.1c69fb81.7a49d.17ba@mx.google.com>
Date:   Tue, 10 Nov 2020 17:11:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.206
Subject: stable-rc/linux-4.14.y baseline: 158 runs, 2 regressions (v4.14.206)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 158 runs, 2 regressions (v4.14.206)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.206/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.206
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      27ce4f2a6817e38ca74c643d47a96359f6cc0c1c =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fab04c616e2748d97db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab04c616e2748d97db8=
854
        failing since 224 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fab0317a373496811db887b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab0317a373496=
811db8880
        new failure (last pass: v4.14.205)
        2 lines =

 =20
