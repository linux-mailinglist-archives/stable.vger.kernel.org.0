Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4B3381C4
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 00:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhCKXs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 18:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCKXs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 18:48:26 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF7C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 15:48:25 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 18so623926pfo.6
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 15:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ds6urH+FkcMYKl3455LbIU0uqAf+CxDMzF1hgY3KXZw=;
        b=SvS2kfx6W7LhazXPwPu5vuQs5o2w/mm3jcTbwkT2MymgqldE5X7xyoZgJQsObDFAi+
         FBw1VChyvm0a0S7W6gf43xgToVqShzip0u+OUiq5PqXFpgweupcoZ690JIjsiHAQqegP
         4WhTj/QobHuI4xoTn+q44QQqrKU7BK/zIZb08Y11e4a/olxaTsy0qUNOFWDHL2FZHhXO
         GopinTOYuIWcYLFKrHFhbBdw2c7h6XJIQC5n/sLSAdqQur5rLngEAIifueoclc9kr/xa
         WGDpuwukKCx6gKQ+WHWtGLEbO4Ct8x7h6Qk1HND3JBVvW6KJHPpMuANw135MlhKFG7Jq
         7nUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ds6urH+FkcMYKl3455LbIU0uqAf+CxDMzF1hgY3KXZw=;
        b=AE8b+435BaXAdIXwP5OSakKIzGQnPRJpS7ZcrttC7qtc0zyVwLRq4m/POBvvRJ6j6t
         FFDgWreuNvMcVYqhLCX7Wu9wheVCmlSlmTta4WVlM9MgiTch4KGcb4hwmmV4kboKKwfu
         B1YXmex16BXu/Jf6OJnj2OmAAKBG6u4nhZOVKDvc7z2tv9VATVEpeiYmksppPhNcLwUB
         y9WPYfgXXcEWa1ZWryNRrRfle8uMV/YrbSJxq9TB62ZU+Fxi5q+bB+R/CtzXGSKnJzHI
         YgbtX3ThevsSCoUxPOLuqc2A6TjYrmXv8vpzta8CqHaoV3FWNpGtDmgbT0e7g/Qi67bY
         cMUQ==
X-Gm-Message-State: AOAM5327Waax4xYW7KQNjZguQ3TBiuQm7NwtJQD/figVpExpcFAcWPGt
        5A8yIL3TBg/QN/Rl1ZMAWgqGnDQb8ZrVs7ro
X-Google-Smtp-Source: ABdhPJwn+BaGSYUvvtANiociFPK3UFaCFDZuK9IJeXP17kXOlsMmqKUiq0PbGVfI6fSDKZ3K13B0cw==
X-Received: by 2002:a63:fa05:: with SMTP id y5mr9106358pgh.154.1615506504956;
        Thu, 11 Mar 2021 15:48:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 25sm3426809pfh.199.2021.03.11.15.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:48:24 -0800 (PST)
Message-ID: <604aac48.1c69fb81.2318.9f2d@mx.google.com>
Date:   Thu, 11 Mar 2021 15:48:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-13-gcf7e1fa20d452
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 67 runs,
 3 regressions (v4.19.180-13-gcf7e1fa20d452)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 67 runs, 3 regressions (v4.19.180-13-gcf7e=
1fa20d452)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.180-13-gcf7e1fa20d452/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.180-13-gcf7e1fa20d452
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf7e1fa20d45200b0dad0a561975f501373581bd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a760c98bfc1a697addcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-13-gcf7e1fa20d452/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-13-gcf7e1fa20d452/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a760c98bfc1a697add=
cdc
        failing since 113 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a76232fe189845eaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-13-gcf7e1fa20d452/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-13-gcf7e1fa20d452/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a76232fe189845eadd=
cc7
        failing since 113 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a757e94e8998258addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-13-gcf7e1fa20d452/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-13-gcf7e1fa20d452/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a757e94e8998258add=
cc1
        failing since 113 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
