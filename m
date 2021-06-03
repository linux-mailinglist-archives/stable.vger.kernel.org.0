Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F91039A2FD
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhFCOYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 10:24:38 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:41956 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhFCOYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 10:24:37 -0400
Received: by mail-pj1-f45.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso3996976pji.0
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 07:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7YCqd5GbNkDMl/GEeCU1RFU7FuiU2odyl1N75hi1Paw=;
        b=znAj5Ok0Gxy5inF4OB2UpjdzTlXthOFQxcWAZuacQgJY1Yq9+evETgfAK48fKBooPH
         9FLNqcRDB83rFeOPolnOo68oMICqbLna5R5J3UaoIC3sRvhKweQg8AkkK0xzeHJoUJLZ
         lfAvp5I5kQn7lrr719Dll7+mjb8AUNpkGN616hF+vbvJ6zbUhJPRvhcbYAupkcQY06ij
         YN+eytQSYNObC6njw/7d9F3rvYPJWARaHaJmLLkon6L1rMIfqi2V9P3JfHALMO5hk8mB
         N819GK19LrGFzPLfRfBHLS8bviJ9Kivxujl8SkdzbRNLXAQ+5tglIOXT2LRSm1Z/E52z
         pExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7YCqd5GbNkDMl/GEeCU1RFU7FuiU2odyl1N75hi1Paw=;
        b=Of/MJ0sA5LdRnW8eHqR19JielshteXd6PZOwPR0fVaFp0C80JTWjQtZIgcKOUSjP6K
         o+QAEVBfdHkfv+EtcQqGJP5k7JC9AuJs1f1ZK2YLbIipDXCQ2EaV+9V7xltQ0DVelCDX
         Ke09ZRmVO5K7GerijqxsqOj/iWi9cPhRaGiakMWgPQincR4CFxSxSOk65UxoZI2hGjiX
         EE3IvGlX731RyHuhe0lOTSG+cqBCHjvJcTL2Z8+ntu/WGG1g+tWZNPLyl5TdH+X06UXb
         +9fXuEF8Yb/Gq8sZG2/57wp0Xd8LGwz4ubcmtk1h1Vk31heoPd0VQ1HKZLrtiN19iqBB
         5eYg==
X-Gm-Message-State: AOAM531ZHajiuwNNR7GobWptYW9Pr86OyX87kor0VxhMvItEtQP+URZv
        3UKI2M+egIwdd9WK+8H9zkQW80hDF8YDTg==
X-Google-Smtp-Source: ABdhPJycxLbDarSiqAss5/yyi2Kg5r98jTnkNkBlTTmM/BOnMKNLHrQg4mqq0xLN4oTNVgPPbBg5Og==
X-Received: by 2002:a17:90b:1810:: with SMTP id lw16mr191658pjb.203.1622730112742;
        Thu, 03 Jun 2021 07:21:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r92sm2676225pja.6.2021.06.03.07.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 07:21:52 -0700 (PDT)
Message-ID: <60b8e580.1c69fb81.3aa60.7fcf@mx.google.com>
Date:   Thu, 03 Jun 2021 07:21:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.193
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 133 runs, 4 regressions (v4.19.193)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 133 runs, 4 regressions (v4.19.193)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.193/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.193
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1722257b8ececec9b3b83a8b14058f8209d78071 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8aabd0347302059b3afbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8aabd0347302059b3a=
fbc
        failing since 196 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b09a868fd63c29b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b09a868fd63c29b3a=
fa5
        failing since 196 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8aac70347302059b3afd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8aac70347302059b3a=
fd4
        failing since 196 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8aa684575a4b011b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.193/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8aa684575a4b011b3a=
f99
        failing since 196 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
