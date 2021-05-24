Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6135338E7A9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhEXNcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 09:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhEXNcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 09:32:05 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F090C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:30:35 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so9405828plf.7
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1Z4BiESzWRfIpTSIxcoGzL5fLYTLOT/Ia4vrrjdl/Fc=;
        b=ztIQo7RJ2jD0HFqTkNZwEOxVZRWEJ2yDK6n+9KH6ir1FeyPPNYzAanoUz+VrqCFngW
         r10f+mq9KCu5CLyAwn/KunS28qA4mCnN93j6450In5tCKSWlTfQ4FSegSjTTbupBwVmE
         7ZAi4v57r62YmdgJSOixrrR5ETT7UloRuxGsHu9++B4ulURNZJnKyhzEpqF1e09tztsB
         wbu+DphO/mL6Lo4rH3R3aCO5jrrgd70C1mlVDfMoDKGSw5afU82Zd3F0YjXRcX0Fp3N4
         VeIlG8dMoR2+2+fvfT7TIGNho53VpUhIvPLxAoFKzIQ5+PBe39ukiiZrz4bVJzLCXPxC
         m5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1Z4BiESzWRfIpTSIxcoGzL5fLYTLOT/Ia4vrrjdl/Fc=;
        b=Ia8tddD+mmfpJkafU7ZevyTRX/5spYr/6MrgWm8+qAeWnWQ9UTHxkVPbERRwufz6zv
         2BThFts49vpyVb+ZcVFYESNf6FKeR0YQ/VZBghLb4etF9e+QjNwvvooui8bE7UMmB/4A
         vQoLP3SDflli34Wc+XjWcHr2UqIddOcQDPfLlVt/dbqbLJV1IHYf1uuDpvoBLchn8IVY
         IAjknyUh/skw/9FtfFfsHhU+VlwHXsUp7vMNcFSnxR60DTlBP3912e96ylFLHYG1YESC
         0YHtj0SMkE30C4wQoRSrAXm7bzFUvg4FN8D45diHcX9ack+lxtmBSHu4c81Yr3F30LlZ
         sBCA==
X-Gm-Message-State: AOAM532SgmiwWK+Dm3UfJND2o7cqP9mlIRkqqRWrx7+5coNmc0YCyglq
        M98oY+QhfdkLlxpKsJgrGMNQdiqGXXtDE3dM
X-Google-Smtp-Source: ABdhPJynN0nIzx7984b847/JiAQD670YN4iV10ynvbfz8g5khAn/3VBV0VEugEhb/xWcryHkgs04bg==
X-Received: by 2002:a17:90a:4493:: with SMTP id t19mr24786387pjg.217.1621863034639;
        Mon, 24 May 2021 06:30:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k9sm11771598pgq.27.2021.05.24.06.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:30:34 -0700 (PDT)
Message-ID: <60abaa7a.1c69fb81.3466e.6d24@mx.google.com>
Date:   Mon, 24 May 2021 06:30:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 77 runs, 4 regressions (v4.9.269)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 77 runs, 4 regressions (v4.9.269)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.269/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.269
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      265f4a0e42465aaa5b8409d846b2a34a923b8938 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab78bd7ebed6a821b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab78bd7ebed6a821b3a=
f98
        failing since 190 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab79c47dab0c92ceb3afc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab79c47dab0c92ceb3a=
fc5
        failing since 190 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab7e55907162f052b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab7e55907162f052b3a=
f98
        failing since 190 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab761822a50c2ceab3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab761822a50c2ceab3a=
f9f
        failing since 187 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
