Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0335C3A9D73
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 16:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhFPOXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhFPOXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 10:23:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94D1C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 07:21:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x73so2335185pfc.8
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 07:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sCwVsEl/3RSBijD9oh3HHO7kZzbe/W7Lvtx6b5jCKLo=;
        b=b44J+B1G41Oy7m9VRZNpRnaXqjV1IjtH8N/6hafqM94GyFz9M5TBFY0JMpk04cFfhm
         f8v9r5LkZeFFYNPDgK1qJDaXkJS8MV7h+K3vRjHI95/zBq52afKHZJOpTm/e+zskkz3t
         9XA/QnaWnpJK5iVMsMERoraZ33ytCacj7L+d3NxkQAok9t5k+p0zjSbVKj1EYKK6kPIU
         K7UIyHkwGgEjhCJDW6CpjaY0k0c+xbHO+i54t83PRGIc+vlR1spKOLLlUmh58IkxFC6M
         2onPW7TWCQcg1kPM2rOmM96K1l27OXbUa2TWewLYSaUf7idQieqzL+ocEKDdIFhEAEIW
         uBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sCwVsEl/3RSBijD9oh3HHO7kZzbe/W7Lvtx6b5jCKLo=;
        b=XQNk4EiSLk9dIj0mb0GBx0RLxBC87bqukKqaNL8OgCmbAXU1Sh1JYSZefDVgDbv6jo
         ODG9hgl/LuHTGLBhQciQaqi/uniPn67+exe5RW56tLwz8Q6//h2V9Ge1aNdDMKilKuMN
         ge0LSdw/tzfB9Z2ZeTNH7v8lb5IBznPYa7abWTuXon6yY/7QNPAsA8mQZ7uSC490EASG
         Vohflu/pj6eDpYu1A4CcqdqcF35MNrrMDBA895iX4tQATpJZTEeDJ35xWSePVOwirNdn
         Ldg+1Q3hh9YXVbtndIL3cqQnKZzcbvPEZP3Hv9UI+XKsYfNCvQ3ePpRn0lEQT6bbjMR4
         9bug==
X-Gm-Message-State: AOAM5336B5rDvmcDwT2u3yPknPFyX/55+535Ci/6f5zQarV5uVpuIVVx
        5BpKc0RE/EmvkUPlTUi9Ct8F41MY7JhGLz4z
X-Google-Smtp-Source: ABdhPJyc1V7h/DQiqL1KHq1Yy/wUfgY/TlAe32tTF0kN0LsaChKJjIR472pJ0lqVNdqoI4LoQGqYGA==
X-Received: by 2002:a63:b00d:: with SMTP id h13mr5261812pgf.74.1623853262259;
        Wed, 16 Jun 2021 07:21:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s13sm2603315pgi.36.2021.06.16.07.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:21:02 -0700 (PDT)
Message-ID: <60ca08ce.1c69fb81.c1443.6d93@mx.google.com>
Date:   Wed, 16 Jun 2021 07:21:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.272-42-g3a4807ec2fca
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 119 runs,
 4 regressions (v4.9.272-42-g3a4807ec2fca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 119 runs, 4 regressions (v4.9.272-42-g3a4807e=
c2fca)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.272-42-g3a4807ec2fca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.272-42-g3a4807ec2fca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a4807ec2fca1d34ec9914d2feebdc025b0554d2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9d032ec5ccac88b413272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9d032ec5ccac88b413=
273
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9d2a4a88778c401413272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9d2a4a88778c401413=
273
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9cc65b6b29996e0413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9cc65b6b29996e0413=
267
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9cc138aa90a72f4413289

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g3a4807ec2fca/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9cc138aa90a72f4413=
28a
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
