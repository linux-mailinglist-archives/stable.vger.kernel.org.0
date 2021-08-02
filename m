Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F54D3DD380
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 12:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhHBKCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 06:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhHBKCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 06:02:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05812C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 03:02:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so4977338pjs.0
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 03:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gwcwiun7Y0UMbf6byQ9pExUbl6idjTSKc8EW+u4YV9g=;
        b=u4a6l2qp6rpIrFo+4rlXHssMh+k0vNe3neFJTgT7/yhCKoYn9u+7JerzLm0uxXuH0c
         rJoM7MQY/AgKlBc5GP3WKNsqKl/8FyKnbfGIxKeM+/nSxZm8wql9IhVA2s0E9GVeDt7W
         wuqqpnGh5xg29CbWiMdZF0aoGmvIDird9bdSPmXhkbW1Z8/h599T8PtcpbBpLSdw7Od/
         UsQgCWq2PT6p8vmWaRB7xdW9AoayEkUqC0aGOSx77p9kFMbILO6DjErzU/Uh5QHNjosf
         mc3n56vlx4wViZgBaPjCHFRojJ0knAHCVtRKqWeLSJuBosNvunOiU1tL6EyKW+gRa/mW
         mMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gwcwiun7Y0UMbf6byQ9pExUbl6idjTSKc8EW+u4YV9g=;
        b=s2kvQDLjaxrQrB6BnD+xNcz28yYpf7wBcrtNwCPA4HaYjL9RZne8lHJgqvIUlDZxfE
         jI9U3spFvJI4rFti2sFD2FPLJOpfvt5RRtdZZyApGR7X/tUbNkeWrS8Ww/2TgkYVY2QT
         Tnaw1skfZ5SXyOFqSj6hXWrZ4Rb+0V34UshxbiPYv0nBcvxFbc5XEVS4SGlLIA2OYPMV
         mUOwG6zVqfXGXTl1bfV8aZ7YAAz6q4vT2pyv4dBB28pRYbT/QREOHoTpxdMv2tqi4fxb
         wjczlm934VrKu9K70obthH2/knaQng9DuaduajEUX2fG9+yn0lBFNPU7aMJF99it47bZ
         8cmA==
X-Gm-Message-State: AOAM531T0ZMVjXnvK95eUQQC4lWVHdNPeRiVxTNZ+IrMTNM0rdNqA6dn
        drCdigQs1lLgmuGs4NhThuARCKJjNPLS4KFo
X-Google-Smtp-Source: ABdhPJwJ7z1YL9J5xiOSh9C1Woxl+JCcu2Uf/FX5LJwzcxt/lOyeYuZ+OlF4zRxwZIsHvuMXCVVh6A==
X-Received: by 2002:aa7:9436:0:b029:30b:30ba:5942 with SMTP id y22-20020aa794360000b029030b30ba5942mr15837683pfo.47.1627898528175;
        Mon, 02 Aug 2021 03:02:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4sm11167060pfj.42.2021.08.02.03.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 03:02:07 -0700 (PDT)
Message-ID: <6107c29f.1c69fb81.cb563.ef54@mx.google.com>
Date:   Mon, 02 Aug 2021 03:02:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.7-92-gf0aae5f0b8ef
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 194 runs,
 2 regressions (v5.13.7-92-gf0aae5f0b8ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 194 runs, 2 regressions (v5.13.7-92-gf0aae5f=
0b8ef)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.7-92-gf0aae5f0b8ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.7-92-gf0aae5f0b8ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0aae5f0b8ef225997d01500abdc41aefdfde210 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61078f22cbc8ac21f185f45b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
2-gf0aae5f0b8ef/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
2-gf0aae5f0b8ef/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61078f22cbc8ac21f185f=
45c
        failing since 4 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6107900844b92a0bf985f464

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
2-gf0aae5f0b8ef/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
2-gf0aae5f0b8ef/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107900844b92a0bf985f=
465
        failing since 3 days (last pass: v5.13.5-223-g3a7649e5ffb5, first f=
ail: v5.13.6-22-g42e97d352a41) =

 =20
