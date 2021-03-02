Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B8532B185
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbhCCAqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573289AbhCBQqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 11:46:47 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF79DC061794
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 08:45:28 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id e6so14179530pgk.5
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 08:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Npndv+tvwoSqt7giipSP2MxqYaNEmVtBRr3lLYwkTEk=;
        b=lcEKejiT/TkAS/EvU3HHe+yNANxuApsNtvnPF/bBmKffjXX2pJXZy5hD2ksTdNt6OK
         Oy2q/Lm3v9v1SCVJZcx1w3+eiCKKC/j1OKOiZcM0MrCM+6XHF5FU1d7SNyRAO4m12AR6
         11hYAF8esj6r8hEhk9dX4G1bSWstXYVI1N690U3ULgj4dBjjsKHS89W53XqOxt/sDX1B
         geomamsxNqlBj+oj4+zQSWl3ba9JIlSttGfjI/vT+CCTNt4v1OaxU83IWPzY926Cxecu
         ZNKckZIJBRiP1NLv1bLWsrvQwUltkIMKlHRS4x5r6hI8xsUCfRt+u4LJv5zP/ks0gtza
         9sYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Npndv+tvwoSqt7giipSP2MxqYaNEmVtBRr3lLYwkTEk=;
        b=QHhRgJ5GAPzvMoT8otTN94/uiKYDL/uEPCrvKgg77Yaks1QmAIz8HiAWBLTm1SLEFD
         rzvlV3vTPKZzyfT4wIcthqfCvp9jQPaJER7O1+0B43e9yHMadjtBJN+J/SjK5xOpxTAT
         fs6gsGpknOptjkC16SP1ByyG4r4RcJcrxc9+eimylH8A+j9MdoBG/fuf70SDPLB6vAeT
         bmYw8to6kA7PHDxbE22+LGZJqpAnTfF1NKyBrxwkWzX2xTS+LGk9sPt87V8b3P+jztJO
         XR8Vkxf6IQEYHvQqTZPK2SO+I9rfz2znmOh93PmnW+2T/GDNLaAApIyQjQ9qhaTtwVd4
         Q4pA==
X-Gm-Message-State: AOAM530O1zZVXaHo4uVVDhUkTSBbJo+rlwvNYB2OY7T5uMy96mVSNcts
        /AZkhRzEOBC6um5IkcuebJ2h3V8lAOxShg==
X-Google-Smtp-Source: ABdhPJwZhtfIhY1rcO/64QX3Ibd917JFxi+8TVjmt4JjWFU/eaJ1H5/FKHI5iRcMXqOuInc8G7jzvQ==
X-Received: by 2002:a05:6a00:1a44:b029:1d6:4170:ee0b with SMTP id h4-20020a056a001a44b02901d64170ee0bmr20465666pfv.57.1614703528238;
        Tue, 02 Mar 2021 08:45:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t17sm21989066pgk.25.2021.03.02.08.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 08:45:27 -0800 (PST)
Message-ID: <603e6ba7.1c69fb81.83a93.2631@mx.google.com>
Date:   Tue, 02 Mar 2021 08:45:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-177-ga03a0d1d4a213
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 85 runs,
 3 regressions (v4.14.222-177-ga03a0d1d4a213)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 85 runs, 3 regressions (v4.14.222-177-ga03=
a0d1d4a213)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.222-177-ga03a0d1d4a213/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.222-177-ga03a0d1d4a213
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a03a0d1d4a213aae736f3e47cc0acae723137f88 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e368728a03fdbd8addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-177-ga03a0d1d4a213/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-177-ga03a0d1d4a213/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e368728a03fdbd8add=
cc8
        failing since 107 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e3676311b522e2daddce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-177-ga03a0d1d4a213/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-177-ga03a0d1d4a213/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e3676311b522e2dadd=
ce4
        failing since 107 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e3634bcda933a00addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-177-ga03a0d1d4a213/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-177-ga03a0d1d4a213/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e3634bcda933a00add=
cbe
        failing since 107 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
