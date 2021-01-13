Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E52F52B1
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 19:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbhAMStq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 13:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbhAMStq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 13:49:46 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCE4C061575
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:49:06 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x126so1781913pfc.7
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fq3uHNHYF3+p+TeamNgg9rIqGhtQQdty9uPVoK4ty9Q=;
        b=gSCDls801eMRRZkHTWcVCpzUbg/mlwW3MIECujS8JUq8jXgzHhobrjrLzs3rkVCyul
         jn7Ywt8C64qMaZbERlBJ1yIfxbwhPPycIt7nToqZ5JJxCOLFXZyP+t4keWrojm+OhDcn
         WXfjJMmBC3nkJOoPl55AaYrEFe25eUPaWVjT4Ork1z9mJI2RS0thTqbE50ot01Q+iDHu
         YOmGTQ0qauheIKxqSK/KqfXopnjPNaOGcqvnkMEG7cUWNakU9IpwxS7X33sfBNMqKvsy
         YXNm5trrZOF1vifP0lbgcFfnBGbTNiOaNr2fW5G0qRnuwAtgY8JSyr82gaBKMSaCOQA6
         mBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fq3uHNHYF3+p+TeamNgg9rIqGhtQQdty9uPVoK4ty9Q=;
        b=b4okY9gDxga+AIukyYIPcbdU5U55pnvDFI23bA3rIpp2mM5qGEmAdSjfMmgik+btEL
         UUGWdHjpngo0QA+qnKfx0+Q1vunBQ2jyIsA1qw28yLjdAn5Y9XgpzqHAD+LJ6renLmeK
         uzUCxNy0bnChOPFeBbeIMOa7p1oFrJW+PR9SmoPa4vskpKFx7Y/cMnOcFAI2qVbspKaO
         drAVO40fh7/lFTXwQMoBHXt0S32Pico1XCVY+3JSBJMJHxVPZnuJ7F8EOZ4rxEdkaE2O
         jKPoNowJXd1ltW3FgvyvVhkv/LUWThey8S3l/0Cd0OvVy690RjHH8LY2kjoFR+d78Nik
         VX6g==
X-Gm-Message-State: AOAM533zjKOWsnL5Zq1H8ILyssJOIcrALvnuOyQyGeV5AGvUM8994NxL
        wG9KlZcXoOedfh+ML/ZBXk3IYOetTy7BJw==
X-Google-Smtp-Source: ABdhPJwzOqTyjK+Ik2tT/WElGB+cZn4nVGbOdr7bqZJ4FSrBk+/XcucGrL0Vj3/uw0YEQckRiSZUNA==
X-Received: by 2002:a63:62c3:: with SMTP id w186mr3382446pgb.83.1610563745278;
        Wed, 13 Jan 2021 10:49:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b189sm3154401pfb.194.2021.01.13.10.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 10:49:04 -0800 (PST)
Message-ID: <5fff40a0.1c69fb81.7d626.6f9f@mx.google.com>
Date:   Wed, 13 Jan 2021 10:49:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 121 runs, 4 regressions (v4.19.167)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 121 runs, 4 regressions (v4.19.167)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxl-s805x-p241 | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.167/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.167
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      675cc038067f0e530471c56a7442935f84669d95 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxl-s805x-p241 | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff10de7e5a3b26e9c94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805x-p241.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805x-p241.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff10de7e5a3b26e9c94=
cf1
        new failure (last pass: v4.19.166-78-g7f0a1a1d4ba9) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff0cc7e0517f83ecc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0cc7e0517f83ecc94=
cd2
        failing since 56 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff0cd4e0517f83ecc94cfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0cd4e0517f83ecc94=
cfd
        failing since 56 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff0ce93788f500f7c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0ce93788f500f7c94=
cc8
        failing since 56 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
