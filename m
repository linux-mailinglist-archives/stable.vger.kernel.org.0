Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1C34160B0
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241678AbhIWOKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbhIWOKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 10:10:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFEEC061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 07:08:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 145so5808589pfz.11
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 07:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IOyTJedHW1cS7OXikvXskKt0yr7Da4N/GupiQ9pl9p4=;
        b=e3VUOXAtRy0Utw42J1H9mMm6m4PmiPyarJkzMs0aavB6gp+6kZZVM/1r+0IZGtbp1C
         ZSkbRPhNarrMQrMiMDp05wZQUeB9697N45JZydl874qdtCyqJjoDIMgsfIndoHGWxezz
         Q2bn+j9Ubgx3Wrhm/RrmrKyTMbkqHvXSN8xH5Z0hMATxPVkcnx0TF2EsalmdY+HaV1pg
         Wm0PFYR5Q6/fdDPIbqjDFdWLeMJjfpzrzDMIfM0PK3+uquvbzMWdRcqYyTx5r9LSfF4/
         1yKt2XkfKjv6PWqnv8FKWMBKCIkp1mGD7U0g6TebWPTuTco9RnY54fHrUVtUgMrJWbvo
         s6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IOyTJedHW1cS7OXikvXskKt0yr7Da4N/GupiQ9pl9p4=;
        b=zxsjN/YJ85wS9uc7zEwYd6OZgKDbanH5LVJlDIG9a7jurZgaf0o8oPGNfBJC7Q0blj
         Q/vAr/2MHoc0wGQAJXQ/evPgQB9qaQ3R8INQz6/3zKEe1OdvDqTRVZbfmZWiC/yYQgDL
         diX+JRvc6T2RPzlnV1b51dqwHe2qsf4H+a9BZko+sJFTHTPBrjpSS9c+3WDBfu8fPS2X
         tau8p6GduklQhDLt2UJunoFOdKJRT41Z7ypvt4LoLAIvqT0HIxUB/utzH4yRyPjjSWFx
         65K5Ae2HsKBb90DDMZUD0yxA4AXlRExUnPHaJP1ts4qNwl6/IhxnCYNC7nOzltaPp79J
         hm9A==
X-Gm-Message-State: AOAM5318nlZISMDy9Dd97s7Odb2yKyNMtCaytnWyEaZU5lXy9ot/GE+E
        CH6Wz8Q6KYaENx+fsEV+iPzFp+UfvREPl9kP
X-Google-Smtp-Source: ABdhPJwPv6noKmUY3Rlt1lQwvCQ8PWgWUZACoty9b3x0khVDYXcRkKA3ZVyg/w00e43X/jBF7h4qsQ==
X-Received: by 2002:a63:8f06:: with SMTP id n6mr4361419pgd.315.1632406134867;
        Thu, 23 Sep 2021 07:08:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm9075749pjw.4.2021.09.23.07.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 07:08:53 -0700 (PDT)
Message-ID: <614c8a75.1c69fb81.11f6c.d2e2@mx.google.com>
Date:   Thu, 23 Sep 2021 07:08:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 111 runs, 4 regressions (v4.9.283)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 111 runs, 4 regressions (v4.9.283)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.283/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.283
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a4bf15a4f9229052ab38718ad510848947e8871 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c56daa904fe7ddc99a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c56daa904fe7ddc99a=
2fa
        failing since 312 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c8814da08fa791399a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c8814da08fa791399a=
2e8
        failing since 312 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c57a7be157a042f99a319

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c57a7be157a042f99a=
31a
        failing since 312 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c62ed1dacd0f1a799a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.283=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c62ed1dacd0f1a799a=
2fc
        failing since 312 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
