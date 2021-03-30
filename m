Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF07E34F267
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 22:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhC3Uty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 16:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhC3Ut1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 16:49:27 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC3EC061574
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 13:49:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s11so6904165pfm.1
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 13:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZAvcD5TTr2C/65sqPL80P8ffz/Lw+VCNuiX0VnrA1IM=;
        b=PuovSDyqiz5OXbt8b8dhPBGhroba0U0lwWksWvZYi/4l6MUU/wwgi7HGwDvD2GLnY7
         /KTmJe6+cW39RM48yI+znMrlQKD2Y2xHUFwJiVNT+1QQq4Te1jZDVL8M3HjYf5md7rlT
         SA3C/n+HMMRZq+BHyCYW36zHouZzFbSkhLrP3y2E/ycYqM5DBDGD2/1wiR/9ZjF/F5ZS
         zsPwn2ooKakXJWDlsYOCvQSc5cJRWLGAUmRlqw9L9DE0E2R5pTxoOXIS4vDL67eq53Bs
         qKhttyvPfq8Gwy2uSMw3PzzqfmcRPqCXo2eLwcC20ymlu2eqMbgueAwso/Hk3fa6XlfU
         pskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZAvcD5TTr2C/65sqPL80P8ffz/Lw+VCNuiX0VnrA1IM=;
        b=TDlVj+9K1nzI0btEO5IjoIkvgIBgp9ZizS+rSk5VzFb0rpu0HWwRVVf173Q+BwzCyT
         1caw8JG0unYCL0swnF8Vaim3tduKNxW/BWxjaaLVzl/zTZzEFmb1bvk3jeyjNjttEQfI
         JadFxQr96p4EQfhas05guI/bDSulu3rqG4mApOZPb9+zMKJ2Pt0HcbTcjjuHdx/Ovq8j
         xkSshtVOssQCvUaWVcKnPGSOFbNUhnuF3uwFH6uariCUC+Y2QY4PBjTgTODmt5DHr8ha
         qXxrtdJxOa/f0DblocIkQhB9zLzVF5U50Tf2sBTVLVGbr+X/JPXJ3ExtI3uG8fb866Ku
         e+Aw==
X-Gm-Message-State: AOAM533V4VwGsEupvAeW6MW/+yUElVOmhbFCNRvy+5BA8mO4HxwdRZdc
        0/EKzc5HUZd0iyRn9py66KU1Dgm013ct59ky
X-Google-Smtp-Source: ABdhPJwZTbKHJOyzV337bsoijqAvrQYHilRyI6g7yc9Cgzh1MEGsj+gXv5DP/yTo3aA7P4AWNAAO9g==
X-Received: by 2002:a63:1316:: with SMTP id i22mr14341789pgl.419.1617137366892;
        Tue, 30 Mar 2021 13:49:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z23sm83102pgn.88.2021.03.30.13.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 13:49:26 -0700 (PDT)
Message-ID: <60638ed6.1c69fb81.994ef.0573@mx.google.com>
Date:   Tue, 30 Mar 2021 13:49:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-73-gef32d8257724b
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 141 runs,
 4 regressions (v4.19.183-73-gef32d8257724b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 141 runs, 4 regressions (v4.19.183-73-gef32d=
8257724b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.183-73-gef32d8257724b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.183-73-gef32d8257724b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef32d8257724bbe9dd36a1891bbe8ec0f73ec1ec =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60635cfda6eb741c55dac6f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60635cfda6eb741c55dac=
6f2
        failing since 136 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60635cc341ef162d03dac6ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60635cc341ef162d03dac=
6cb
        failing since 136 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60635cbfa6eb741c55dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60635cbfa6eb741c55dac=
6ca
        failing since 136 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60636539dee36c356ddac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-73-gef32d8257724b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60636539dee36c356ddac=
6c7
        failing since 136 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
