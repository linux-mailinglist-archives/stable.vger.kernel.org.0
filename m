Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B313813C1
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 00:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhENWam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 18:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhENWal (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 18:30:41 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D8C06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 15:29:30 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x188so743616pfd.7
        for <stable@vger.kernel.org>; Fri, 14 May 2021 15:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B0pkQsJ6rX/QgTtTMc+dUh+w/5Fgd2IWx6/JRGD+LDo=;
        b=mqNBJW2bRjcaOXm6pcHRpf/RZxlPxmuTILKHfrfLKOPtvG+I8FjaRcIk8nGMqWjUuR
         HfCStmqdYKvk5xJ70k4C3GcQJsevvn7rYbd5fsKAOS4KcoeOC7ewY7H4i/f4GYFCnMOZ
         bs09gGhZqDjWptYbkN53Iuks1kD+lRysOPoDzJkQK4jORS+Eb49TjZclrfYCtGAFgltR
         eFPFMdjCJC8zO3wGp1rascXUZMcvNdnoosrlQfzfYMFMYt8JTDjtLJexMd5WQteWRs3w
         zTynaEAmUvwIbJLaH4CTnJdBbo42G7+D8L12zGAbB0RaaLBnpCdRW4YHBUsYh3O5kt1O
         LX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B0pkQsJ6rX/QgTtTMc+dUh+w/5Fgd2IWx6/JRGD+LDo=;
        b=rs2aH6DxfWD/smQEQ4O5hRikgyrz2CRwdqyqZlh089EU8wQ7GgsI8ldxoJo2ud8tvz
         nBWSexFVRDF1rfVKE+8UKjQIZXyZIzkQiNmpeLkOXybQ/JWqWt0WVoQlYyXbKRBUrpJ/
         i6/Kq6v4xXlVeWMCf4tj6G46JNJEsvGuvjlDaZNBpYjikxW9YREalfbOTWBxU0AjEMTh
         CTEp8GcArqe8i8FFt1RYTSWcYbO9MrxRHacvWT7LKJov0Z0Z+cMDWAMVn77xrZ/9C+mY
         JJ5UwL2060dmn0Pf7MbGKELVr/azupKIA4wzIycg75RDAMu95uW6CHCm1l9KTNNletW3
         FYig==
X-Gm-Message-State: AOAM532zkKq2dNbgAYqPkmQ+K9NkQqUCitO5rPxHSjTWaq3lOKKxdze2
        byF0A0Y00I5C+r3fIe142EtO8i/ThvZXyFMB
X-Google-Smtp-Source: ABdhPJxH48dHQy/Ff/FqD46aruMU5NHUTduXGOo9ssKa/x88VV4wfCJWaoIlTTrPyaqavzkAFpIFOA==
X-Received: by 2002:a62:aa12:0:b029:28e:7580:8f3d with SMTP id e18-20020a62aa120000b029028e75808f3dmr48354732pff.42.1621031369455;
        Fri, 14 May 2021 15:29:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k38sm4932082pgi.73.2021.05.14.15.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 15:29:29 -0700 (PDT)
Message-ID: <609ef9c9.1c69fb81.7553c.1ce2@mx.google.com>
Date:   Fri, 14 May 2021 15:29:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-11-gd9f5252d1cac
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 133 runs,
 2 regressions (v5.12.4-11-gd9f5252d1cac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 133 runs, 2 regressions (v5.12.4-11-gd9f5252=
d1cac)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-11-gd9f5252d1cac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-11-gd9f5252d1cac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9f5252d1cac3864f27292eacfbd9f21fc1ff822 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/609ec892b7645bf6feb3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-1=
1-gd9f5252d1cac/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-1=
1-gd9f5252d1cac/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ec892b7645bf6feb3a=
fb6
        new failure (last pass: v5.12.2-1059-g6591015c57822) =

 =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/609ec7ec7941d5cd03b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-1=
1-gd9f5252d1cac/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-1=
1-gd9f5252d1cac/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ec7ec7941d5cd03b3a=
fb9
        new failure (last pass: v5.12.2-1059-g6591015c57822) =

 =20
