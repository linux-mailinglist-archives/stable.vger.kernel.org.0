Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339626A2B0E
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 18:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBYRUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 12:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYRUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 12:20:46 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BF51287F
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 09:20:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z2so2616481plf.12
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 09:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ykaAle1KwTMAR2VZmDws5B0eaiplZlfcAAdVi8VBZpc=;
        b=XuqsXf+du5t6IXmZVD18ID22eyqsBdRXtaE5ncvQCkPNwVsqicClGz7Kn9Xr9uoLCY
         JzwKB/GOFwLDdVRRkknkeLbvZnzJbJrJwHnD+gCyWIWGIULcdKKOtvkWnZcylSfgy0No
         uQKuDyi+K8FLpSFeJB+Hx8f1YahDtfY3clU3XaTbXE6HRpobq0s7CKS6t4/pJcUagDbg
         ghVVbb9nbuqNwn5/+3I0Mky5isdGwfSVBh/9PvYr9f3I5YUevpVEOrmT4CsrY1abCmo2
         pkwZ9VCKEleyLKyKHEmRscIruEj4EOIWzqMscr9gBB2W+Ler/AhrXKaP4pCtR6XJ7n2f
         CpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykaAle1KwTMAR2VZmDws5B0eaiplZlfcAAdVi8VBZpc=;
        b=xMGqEQCak9t7qcV27xaDWbkNrwLxXaXIFURWoMhH9Epb6x/nmU1QoIu5Hyum6EhdUq
         AsR605Z2eAx4a4QB5Un3nC7eeKudhQxoLcuH44wu+3YOWXiFl9kkoxxZFXfPLnvZHya0
         ZdYU97k4E5sNt4Y+WXZ1vFsFW2SqHQpHHgkkFuYswHkh9bwqTkf7gkyQU7AhG2V0nRvC
         +RaLZ+PhcIY6+H6prHUdZl4PETzDkCko5u09qyyV/LLgumyQQKPu5w1E+JX1Lw+jIhHJ
         pq3f/wyU5K4zlDAqEdHmeaRf4z7aSSS94eQqoYpGKoiI/BPNemH94GbzVOHNaPUJpLIr
         5tog==
X-Gm-Message-State: AO0yUKW/u3Jss302cRA3jxgrcFm6laZegKzoaX6G6RF6mdUaGQB4ijts
        zpWyPH2Psn+t2nudkbEt2AzIaL65Mzt4H78tnrBTMw==
X-Google-Smtp-Source: AK7set+qOZ9twJxGa7spyDY2qzIS6Et+p+eMEdazJYGgZGvnpLV6vdfPSDXVd6KBGkoI+vOCoAbqBg==
X-Received: by 2002:a05:6a20:748d:b0:cc:9ca2:8b5f with SMTP id p13-20020a056a20748d00b000cc9ca28b5fmr4564689pzd.15.1677345643332;
        Sat, 25 Feb 2023 09:20:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7918f000000b005d3730383a7sm1419583pfa.220.2023.02.25.09.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 09:20:42 -0800 (PST)
Message-ID: <63fa436a.a70a0220.97c80.220e@mx.google.com>
Date:   Sat, 25 Feb 2023 09:20:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.170
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 144 runs, 15 regressions (v5.10.170)
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

stable/linux-5.10.y baseline: 144 runs, 15 regressions (v5.10.170)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-baylibre  | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi           | i386   | lab-broonie   | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi           | i386   | lab-collabora | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi         | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

r8a7743-iwg20d-q7        | arm    | lab-cip       | gcc-10   | shmobile_def=
config           | 1          =

r8a774a1-hihope-rzg2m-ex | arm64  | lab-cip       | gcc-10   | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.170/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.170
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      22d269bb30db7f5a4e71a8a813a0f4df5255f7de =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-baylibre  | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa1028de5efe8aeb8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa1028de5efe8aeb8c8=
630
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-broonie   | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa108ac67af7cc298c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa108ac67af7cc298c8=
652
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-collabora | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa1027117dcde6f88c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa1027117dcde6f88c8=
64b
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0d941af73e3e458c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0d941af73e3e458c8=
638
        new failure (last pass: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0ed571bbd0df6b8c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0ed571bbd0df6b8c8=
649
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0da5c5d8325b808c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0da5c5d8325b808c8=
66c
        new failure (last pass: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0f22ad6be304508c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0f22ad6be304508c8=
63d
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0d92dc17e9f6788c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0d92dc17e9f6788c8=
63b
        new failure (last pass: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0d95c5d8325b808c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0d95c5d8325b808c8=
63f
        new failure (last pass: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0ed4e2d49ec9ce8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0ed4e2d49ec9ce8c8=
630
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0dbacf27fe3fb48c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0dbacf27fe3fb48c8=
635
        new failure (last pass: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0efae2d49ec9ce8c8663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0efae2d49ec9ce8c8=
664
        failing since 2 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa0d93dc17e9f6788c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa0d93dc17e9f6788c8=
640
        new failure (last pass: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a7743-iwg20d-q7        | arm    | lab-cip       | gcc-10   | shmobile_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa1accd00a07cb598c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa1accd00a07cb598c8=
630
        failing since 19 days (last pass: v5.10.166, first fail: v5.10.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a774a1-hihope-rzg2m-ex | arm64  | lab-cip       | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa14f3ce1a7e40548c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.170/=
arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa14f3ce1a7e40548c8=
635
        new failure (last pass: v5.10.154) =

 =20
