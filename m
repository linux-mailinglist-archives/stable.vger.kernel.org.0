Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437082BC66F
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgKVPT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 10:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgKVPT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 10:19:56 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA6C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 07:19:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b63so12473139pfg.12
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 07:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/KYd7+1lt68G/0bqGu6m3EhFGsxG32AOIDh3Rw440JM=;
        b=g8i62rW7tOwYJyXBTeeRY6X/n44BwQBSRQGqu2+EuxLkzGV/XeAtrB/LIrUAJGCfQC
         dE+evQlMV8KbKcJyC0STQeBjORdtuiXHhJhrMV6zOgNiEfaD9BkQfdkJwrHRFX9Ot8iC
         bqzormhyws0g2jpyztmhZyV1fPqnu8oFLIlEGji4FGESsIOuELZlh40ussKIWt3RCSnl
         GRentnOD60/6ZDtkcY+q4K/mWO+EPXF3G6/nwZmUJLa2KA3Qn3J1arfUnkmqUKEcwnfd
         dx+VeCK1MFpeSEelSU8am58ESli7rIVeaxGmkjO5xE67xYiKRf47+UC6hgEKqlAxZl1y
         ZBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/KYd7+1lt68G/0bqGu6m3EhFGsxG32AOIDh3Rw440JM=;
        b=Y2INiP3yRXZ42jvnCMTsEDlUjG5PzuE6B+wPMhyjByn8T/0Podt0ZzHM6cA8TNklEt
         wMeUTuoesPkU9lcF4q7hnI8bbT9dXrbZT1R/pqmxeGTvuRh9fp+smkfVovaBb2iNmvFr
         Vo34RvYdJ4ImnzA5VmQjIggtklqig+Jiw/YzdeiRXKLQWzirVgZJFXfnjnc9+LYGDGHC
         DYRbt7dFIOfkAjvosQ7UaVOCgGVnIb3lrYExmeu81Dquvwsk1XudJ9omMAnat8MWgqG9
         pgqLzDiWgaNjaqcse7lfj0H0XQqqKuBjtrCMjU9m/9PX03SHdca7q+du0AQ1Yp6sz8MT
         uPuw==
X-Gm-Message-State: AOAM532T8HH2wvicaWJbsTEOOXBm8ecjOpMfMZehnEFyOXF7X3ySgMyE
        AzjfyOy5cPCr5tCc61AkOL6WX1HIywtUYg==
X-Google-Smtp-Source: ABdhPJxaBKYHPbnuL7EUCO5SHITP8yuyL0+TLpPmyNenk8BzUqPSP30iRgXnpIPBYqFSTeOPBSLMVQ==
X-Received: by 2002:a17:90a:7341:: with SMTP id j1mr19875795pjs.78.1606058395398;
        Sun, 22 Nov 2020 07:19:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm11870203pjb.18.2020.11.22.07.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 07:19:54 -0800 (PST)
Message-ID: <5fba819a.1c69fb81.d8bc8.8953@mx.google.com>
Date:   Sun, 22 Nov 2020 07:19:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.245
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 145 runs, 7 regressions (v4.9.245)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 145 runs, 7 regressions (v4.9.245)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =

r8a7795-salvator-x   | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.245/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.245
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ce62d3c7a552d9b1e3471a189abcccbfe5b91ac8 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba45e85c4ee52646d8d906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba45e85c4ee52646d8d=
907
        failing since 3 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba45ec5c4ee52646d8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba45ec5c4ee52646d8d=
925
        failing since 3 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4d674c889d82bbd8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4d674c889d82bbd8d=
925
        failing since 3 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4597db3d932b36d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4597db3d932b36d8d=
90f
        failing since 3 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba459f32893aa8c7d8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba459f32893aa8c7d8d=
91e
        failing since 3 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba47c85ac0bae415d8d935

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/x8=
6_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/x8=
6_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba47c85ac0bae415d8d=
936
        new failure (last pass: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
r8a7795-salvator-x   | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba45e95c4ee52646d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.245/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba45e95c4ee52646d8d=
90c
        failing since 3 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
