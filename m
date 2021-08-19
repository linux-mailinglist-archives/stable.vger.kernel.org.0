Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D6D3F1026
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 04:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbhHSCAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 22:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbhHSCAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 22:00:39 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310D5C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 19:00:04 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 7so4036730pfl.10
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 19:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ozhivyRRHn4VAt7pSb/cNMckQTXVGjxxLmS3/0kF6rc=;
        b=TJlwPKvwNugOcNotrv2VFs7WLvaRiUyq3Tevm83PRkDiVNG2sKPR4UDdlJL7yYV/Y3
         xo6PB5r2yooetBthnY5USoEH4NEB6K8x/vpmQVJwwk3+0mEPQpb9liGDXFek1/iPd107
         tbRyLPbBjdPD3Pb0KbtZCjq/V714rQsUZaA62IB5mms/HYTgJaf20wJ5xqqiIVa0Whcc
         nbqfh8YIaguxOFHcnQ4EaYDrpRztyJ1ktTKW1IsJb2EwScDLKUe9R/hXHaFJxEbK5KD9
         VHWJbXYSGHsF895v6U6bVXiQrHxvv9wlumdvJd5e0/Kvf07TrtZjPURJF1dpteRZv9U6
         61yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ozhivyRRHn4VAt7pSb/cNMckQTXVGjxxLmS3/0kF6rc=;
        b=DGaLGvaH0HYQ+wCBbBAHz6YRLCDdEy8zx0cKv+8QHhRekG4uex4pYT9+zLHppB9TdW
         2WCuibcGc+xF79Q2csipXkCOcqBCymHVZVC8JC9OXKN+JKaVNBet2OvohphMjmRUtD2a
         2GzlsezD3yRIjD9qJt+lXxdicCse8kcaOdAmLBEtaIMr94TDqFK8Gvn8k2AEn0KHHLZ7
         VWjkF3DoqX8rSrc43CYbCyRqzB9gdmlbmfQ2YRhQd6sVkqA+RXUKWGi1CUHrJydQ3D3n
         POyd4zlm8LmB1sbbaqJeqN7tXi+opOSjH6Ds/RJeUnIhOxpPNrfB747MGtQWT8j4QKRU
         X9+g==
X-Gm-Message-State: AOAM531gDterOZiDP8u/MFAaBms1t+23hH/6GLngpnBdQEXWmKAPuFIE
        7ZR4MnHdKXD4Uz25MDAAjz1Bp3ZzaduFoavj
X-Google-Smtp-Source: ABdhPJzv1Bjki/b8wpZ878zXuc7hKLXm1GAjkW8jRJ+m9r+E7NlBhc8NEahrYwlwHBr09d975hT8rg==
X-Received: by 2002:a62:8f86:0:b029:32e:33d7:998b with SMTP id n128-20020a628f860000b029032e33d7998bmr12513179pfd.64.1629338403517;
        Wed, 18 Aug 2021 19:00:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10sm1301432pgj.48.2021.08.18.19.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 19:00:03 -0700 (PDT)
Message-ID: <611dbb23.1c69fb81.6967d.67e4@mx.google.com>
Date:   Wed, 18 Aug 2021 19:00:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.12
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.13.y baseline: 160 runs, 1 regressions (v5.13.12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 160 runs, 1 regressions (v5.13.12)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/611d87b09be002e1d4b136a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d87b09be002e1d4b13=
6a8
        failing since 34 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =20
