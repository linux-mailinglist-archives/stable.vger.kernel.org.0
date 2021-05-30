Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DC2394E99
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 02:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhE3AJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 20:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhE3AJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 20:09:04 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C589C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 17:07:26 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y15so6127204pfn.13
        for <stable@vger.kernel.org>; Sat, 29 May 2021 17:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OuuK3Mpm1uOy3g+z+4wM3SyRacrwNoMLR/OUD3rzScs=;
        b=JMmxMSBYwosxLsrE2Nr1zcP6MfIYr+rBpl3B44gmiS7wIaLmzHQc1bq+PJ+oyVH4HU
         NYaouLeUjT9cjb+fxc5A+/r93caAJUIPjmlMEjFG5h+APHEwPWjqtMweBRWv+lx0+xC2
         mGz4PYfNVEB1qPEFcE9dl6TOIo64bFlbSHP26gYuRQ8xKSy+YPTB5grVvmiUdtgQq4kW
         EKDYnZR5XbGR7U9GoDC9wiPBLd6MLe+sYLPtBtDcCvFI0ltu00utyl6LH7aVaIPY3znZ
         bPseO2HyNsck1SrlGzSuo5Ys0bT+lyt0+Z2rXi04ydoVkoFagC5nyMUf6fVesoMBfpLQ
         yHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OuuK3Mpm1uOy3g+z+4wM3SyRacrwNoMLR/OUD3rzScs=;
        b=mvzNHnMdCayUsdBCUIEroJIaoF40beQfMUIeYcEuK4k4TfutLm6+8Q3w2V0KCy0qql
         ghc1gztZxITimode7IOgCZgWA17EFEh/JrszwQV33SugY2vBnjQXSDplSeNUeDrAoKlf
         iWm+is0r6PaY3It6lr1uSyi76pZlDjfW0WYHRqKL2bApfrXra7C5dOyMi497JmWuyR2T
         N2qSrjYGxJuWpIijDAgSek756l8QR66lMjsQI53UOOf0TWkaE5PPbxCQcw5TOXOLP+EP
         zdkz+9bzijYeh/Zphpo6Tu91+LSyXuGZXK8ihYnQZ+h4oWNY0k+E3KeDMp/vh21ZgXyq
         h6rw==
X-Gm-Message-State: AOAM533iR1e6hWhAD+wpGtUMGz7YT0UZTHqkQ92sdLoYXRBV423FDYth
        6QnUhlmUFiyCHIC4RHwd+sqirXQqsIvVMCWp
X-Google-Smtp-Source: ABdhPJxOOBnSLc/qRk1R0A2nS8NLVTfzofJ7g7XCw4/iSHuX0rthlqwvKUf+EVggULmZ0bxnZcVMhw==
X-Received: by 2002:a65:6549:: with SMTP id a9mr15792671pgw.213.1622333245327;
        Sat, 29 May 2021 17:07:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i16sm7328581pji.30.2021.05.29.17.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 17:07:25 -0700 (PDT)
Message-ID: <60b2d73d.1c69fb81.de24d.872c@mx.google.com>
Date:   Sat, 29 May 2021 17:07:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-60-gf52448767746
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 204 runs,
 1 regressions (v5.10.40-60-gf52448767746)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 204 runs, 1 regressions (v5.10.40-60-gf52448=
767746)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-60-gf52448767746/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-60-gf52448767746
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f524487677465cf5755e4b6777ffe312e0317a2c =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b2a16ff8f1247618b3b028

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
60-gf52448767746/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
60-gf52448767746/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b2a16ff8f1247618b3b=
029
        new failure (last pass: v5.10.40-59-gdb37b08608f7) =

 =20
