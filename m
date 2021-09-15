Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E5F40BD0E
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 03:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhIOBTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 21:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhIOBTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 21:19:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F69CC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 18:18:16 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id n18so1014213pgm.12
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 18:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fw209NUsrlgAeO5XIMy5AJpzkZzYEBloN53kAgHPzbM=;
        b=XpWBrjOrrRlNbsA2uBssieQGwcwffom/Pb4lZ6SeCqWlOCoppjCV2uswgNtvwniCwU
         nu0PQEogkGKPr7oG55emcw70Y1wWNbDdY6bpLkR/FOZq4e1GuDUp6DVAY8+PdWLkiFf8
         +Gepb8cc4FV05tXFDxFT/10+jzkMj2BX+WO4IsZwTssVvebrs9pzo1rp4B5x8ZT7A1SG
         pzB9TgFwAz3kSuQ7HS+b0f9mFvqe9+01SExvK0wiZBmGwzfjDCJiSByT69+O+toDgRqB
         KhALDoSb9W3I8kmF/MiCrET7Nyn7FR1iWEm6r6gtjsXO7A2tSL84rZk7jdxqtX+AkYb1
         gtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fw209NUsrlgAeO5XIMy5AJpzkZzYEBloN53kAgHPzbM=;
        b=t6Vfu+FfW5n2uoFu/c2gJTKqbwQWIdkE6c/UVzjEv4sPnA3DI3854fW0XZPJ6uzWOr
         kQjm5MSR83FPUm1WPgj00qQlyiuBFMYt+Vb1dLS8feh3z1FF3CMQAKNU+5cs4I05+8rt
         zi61wuCJ0q9yztRZe7pN4fvydhaxUgKJz2pKI+FzMtLlL6sT2p0lynK/tDfTB/40UjUk
         MHnzFaA/fqKnQAuH8ozUHVjRwjuhVaHKU9pURoFuQjiKcCnEeLL9AiUJY+g/inPGvv+A
         bNMfR9YENZaXu5PwDJS0rtwevyGMx8m5aOp5T8NRWl5CLz2n27drfpO5O5B0CmYKiSXh
         TP/Q==
X-Gm-Message-State: AOAM531LABUjA4d5zINV/HQ1v6/kjMuCHIJcAZUOtDqzvwn0UW+6l/GE
        TssFO6q0ewFNBS4FXxfRB7fDgLi7DL3j8LQU
X-Google-Smtp-Source: ABdhPJyin5E6nHlmJjv6XEYccyb8XDso4ZRUf5AomunncvUJCVUyCOYYROGX8ue8XfYfU/46AgiRyw==
X-Received: by 2002:a63:595f:: with SMTP id j31mr17826360pgm.109.1631668695667;
        Tue, 14 Sep 2021 18:18:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v23sm11175168pff.155.2021.09.14.18.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 18:18:15 -0700 (PDT)
Message-ID: <614149d7.1c69fb81.8636e.2199@mx.google.com>
Date:   Tue, 14 Sep 2021 18:18:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.64-236-g18f8c8a12e33
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 3 regressions (v5.10.64-236-g18f8c8a12e33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 191 runs, 3 regressions (v5.10.64-236-g18f8c=
8a12e33)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.64-236-g18f8c8a12e33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.64-236-g18f8c8a12e33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18f8c8a12e33b63089416b0e919c60ee22193ad2 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61411b71e39202216199a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g18f8c8a12e33/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g18f8c8a12e33/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61411b71e39202216199a=
2ef
        failing since 75 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61411aa9cd5b077e2299a31a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g18f8c8a12e33/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g18f8c8a12e33/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61411aa9cd5b077e2299a=
31b
        new failure (last pass: v5.10.64-214-g93e17c2075d7) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/614119ebc8ebcef8a299a315

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g18f8c8a12e33/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g18f8c8a12e33/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614119ebc8ebcef8a299a=
316
        failing since 1 day (last pass: v5.10.63-26-gfb6b5e198aab, first fa=
il: v5.10.64-214-g93e17c2075d7) =

 =20
