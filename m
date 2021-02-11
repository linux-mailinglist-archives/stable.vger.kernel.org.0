Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9561131841B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 04:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhBKDww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 22:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhBKDww (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 22:52:52 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E1BC061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:52:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x136so2867999pfc.2
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lLZD6RYupWdXn1L7Vp78Gcqgl/7UuvRe6yQg//5IWwI=;
        b=PgftMRJ1Tg1cYcm4CX2rKO0aid0eKMbo9PAk2NNcdYMzBiU0EBFw5T/Xyh9McrPWG1
         iyLO8TK3YMAlTdzXTfVeenhV7Hlh3Cinv9jyzOKS0o0iWgEg+ChUvxGc6Hq59FzUnSI/
         YwZjl8+hi7FjE8T3EWn6nhHsi1qU+clu5fhO0iNliskM/WqHGJ31v4CI6mtEOgGNg4Lv
         sX5FTNNLjxzAfjBcpK42My2xBc3IH/y4SjwM/CdxP720lYNP0nv2jmehH26rCeUPm6N/
         W4f9Yvpvq9bNvvd3L7lxf2ZK2Y7j1pMkmUCwDlfuOn5cszx1vSXpYwzsYdaBvVaVh35k
         yZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lLZD6RYupWdXn1L7Vp78Gcqgl/7UuvRe6yQg//5IWwI=;
        b=IfSem/GSWD44TlXFUxCQXhFVx3Z3egYMPT4f0ZO4PypsbfRAMEVHtX8v/JspMoPlnK
         RwNvtO19f1ELXhtyfLUOmYuGz6sIxWhHNIomWjJHOokLL1hqEkXv6rDdvWcmJGg4sJKx
         8WeT9nQTJmTF9+0217m194lGb+d6M4w2VzQ4/F56H0NS202jevzP63M1higvku9JbZuk
         TeIqh2X2Z872mSa0Io0Pm6PNgIsl7LwUfPWkcfLJ+C4laLxP18FXFWlc9RR2pofyTD/v
         s4FuWby43F1BdCtxOG6MBOyPN6WGD0im9vIFRgO/FvxZLCF86ZhRvpoL2wX73zJf+3sB
         Ouog==
X-Gm-Message-State: AOAM531kAtQivAH3+YI9c71yW1voMIhW4odt2jL8cdMtRh4s2HInXI/g
        okwuqCA+iLF7MsfSwIK1FM68/LdvSVc6sw==
X-Google-Smtp-Source: ABdhPJxlmHk2Pq/G/MUFir0t2TWPuivKSHp4jrt0lUQgs3N/Gjkb+C2o1dqq1HLEnXQL6dF/pVkQVQ==
X-Received: by 2002:a63:1f45:: with SMTP id q5mr6101646pgm.414.1613015531246;
        Wed, 10 Feb 2021 19:52:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm3665622pfp.122.2021.02.10.19.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 19:52:10 -0800 (PST)
Message-ID: <6024a9ea.1c69fb81.82ce2.9131@mx.google.com>
Date:   Wed, 10 Feb 2021 19:52:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 100 runs, 2 regressions (v5.10.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 100 runs, 2 regressions (v5.10.15)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =

meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d18b3ee633e0c9d7ddcaa489299113fb88ea672 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6024779dedf83113663abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6024779dedf83113663ab=
e67
        failing since 5 days (last pass: v5.10.13-15-g62496af78642, first f=
ail: v5.10.13-58-g58d18d6d116a) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60247808718280298d3abe81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-nanopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-nanopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60247808718280298d3ab=
e82
        new failure (last pass: v5.10.14-121-g21cc9754fccca) =

 =20
