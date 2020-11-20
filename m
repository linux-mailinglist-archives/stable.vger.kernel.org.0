Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACC12BB0EF
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgKTQuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbgKTQuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:50:15 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8337C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:50:13 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 34so7743915pgp.10
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1ZgreufGw86/Ycy+bSzn+pbDga2xeOeQLCqMYGibBXU=;
        b=veL0+cF0LtR2atJCWrKI9u8kqCRLOm39nTpsDJZpb1N4aDdH0yITH0LcYV+i1GHUQu
         6CWM0inIjW20Ki5jcWGSiowjFiS1qRP+QsPbTB6YkXHaD1fsBtud0l5hRgYcZeXV+Lmk
         3/kUiH1OvZFQEU6i0qtXTNhIkdksWtrdKO6RAP7bPXudvkb+ZBUcOgyP+vDgUyTRRYZh
         1erQ7AnhOdppGBhmdkQ7gFMmJWjArOb1mBcrVzAnggYiKFl4iusqSTBnYuddRY3gQtXj
         J3R/uFEBMQf3oMzCFffqZpenHYytfYx83Ho4CB0oQjoXWbMot174V/h72c8pirOOU3se
         Mafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1ZgreufGw86/Ycy+bSzn+pbDga2xeOeQLCqMYGibBXU=;
        b=XLEMumJrUwqxZpclkUY3aWYJfHweyfkIiNiemzGtaO6QDd7sfbg/Sy0QP84Q0cMTBT
         sC6vEqXSGTqxzHf6z3Ns/VLkAMJLurVeszXaDa8nGnWriiDxGTkZ+IEcm+ts1W+naYzN
         uc/3X5r1UV71EdEHnlfM5OhZVODlHZg8zDV8MqwU04QZkDFAQa2hcTRZ8MARAQpocw6H
         Tu9I65CWjZS1oApMh7kVIxOHcZPc0rUjWLMrTaITDaNELKSIxfeiHIZDhDuWnu2WtDZY
         BoNClLJ/Aeikk2ne6+dE55kWnJTgzjI1qq+ezGY7187p3neKZUYAKonUneZxRxheKTpW
         JSCg==
X-Gm-Message-State: AOAM530tIopIALQReF7xMENj4DixLWcu0bQxAHaKPhcuPkh/1p0Icnd0
        yxw5mPwHbxP2wtoD7qSj7csu69/GxrIZWA==
X-Google-Smtp-Source: ABdhPJzhWhB3WxV+KPp+tLRiifZlxfcGECuIqLLsGZay7UXClIOI28r9Y6cyQODz0Wkhw9g0s97oqA==
X-Received: by 2002:a63:3117:: with SMTP id x23mr17646416pgx.306.1605891013029;
        Fri, 20 Nov 2020 08:50:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm4113264pfe.65.2020.11.20.08.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:50:12 -0800 (PST)
Message-ID: <5fb7f3c4.1c69fb81.bf8d8.78a2@mx.google.com>
Date:   Fri, 20 Nov 2020 08:50:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158-15-g5ab11a539ca7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 116 runs,
 5 regressions (v4.19.158-15-g5ab11a539ca7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 116 runs, 5 regressions (v4.19.158-15-g5ab=
11a539ca7)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.158-15-g5ab11a539ca7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.158-15-g5ab11a539ca7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ab11a539ca71c870174aca46b388b09581e06c0 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c1ff9377b67fe2d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c1ff9377b67fe2d8d=
908
        failing since 157 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c2e315099b8df6d8d90b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb7c2e315099b8=
df6d8d910
        failing since 9 days (last pass: v4.19.155-42-g97cf958a4cd1, first =
fail: v4.19.157)
        2 lines =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bf14919c0ef167d8d938

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bf14919c0ef167d8d=
939
        failing since 2 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bf463c88063249d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bf463c88063249d8d=
922
        failing since 2 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7becdbb130ba23ad8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
58-15-g5ab11a539ca7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7becdbb130ba23ad8d=
905
        failing since 2 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =20
