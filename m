Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C203697448
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 03:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBOCSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 21:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBOCSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 21:18:46 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F7E2D14D
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 18:18:43 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id be8so18906219plb.7
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 18:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LjkUztqkFb/XLy8W/W3ZxIK7Dl4VX45xob33K+MS8JE=;
        b=tcJp9C5QlHxSHjSgGMtjr5QXevw/R9Oola4T9kaVecJP3iK9+i6AsiZyN3mADWogF/
         RWU30n8FicyhEtBEpL8M74AZz8rVh5xoXO7LSmB7KsnY6ZQ38gLzAoSiYapAGKwxB41B
         GciTUFCpRy2aAFtkto8jToYXHTo9pPJWCfxtFVoONANOAT9qNGU84u72EvjEG2yczK54
         IIdlQd0/mUik2k08wqBmufG6veEsdaHV7sYfEV+NeJ2pYVg2m1+ZkyIH65wNHdAW6ojM
         RqdOPl8c3Hr8JwwKIIMl9nsP3NfzK/CLadguzM8UiUs35TcGE5yVYWc4VO9KxtoX3ZGL
         S6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjkUztqkFb/XLy8W/W3ZxIK7Dl4VX45xob33K+MS8JE=;
        b=SDY5deNt7ISl0wIaYvOi2iqH1o6NcOlZWFUXrKHkUxU8qurLZg6MTj47LAO2yNEQsG
         WFJe4KYb4P7IOJm8IIMEjUjR36XglJNSCzgbkmoK6qwe/Ea1IJh9hZglePwqC2XTPoiw
         gWu9WLxJx0WfetbeIq21L8P4jRRUZBd/Cv1VF8VTM26pa+5YK42Gx8Vr9bX4E08VNHYN
         c3ve7rMe+o1UHDSLa8s63iqGtO4MBS+1fRYozDWJ0eRpNkbQQC2lf9x6vv1sYVRHqiZH
         Gvfb8RFW2rjgr/LjkEh6unYQ9DqZQcR66fmCSogQ6cS1MSZKR+Nner32YJRHTMyRSpNj
         413Q==
X-Gm-Message-State: AO0yUKUjHjtBdxiwIAJ0R4tCrDqSzBSjc3kgAhe5NXP4BZH0hNXuARrq
        yQnzW6D4wBOwFnMOAI7NLlET8JwpazZKcfYV+Z0=
X-Google-Smtp-Source: AK7set9b/DYEVmMMP6DygKvOtNGhTJGs0Frer4sjiDitV/o2tnG8HLxw/6PP8gn0WV1OgH1nvTTXNw==
X-Received: by 2002:a05:6a21:9986:b0:b8:c6ec:a269 with SMTP id ve6-20020a056a21998600b000b8c6eca269mr315479pzb.16.1676427522892;
        Tue, 14 Feb 2023 18:18:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3-20020a62e903000000b00593225b379dsm10454767pfh.106.2023.02.14.18.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 18:18:42 -0800 (PST)
Message-ID: <63ec4102.620a0220.1ff34.3c01@mx.google.com>
Date:   Tue, 14 Feb 2023 18:18:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-133-gf90240a238a9
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 172 runs,
 14 regressions (v5.10.167-133-gf90240a238a9)
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

stable-rc/linux-5.10.y baseline: 172 runs, 14 regressions (v5.10.167-133-gf=
90240a238a9)

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

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

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

r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.167-133-gf90240a238a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.167-133-gf90240a238a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f90240a238a9596894598787d667151f6af55c58 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0f215e500a371c8c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0f215e500a371c8c8=
652
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0f4694e3498c948c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0f4694e3498c948c8=
638
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0d2d23d43dfc268c866f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0d2d23d43dfc268c8=
670
        failing since 0 day (last pass: v5.10.167, first fail: v5.10.167-13=
5-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0fae1ca4c907f68c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0fae1ca4c907f68c8=
652
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0d52c2122fb9678c868a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0d52c2122fb9678c8=
68b
        failing since 0 day (last pass: v5.10.167, first fail: v5.10.167-13=
5-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0fe6231addac478c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0fe6231addac478c8=
635
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0d0087006e087a8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-=
qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-=
qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0d0087006e087a8c8=
630
        failing since 0 day (last pass: v5.10.167, first fail: v5.10.167-13=
5-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0f94f3f7c3d1458c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0f94f3f7c3d1458c8=
637
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0d2ede518498428c864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0d2ede518498428c8=
64e
        failing since 0 day (last pass: v5.10.166-100-ge9ce3cb0864d, first =
fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0fad254b856c888c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0fad254b856c888c8=
64c
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0d8ee9d59392848c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0d8ee9d59392848c8=
633
        failing since 0 day (last pass: v5.10.166-100-ge9ce3cb0864d, first =
fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0fd2f7e07719e68c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0fd2f7e07719e68c8=
63f
        failing since 1 day (last pass: v5.10.167, first fail: v5.10.167-14=
0-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0d01792156cfb08c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-=
qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-=
qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0d01792156cfb08c8=
659
        failing since 0 day (last pass: v5.10.166-100-ge9ce3cb0864d, first =
fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ec0ebaf51a9f99b68c8682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67-133-gf90240a238a9/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ec0ebaf51a9f99b68c8=
683
        failing since 0 day (last pass: v5.10.167-140-g65fa84413c15, first =
fail: v5.10.167-135-gd76a8be7803e) =

 =20
