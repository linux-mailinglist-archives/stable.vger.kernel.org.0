Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA72C32D606
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhCDPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhCDPGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:06:47 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA3C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 07:06:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l18so7186755pji.3
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 07:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GMue6RQyO5x/sLLG3x6rX50XIiG+bNflTJE8bFiZwl0=;
        b=dNZX4oGyDR2gDZJueY7ptnPIEZDE23gfFiQ+JK8XlcRMpJJRfU9g4Wta6mLlqORgZ5
         /CC7e57kEgGZIfbK+57QczEixOM3nDAHFcXiBG1p0hBig122UZirVF65lfGxA2u1OrDo
         g9vTMyrftRAkRy6Edn6kKA8CjxSK/aO1fxE3OxSOCErhCsq6PuR0JMB1qTSb150895FV
         P5lIRGv5mb2lh8yUCk5hl20nGEnnxmlOwzKTmdL3/xNJxmYQmfV1LAqHCMV2YNfOi2jP
         Jymi+S6Iwa3Wczsu6wsYEdfe7Foed6QKLaPJYAAhWZUftZ5mKjRqjMlOpsNW9xifcEwZ
         ZaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GMue6RQyO5x/sLLG3x6rX50XIiG+bNflTJE8bFiZwl0=;
        b=CU/CVkd8HCBk1/UPCxRVqANO9ROQDh9Ndig419ihW1AvTpAuR6/sVBeSCeOx6g9J0C
         BLU8nxwVSt29cU7k+AuflBk4AIryUGRDwnldguQo1JJh28zgwPJB4i98cHMtriJxMWuc
         uOMoPi4cLFv2JnUvZy14h9VXCXbWwV3hb1CSrBikHcYkhGCXk+apUzxr6LbpdPfIQHPr
         6MO8GlM2aglln4uRdUkk0SJGFnuqmPLB43Ioj0hnZjvnG+s4Lf8LlJbr9deaAtXc80h8
         L406sMvhNef7XDlGHHQPpRjYLFASwDar8RFNwAbJ4mFmtDvj65mhZC6OzloVWZwWWV/z
         9Qzg==
X-Gm-Message-State: AOAM533UPLeLBBvgwLNZqOuRmI3cBcvDZATXcoF44x8ThwUlRudg7eHb
        b6+YubhYFwWXyhmwbUMUiMAYZldBvBfvT3uM
X-Google-Smtp-Source: ABdhPJwHogOQfCrbMza4lwVYkWCAovh01ef2uJ6MBC/1bQ4ZuaDG+LwOxGBZpHFZmNMDaDDk75q56Q==
X-Received: by 2002:a17:902:344:b029:e4:a7ab:2e55 with SMTP id 62-20020a1709020344b02900e4a7ab2e55mr4507314pld.63.1614870364832;
        Thu, 04 Mar 2021 07:06:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w202sm31644120pff.198.2021.03.04.07.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 07:06:04 -0800 (PST)
Message-ID: <6040f75c.1c69fb81.6ff98.71a0@mx.google.com>
Date:   Thu, 04 Mar 2021 07:06:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 169 runs, 4 regressions (v5.4.102)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 169 runs, 4 regressions (v5.4.102)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.102/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.102
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7f324ea75baa059ea126cddd4141198895880a69 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040c36b7a4a44c987addcf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040c36b7a4a44c987add=
cf3
        failing since 105 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040bf5634eb48a887addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040bf5634eb48a887add=
cbb
        failing since 105 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040befff01eb0284daddcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040befff01eb0284dadd=
cc5
        failing since 105 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040bef7f01eb0284daddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.102/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040bef7f01eb0284dadd=
cb2
        failing since 105 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
