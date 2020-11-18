Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC032B87E1
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 23:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKRWmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 17:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgKRWmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 17:42:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724F6C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 14:42:20 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 131so2512586pfb.9
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 14:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ivRHP5u4dYgWeSQNt0FrdM0sDUa2rnjZy3+o3EcVoQ=;
        b=pTPgaVQEPi/X3mwfxr0CDFvJqNhfhBJPJfhP+gy3puC1Vk12X5MBsyb2FWOoGZauIv
         7NbADQb5zjNcCWvHsyhYWlDehaDChUx6KmKK2uuHUCwyvde1N8QxAAo+T/DNShUf34vu
         nrbdRFHAQhl8tWbMgiFVdw9++9OuCSsx6MdlOCVq5lhw9LpqQS2/1MHNqtpFIQXIv/KO
         EAzoas+EKbxAf7sQnmwbozGwDVQvm+3XDexgdWPWkoeqgmS3ip8XnvkX4pwr3y5Hj0Z7
         RRtEClCbUjhOj1OXBQNsoJ70dkmv1uu6x7djPt3VYdj+unBDuVyEHcGQDeIFjnO7ZqU+
         006Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ivRHP5u4dYgWeSQNt0FrdM0sDUa2rnjZy3+o3EcVoQ=;
        b=Jzsz9qLpeNNIFXk1CJkIZdYHSbdeWyIkXiZo1LjllvNIHWU3OLvGUNNRhNWh6uLDft
         aQao1JXuvW4f7vUXsTyv4+jGcpTTE68AKclUeP85yK28eTakCNhfuYiPYoRCdVUHoB14
         mjcLUl6VxfIbX1KR69fHnFwlE+r0EuEk8C0mn2mxYp/a3ms2nJJa8hqGRgkByAHTfmd9
         8GBdSQzU+NIhupwAnbz0XYO4vwwxwP3iSo/Qt94TP7NyHLTHWcbK9eaDVi4m/kTnyDaI
         N6hvmsMTZZ3IADeZSSha4geW94A3shcLih9bl3r6E1cjkVy/AOo0XbZqIK28WrcEzsRO
         23gw==
X-Gm-Message-State: AOAM5302DpANTHmCp2pFmEkAtCZrkBrjvtYHGAVIw8epjVLU4rTSl5SO
        kYuTbrtatGGswjJWcQ6HVUVKuZcycTX1WA==
X-Google-Smtp-Source: ABdhPJyHvxHB6p7hmEQJ/FY4J7OHlV1Qf2pjdS/VVNCLxiKf5EKi8AH4O/F4GPpkNtrSKD7oxrIdDQ==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr1168874pji.7.1605739339052;
        Wed, 18 Nov 2020 14:42:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm3561308pja.52.2020.11.18.14.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 14:42:18 -0800 (PST)
Message-ID: <5fb5a34a.1c69fb81.b3a18.677e@mx.google.com>
Date:   Wed, 18 Nov 2020 14:42:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 149 runs, 4 regressions (v4.19.158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 149 runs, 4 regressions (v4.19.158)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.158/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2c746135a12e3f329171ed168ca0078d468f6d85 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb56fb55e3f45b2bed8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56fb55e3f45b2bed8d=
934
        new failure (last pass: v4.19.157) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb56fc88827deb1dad8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56fc88827deb1dad8d=
908
        new failure (last pass: v4.19.157) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb56fcd8827deb1dad8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56fcd8827deb1dad8d=
911
        new failure (last pass: v4.19.157) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb56f7f9c4169ff9ad8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.158/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb56f7f9c4169ff9ad8d=
90a
        new failure (last pass: v4.19.157) =

 =20
