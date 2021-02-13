Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7AA31ADC3
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 20:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBMTYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 14:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMTYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 14:24:02 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4B8C061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:23:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e9so1526730pjj.0
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9sWRs26uVslx0HaEM/CP8guboMsiPqo2QnY1LhWC+ps=;
        b=RFHHMNVOimFRekufaUcOsg+smowf4uC0pi86D2cAbE5ex9ShffXPlyE9JOJH+GXKX3
         QuMg4U4hPxbn0p3V5XiLhkCPA1kBLZ1mrHCN3dIsreedy4eGoQJihnVwZflW5rW00s4F
         LZ4pcVlq45qVH+I/bfdr51z0O8Ue6OKAAOUrDtm7Q1AxswEHZY99bp3BYYavW3PsuH3s
         +aBBG4WoNNoO+khWWe5LaH8HKWTr5Cf6tt22AzJtGKs5LV12OJvsvGWHGwHjvFOheMmI
         3m7OvO519FlIXdG2HNirNyFu6zu4pR8Wwipsl5w8Gto3fzRyAZOVA471MBC1Yan0JlKu
         LaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9sWRs26uVslx0HaEM/CP8guboMsiPqo2QnY1LhWC+ps=;
        b=oKEctsMRMQhghfGkfSqOqlQ9YtVZt16Jy3ZsDFznF/NHfZxYU7PSxpxrilrLqrXm23
         uM+Wz9DpsGcsNjWHdX+9Z4opKk/+VT4LOpkHz2DmNstU+gCkHfCvM9Pkos7S88RXQ1mG
         1VbRkqtRsOU2JhGN/+Dm9VoHIZMi32PZ+sks4rNPD4ApWwUtO8QHvU97kHO3yi2rWRze
         8JalyZQMa3bkr3BzAutl0wWblU8BswmqYh+3Pui7f/fzZbOYTUGxEui249zSyAV2PXh2
         6ID+jAiuMVL9DH32xrffGo5H9CbtQeLRIqT4jgCBThRG2hfFFcq0p93DPptkqCDFr49w
         N+Gg==
X-Gm-Message-State: AOAM531fgJ2gfYJLPNS/5ch56wSEt883eN5shmmFaYbTmFFTMLrBH5HG
        1KmrtoZPk+AD4EovNAG1FyosyftK1IuO+g==
X-Google-Smtp-Source: ABdhPJwvqtNzZCFcNpilwVB++veWbyVRHeildJHNufzAxKbOaK8aOTZJcwHC4ReUts9XiCI+cSaqDA==
X-Received: by 2002:a17:902:8501:b029:e2:ebb4:6e77 with SMTP id bj1-20020a1709028501b02900e2ebb46e77mr7653310plb.43.1613244201596;
        Sat, 13 Feb 2021 11:23:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15sm2243188pjq.9.2021.02.13.11.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 11:23:20 -0800 (PST)
Message-ID: <60282728.1c69fb81.14e79.3c94@mx.google.com>
Date:   Sat, 13 Feb 2021 11:23:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 56 runs, 3 regressions (v4.9.257)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 56 runs, 3 regressions (v4.9.257)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
meson-gxbb-p200    | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =

panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      282aeb477a10d09cc5c4d73c54bb996964723f96 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
meson-gxbb-p200    | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6024699b84a41870753abe8e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6024699b84a41870753ab=
e8f
        new failure (last pass: v4.9.257-19-gb6978209a21b) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60246a37aadb5ea56f3abe82

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60246a37aadb5ea=
56f3abe89
        failing since 1 day (last pass: v4.9.256, first fail: v4.9.256-44-g=
cffa06cb070f)
        2 lines

    2021-02-13 15:49:53.028000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/602468b57fe1c539f53abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602468b57fe1c539f53ab=
e63
        failing since 84 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
