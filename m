Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B842716C
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhJHTbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhJHTbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:31:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C70C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 12:29:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l6so6766115plh.9
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 12:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/YMjjqgk/otpPD4gP6G7J+FyKCbr2J/KwbF7V8z8j88=;
        b=DvWeqcVt1vQGKFFOapCYe3jFh8vxvNUrAiQLUCYn/21Jk7RlEm9tgIjrcMaFgyfig4
         6zyMrRs0dOUdfDor8omUrloa7Kdck9pqUIbSP+pguly/AWPlZGBl/ZaZsPORCNhNCXFN
         WF98R8eIRemeSt/CnY7UmDmU3XiiXcQrYZupiO/nkPanPOPeIoVTTwL+fx28EQTLnhul
         l494TRGRptQaBNi18yK7TLmAR7qoCdLXHBNwodHRt54P28XSPLvqegUZaTT/qs84b0zF
         7ieRPBqqTUqGx4M4cBR3g5ST26vFh9s7PjtUL1C+Dw/LVoCSTgbE+/Jex2OLUODnxDEf
         vniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/YMjjqgk/otpPD4gP6G7J+FyKCbr2J/KwbF7V8z8j88=;
        b=jDSs0kulqeNHzczOUjIWmyfM7LPTHexay/J0van9bXlPXxvHTbNY2BibEAVP73Mnei
         NluUZF0/lNCO/4CXg2sJcuAfZGSC/eL7jHQRDets7fsLtHeozp+FW5i6mYK1Dbx64pOQ
         GEYbbHvAU5lKVWqYDCUUTfygrud73f434eKAVIEQcUPtOCXbGAN7oW6BMDuzWvZajh+j
         v1Q19AnsktEsy31UCYF7d/2sdb2dHgxy62kop8DAYoCTtNqoR9QQoBAUtKO0mw465uj3
         xBBOImz3vsG1JXL6UwKdi4OPw//KZRMS8I3Yoq0jaZIAJTmhTqhWHNGVwn4+jwooa7FT
         eX6A==
X-Gm-Message-State: AOAM531YzVHlXGLgHnSpxE29K5PJAcyf8moPdU7RtoSTDCk+q5BfX4dJ
        NKiBO/O+fFt9FE/ez+FRK0IQThQwcZANL2h5
X-Google-Smtp-Source: ABdhPJxQ9y79FNvSnAOXquK09j8GH/Ls/RaDrWwUJczLzu+nx38sGHntmvTFwRhgHO9nWJML8rRi7g==
X-Received: by 2002:a17:902:b490:b0:13d:588b:d857 with SMTP id y16-20020a170902b49000b0013d588bd857mr11024921plr.16.1633721366411;
        Fri, 08 Oct 2021 12:29:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm132444pgp.30.2021.10.08.12.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 12:29:26 -0700 (PDT)
Message-ID: <61609c16.1c69fb81.5a44e.0925@mx.google.com>
Date:   Fri, 08 Oct 2021 12:29:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.249-11-g7d769cc629ad
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 130 runs,
 4 regressions (v4.14.249-11-g7d769cc629ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 130 runs, 4 regressions (v4.14.249-11-g7d7=
69cc629ad)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.249-11-g7d769cc629ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.249-11-g7d769cc629ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d769cc629ad98f5af7d44e0b70717708a7b323e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61606575eaf6f1316699a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61606575eaf6f1316699a=
2e8
        failing since 328 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616094974bc48865b999a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616094974bc48865b999a=
2f2
        failing since 328 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6160656cdb786e3fcf99a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6160656cdb786e3fcf99a=
2fd
        failing since 328 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61607842fc706e53b199a31f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49-11-g7d769cc629ad/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607842fc706e53b199a=
320
        failing since 328 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
