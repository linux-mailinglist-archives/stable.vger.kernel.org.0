Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34B242384
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 02:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgHLAvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 20:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgHLAvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 20:51:17 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91D8C06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 17:51:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x6so133581pgx.12
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 17:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6AGkRVxjfZAF5dT6GBRS1NTfwnUkznH47VmnR4ib/BQ=;
        b=ZoP45dWOQI3uv71Zo+sk0KXIbwv3YMJVqV9NK48DSOxJqABUFFGZCgKWh7mqU8qJzJ
         5z8BfO3Ik+8lmg3CCjmHwmgPCHxLUMASXY2WdzvOctX2oEk7J6HQoGed2JDAUTCb7OcZ
         rJjCFsdKgyRdkIFPcoDZZGgvaoLj5/1Kj3kxhNX3oDPoYVCg1uB75zD22I+rdxny13zn
         L7qU8jzonYS0DR+Vt2EvEtm1w0SBDAFpiBzHkb17PppFnj2ZnydlEs/eJBxjw55kQOqi
         9cw29J/UN/xhgDU0FSqZwinD9mNnIur1gxImYrjo4Hrtefz5tzQjHzUZpA7UyPk6qROm
         ERMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6AGkRVxjfZAF5dT6GBRS1NTfwnUkznH47VmnR4ib/BQ=;
        b=YhZ2mE/XDno5eK29aKCMa3Tc3z5e54l466ErhCxzVAf/d6+JLbMJQjY39of0Cl+rJy
         6rapxM3YX6qKuhTXeURgd71KzD31q4gfZQX0QporrdzXpN8RTE77YhoflbVefsNASwbV
         6Fg8Jri/rGccxLxkTUZkir6sxFQ2qv90K0U0mPDQ34No6837UJlnT0UxoqriXE3LKYaa
         ubJlYLquJhJSVpyWZOsBCVtNdeK2u0Fs+7qUT3y3ftaXu362AwqKU/DoUDkMmJ5NJsM9
         3tbH5xwjqzmKcfAA7xyVXMF4/GJiif6WVqZhs+i8M03hr1Z3Dv73MQ6YLBOSaaA5P04f
         yOSA==
X-Gm-Message-State: AOAM532hskEKBTE1oeryN5CM/krK1QC1V6MOCErjsYbZuW7bXI68eSAh
        nxaZpVlhr+Q1/MIy1eAUwd6V8Grye44=
X-Google-Smtp-Source: ABdhPJyt64l23HWKK3WPznuFJHBWJwTk29eyRqT/2AY90ir/xA0p6yisoGewCJzGyc4MAtyD9F3X0w==
X-Received: by 2002:a63:4181:: with SMTP id o123mr2836841pga.387.1597193476351;
        Tue, 11 Aug 2020 17:51:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r15sm284015pfq.189.2020.08.11.17.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 17:51:15 -0700 (PDT)
Message-ID: <5f333d03.1c69fb81.dcf2c.138e@mx.google.com>
Date:   Tue, 11 Aug 2020 17:51:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.58
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 189 runs, 2 regressions (v5.4.58)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 189 runs, 2 regressions (v5.4.58)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.58/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cad17feaf0d05e60f7fe3c29908f9e2d07fbb7ee =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3304665f51b908c652c1b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.58/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.58/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3304665f51b908c652c=
1ba
      failing since 122 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f3301af7afb542b5852c1ba

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.58/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.58/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3301b07afb542b=
5852c1bd
      new failure (last pass: v5.4.57-68-g133d9613b2c8)
      2 lines =20
