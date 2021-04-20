Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB5F3660C2
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhDTUVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 16:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbhDTUVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 16:21:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCD1C06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 13:21:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v13so6716020ple.9
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 13:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1mvo+rDMGYuA68SBaKp8tMrwfgH7Dny53rIxkd2fg8I=;
        b=t1p2i6cEjQSrKtqCHFsKu8MuBUIMQjnQoX7LAulxOHB2nyueJRbkZGYV7QErtYVp1U
         PG4B3mkqFQY5C/JH6zhg+xPIDMTD9BkbdPLg21vSUKIZuCY2iLtE5UsvyT9i1YV1xQ+b
         PAO4iYLiHAAq6wd1xso7l5+6ATVdiMyX2BTwoKXs0cjZxIyYYk+w2aS7JV1XXn3LiCBe
         ZKN+vmXB/BAN6ZMzTtNuc14xA01CpFSAUQWgGB2AWFMKdy9WxE1HhZCAOyF+beeCKyWf
         En72GEv8zzFCTr1FXnZYAkDDMN5iVLKV9YYro9Jg+mqAKUYRP6vLPL5RE1qXMeCiLRiO
         khbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1mvo+rDMGYuA68SBaKp8tMrwfgH7Dny53rIxkd2fg8I=;
        b=NbxGctYpn/CWTLn0B87cmr23Q4MoJIHH7ar+r5/eeC33Xd1LCyXQ5w0mYhniiYnTQE
         dKbj0jj70VOJphzTpxR+FmS1ofL21Me06C6s4KTW/aa7PAkS973wiRqkLCyrUNkjYRqT
         fIWAtw4MHK4X9uzqFkS/b9tfaICPmCSPocSEOQ9l+uB1jr0twlEfgXGYFA05j9fxoEpu
         XoTOX0ZM6XU5LuFRKVD8QoZLbJAaScdibKTzSXvl4PDuL+NEtkzpLDXTUWbcyvPjT2q3
         Rbz5Le+C3ixqjOdFxoL4BCL5vGlTIojUQLkuiYEGRNZQ8ezaCckanez5aOEuBY8BfWnO
         9Sig==
X-Gm-Message-State: AOAM531Vq+Vsr+wAzXoZsHaNTRbLz7QQExNBuLuWwF+Rg7RVRAEzRjnX
        HYu1abf4O37ulJuUz48cNkxMh9XsXtYyJ2Ni
X-Google-Smtp-Source: ABdhPJxUjICnLRnbtbvweQvSOGwwZpz/fXAriYRJdP5wL/P5g87SS6vXji+FYPWhoclgSjv2zK65Kw==
X-Received: by 2002:a17:902:7c17:b029:ec:bfde:23e2 with SMTP id x23-20020a1709027c17b02900ecbfde23e2mr2754465pll.33.1618950069160;
        Tue, 20 Apr 2021 13:21:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f65sm3103654pjk.2.2021.04.20.13.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:21:08 -0700 (PDT)
Message-ID: <607f37b4.1c69fb81.b715.9788@mx.google.com>
Date:   Tue, 20 Apr 2021 13:21:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-27-g04d360867dd4e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 5 regressions (v4.9.267-27-g04d360867dd4e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 5 regressions (v4.9.267-27-g04d3608=
67dd4e)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.267-27-g04d360867dd4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-27-g04d360867dd4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04d360867dd4e10ce1e232d06ba75add0d347153 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f04ae97bb3ecb1a9b77ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f04ae97bb3ecb1a9b7=
7ad
        failing since 157 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f04ab97bb3ecb1a9b77a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f04ab97bb3ecb1a9b7=
7a7
        failing since 157 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f04b297bb3ecb1a9b77be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f04b297bb3ecb1a9b7=
7bf
        failing since 157 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f04498c2047a3139b7799

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f04498c2047a3139b7=
79a
        failing since 157 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f045b3a0aec155e9b77f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-g04d360867dd4e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f045b3a0aec155e9b7=
7f2
        failing since 157 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
