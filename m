Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908E237707A
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 09:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhEHHz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 03:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhEHHz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 03:55:29 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEDBC061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 00:54:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i190so9464174pfc.12
        for <stable@vger.kernel.org>; Sat, 08 May 2021 00:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VwqWXq8DETeV67PpornNJKCWBlIx5F/AAGRip+T/PCI=;
        b=sbLXYOn7H9zELU0+ZklI9LFWmjDTXpOw3Qga2d1sT2pJChVENCgeGTfjnn9NpJd/pk
         psbiciNX7WDh4dfXhfEd4eJv8u61YsDhp9dhUN85T+dazPTmV1U0lTGxSgHCkDxqbufq
         AHBVKs7a0HHadzN74Sx1+hUd1zf4rP0Xra0k8umoF6Ajg1Dj/U3ITu5c6XdIPyAOMync
         IH1LPHDAVih+OxgWVxyu9eNAaNvunL+D3p1GGr35wKRXRwZsFJMmhswR//ZfIjS/rKi0
         GgAOnsQFNUcb9ZDVFMC0vANEucN2PPyAjlqY6zRmkKCiA+xT08V5IU9qV7TU5cYy789U
         lwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VwqWXq8DETeV67PpornNJKCWBlIx5F/AAGRip+T/PCI=;
        b=ZuqwbGebkQfVaJ6WhbTAMHi9ac0gg9JSlVu4EIMJlE0k94qR3JLnmmBd+mwU8hJXW2
         dwnsRHggiQRTKdVgO+8cHFanSOhnUwGAB/L/Xtu3TD73PBgl4DJroDy4tx5OLRpzSTYM
         eJp7Ku0zmyLobKaF0MYISzteWrW1hKPtzusR4Vlxg1INvqwZZtIgW+82h1PpPkcyFqJ6
         npHkOT78plcMYpvItXxdgTXE4J3X/ATuLofWRLfiUincfb2J+8hJpnXCJCKuUPwJ1hZG
         p9jrsEiKUUGw+rmqrgVtxwheHsw1Ecjc/KcFn6nCOe3tK2TsiGOLMcL+jPQQSALIgiwN
         /qUQ==
X-Gm-Message-State: AOAM532nwAjiiFFXslgXdFilo/3l2depEjWIb5ddkE5Ue5JfTn9OFbql
        YNLPCDg3GPoojP2w20/2dvxWRAR1kTUs2Eeh
X-Google-Smtp-Source: ABdhPJzfIWcrlraJikIgnLdEKrZSdOJ9Pie6EGC7abW72Xgd13z0cD36R+PV1//xskkg9g3synlUSA==
X-Received: by 2002:a62:16d2:0:b029:27f:3dbf:a466 with SMTP id 201-20020a6216d20000b029027f3dbfa466mr14266233pfw.11.1620460467904;
        Sat, 08 May 2021 00:54:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm6261512pgv.48.2021.05.08.00.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 00:54:27 -0700 (PDT)
Message-ID: <609643b3.1c69fb81.5f1d8.3c5f@mx.google.com>
Date:   Sat, 08 May 2021 00:54:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-273-ga7ae441f5332c
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 147 runs,
 2 regressions (v5.12.2-273-ga7ae441f5332c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 147 runs, 2 regressions (v5.12.2-273-ga7ae44=
1f5332c)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-273-ga7ae441f5332c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-273-ga7ae441f5332c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7ae441f5332c43950e20f13a7360e9adaf7b253 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60960ef37996cb83446f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
73-ga7ae441f5332c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
73-ga7ae441f5332c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60960ef37996cb83446f5=
46a
        new failure (last pass: v5.12.2-67-g20acef25b911d) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60961277c0320f8fa46f5491

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
73-ga7ae441f5332c/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
73-ga7ae441f5332c/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60961277c0320f8fa46f5=
492
        new failure (last pass: v5.12.2-67-g20acef25b911d) =

 =20
