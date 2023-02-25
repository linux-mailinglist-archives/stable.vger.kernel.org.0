Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246786A2BA5
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 21:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBYUUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 15:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYUUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 15:20:52 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CED713504
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 12:20:49 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 130so1484838pgg.3
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 12:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nNbU8nQ+oXdmTYOq3w+hmJ2A459PyVk9m5ynF2cvhLs=;
        b=gKVZMZHOYXDebBiuWXU8jDfYpYjKKQHgs3FzTt+SolWyZQ0msnun6BZL9TNpfPHAoM
         RMq7qSX1p21aQO746Tm31teZpIN0GCr8Axr9BrV5BDuN9RkcwHH/DPZ2S2mmlYfs8ACv
         saycG6xzAGPLJZzDVuNNFCxJUxoZbjLu4wY7RXm9JdpLFwXEJ4RbMupu3Lj9XNm46Ncg
         hIDfIveJ5EsCCOTNAlVf3m3sHy+UnHSMbLJ+SoFfgpfg3XV06+QYU37IfhadWTa900/G
         qql3HqAo7edhHFs98PTQXjFndl16I8e5su7CejjDhhVV/MDI780FGkRDV13xGPjfwjC7
         6Glg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nNbU8nQ+oXdmTYOq3w+hmJ2A459PyVk9m5ynF2cvhLs=;
        b=sosyNRCaESw2AmWCbEDpZoyUkaWfoHiSTrFC2GwX7fNQE2qhV0+eyYFboqdJYIkV36
         T64lD8etoicuomPKkID/p2KA+wXiOXGv1N/YvnR7H0ZljsqMqk6mSSiHlCoCNdeUugql
         JMIfOt01bbZPUtUPmbQe3c5HQpNd7nJtgRxPAdWcdr4LOd0cmavyYRw+HKQzhG+Zn+No
         Avs8M3mbw2uNCLVwpqA86j7mI8t63XKnMzlIZ0GQp8+Z3XH0D2UMM3P9HLPPKUyrh/ht
         84pldLAP9K2IWaaOFeCuaP2fYdOJ7xjR4P1nR/gsiNxPog11KLOziB4f0AAx2Es8nTCq
         XBGg==
X-Gm-Message-State: AO0yUKVefbySXp1RRh4Wrh356+AlJn1l7ga0LehQe8tZZH+v6p9FjUmS
        eY6zGtlyaRLIE7t6b3XMmzmA8Yu96aB+Mjgtpxg=
X-Google-Smtp-Source: AK7set/hw02P3+B3+WLWbeg3HcIA9sv9DkQzApzZ6qhJMdLdsEGI45X2jKrO2LhRTlCkoB95yD6eow==
X-Received: by 2002:aa7:9e86:0:b0:5d4:e4c8:2ecb with SMTP id p6-20020aa79e86000000b005d4e4c82ecbmr10927714pfq.18.1677356448184;
        Sat, 25 Feb 2023 12:20:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16-20020aa78c50000000b005a817f72c21sm1552750pfd.131.2023.02.25.12.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 12:20:47 -0800 (PST)
Message-ID: <63fa6d9f.a70a0220.c6caa.2692@mx.google.com>
Date:   Sat, 25 Feb 2023 12:20:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.170
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 157 runs, 13 regressions (v5.10.170)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 157 runs, 13 regressions (v5.10.170)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.170/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.170
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22d269bb30db7f5a4e71a8a813a0f4df5255f7de =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3a4c246356cb938c8686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3a4c246356cb938c8=
687
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3bb1ce2edc31578c86b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3bb1ce2edc31578c8=
6b4
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa38bc76b3d2c51c8c8647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa38bc76b3d2c51c8c8=
648
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa39870355fee2478c8663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa39870355fee2478c8=
664
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3a21f6cbab423e8c8668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3a21f6cbab423e8c8=
669
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3ad4c63bd40c018c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3ad4c63bd40c018c8=
65f
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa399702d8391ccb8c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa399702d8391ccb8c8=
639
        failing since 11 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa38bb7943bff3f28c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mi=
xed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mi=
xed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa38bb7943bff3f28c8=
663
        failing since 10 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa398636b8e8ab968c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa398636b8e8ab968c8=
631
        failing since 10 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3908294ca01ec78c8670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mix=
ed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mix=
ed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3908294ca01ec78c8=
671
        failing since 10 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3a99beda0e59db8c86e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3a99beda0e59db8c8=
6e1
        failing since 10 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa38ba9229c4bccf8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-m=
ixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-m=
ixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa38ba9229c4bccf8c8=
630
        failing since 10 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa39825092e3f5768c867a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa39825092e3f5768c8=
67b
        failing since 10 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =20
