Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC76A2B9E
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 21:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBYUJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 15:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBYUJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 15:09:23 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534A75B8A
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 12:09:20 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id i10so2912622plr.9
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 12:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lUEa0UU0z//dhpr4IA0yRnAPnq6fgtW3+2HhS9Ggb44=;
        b=cuE+3zuUh4muI2ZBtZL+sluwV64f8tZYmHG47UiBHdaZL4gf9IPBVVe+7qZtuLNI2g
         SCv5r9r/5tNd6GKCCjs6VCu/bO5VW8RjaWHMf9a2TPkjWNizVAWwTrcFdzWHMkiiFxgX
         80aR9miuU01ZEV1KuRrWQDphMD3ZjOvWtzuvKtOdLAS70eb4WToN9hkmucPl407gEV7a
         gOdDttnXFTf4vHitECuANti+OJoq9RH4N5c8Aa+7NXcoCMbP6+SXfnfXunl9OOY7wgMP
         u7XYOPZLYHUJvHEU/Tz6EZnoN90qtY+4g4Z7T1w0Wnz5JcgBdMYkKW0vMwY92Wyqshbs
         En+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lUEa0UU0z//dhpr4IA0yRnAPnq6fgtW3+2HhS9Ggb44=;
        b=M36PCU2/s/n1wzt5Zuog7C/+syX+fSy+vfDl+GlPp4aonH+UxLjGsIpp9Hyz2rzfWj
         AtG0M1uAPqp+jhPXqhDruHxyPnZ5BQUJGlTu7cy/gVb2Sst5wxtxn1aEe+oJ3o08oua1
         46Fh8qxYIs2br0Bc/5yHSll5RE8tegqT8Tcu0Z7aKTl3476nf5zr2PLkLm6lPjq1R4kv
         mNKwFuvCEuOfBA7CIvXIwYz5Rw0FGQ0xZAAUx6Ai/Xt4gKeXXApMD2xtyUkGsLIcDWxb
         Q39W7vk+o5J55SjlRCCRtg+WIXd8ydGOb0GeaBsk02PwqGPUt9HPdWs5VHiJXt6FL3u5
         2Uzw==
X-Gm-Message-State: AO0yUKU1xp/5dLlIUbbYHTCSSHDKWKOc7x3a58UtLfToJu9oAMzzN0DQ
        ieReP0QLLgrAOXwzs52+R0MBQ+9b4tvpTkKB19o=
X-Google-Smtp-Source: AK7set/M32++xO0l+OLva6j10ClxcGTO4l1J5vPvAu5VTIRZdtnEeZWXXJjgptBqjm/2ZNQHqHjvNQ==
X-Received: by 2002:a17:90b:382:b0:237:c7ed:8f57 with SMTP id ga2-20020a17090b038200b00237c7ed8f57mr2214293pjb.3.1677355759184;
        Sat, 25 Feb 2023 12:09:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a9c0700b002348d711ebbsm1657809pjp.16.2023.02.25.12.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 12:09:18 -0800 (PST)
Message-ID: <63fa6aee.170a0220.3180c.2db1@mx.google.com>
Date:   Sat, 25 Feb 2023 12:09:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.96
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 148 runs, 12 regressions (v5.15.96)
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

stable-rc/linux-5.15.y baseline: 148 runs, 12 regressions (v5.15.96)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
odroid-xu3             | arm    | lab-collabora | gcc-10   | multi_v7_defco=
nfig           | 1          =

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

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d383d0f28ecac0f3375bdfb9a0c4bfac979f6f8f =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
odroid-xu3             | arm    | lab-collabora | gcc-10   | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa39b302d8391ccb8c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa39b302d8391ccb8c8=
653
        new failure (last pass: v5.15.95-38-g75c1b03758ed) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa36773ecc4d5efe8c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa36773ecc4d5efe8c8=
63a
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa3660290aa167f38c8694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa3660290aa167f38c8=
695
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa34eb79d39327868c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa34eb79d39327868c8=
634
        failing since 8 days (last pass: v5.15.91-142-ga0b338ae1481, first =
fail: v5.15.94) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa37199ca6d7725d8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa37199ca6d7725d8c8=
630
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa34f8686b0b1db68c8675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa34f8686b0b1db68c8=
676
        failing since 8 days (last pass: v5.15.91-142-ga0b338ae1481, first =
fail: v5.15.94) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa37289ca6d7725d8c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa37289ca6d7725d8c8=
64c
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa34e579d39327868c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa34e579d39327868c8=
630
        failing since 8 days (last pass: v5.15.91-142-ga0b338ae1481, first =
fail: v5.15.94) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa34ed79d39327868c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mix=
ed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mix=
ed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa34ed79d39327868c8=
63a
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa371b3f7653e17b8c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa371b3f7653e17b8c8=
63e
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa34fa686b0b1db68c867b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixe=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixe=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa34fa686b0b1db68c8=
67c
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa375038d1dd4dfc8c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa375038d1dd4dfc8c8=
640
        failing since 11 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =20
