Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D1A42A074
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 10:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhJLJAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 05:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbhJLJAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 05:00:30 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BABCC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 01:58:29 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id o133so10793776pfg.7
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 01:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NwOWKULTlaOxrw/N3+RB1iIKbCVIss4T4LBIHvm519M=;
        b=NtvW7fa2a7OILMWj7MsJZbJKJH8bjHGxkVbGTGOtFhQoyO6M5teEKcQ3DvBRfJZxVW
         fM31EMganLLYnfSOvafVXqMZEcHvrZvsVX8Mm332MnDE1yk7uww/iewWuiqvwlhTFHWN
         yTmdUoiWG0tcFCcMYXd3V2kaO0Ku+/t5/H48ZbR0ZzcM3SXif3ODwOcJuJhve1W+pnCm
         IM9xZ0NUGerX97LN72omj/6UPbR6nvnHHlYKG5q3pXSb+mpLATWuSXf8+nGCNOs94IFm
         9vlZjQaZ4ItE4YEAETxWycGRPckcNJwjjOOAVAFWl+JMCheCpgbq+3EMbBvOFaH7DYz+
         BMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NwOWKULTlaOxrw/N3+RB1iIKbCVIss4T4LBIHvm519M=;
        b=AYax6srGh2+GdDaL+cYw3Ia0AxL2BvWC+I5h3uKds+vmNhuvBKxNXHhKy/o2bNyKyC
         X8+yAPxZJKv+gEfC6HXUn3hI/jXNexnpKEPO6v+63UnsHhiGXZXMa0czJy3lfM5bjgB6
         8bXIzjBBH9xFSuyPEZZDPOinDvsNOLDU33kCXsAaYgTwwrx8tu7peZigj+yoqyHyCg5R
         9wZVlOu9uPIqGnRNB8mHa6gWBngrqUeC7HZD9I39P77UWDMYE0EM1tS0wXdy7gJ8X6Kl
         oJpqfhPaGkBh8IPdUAeEtK7QE7tYhN/0/WmSd0fJds9YTYGZ9Y7OTc3a55GneZxopqIe
         +soQ==
X-Gm-Message-State: AOAM533Gr6+py97P/kKDgrXBKlUD4BD75A6Ual8NFhyBVlaHZAuHpYHO
        +R3evYSp+4ZgLbZfmJhE+5rJZa7Ik0kkZX93
X-Google-Smtp-Source: ABdhPJzSL9qLkfI37xIEBJ2kZYZJUYqJw7hZXeerDIfvunDcHrkGoO2fKknUQlJaMTDS9WMzdFr52g==
X-Received: by 2002:a63:7045:: with SMTP id a5mr21943379pgn.404.1634029108597;
        Tue, 12 Oct 2021 01:58:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k13sm11400242pfc.197.2021.10.12.01.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 01:58:28 -0700 (PDT)
Message-ID: <61654e34.1c69fb81.c6386.e6a4@mx.google.com>
Date:   Tue, 12 Oct 2021 01:58:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.11-152-gd98305d056b8
Subject: stable-rc/linux-5.14.y baseline: 124 runs,
 2 regressions (v5.14.11-152-gd98305d056b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 124 runs, 2 regressions (v5.14.11-152-gd98=
305d056b8)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.11-152-gd98305d056b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.11-152-gd98305d056b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d98305d056b808dd938d2ae6bfd0e3ccac00a106 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616515de5dde7007f908facc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gd98305d056b8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gd98305d056b8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616515de5dde7007f908f=
acd
        failing since 3 days (last pass: v5.14.10, first fail: v5.14.10-49-=
g24e85a19693f) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6165157a1af65ca47d08faa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gd98305d056b8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gd98305d056b8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6165157a1af65ca47d08f=
aa7
        failing since 4 days (last pass: v5.14.9-173-gd1d4d31a257c, first f=
ail: v5.14.10) =

 =20
