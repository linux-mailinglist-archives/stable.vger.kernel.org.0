Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592773CF499
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242375AbhGTF4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242384AbhGTF4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 01:56:04 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7539C061766
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:36:35 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 21so18752654pfp.3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kvJjLwM/lHzapiNDzpTL04C73QnI9H2h38Di4R/ZM2Y=;
        b=ViKcmDBKHB0eLReCam6E0UNwRM/IAofKZWIDsGc/rbBSCA9p+3pUDOQGCteT3e33si
         t7uVafyfuKmfw5SVKiJJlFSlBqs7Mr2dSYA51j/UHoJPIALGgMmeBZbJe5xu7LPE+l4B
         YjxjTmUuQG5PbLBXrMqnG4lPS/Oo+boGo/lTMFOC+VV8f6e9ZKkrFq2hp2npElXs5TXn
         tr83zx8mD4W/+bEN69v37XrFFonKchBOMfnRvcE7NviiN03rxNDABzPXm3fqrdpuM1Eg
         N5IUpUm6C5/EuXhd/zxqMTuOaQH0rTziU5/CTBknWTZBRrN9dhX3GVeS0ToYVI2wjWo/
         QyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kvJjLwM/lHzapiNDzpTL04C73QnI9H2h38Di4R/ZM2Y=;
        b=LmpwaKOATjGar6PP0j8ztiaX8MhtST3ETpIymK5c7Mbo0/RmAHJzJIyec1XrDhBNXC
         JqXUSr9DvtFRJI9vFcqGwYWMc68EqIFKSDDAm4Qnx3XLkQTP3HCL/e00x9EWMWG5Ry6l
         GYivSqd9oQl0NWerNPHUVlik/z64uRvkuNPkeVlOlOLBd35i2IgKQyXxvOr4Fa5if4fs
         e1T+3MT5c5r4J4pxVtQac9IOYOzw2wU8ZR0RWVwXqTlsMkrVM4xwHwssucsiM4DFKsOt
         UtuF0922PRMt6QhhE69LkPGGwCt79NOMWgda3cm0MmxiYi8GxU0mlQ5bWspBtYLh5cY7
         LcSg==
X-Gm-Message-State: AOAM530M7ahGEp6CPvA4SloB5DPtS7eUJr92t4kER8UgtfEr9+SvfY59
        Kw0+RdxFPaH3lgENMFYa18KCohEdgytiow==
X-Google-Smtp-Source: ABdhPJxDpRUsZAlqXGPvnMKksAz8RGdYooNzHWSQ0C5jPjaqAOP58l58EB7IBYdam/C42gA5ffTC9A==
X-Received: by 2002:a05:6a00:884:b029:346:8678:ce15 with SMTP id q4-20020a056a000884b02903468678ce15mr10432541pfj.75.1626762994769;
        Mon, 19 Jul 2021 23:36:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14sm1777649pjg.38.2021.07.19.23.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 23:36:34 -0700 (PDT)
Message-ID: <60f66ef2.1c69fb81.518f9.660d@mx.google.com>
Date:   Mon, 19 Jul 2021 23:36:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.239-314-g746f596c4348
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 1 regressions (v4.14.239-314-g746f596c4348)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 1 regressions (v4.14.239-314-g746f=
596c4348)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-314-g746f596c4348/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-314-g746f596c4348
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      746f596c434807e0e6b1cf59b498077be16985fd =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f651cbbec987429a11612b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-314-g746f596c4348/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-314-g746f596c4348/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f651cbbec987429a116=
12c
        failing since 140 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
