Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF4C6A0D94
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjBWQJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 11:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbjBWQJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 11:09:51 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2733D923
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 08:09:49 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id l15so14646935pls.1
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 08:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pLwh6pnWMZN4XzgZ6NUn/fhKASxaGpUZ14c7WmxDDiE=;
        b=Kq4hF02M45w5N1yMN2fZcArWGgnsU+8b1tkV5VIRmwGyrnayENFpXZYqr3tMCbeB36
         /tQymgbG2vfedPiKNRq8R9ZugV++vp2d7cnWNqu2cpkn34kKbuOEBLNBjR/0W4Q9UFRh
         1b+klwzI8tHEO29OT0AOBEc+dATRQhXu9qwHqJzztPVy6+HkagzHIbg/d54ATuNHC+qo
         E/WgrmcfJkUFHyF/afNJ6Hb+YkZmaAdBDidGnym/vG10XF80IBSuELznRqGF7G8adZEG
         5b4vg5wHqBNnzYoqptOwAlfosi2FWmzbN5K0AnbO+8Q+ihJ/ileKR0zCWvcXKB0+yPAB
         iO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLwh6pnWMZN4XzgZ6NUn/fhKASxaGpUZ14c7WmxDDiE=;
        b=vv74ISmSNi9npJUKNKU3kdfRs4sTxw9wwmRarm7/IFSwxZOat015HugUD0u6VsqpG5
         m9Tw1YrHgFaixjIaTv3IXkqwbSbf/tGuYR4ZbecQTZkwqh4dRYfIU/H4K8njY4NuX0Pz
         ZR7zstYLOpP0y6iGWLBv9/ppK3hPkEF5G5StHZVymb5Mf5A1ijTuukRltLoN6duUAW9c
         N158WtfCRWmV4EhSXbDebSG6Twq9QGBcc0qhQxMjzOGE0HMLBdCV40h1tVk/EaTTG4Y0
         hE3AOuM7Bsb3iKp42KY1mw8k7PLneCd7yKhDBff/uqX4AyMZWLh43dQ77vPQcsnAuA9O
         N9Mw==
X-Gm-Message-State: AO0yUKXtT30SLmCcr61lGd9HT3ori2EGXMEktXggrKZ3Qkb9v/VmS4yr
        DjzJsIv65sYdjsXcvXcPPerzszgzDXoCvWVft4M/YA==
X-Google-Smtp-Source: AK7set8YsX3CMcRQWzbMTEH/pKR+LKf8j08DsXNDVpG6/sCsZeqLQ87JpY6eK44G/7rRXQeTzeoksA==
X-Received: by 2002:a05:6a20:3d8d:b0:c7:40a1:ac1b with SMTP id s13-20020a056a203d8d00b000c740a1ac1bmr16257054pzi.50.1677168588590;
        Thu, 23 Feb 2023 08:09:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79111000000b005a852875590sm5009544pfh.113.2023.02.23.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 08:09:48 -0800 (PST)
Message-ID: <63f78fcc.a70a0220.a5183.9fcc@mx.google.com>
Date:   Thu, 23 Feb 2023 08:09:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.232-17-gb557ab7cf779
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 37 runs,
 13 regressions (v5.4.232-17-gb557ab7cf779)
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

stable-rc/queue/5.4 baseline: 37 runs, 13 regressions (v5.4.232-17-gb557ab7=
cf779)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.232-17-gb557ab7cf779/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.232-17-gb557ab7cf779
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b557ab7cf7793e05e0ab6c833a73b26bec189956 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f758368201a58e128c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f758368201a58e128c8=
636
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7582d98bd98b2e48c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7582d98bd98b2e48c8=
649
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7580898bd98b2e48c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7580898bd98b2e48c8=
63a
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7596139f41265cb8c866c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7596139f41265cb8c8=
66d
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7598ba7a331e2598c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7598ba7a331e2598c8=
63e
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7598176a267ae778c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7598176a267ae778c8=
663
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f759a9a7a331e2598c8666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f759a9a7a331e2598c8=
667
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f759487363eaff728c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f759487363eaff728c8=
633
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7596397e0b7989a8c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7596397e0b7989a8c8=
653
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f75989a7a331e2598c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f75989a7a331e2598c8=
63b
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f75995a7a331e2598c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f75995a7a331e2598c8=
647
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f75996a7a331e2598c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f75996a7a331e2598c8=
64d
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7595a39f41265cb8c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
7-gb557ab7cf779/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7595a39f41265cb8c8=
656
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =20
