Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36833C5A12
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhGLJ0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 05:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379157AbhGLJZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 05:25:09 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AD2C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 02:21:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n10so1662231plk.1
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 02:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GZQnr7sVkPqSqf6WUhTMKjA60+IM0IKFV1ZuMsH/PKo=;
        b=MSAg6YAKZL0M0SOtaW5qjJT0MpiZMI+pZ58xCkArOzU6NU91m2Ar+o6z3Pz2m/mQQQ
         S66ZuINOi/vfIDrzSr+meNkbtqqNAT1X5PdnQSutSOXwgz6xx9ma80MNVHd2KHk8qF4S
         5zqKq1YNQ9oGkUZrio2KRv3xP/zlQSTZerLtUpmUEhONU53XXDiuQvEu4KUPBOvcdmU2
         pB5Po1fcZ4MTmND5g/svkAi/oP+hK+HeNGJXpQSNqdgLOmwdJ2j/POufOLu+7uq4b21z
         bRf7Jr3qvI2yKE/HZuDliMgXRVzJg8iJt/V+wIMz46HfeoLaRE1/6pUbRkSxiNytnmkF
         p7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GZQnr7sVkPqSqf6WUhTMKjA60+IM0IKFV1ZuMsH/PKo=;
        b=jOQzunemiapAwXEHpTFVS/YsJrcxe9Xg/eEnlLaCAKj1PdKM9oajjMEAQeIk1ovVU7
         9svjgL0LVdOPGGQUBPkYfTYMRNxLjzFEQvjBU9GdYI84DvweFqK8I0puWTSUkUWBJ0a7
         deEsxtMRQIH2EEUFJBl06mQwwdZ/pJWJNIrKTmjpm1WgX8u0EOr7didgmqnSE/LVoggT
         YUgv1buULWYXyuu5chrSWajynGXgb0U1xR7WRoCqZ1r5rChnVz/gCTjbV2LEqUIDnE5p
         9pZ5BtvOq9cUiJR7CuetQBlfbOhZEujFZ7/dWuvbHM1VfOdFUKK4pBoR5V2eBB1BdqVh
         6s0A==
X-Gm-Message-State: AOAM530ppoZKL5h4sgXHOaG8LmzMKvpnZqtjlKoEX50nOz14zGWhmkUj
        qA/5DZQ1Zq4fKlH56hF/H++SOjSXiy/CVNtz
X-Google-Smtp-Source: ABdhPJygLzXISymp0t4oFGKgBS3P3tiWdaebV2OhCfoorDMtagzHb3WPH2ARn6HF02vKT7hVg+jIaw==
X-Received: by 2002:a17:90a:3b44:: with SMTP id t4mr29339598pjf.203.1626081717176;
        Mon, 12 Jul 2021 02:21:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o20sm16872402pgv.80.2021.07.12.02.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 02:21:56 -0700 (PDT)
Message-ID: <60ec09b4.1c69fb81.9d79c.2869@mx.google.com>
Date:   Mon, 12 Jul 2021 02:21:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.197-225-gcd4f01324a0f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 141 runs,
 4 regressions (v4.19.197-225-gcd4f01324a0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 141 runs, 4 regressions (v4.19.197-225-gcd4f=
01324a0f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.197-225-gcd4f01324a0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-225-gcd4f01324a0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd4f01324a0f61912506b11eb9692973b705695e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebd1325557d700a911796f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebd1325557d700a9117=
970
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebd9b0c1e172604011798a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebd9b0c1e1726040117=
98b
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebd1415557d700a9117979

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebd1415557d700a9117=
97a
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebfeb5d40f804d70117985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-225-gcd4f01324a0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebfeb5d40f804d70117=
986
        failing since 240 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
