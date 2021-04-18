Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E753637CC
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 23:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhDRVYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 17:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhDRVYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 17:24:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CC9C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 14:24:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso19193487pji.3
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 14:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dR/QOnFoak1KQD/7zakkqKnnDGZ/+v8ngi7SVPVKeTo=;
        b=e4plv7qQwOCjA8+7MKOqPLwguH8w5okdsPjvfj/KLyr8TcbdL+VC14Uw8hIRQ/qVVQ
         JpwAtMii6KBPyk360f9oLCF3GcrWwuDdfzez4lySzMqlgPvI+XAqIz3lmaUnb5BlFdAQ
         GEq4g04AHaWwMNBseiGrzaJm9YZ8vyyZuP6+kDQINOrEIh314lmd9dkIdmPnh/AzXu18
         n0zK7/cXLT6qT68i90EWPwJhfC1IXv8ZN6fMi81Sx1UOqz99x0knPWf9rW1sDb9H2n05
         CW2BqdbK37/Tci2ZE6WbHiSX2QE4+FHXtXYvYrcbiKyOBZi2U46itVoz5H7+wFfuH6og
         XaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dR/QOnFoak1KQD/7zakkqKnnDGZ/+v8ngi7SVPVKeTo=;
        b=mrkm+KVfHWdMZPDqgNf9gPJo61WWIUAHFi6KbVoeDFXnUNdiSnhMRGP0xErSti2WMQ
         o5Jy96A27X6LMTBt51TBgwA0Oc5/7SeUHVO2VhDbA1mz8O4dnHwWOl5RIgRPoUUyHDyh
         VPXuVtmwqd2S1pZvl1YcCDZGSG0jBCm+UZEhqTpsnvwyv3eL4t4UBXjI3FnpmLk+0v3U
         bkt1NXaP+DyM8Qu4RBAkFx8S99M+qgJrdCUWF0oFMrVYgnfCeTT+EWTXKxAgO3qJCtiC
         1Do3fWIEY1BAoS+6ACEQVspXNKgxI/yrW5NO+T+xIVZZQhmGFMFoRKIyFm+2LUh1zdj7
         RHIg==
X-Gm-Message-State: AOAM530sFd9CTYwBYfokHKeacHrBpRi9FniTnln/LzoAlCF4b1WsLFA/
        7Og1S1/2hNvOPbpwcYHceNMBv02HAR9ODHbd
X-Google-Smtp-Source: ABdhPJwf7ZhDhCy+p8lfnCS0VXEJZvmwd6F3MguWAdCPzlnGF06ltRmKOlns17US7l/CxVEUtQnm9g==
X-Received: by 2002:a17:902:e88b:b029:eb:8aff:366 with SMTP id w11-20020a170902e88bb02900eb8aff0366mr16284122plg.20.1618781043562;
        Sun, 18 Apr 2021 14:24:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v8sm10017755pfu.205.2021.04.18.14.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 14:24:03 -0700 (PDT)
Message-ID: <607ca373.1c69fb81.ba0bc.9f32@mx.google.com>
Date:   Sun, 18 Apr 2021 14:24:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.188-42-gda54c8927dbd4
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 90 runs,
 4 regressions (v4.19.188-42-gda54c8927dbd4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 90 runs, 4 regressions (v4.19.188-42-gda54=
c8927dbd4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.188-42-gda54c8927dbd4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.188-42-gda54c8927dbd4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da54c8927dbd495958a09d2ef45ca5f1afb7d037 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c67bbdfcd5431e2dac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c67bbdfcd5431e2dac=
6b7
        failing since 151 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c67b0cb2b838b89dac6e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c67b0cb2b838b89dac=
6e1
        failing since 151 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c67b086e7e44b93dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c67b086e7e44b93dac=
6bd
        failing since 151 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c67612b587cf41fdac6d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-42-gda54c8927dbd4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c67612b587cf41fdac=
6d6
        failing since 151 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
