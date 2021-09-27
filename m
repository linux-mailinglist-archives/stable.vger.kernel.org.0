Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ABE419275
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 12:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhI0KsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 06:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbhI0KsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 06:48:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6977AC061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 03:46:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so1159509pjb.4
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 03:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eyIuqZjSGvu/D313McgAtLALAz6pdr/OOCODOoZRaD4=;
        b=IQn8eZvK1Fl9lZ4LdlH4VTM7OjjRy6dL/auzg3+z5Ox56lmtPJ6iV1Q6tIWBh5iD56
         AbQ+RmqS0HdbVCaovzaJzh6D19o4mAr2whLLSaKZjc5FSYOXhupS1uIeVV2illCTxPTs
         /AbT6HuWfZoAFpq4JsRdawhetPj0xK+mg8ZdsP4s+DoC0+L3tGtMbSzEMbtXE6FlcaP/
         ucuj/L3vlu0Iv2pb+Zr24VfZUGXqBLkN3wyXso7sw1kk2hfiN6mz+Vl30nDGKF7XLLw+
         sR6YT03DCjMrhLIrqrYUeP1jzXZjaEuT/YK8Vjt16lGLyAFMXHT5kUYaehkyx1mmn3dV
         5jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eyIuqZjSGvu/D313McgAtLALAz6pdr/OOCODOoZRaD4=;
        b=E/lgG1CHqkBMjvLrLchqedryHYh1oQ6c7CfDlMEeT3Kgb11vW+JTvtlqBg+x/mTk+s
         Eb+MC3Ifmrb5BIPrbTD6xb0PloShVtLHGHlwaYJdkjE7lqzVUZmygaqHUb216ywFu3Oq
         x2rASrHABftXd5TaGsuR6aFzCy/rvCMV6z1l6zJzfxIlFzeBLqg/U/9V8HkMInrTbLKX
         Wzc3YT5K+pXJ2dn3HTWtF8tlrmwDLvSuv8p627lVbrMfK7VQfHl9kOsap6qOKR3zsRc/
         +XstcvJ5DhkhIwmtJEYJKf/V55gRvPHgvvlXSDBX5nRNfdUxjUWNomJ1FNWtxXeV+k0/
         Qomg==
X-Gm-Message-State: AOAM530YawQmgaY1rz97HliB3GNjuMamlmG7nKKl27LvIn2PV80xrbGY
        3RUeXJiQ6P0hhLcAhCZvem9kE+FPk3f8ugkb
X-Google-Smtp-Source: ABdhPJxH7sMGQzKX5IwmF6GR1XirIOeez/xq5U4FdLnutuFDB2xpw0UqWnA5bVO4NcGuScXP/OU3Yw==
X-Received: by 2002:a17:90a:12:: with SMTP id 18mr19151125pja.104.1632739603588;
        Mon, 27 Sep 2021 03:46:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm17568257pfn.91.2021.09.27.03.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 03:46:43 -0700 (PDT)
Message-ID: <6151a113.1c69fb81.defda.9319@mx.google.com>
Date:   Mon, 27 Sep 2021 03:46:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-55-g6510cb79f5df
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 5 regressions (v4.9.283-55-g6510cb79f5df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 5 regressions (v4.9.283-55-g6510cb7=
9f5df)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-55-g6510cb79f5df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-55-g6510cb79f5df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6510cb79f5df72fcd5f00174e5d4cd756312dfba =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61516cd4a80cdad24599a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61516cd4a80cdad24599a=
2e0
        failing since 317 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61516cec2a411c880f99a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61516cec2a411c880f99a=
304
        failing since 317 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615185d3bdc464194c99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615185d4bdc464194c99a=
2e6
        failing since 317 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61516c96310726bffb99a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61516c96310726bffb99a=
306
        failing since 317 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61516ede1e2ffe119299a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-5=
5-g6510cb79f5df/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61516ede1e2ffe119299a=
2e3
        new failure (last pass: v4.9.283-25-g73e640213b94) =

 =20
