Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5063CAD54
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240937AbhGOT54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344957AbhGOTtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 15:49:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51A2C077CEC
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:15:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g24so4785880pji.4
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZrkU9Begpz8LWSbFXroRZsZEFcNAz0CSPbTjqaN3/bM=;
        b=v4yfCUFxFXC0gcEBy+B9D/oFjHEuF6ceIbAeFRjkovYQB0v5wlx+PewQD5OnxkFASH
         X0RDaCT6BjMcVF8XB6/5pQjhzbFK+xpRQ5A/XQefXuANhyhAdugALe4o1ojJX13GZrKF
         Pd3PsZs0mdygRp5TbuZXrA+t+GRKuxsEZI7ofU94jeXq6ir9R8fjAWKbXdEQ99yG23MG
         EYkcVQYx8S2PwV7uCUBmyCq9ygIhtF3duOmwDJb5mN6lF0nUeaeLbIRLKYz0Fp3W6AFM
         XQfywS8SWI2mp8CwEq3jycI69IGg4WblMPcXSUPiIWU0FnLsmVizECeh7kZCfg9oyePT
         rdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZrkU9Begpz8LWSbFXroRZsZEFcNAz0CSPbTjqaN3/bM=;
        b=ZspTyuoFPgCpNPz5+oN92hjEAoKw6pcPfpndGLHm67cVnyQkVPXJJdMNbXeaIA+MJA
         IDeGp9Cb9JKgo4qFOcOKKj6ZOyYe1hdkGQ+RNfVTHq9FphJkwud8duaDp0NbnaRRBVlw
         HOJBiEW8dgveDZqkamTNmWDHKOIPbdTtr3XcrS6qQN/G1gxTdWTMT6g8+hOKf/ocBsqO
         hzseW7Y9O0M2VbQPhYKWymvHnKDix+fvrxpAC/1/dnjPeB0VG9vb7PkT9+CYzqn02Aac
         0pBQj0k+nDSb34P+e2tzfssh+c9cnOPC9Hs8mIA9Os6PH2augeaUCqMf7f8K9m+GzAiB
         MhnA==
X-Gm-Message-State: AOAM531tr1v7FcD2Iv3t7tRSqBNnT1xcg2AnBicBuzx33pO2Q7cOy1fj
        N9RA4k0C89E3aW0NjPASshEuy8yrrushw1O7
X-Google-Smtp-Source: ABdhPJxz2+GosdH/0CRwHS/X8n+rx/cBRg1ntWjRSgdkcC/6xssZ1aICj2JE/zadYlDf9jfyZSa9yA==
X-Received: by 2002:a17:90a:a6a:: with SMTP id o97mr11810213pjo.179.1626376531997;
        Thu, 15 Jul 2021 12:15:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm7170715pfc.10.2021.07.15.12.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 12:15:31 -0700 (PDT)
Message-ID: <60f08953.1c69fb81.aaf72.6dc2@mx.google.com>
Date:   Thu, 15 Jul 2021 12:15:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.2-254-g761e4411c50e
Subject: stable-rc/linux-5.13.y baseline: 201 runs,
 5 regressions (v5.13.2-254-g761e4411c50e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 201 runs, 5 regressions (v5.13.2-254-g761e=
4411c50e)

Regressions Summary
-------------------

platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig         =
  | 1          =

beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig        =
  | 1          =

d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig           =
  | 1          =

d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =

imx8mp-evk | arm64  | lab-nxp      | gcc-8    | defconfig                  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.2-254-g761e4411c50e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.2-254-g761e4411c50e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      761e4411c50e1f3338c5e490280aee65cb18ba05 =



Test Regressions
---------------- =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f056a77dfced6bb28a93e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f056a77dfced6bb28a9=
3e3
        failing since 0 day (last pass: v5.13.1-805-g949241ad55a91, first f=
ail: v5.13.2) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f057fbfc89e7a0508a93a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f057fbfc89e7a0508a9=
3a1
        new failure (last pass: v5.13.2) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig           =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f05532ebd4809b428a93c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f05532ebd4809b428a9=
3c1
        failing since 3 days (last pass: v5.13.1, first fail: v5.13.1-783-g=
664307fdb480) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/60f056867dfced6bb28a93c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f056867dfced6bb28a9=
3c8
        failing since 3 days (last pass: v5.13.1, first fail: v5.13.1-783-g=
664307fdb480) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
imx8mp-evk | arm64  | lab-nxp      | gcc-8    | defconfig                  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f059bc05e9ab57eb8a949c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.2=
-254-g761e4411c50e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f059bc05e9ab57eb8a9=
49d
        failing since 0 day (last pass: v5.13.1-805-g949241ad55a91, first f=
ail: v5.13.2) =

 =20
