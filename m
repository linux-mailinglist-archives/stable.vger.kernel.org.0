Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4625E31C539
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 03:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhBPCDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 21:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBPCDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 21:03:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6804FC061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 18:03:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e9so5002017pjj.0
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 18:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b8F3BdjYpb32oR1lRlylJglonbiEltp0bbkIydo8c94=;
        b=DcADsVz+TjJf4nC0NtaF6fFWgegSzTUBFV3JkVZUQ3/CKvpQ6K5K1tk/11x18xqwh2
         og1shKyHzavohHkF7nfATeXgzSfj5uoQoPnuIvX38+sF9UzmXx1Rqrj9CjA/5tqAYGV8
         oZ6VRyJH8Q3MJIVmcwRrbyXpVZ9LX2rPE6uQkmWvtgmXGft8up1End7DH+47HsSgL+Zd
         yiKoMhUiBsY5bRXT2o7FzS3ExWocePB8NUWrU6b510OMVjzUWZmHOq0PGzinSPMftAzq
         wMrndwxYuZg6ZFKcQdRgz2VliK98MUsYficSz3eJv9scfAozHaGPmVSH6cIxLYq3kkZJ
         M6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b8F3BdjYpb32oR1lRlylJglonbiEltp0bbkIydo8c94=;
        b=qHKMMLMMYufXOg9BAo8CNrmM6Il2pN7PVLgX6bVK5ald9FrGjkUESmdd+DB+oJ3sJT
         a9rA/hxPi5yytLYDqnGELvQy1SCmtVuMecpLCtgEy8wqOzNu+zZ2FlXpM8AHATidPFPl
         wg3Qv4oGZPsLgqVpie6+s5n3TVMLmq71v+T4t2hK+7NYuClOxGgMoWiJtLZ4secWSGwP
         xCoxo0F/nja4WRNhiVNFZmnp4dTwn39MSafSJM4lnzawi2W57uUqPk6m7SGrQVxpf7jd
         BhAT29GKS1dsviG9jUhmqhfajBAv4HnvjxtCfOPYxjc/8D73b+rBKm4XlnPmFSANvHjm
         j4wg==
X-Gm-Message-State: AOAM531PnqpLwP3Gaxq0pOg1hc5TwVfUxnfQv3hKKgJXwty3buF3mo2Q
        14T9U8MOt8lvr/KfUGJEOqqTB0TSjtTaBQ==
X-Google-Smtp-Source: ABdhPJz5ET/DdVzYqu+Meb/tYuzHY4UoyBK3FQ+41xnY/jLug8o16jA9jlmkPsLke4e9bxzK3vFGxA==
X-Received: by 2002:a17:90b:1090:: with SMTP id gj16mr1662812pjb.63.1613440986616;
        Mon, 15 Feb 2021 18:03:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 202sm20079307pfv.89.2021.02.15.18.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 18:03:06 -0800 (PST)
Message-ID: <602b27da.1c69fb81.9e944.ad8f@mx.google.com>
Date:   Mon, 15 Feb 2021 18:03:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.98-60-g5fea8afedb8f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 89 runs,
 3 regressions (v5.4.98-60-g5fea8afedb8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 89 runs, 3 regressions (v5.4.98-60-g5fea8afed=
b8f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98-60-g5fea8afedb8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98-60-g5fea8afedb8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fea8afedb8fd41f17957e07a3ff5b5d0e77b7b5 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602af2ef706060e89daddcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g5fea8afedb8f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g5fea8afedb8f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602af2ef706060e89dadd=
cb9
        failing since 87 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/602af4d144e0d1602aaddcb1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g5fea8afedb8f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g5fea8afedb8f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/602af4d144e0d16=
02aaddcb5
        new failure (last pass: v5.4.98-25-g5c3d6f8d21fc)
        21 lines

    2021-02-15 22:25:06.249000+00:00  :alert :   ESR =3D 0x96000006
    2021-02-15 22:25:06.250000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2021-02-15 22:25:06.250000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-02-15 22:25:06.250000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-02-15 22:25:06.250000+00:00  kern  :alert : Data abort info:
    2021-02-15 22:25:06.250000+00:00  kern  :a<8>[   16.289128] <LAVA_SIGNA=
L_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-02-15 22:25:06.250000+00:00  lert :   ISV <8>[   16.298320] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 728668_1.5.2.4.1>
    2021-02-15 22:25:06.251000+00:00  =3D 0, ISS =3D 0x00000006   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602af4d144e0d16=
02aaddcb6
        new failure (last pass: v5.4.98-25-g5c3d6f8d21fc)
        4 lines =

 =20
