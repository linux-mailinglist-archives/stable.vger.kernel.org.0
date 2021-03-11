Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAAC337D35
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 20:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhCKTIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 14:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhCKTI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 14:08:29 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2309FC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:08:29 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so2099500pjb.0
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EU31z6+5yEEzVdyZWzaUY8DbKAr+P9i/AjppepHVnng=;
        b=FxsaD7REoBy5tJBlnxEqQqp4mC0b26gK4zS080v6nF1VrLSvjuwot7Hah5I60go4Uy
         DOxUWwbTrY9LLhvxyCLx7pAUnmcaFj08Xp+WSlq4vcPTRfoAnnpx3oSkhsQ6SXKW3JOj
         w0wlF1IG/dObf/ckB/5DWUFpEFqV+W/3OaGo12b8r7eOhV5Du2WyqxEkwL7YYUd92qAo
         pSGG7UsOF6ZCdjjdKWCXzGIRqjbClYt5Q6/LJhRDGlYw8FJxWjBCg5fEQgZhJYMzRvJZ
         knpijZZMlAnrlAssj+pm3pOjH1s0B6yQPfMfwj5Td09DVUOXWEhZ+uZes7543kfzw3qp
         RpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EU31z6+5yEEzVdyZWzaUY8DbKAr+P9i/AjppepHVnng=;
        b=obi6BTUO/r0VHD84A+V21KYut6hB0tuPxpLt76DkZvuPVki4wVh1hl9NhKN98A7rvf
         DohbJUKabkML/dNdgRvw2oKC55j9trUKWMkRxhiAl0/a1grMbrrf49ymbmmNg75PFCpc
         7r10L+v0QEy0iXfrtyojaZsjNmdneOMNyvaGj7+QZKhU0O+45/+3nSRfDCto4R+TZ6+P
         sQK4i0JKYnD35Xf0uYI4CmIzq8xkNJw6VOTsFHLZ3ev1JfaGqwoKhWYUE8aUQIqWhoou
         vIrSeuMkEUY6o7jpW3hHjAaqKC1iLSf+yRlUZJch2GvGGTKqsjbXoHzHt34VFP6CdLnC
         OBJQ==
X-Gm-Message-State: AOAM5335HAQiVWO3cnWa87KKjJlF8jNHCXqT2rm8iNxK8BoQKq3yzQk3
        mweoVoN+WgUT5x28L32cjqzDmNPHPCogmUZ1
X-Google-Smtp-Source: ABdhPJxWg+Tz/slAhGm1+kLF97QdsaJdzmLQ61M6kzLjEhO38+WokQqqoTv3b2ahrYtC+rXo4h2jsQ==
X-Received: by 2002:a17:902:9a45:b029:e6:1444:5287 with SMTP id x5-20020a1709029a45b02900e614445287mr9644167plv.54.1615489708407;
        Thu, 11 Mar 2021 11:08:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1sm2904269pju.7.2021.03.11.11.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:08:28 -0800 (PST)
Message-ID: <604a6aac.1c69fb81.8ad7f.7f49@mx.google.com>
Date:   Thu, 11 Mar 2021 11:08:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-11-g095e4a0888741
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 70 runs,
 3 regressions (v4.9.260-11-g095e4a0888741)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 70 runs, 3 regressions (v4.9.260-11-g095e4a08=
88741)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.260-11-g095e4a0888741/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.260-11-g095e4a0888741
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      095e4a0888741c13fd7083fe42a90f3ac3a8738e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3465336753f707addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g095e4a0888741/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g095e4a0888741/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a3465336753f707add=
cc0
        failing since 117 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a343d7b02a4414eaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g095e4a0888741/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g095e4a0888741/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a343d7b02a4414eadd=
cb2
        failing since 117 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a34381cecc1c23faddce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g095e4a0888741/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g095e4a0888741/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a34381cecc1c23fadd=
ce7
        failing since 117 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
