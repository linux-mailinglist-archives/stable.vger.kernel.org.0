Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFB2D6AFC
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 00:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388204AbgLJWbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 17:31:15 -0500
Received: from mail-oi1-f173.google.com ([209.85.167.173]:35624 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405121AbgLJWY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 17:24:57 -0500
Received: by mail-oi1-f173.google.com with SMTP id s2so7590751oij.2
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 14:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AsXpq73TurOiMjNQS5YGPB4GOjuRJVAdAsO5KjHejoo=;
        b=HDLuPi+1aleyCgc60v6HTHhICaIzHYtIWg3YjGIBJnPm0I0uYOPqXOwLdCCZf5HJfD
         N+L8LtbgLAWfF79ZTlaP76Ka7lL2Otc6An974OPiLDVM2xwvzJTifPteMxv0RQezVqvc
         QxwGA9UBcvucs+JDoeFSpj+3EiDW70SYZLXsBPh7j4hxa8RtFi6P02cst88HGHaTlrvH
         J3ebB4bVnKh2qkp9AwqeKLRu+3R4zlRp6eFYJCO5f0uJGKstoQ2P5y/6l2tWUWIiPHfv
         HbNVvB697gfrXyMeEsrembmtM2TgKO9iF5YJh9orKkoIwmgK3QoPqy/kfpd2I1idR36W
         VjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AsXpq73TurOiMjNQS5YGPB4GOjuRJVAdAsO5KjHejoo=;
        b=GoY8XKtXcQujwEaWx4xvCMTQY0DY2VEzoJ/BQuT8hYTbd5S8WGf/yHkxYYqdU+WxwE
         XmmfZhBq6r716sOgMMbYyWr5z4WLGmv1Cu9tzzI/S1P18PSG4fVsI13FBKeX3h7OC1gt
         3nCX0grPKwpRu6hzrH3l7CAj0oMcwwJjshWNOUyH6r22Ns960dWFzqNP9tpDCEK5Ahio
         j1jC0r+1sAULEzNqwRkMeJgAZYOFqnrCleHYImjujHJ3aQkOKxuDgOcpq0UWtUZ9SrBV
         u+GZhrAxZ/QnG11Kn5kucdzFBlateP+Lpecu9UxW8cY4l7SpuLAhMGVVPvVmIl+EuyKi
         o37Q==
X-Gm-Message-State: AOAM5315ErBmfdnUUndJEHQq9GcHPErpFy/QJwX58UdO7qKLNuDG3EQc
        TnzXEwhHmZZIKprVd59HMifrMwaEylL/iQ==
X-Google-Smtp-Source: ABdhPJyXrpcbe9cwPCNGXjNb67MGg4TmT1LcJsOJtOXY1qlpC1Bj4Uq2dy2ZBsLvO5db6qi0RECFZg==
X-Received: by 2002:a17:90b:3682:: with SMTP id mj2mr9684935pjb.27.1607637008552;
        Thu, 10 Dec 2020 13:50:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 123sm7300270pgh.21.2020.12.10.13.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 13:50:07 -0800 (PST)
Message-ID: <5fd2980f.1c69fb81.8a64c.db47@mx.google.com>
Date:   Thu, 10 Dec 2020 13:50:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-55-gfc1de0dc4276c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 177 runs,
 5 regressions (v5.4.82-55-gfc1de0dc4276c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 177 runs, 5 regressions (v5.4.82-55-gfc1de0=
dc4276c)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.82-55-gfc1de0dc4276c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.82-55-gfc1de0dc4276c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc1de0dc4276cf610646922e65df5ad81151ac1e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd262db0cbffadfbfc94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd262db0cbffadfbfc94=
cf1
        failing since 20 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2636e792ddabc85c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2636e792ddabc85c94=
cc0
        failing since 26 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2639c3df0c783bac94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2639c3df0c783bac94=
cbd
        failing since 26 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd26373717f7ab11dc94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd26373717f7ab11dc94=
cc7
        failing since 26 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd263287e334021e0c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
55-gfc1de0dc4276c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd263287e334021e0c94=
cd6
        failing since 26 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
