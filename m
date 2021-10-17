Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B442430A6C
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 18:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbhJQQM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 12:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbhJQQMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 12:12:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEA4C06176A
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 09:10:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t184so11966508pfd.0
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 09:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FtOroeJJ7HyHi9S1lDNUz8CwQfxsnVNZ0R155LEFdyM=;
        b=ooxMGPv0YPqli2wA4wv8xEVKtDSJ71g47j83FQbQOfSQXxMh3SQ0XeMTMF5EQe0sjZ
         +v6BZC0MRzXJmKo9pIVfLKjt5bXcjTB63yMcO1UGaiZiV6n4HgkeZf4/KMihSQTikCxb
         GvhHDNk2AQzZ9nRmi15dedmNFSkHv9k/DGSAZSBYOcnUExx48bDAnNLyf3JzfPNOtvF6
         KK9CFPoCGtsHvn9dos6cOOxGuUlSSveX8EACvZ7lJ/pm55K+4MfUmjZXuj+W4jyfrk8z
         U66R5kcTDri7WiygjN+nacwuAapRU0xf9YjZfWcFp6XGtIwaJx5RT9bIqWoUrIWYjhop
         MjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FtOroeJJ7HyHi9S1lDNUz8CwQfxsnVNZ0R155LEFdyM=;
        b=pqFIhsbXdGLw2kGz82fDiCjuGK2YA48ckv2V5hCeyuQiYCHse0PYJYyXwmNir/DsKN
         c1PS4e/9Kt31TPAuYHDvI2s0YODExAwITCwQjJfNR9PeRiVW6Mbd/uobVxXLUXKwX4pJ
         kmcQEVR9zr8U8KBG+5qgXdYJtCj6S67ONrGPl19UGH0OIwbwQJnlazmhiIGAtPkKvznB
         EBBp1uxKaf262Tue+5643dUY1wCmRGwsG+L0AjRkAYOBhfJBeiUMFqpJHTmL++n4r+V1
         sY0V+daSWZY7ZkI2ULoOwA+tILJOto63/tr4J6aUZou7t0j0o1Mj4ce4ziRClJ+qoueA
         ZzaQ==
X-Gm-Message-State: AOAM531JCas28qd8qu4v8HRNGyZ+SvxwnXImNfnj+7rVY/jia6jZbJdq
        X+2MF2xQ3WStkQiHYxU3hJGZnEb1y2LwZQh1
X-Google-Smtp-Source: ABdhPJxtLaoP5MF1xE9da0QDrQ6sV0i4F7BkwBINuIMGUtZhNe3HkwSrRE8s1QykVxXGYwtVwEmW1w==
X-Received: by 2002:a65:64c3:: with SMTP id t3mr18691401pgv.244.1634487044401;
        Sun, 17 Oct 2021 09:10:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm9760165pga.27.2021.10.17.09.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 09:10:44 -0700 (PDT)
Message-ID: <616c4b04.1c69fb81.ac94c.bdfa@mx.google.com>
Date:   Sun, 17 Oct 2021 09:10:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.251
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 81 runs, 4 regressions (v4.14.251)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 81 runs, 4 regressions (v4.14.251)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.251/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.251
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f6b016a9d961296d2db609d0259654371625e22e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c0f4a723f310f503358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c0f4a723f310f50335=
8dd
        failing since 332 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c0f54f5e42a7ac13358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c0f54f5e42a7ac1335=
8e9
        failing since 332 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c0f4af5e42a7ac13358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c0f4af5e42a7ac1335=
8e2
        failing since 332 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c0ef487847a10ba335916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.251/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c0ef487847a10ba335=
917
        failing since 332 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
