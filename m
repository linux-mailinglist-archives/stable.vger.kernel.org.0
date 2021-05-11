Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82B0379C1D
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 03:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhEKBfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 21:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKBfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 21:35:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F50C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 18:34:48 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z18so6439604plg.8
        for <stable@vger.kernel.org>; Mon, 10 May 2021 18:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RPt3StwCYRYnPmlp/KkhYtudEVsavb1JU9M+oT7IerY=;
        b=iusN+0ExQ9+0dr6xDLlmT6PifTqGrwaGtWNar2YOq3aLAiVQYjxd/1ts7MAkgyldkX
         n7YY/3zeXgd/TOo0loxzDaKbVPIMMPUblmcKQ+YMO3jqH08kWwHnI+F6rL0N6BKQKaB9
         Bael1tPJ0cPmg6fT8JUAKqwotrNR0/zNtu2yh0NpSrBaqO615FDmClOCYYwLvK5Lbc/Q
         7D3yDvF+o/A2gdW8A2IksHP4C6VrT65LAPimbYpolq2Y5HwLWk/vSfl8IZHas9/gLeDc
         44QHg4MzkuyzNKAWzugCHu6P3E8tLhfCvp5OVO9eNlvynUO1KgUGu6sf39kATZUH/YUZ
         TTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RPt3StwCYRYnPmlp/KkhYtudEVsavb1JU9M+oT7IerY=;
        b=SQsSgyh5H//p5xlw6KFtf8OggOpxd5qAjcvbYoqa+VPRj5RQjQGS8mlcuu6DQllnLM
         Ak00PYPaXMG77J64fgHVtMq+BsIPR4H2rDt7ZGZ/QQm0oyogA9J9AdoxmBlvIN4/HwH1
         3UukJsj/6e5x4YTLqi40+xlIaT83QXwdx1HkjlmD3qqKgSAx7QML3nWq2u7g3d4gmWH4
         o6JdzO1bINEm3U+vyXaioqy70DRC2U1PDlonkanzhONWlUTVZdAGn7Tj1nD4/HpFJ0Da
         G1YzPedUuvyVkI5xpXaih9kGdpj7jFYM8MfuHOJ23AFiJK6rre7HWBSMJAiBU13Wk0Xd
         Vezw==
X-Gm-Message-State: AOAM531m8NdSFBEA3RdtkWmLbMxLeST45ru5VCjywoOLPccFrH/xD2cF
        fi4im7ArErE2LeLvjADRt7Nx8R3XB7LqCB87
X-Google-Smtp-Source: ABdhPJw4J+rkpty95M+EBxxqFoSXKmEj8FLPPmbrezMYOa97QtnkL2/9FeO/tgOr5hn1T3kbnxzK5Q==
X-Received: by 2002:a17:90a:3c8d:: with SMTP id g13mr31522916pjc.13.1620696887699;
        Mon, 10 May 2021 18:34:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a190sm12286199pfb.185.2021.05.10.18.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 18:34:47 -0700 (PDT)
Message-ID: <6099df37.1c69fb81.545f2.580a@mx.google.com>
Date:   Mon, 10 May 2021 18:34:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-120-ge89ac2bf9c735
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 136 runs,
 4 regressions (v4.19.190-120-ge89ac2bf9c735)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 136 runs, 4 regressions (v4.19.190-120-ge8=
9ac2bf9c735)

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
nel/v4.19.190-120-ge89ac2bf9c735/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.190-120-ge89ac2bf9c735
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e89ac2bf9c73525440165f01ee30bbd57ecdb9e4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099acd2d3c839bc516f5489

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099acd2d3c839bc516f5=
48a
        failing since 173 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099ace9c89ced48616f54a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099ace9c89ced48616f5=
4aa
        failing since 173 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099acd1308f4b21c76f5472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099acd1308f4b21c76f5=
473
        failing since 173 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099ac9bc30a9290186f547d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-120-ge89ac2bf9c735/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099ac9cc30a9290186f5=
47e
        failing since 173 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
