Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEBC429CBD
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 06:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhJLEv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 00:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhJLEv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 00:51:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACCDC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 21:49:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id np13so14767895pjb.4
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 21:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IeOfwm/IiGwbC8TP+NswnAI2voWoCPZ4o8eUEOjrmKU=;
        b=SsamMJFAXMc6IEj0ZYNRjqBMuZhDSlK74sAgIQUQJnIp7XghxNdiA8i53K0IUe1EOd
         WT+RtPjocw0/p01pUFaAhDl/kh+aPolsLrr3MalLBMEL1RBYa8ppT8wE2g+QpZly52Da
         +zOJSQgD1/ioHi9ls1vkwBoalUu76gEUMNlvEftSSZR+VmWpyr00odzmpl6OaThsCv/+
         l7w9ibRTpj3e6fdYhNplARwTSmI5Bvd2/BXu74Z4Y2IMNoH3n3YVh4vxjrl2oCB9Jdve
         /KrJD7qswtcHh2Jv0wipblMVf7YBJe1v6ado9hbH/PHD8Tecs7jeyCXYeZ5fUpHqCDm1
         BY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IeOfwm/IiGwbC8TP+NswnAI2voWoCPZ4o8eUEOjrmKU=;
        b=EUhoX29Slxt0ZEI3NwFh2PTsNVJg5xct2tBbWjOuDNhTGl5HjxcyPRXtEHETxaodkn
         t5bxT8KWoat7oD3U6VeN9EMvUt6nCi64Cg1qfFfce8ArimQ+Nos/U/53R5FVyJV3PWQ7
         rbUIGBWUAxem6r6ZrGWZ5BUzq80zajTKGqIDsh1rvBxsEtlbqUianXEUICXm3JFDPE9x
         SnUXFmC1L5jVWuHk/MX8xGAgKKgq74qPEa4uE2bLCjPwjlRToH0fWlKyLesx3Ojr+6/P
         xUA8U52zjZfq6ysKC0bBUnALRUVNdCB1ZNOBw/kRXNTG7szISJ/Vques3Ob7mlXLR8kx
         Vb7Q==
X-Gm-Message-State: AOAM531D0rVl0nDdk3X1vb34qktV+lanBkPRuwvkcnJ4bWdXjlhLh0CJ
        KzBOa5VAnesastMtojj6xEDgYhZ+USdamlF0
X-Google-Smtp-Source: ABdhPJytr1GFnGnuXYXIkTrpzusQxk8zUtfa77e7ysfC9D4qkVJKiBaT0JQnQaNVpFGZ67toQrDryw==
X-Received: by 2002:a17:90a:5d8c:: with SMTP id t12mr3618137pji.98.1634014196879;
        Mon, 11 Oct 2021 21:49:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm1041964pjg.43.2021.10.11.21.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 21:49:56 -0700 (PDT)
Message-ID: <616513f4.1c69fb81.24773.49f4@mx.google.com>
Date:   Mon, 11 Oct 2021 21:49:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.286-20-gf18f3efaf484
Subject: stable-rc/linux-4.9.y baseline: 106 runs,
 5 regressions (v4.9.286-20-gf18f3efaf484)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 106 runs, 5 regressions (v4.9.286-20-gf18f3=
efaf484)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.286-20-gf18f3efaf484/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.286-20-gf18f3efaf484
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f18f3efaf48449cf43da6cda494804253e76da64 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6164d65d46bb64f1e908faa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164d65d46bb64f1e908f=
aa9
        failing since 331 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6164d65ebe0a4114f408fad5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164d65ebe0a4114f408f=
ad6
        failing since 331 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6164d653be0a4114f408fac3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164d653be0a4114f408f=
ac4
        failing since 331 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6164d608c6b3528b3708faba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164d608c6b3528b3708f=
abb
        failing since 331 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6164d867795547c62308fab7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gf18f3efaf484/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164d867795547c62308f=
ab8
        new failure (last pass: v4.9.286-20-gda89cbf2eaf9) =

 =20
