Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E447B309814
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 20:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhA3Tog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 14:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3Tog (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 14:44:36 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCF6C061573
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 11:43:56 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o63so9156009pgo.6
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 11:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yFRqW+dFjgC4Rk8q9ftf12TEPNk/YKZfGhjQmGXsmY0=;
        b=ru9oLbPjsKvOM/iXwAiku7UuIJpoqjbluTDe40/3snwf2YgJCAmnf3Gm6qRX/HRZZM
         R8Ql2zBUo4EmBNuB9h7Wdb/AU7kx4OEfOsM9Ya1beRKNtIrDLZofmfdsjrbvTwHbYdKB
         i2NUKAri/b+ojo0uz1syGrzGD0wRDHrxEO0wz84vqGC60fpJn2UUu7XwrTVSh6s8sJ0u
         qmfr0TP/oI0XT10J+Im7b3ULVgdiMcFP9COnq/ED2hZja1ZXQrpJEdWx5EcQBv3XY2ur
         2Ux6I64cvI6qfAyD6uIBFPVn8PqRAeTxFaZAluFsabeokkV+7cfH96GF0amQRjAPCPyk
         uPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yFRqW+dFjgC4Rk8q9ftf12TEPNk/YKZfGhjQmGXsmY0=;
        b=EMYF2qZpW6WdBYSMkYlan034cCVXIcjmP2WuwgA+IUGUyB7RE2XrHZfoYynFeur4zv
         AEWQ0oWrAUCwaattS37ZkcvowCxKoNLXNQXwv/DM35mBtV7yyPiQ+tBDWh3exO7zoEDE
         uMQ5rZAglfPE+Kab1ZQRhJ2WtKgAYULfxL0XV/pIL+k17zrIv/xGl5G5fwoUKcOGcgQL
         ZVTVVrUcGautUPJ4CfcQkFsIjN7ET++IMDzg01L4WFiNc+t5yVcriBbtXD1xb88P9TWw
         JPmqNwpYslzX2OcgYy7juo5ZWSQZ3pZSncyIOifhZdBj2VgMC6P4mwDlJqXTwJsDun69
         Gavg==
X-Gm-Message-State: AOAM532/v1MPSGZVAJ4bcUij1pYH7jGFh3DWXcTAiak+RqTdsP1GCVgM
        L0cEHVSXPEVw5KZugqEboYz2mztY6GtcYQ==
X-Google-Smtp-Source: ABdhPJy6TB37m1TI5tU7PAACz8hFwGX6cXBJKLgnDyqOmPNrvr6p87URF0DbYQVD02Aggan+EoXmmQ==
X-Received: by 2002:a63:c10f:: with SMTP id w15mr9716732pgf.99.1612035835159;
        Sat, 30 Jan 2021 11:43:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7sm12945646pfh.147.2021.01.30.11.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 11:43:54 -0800 (PST)
Message-ID: <6015b6fa.1c69fb81.7b990.f70c@mx.google.com>
Date:   Sat, 30 Jan 2021 11:43:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.254
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 106 runs, 4 regressions (v4.9.254)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 106 runs, 4 regressions (v4.9.254)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.254/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.254
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8020355f44545d6e69179d49d317130132a121cb =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60157af4b5788894b2d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60157af4b5788894b2d3d=
fca
        failing since 77 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60157b1c8b2223d980d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60157b1c8b2223d980d3d=
fca
        failing since 77 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60157b090dd9989934d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60157b090dd9989934d3d=
fca
        failing since 77 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60157aa6b521cc5118d3dfef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254/a=
rm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60157aa7b521cc5118d3d=
ff0
        failing since 77 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
