Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF953A3457
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhFJT4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:56:38 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:34491 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhFJT4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:56:38 -0400
Received: by mail-pg1-f170.google.com with SMTP id l1so622782pgm.1
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yd+OUmzNloFu3sfODFPSwFP92eHA/vDn1N1c6fEfFP0=;
        b=DX8vzAXiCJ3kHm/VuJrzkPLbGMovLzLns+et16M9RlvjGW97/Pr+mfvYFC2Fq/NuK3
         8S7Xx+YPyLtoXcnaX33Ky8DlqpR2UF55/kildkRCHrzXRlDXMA+WezXEteCJZKxlQQaW
         6q1BuG8iobMwVTSIeHCKtn3wgh0c4jEXYSDeI4fLaIlwljXo00b148mlWPHmqtNlrL8v
         K+OKCE9nuBauQKtFCBeRGa2x9tryZAG9B6ZHfiDgRApvtffuAadnAXKIdiI7tLtxr0ix
         MZy925iW7uFB4x33t/6uVd1haNdEk9LkMutsMJAg3+0xiIVnQqNJudLmg4LZV37gUVS0
         RxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yd+OUmzNloFu3sfODFPSwFP92eHA/vDn1N1c6fEfFP0=;
        b=FYzHCndRkbOIwKQZ5+MJAatx5Ecjc97ih1T1gm1XIIh/ihr2E+KbMgnf5EXOSwLped
         giGV0uaMXMij5SkmIS4ti7IOw0BLuoeDGqQzCpSMPjXE6ynNPIaTCqJXYBJ7HTphEh46
         fCNSvd1krxteLbI+gMy2MchOmTmPZ4hc/bxpTNOE6hS/CkUtQquwYiHbVe3sAfYhBRUz
         Vi+Aw99mmqZ4eiU2OQ3ero2keLQvGm0P+z4Ky/mKmRBVioG90FTbd6ifWM1O3dAGug9E
         wWeU7xz/QL8vtdyRdabkZ3OW/G4pjbuA/JQpAaCZmpcMREMFv4h/IXxWAQt85i28ouxD
         oY0w==
X-Gm-Message-State: AOAM531a/H/tStMzK73iVlfWx+B/ff9ZNmjdD2aopNm4BAyyxxFk32MX
        p5T2Ayb4aDzklyAIwnvLRSAnxuERis3csSvU
X-Google-Smtp-Source: ABdhPJxxSovfcNeplmNjtTre6ZxVF1SYNRM+vdontQB+hTIR/YVQL46rHhWk9wtuG8mx/+igrvvqUQ==
X-Received: by 2002:a63:b955:: with SMTP id v21mr84308pgo.230.1623354810907;
        Thu, 10 Jun 2021 12:53:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm3388896pgl.39.2021.06.10.12.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:53:30 -0700 (PDT)
Message-ID: <60c26dba.1c69fb81.38265.a9a5@mx.google.com>
Date:   Thu, 10 Jun 2021 12:53:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.194
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 146 runs, 5 regressions (v4.19.194)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 146 runs, 5 regressions (v4.19.194)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.194/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.194
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9a2dc0e6c531d595bcdf2c66d0be131679bd02df =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c23c9fd58817a33d0c0e11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c23c9fd58817a33d0c0=
e12
        new failure (last pass: v4.19.193) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c23878e4ceb0bae60c0df7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c23878e4ceb0bae60c0=
df8
        failing since 203 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2387ad31bf4c8e50c0e12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2387ad31bf4c8e50c0=
e13
        failing since 203 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c23874d31bf4c8e50c0e03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c23874d31bf4c8e50c0=
e04
        failing since 203 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2382fb56ee199790c0e05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.194/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2382fb56ee199790c0=
e06
        failing since 203 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
