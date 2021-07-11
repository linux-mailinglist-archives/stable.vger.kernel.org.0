Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED293C3EA3
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 19:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhGKR7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 13:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhGKR7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 13:59:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4128BC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 10:57:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s18so396838pgq.3
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 10:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o3MPVBRK4+oKK+ZcO+Gls/BxB18vHfaoIGXHKNVPgvk=;
        b=qkrrjqUbVMefjF0oQB2TYjbOgHpO1vhSdVyX2vT9xkn7VCfTmeVDK6yx3qUUDTIgjG
         ooSa6H1wUIfIaYjClw7ZwCWI9u/X4xvgKrbcwuwkOP5FWFoCYGl+VC3VghBDRkXk1W0i
         5QZOzXb+CrCVqe9z4XijoS4GS06N6DMZzOaW4JM4VxNjyKuUgz/S8JYO0Vj8oohfBCwv
         n1kkQZtods8aaICUexuYtl6RHRHYzAxGeIekUlJBDiTy9r6fGf5M/jbkRtISelECAbBF
         6yCzoI9PeqEmndxb2HOnEYNAvEjlRmcwP5LKy3kKs/o2+vlxlyhm6Co26be1CuAGNGLw
         B9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o3MPVBRK4+oKK+ZcO+Gls/BxB18vHfaoIGXHKNVPgvk=;
        b=PwAAH/0UArBdYhrVhtFcjdJCtUxE5FUrpJKKs6vWpuEN+mt0qL0UxSrPI7UVDZY6D7
         c61M9n1InSe/6xoSJHRTopcGiZuw/QRmfjhMknq3CHAF2X3Ye7RvSTEIWHO5FAsdaY/R
         KSdd6uuLvC4KQ4zQ/aouKnoDJm/UicGforu/qGLw0l04DEXw0x/8yjDW6S9jCfgVO3fu
         mSKODfM7hN5Jn7p5EGbsIPWiblvdhfpIk+3dlGh4YLclJ6bcUEYnERCPFiGdPIWl0jK9
         W3EmzuPiIE5icOGC4PGo10Y16Vh5uhgA4kJv+Vh4dv4TZcyeA0COKZCQANX4LxtXynBg
         A7tQ==
X-Gm-Message-State: AOAM531bd7eZw+6PEQCMWjaKgQIFNIfvQHPq3VfS0l2wdpORfTYQJ9hl
        wJv7f9c9jjVRbwSJsEAJoGKc1gANSmwLgrYU
X-Google-Smtp-Source: ABdhPJyIln6Eu4muGlQE5uNRskz4DD+FvuFh/4kSmL83SmxCm3r22l7DtAFr0g3ZuDQuR65GlcbsoQ==
X-Received: by 2002:a63:1266:: with SMTP id 38mr43125268pgs.154.1626026225619;
        Sun, 11 Jul 2021 10:57:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm11181243pji.52.2021.07.11.10.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 10:57:05 -0700 (PDT)
Message-ID: <60eb30f1.1c69fb81.1007.12a9@mx.google.com>
Date:   Sun, 11 Jul 2021 10:57:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 224 runs, 2 regressions (v5.13.1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 224 runs, 2 regressions (v5.13.1)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aaa1f5834d71fe7b687a0c41834bd8d4cc733d90 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60e776591f1807404b117a20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e776591f1807404b117=
a21
        new failure (last pass: v5.13.1-1-g80f33de843bdd) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60e77961a2e8b17fe9117993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e77961a2e8b17fe9117=
994
        new failure (last pass: v5.13.1-1-g80f33de843bdd) =

 =20
