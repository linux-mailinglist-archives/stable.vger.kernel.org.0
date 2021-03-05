Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6F32F01C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 17:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCEQcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 11:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhCEQbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 11:31:46 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602C1C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 08:31:44 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z5so1677821plg.3
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 08:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=axpQKURVKwBVW8K687CWEG8Api6i0r1kyZG8abzheiE=;
        b=0YTfJ22xVY7B8wKdw5Kf+/j0QbmIEnFplrJx77gU1YnWqsJywP8Wo3gk9fr9ENZ1Eb
         8+1np9rTkNzzXokK3KmO5kubQdr2c1uqkTGH2JYUitcP8+9PE56bLhZxUoXi9MmL+4II
         DmkHl5rl5frfu+7864Nk5U327PkR9DdUDS4gajx+dekt/31nv/Ciqo+bC0YG+/2k9zIg
         t4vHDGqubfCFyismfAtd2Z0JOoS+njtsfxHlLJ/LVBU3OfhB5FF5G6wxwXKfcXWBncym
         8jN/gw6Y7HPndbtBBvAOH2eT0yhoz05aq9zxT78S+3ETHya6xKa+K3YbpAElR18Ijis+
         +8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=axpQKURVKwBVW8K687CWEG8Api6i0r1kyZG8abzheiE=;
        b=d+Qbl0xpzHhUTM6hVeeZkteTl9dx15Q8Pf6N50BBeaRRoU8d7sCXNhpFscJ8m2f4Hx
         Z5aa4c7UmtapKXZTqI0iIiziiwxIG2zeS8wfpxmSuowoosXFoCGL6jk0aL85MYtpNBm+
         1s8b+waJAisfZN/AQOY2QhZTw8OUyh8p5FJCcFHCC/iDyQnsSxRc7u4D4DxvqkW2bfo/
         imDYkQQbnpq3ctvj7EqaIPagPmv+Ps87iw5q0qwmUdEIfai90QNdLzM4DIGYEvOkox7b
         h0no9tK+BY1+aFrBEvVLM1A2zzA098DLv8UyurZuwwYat2Z6vyISTJ+4yvV1Ff7Btqsj
         D+Lw==
X-Gm-Message-State: AOAM530CY1DgOVg7cpoV2mT3HxgstGS9rARy/1z3AJqm1Wm/BpAhN2N7
        jumdppic4gvrmtDmjcXhbWyovdINbQn5pf/d
X-Google-Smtp-Source: ABdhPJz8X0PAoJJ3KEmDU2GC2u+8aPT+EbuqT3l7cmSkdwa86U9mpCSO+p5yEHjPLAjTtK7QMUKmoA==
X-Received: by 2002:a17:90a:64c7:: with SMTP id i7mr2862998pjm.95.1614961903752;
        Fri, 05 Mar 2021 08:31:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v27sm1300170pfi.89.2021.03.05.08.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 08:31:43 -0800 (PST)
Message-ID: <60425cef.1c69fb81.9d616.2963@mx.google.com>
Date:   Fri, 05 Mar 2021 08:31:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-53-g1112456421caf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 92 runs,
 3 regressions (v4.19.178-53-g1112456421caf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 92 runs, 3 regressions (v4.19.178-53-g1112=
456421caf)

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
nel/v4.19.178-53-g1112456421caf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.178-53-g1112456421caf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1112456421caf2562801d760aef4da53915246c0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424223b3f2b8f89caddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
78-53-g1112456421caf/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
78-53-g1112456421caf/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424223b3f2b8f89cadd=
cd3
        failing since 107 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042390720bab117f4addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
78-53-g1112456421caf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
78-53-g1112456421caf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042390720bab117f4add=
cc6
        failing since 107 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042268509f83abcbdaddcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
78-53-g1112456421caf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
78-53-g1112456421caf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042268509f83abcbdadd=
cc8
        failing since 107 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
