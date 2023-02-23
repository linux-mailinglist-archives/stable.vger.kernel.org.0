Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E73E6A0EE5
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 18:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjBWRsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 12:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBWRsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 12:48:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AFE11E86
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:48:02 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso4723447pjv.0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BrxtLeaJEFxsNfA0RtGINdVOLzSG6GEiBnnvagNH+qg=;
        b=DFXS1XcG7D98WBkcJyUcdBVIeenVtJLk1CI94Q7kEO7eE/464qA23fWPn8I/0u830Q
         xOaYaRLlJyTUZEro7E7eh+Ls55SkBQWpBtXBkzteM9avifDN5FLriMSwwmy0kogkcxoz
         75iG8Hos5zOCK8xQWqnNBx4kCvYvgO9P2TcDRvpw1yw0xCvbn0olvaiHs5HD8cEO/BDE
         6IMYfA6EXKBK0ZcvECtnvlLBIEkv2Dd+UBhRs9n5XVRSQXgn3SNlVipjtvrxPQl8gjIw
         fAAQr1qg+zZFe+9or91Q1eEkhofHYzjJp4DIWp1lb7zwme2eaOUbA0yOZ7ek3MQ4OuvL
         kUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BrxtLeaJEFxsNfA0RtGINdVOLzSG6GEiBnnvagNH+qg=;
        b=Sl+2QHIEDoxHkz/JIhF/3cD1xopVXKwcAIXkOv3brqtQD8lVrrbmIez679Ggtu92pV
         zghHdlfv6pFy8boXmEigodtrDP+ZkEv1OymOkQ7R+NluW/dGn8k+VhN9g89ltJAv6ZoQ
         XzrjtShB0Ctp12ylin5LbRxMelR2sVZDwp/A5dgue5GYUy68tfp9Sj4OxFhvz/JeP8n8
         U4nMIZyGvU2zrgYL01edkJiRqGz3H83PdvGgAuj6vLlIuN/7m3olvRu3xVlCVxcSVp2v
         eWkXtWFEr9KSW9bE53ynV4sF20mDXueNewzIcSdRbk/8LohCacRXkD068b1+Mr8E2dji
         lVqw==
X-Gm-Message-State: AO0yUKU0Juh8xjiCcRVSjwtF9GIdGprowsCTJCbn7cJ9ePJ9llAORlhj
        UvKuAC7C+N2UH9hXOzkBtyL0MDAAf29V40G2wZz4wg==
X-Google-Smtp-Source: AK7set+YM16cXZSUsqmBYr4X7Ap+6uiOEHW1zjpSwcFbw3FJTiHEcgSrQv7MlEcPTnQxXEpuujtzgg==
X-Received: by 2002:a17:903:1211:b0:19c:be49:48e1 with SMTP id l17-20020a170903121100b0019cbe4948e1mr2580355plh.7.1677174481804;
        Thu, 23 Feb 2023 09:48:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jj11-20020a170903048b00b0019cd1ee1523sm11079plb.30.2023.02.23.09.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 09:48:01 -0800 (PST)
Message-ID: <63f7a6d1.170a0220.5dc29.0094@mx.google.com>
Date:   Thu, 23 Feb 2023 09:48:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.169-25-g125881a8b18b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 39 runs,
 15 regressions (v5.10.169-25-g125881a8b18b)
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

stable-rc/queue/5.10 baseline: 39 runs, 15 regressions (v5.10.169-25-g12588=
1a8b18b)

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

qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.169-25-g125881a8b18b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.169-25-g125881a8b18b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      125881a8b18bcd0ee14f300820d0d03c85333af4 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f775ea25ca95613a8c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f775ea25ca95613a8c8=
639
        failing since 9 days (last pass: v5.10.167-105-g33398e62147f, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f775f5d86ae330158c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f775f5d86ae330158c8=
64f
        failing since 9 days (last pass: v5.10.167-105-g33398e62147f, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f775e325ca95613a8c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f775e325ca95613a8c8=
633
        failing since 9 days (last pass: v5.10.167-105-g33398e62147f, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f77524533ccafa088c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f77524533ccafa088c8=
644
        failing since 9 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f77536533ccafa088c866f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f77536533ccafa088c8=
670
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7752e533ccafa088c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7752e533ccafa088c8=
65d
        failing since 9 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f77530533ccafa088c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f77530533ccafa088c8=
660
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7751b533ccafa088c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7751b533ccafa088c8=
630
        failing since 9 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7751e533ccafa088c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7751e533ccafa088c8=
63b
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f77522533ccafa088c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f77522533ccafa088c8=
641
        failing since 9 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f77538533ccafa088c8672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f77538533ccafa088c8=
673
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7752d533ccafa088c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7752d533ccafa088c8=
647
        failing since 9 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f77541f5b82017fd8c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f77541f5b82017fd8c8=
64a
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7751c533ccafa088c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7751c533ccafa088c8=
638
        failing since 9 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7751f533ccafa088c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.169=
-25-g125881a8b18b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7751f533ccafa088c8=
63e
        failing since 9 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =20
