Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22523A12BD
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 13:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhFILag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 07:30:36 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:40721 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFILag (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 07:30:36 -0400
Received: by mail-pj1-f48.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso1197022pjb.5
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 04:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ywj6yuMKmi4tv/Gs955NiVLXSHl+k9zPIpx/lVIhw08=;
        b=terAlEHO4fxdWnSoWTIrQyZbPNt9/0qLX1hb1LC0qJH9uJ99OLqqmR5JhXXnfU9Ywj
         KsD4tZo4o6jevlT0VHbQlLE1O8tXk4fLRbSU/mXY5ky6HZ2Kw2DCpXbWILPtyovk8FDZ
         5kbG2rFrG8bNicfsErUivzdCBpNG0AlWCnT+Fdcf0W2q9hxBDe1hs+i0l6wFKfmYOmyO
         1hbzXFnkV4pqZnMFEXEVEzSyRqwadqh9QzjYd62RfVK/VAuw/NbDnW4IUXRFQbEzLvca
         H5q52EgvXZ3ED0Mye/ALyyKTKMBbFoFaoqOH+kjJkhvXteQIBNpJRRvfjRYAx946xXxD
         3A6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ywj6yuMKmi4tv/Gs955NiVLXSHl+k9zPIpx/lVIhw08=;
        b=IP/Z7sKoLbUXFeKivGiEHtw872NTUZzP1Lkv+SRMg1/E8yqvsPBE453BEAUXGZ+6ig
         uRUluGpCSLErWNV9mAG3NUkh/C9dhfMn+k38xZ1BZOJ+z6fvX/mwL8dUQUqHZeDk6ExY
         w4G8ZArhgK+4jd5wusc/B9oMGqQ7pt5YU3RKYbTMlvsc0eOTpoGFMP7JHADUGVgpdKhD
         MF1uZ3JOF6okJ2x/jAdHTvAlAUCZESvxPpDTQvfea5AdYYB44i2Z4ee18eiwAiqX6u+R
         DiiORzNb4kmXWfn0XLnmyTeCAXkHG+Yg8yzlVjpIQX6nfXycgbOJZ0M7sZiivHjYBzbc
         a/Sg==
X-Gm-Message-State: AOAM532CdJcwyRAB70hdoj3dpbaKpgIqKUWlaTSIfmNuFxyewOU7LvTv
        O53J7PqDSoAYNCc3bJI9GyD6Yi9k09kXMPiR
X-Google-Smtp-Source: ABdhPJwxMmVMZcMH1Thi9Tr6gUQrdA1z7izjTg4MHPcGaVEIkRoWcQtA9doTQXr4WZMF7DO2KUspQg==
X-Received: by 2002:a17:902:ff05:b029:10f:87c2:92c9 with SMTP id f5-20020a170902ff05b029010f87c292c9mr4934562plj.18.1623238061752;
        Wed, 09 Jun 2021 04:27:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 92sm1938037pjv.29.2021.06.09.04.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 04:27:41 -0700 (PDT)
Message-ID: <60c0a5ad.1c69fb81.e74c2.5b20@mx.google.com>
Date:   Wed, 09 Jun 2021 04:27:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-57-g426991f51dc8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 142 runs,
 5 regressions (v4.19.193-57-g426991f51dc8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 142 runs, 5 regressions (v4.19.193-57-g42699=
1f51dc8)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
dove-cubox           | arm  | lab-pengutronix | gcc-8    | multi_v7_defconf=
ig  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.193-57-g426991f51dc8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193-57-g426991f51dc8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      426991f51dc8e83b1fb9c0f9dec63e1e273bb493 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
dove-cubox           | arm  | lab-pengutronix | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60c073d8162af473440c0e16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/multi_v7_defconfig/gcc-8/lab-pengutronix/baseline-dov=
e-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/multi_v7_defconfig/gcc-8/lab-pengutronix/baseline-dov=
e-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c073d8162af473440c0=
e17
        new failure (last pass: v4.19.193-17-gb7e40d2706ff) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c07283b05332c43f0c0df7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c07283b05332c43f0c0=
df8
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c073587cd98491cb0c0e01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c073587cd98491cb0c0=
e02
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c072816bd1f45d590c0df9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c072816bd1f45d590c0=
dfa
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c08e57b5b886ba120c0e1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g426991f51dc8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c08e57b5b886ba120c0=
e20
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
