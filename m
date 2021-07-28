Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116053D91F8
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 17:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhG1PaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 11:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbhG1PaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 11:30:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2313C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 08:30:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so10644316pjb.0
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 08:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WSSecF9RrRTM3FuVWYxvyEEr+6NHtvPfVTTgWoEu3k0=;
        b=ITZ8CK1OkS75Q6DyJkOs7mpbJqIWqkejM7uqbuZCoULHsIF92F+bEXLvySh3P3gSJx
         RLPP58nfzvFxgZasonXOuCuWKk2RCA9Px6iwg5ssPsjQpHd3hwxG//Ejd97h4Lt7and6
         ZX8KDF73oZVpvLoqtRBAnNTc8eZtuyaaNvRHzubwAAE4TRxg0+xbfWcB/KNIfkD8b4Zk
         OfXZjfzoVZGvHbL1F/mg52sTN/XYbsrWCLLDz86wdKEV+MwFcVWKHChOGGJCEWdwHDjX
         QN0FgDgaosa3fCniQACSFrDa7YBjMRvjme6MQCwlvXJEkJ/VC3gMmY7RWWgwPCU5rAWo
         owNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WSSecF9RrRTM3FuVWYxvyEEr+6NHtvPfVTTgWoEu3k0=;
        b=OYHoI65PytUplggjySTodzMvSCUF+VnOhTVUatnHr+zosN1sOnoez2GKkKe1IhSDTl
         4HiN6mt8sxCiwStii/qibuU1KWve68menEVdIs0X6vLavG3h/QYSJDGSmPerEwdzQbb3
         tKa0ZXl2O6OLHowGHgT7hu4dui1p0OfWZm06mtWED8oN957/FINnxKzMHkx97Ny0xQRT
         QKk6kwbQZZw114/fEbkgbG8tX5l/I6JgaBkKyVAtIAB+5CWhExgSZsuRDBNC2Tp4y6rE
         AIPEabIRvHVBn+/wZbYkm2vr6GaH0dfeKcfWfFpcglW4DrLN1+LSUsaH9uXwt7iShIwA
         u87A==
X-Gm-Message-State: AOAM530Ayjp46DRxrEgNxrvTmrEK5TtQ1KSm4uQB735mzV1OM0xI6Drw
        jz94s9thT1fxsRfuB4xVi5ggkuBs/1QA3Mgf
X-Google-Smtp-Source: ABdhPJxFODnxahHTMiICwLokBrMtk3LqpSflZk+ZwmeOVX+WImhBHqNVbvYqcedagVipVwCg5lwcjA==
X-Received: by 2002:a05:6a00:1307:b029:308:1e2b:a24b with SMTP id j7-20020a056a001307b02903081e2ba24bmr415669pfu.57.1627486206334;
        Wed, 28 Jul 2021 08:30:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23sm75927pgf.38.2021.07.28.08.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 08:30:06 -0700 (PDT)
Message-ID: <610177fe.1c69fb81.b28e4.047c@mx.google.com>
Date:   Wed, 28 Jul 2021 08:30:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.199
Subject: stable/linux-4.19.y baseline: 140 runs, 3 regressions (v4.19.199)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 140 runs, 3 regressions (v4.19.199)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.199/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.199
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a89b48fe9308d976d9dcb2112e264d647f7efce4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101428ab8713b06515018c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.199/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.199/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101428ab8713b0651501=
8c7
        failing since 251 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61013f4a39eefd06115018dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.199/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.199/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61013f4a39eefd0611501=
8de
        failing since 251 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61014ca7ca6304bfa05018d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.199/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.199/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61014ca7ca6304bfa0501=
8d6
        failing since 251 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
