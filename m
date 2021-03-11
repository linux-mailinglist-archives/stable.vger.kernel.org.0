Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8198338185
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 00:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhCKXeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 18:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhCKXdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 18:33:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CC3C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 15:33:39 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 18so605006pfo.6
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 15:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ttfMdwBIqUD0/20TamgB7omacKT+2eJAdlZbwsczKA=;
        b=N0kebNcWf8jyxBIkOAriRaDCdq7xFQbwJM50gSHqqaKDbE6eQrC/C5rT9CT3O6i933
         OCC8tYfJcY32QqBqJ4lLLscm8L1y8lSg0B/rJFyR+XP/SZViJcS1Z6um/BqJAWj9WkYU
         Tw435W5vmf4HLEhfm8WdIvuJpDG7nyjYwk4FedujvUHhClDoL2svfn7eb5gr4WRYDeI2
         11MC02nWhpeQ9Y+8bImqD4IrXUd7ubJsqH0O8FeOrE5fZGqADn6cjn6rZNWf+F/CiMQ9
         FgdVDo+xGN0+PX1N51dSvPFHJpQ4PqXFlcFHMXBxZ43M8ig7b8/n9Q/KSuZGyq4BySgW
         Y/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ttfMdwBIqUD0/20TamgB7omacKT+2eJAdlZbwsczKA=;
        b=L07+kC+WV7z23I+SY0pnSq+Aeogbx9IPGSHu1Cwfz7ghBkUm+2hRuaZrJDOKaYqU6B
         p3mq8HZRYOKvdP1+DNA3ZUubuRozNfiqhs+xqxEsRvTpXHz3RyzGXt4tmDnyx7zSbC3B
         iaszjfp5g4G03XNu8ctp7dB9+LW9kP2FXDQWRmJGcOln5faWU+4ysjHkd7uIaBygkROd
         vKqGqyJyeFTNr3y88rVVVqG58/9P1afLciHtMKgd3yTmItNDJu5/cdN52PGQnyKjY9iL
         B0Rc1ErkoZuKLqZNG+kvxDcBKJbRuPkMy4lKn7GTThtTa4HPx6xUsCSfXslUa63dZd4l
         H2Ww==
X-Gm-Message-State: AOAM530xGb2khCh8XF19cTT086g8mlqlfjmF+8m8yRmgOBR5puTOw/s6
        ohkuyOEIA7vdL73PXRt6zXobfesci+BxUcbA
X-Google-Smtp-Source: ABdhPJycs8QIUJnBTR5p6vnwe5QstFivaTcko0lWFBDmwbPFz1uoeu37I7M9M/1lZUzUSzp39/oUAw==
X-Received: by 2002:aa7:9493:0:b029:1f8:a493:b747 with SMTP id z19-20020aa794930000b02901f8a493b747mr9825290pfk.41.1615505619080;
        Thu, 11 Mar 2021 15:33:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id il6sm158090pjb.56.2021.03.11.15.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:33:38 -0800 (PST)
Message-ID: <604aa8d2.1c69fb81.d24ce.0c4c@mx.google.com>
Date:   Thu, 11 Mar 2021 15:33:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-12-gac6e3f484ce66
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 78 runs,
 5 regressions (v4.14.225-12-gac6e3f484ce66)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 78 runs, 5 regressions (v4.14.225-12-gac6e=
3f484ce66)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.225-12-gac6e3f484ce66/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.225-12-gac6e3f484ce66
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac6e3f484ce66973debf20d6f035ba453f804c1a =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604a797ce4756e6cf0addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a797ce4756e6cf0add=
cbb
        failing since 28 days (last pass: v4.14.220-31-gc7c1196add208, firs=
t fail: v4.14.221) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a74174f55bf123caddcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a74174f55bf123cadd=
cc3
        failing since 117 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a74204f55bf123caddcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a74204f55bf123cadd=
cd9
        failing since 117 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a7413c25f281d62addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a7413c25f281d62add=
cca
        failing since 117 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a73bc734a539f40addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-12-gac6e3f484ce66/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a73bc734a539f40add=
cb2
        failing since 117 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
