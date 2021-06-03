Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B83B39A58B
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFCQP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 12:15:56 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:35660 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFCQP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 12:15:56 -0400
Received: by mail-pf1-f182.google.com with SMTP id h12so2404215pfe.2
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 09:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PCir+pXrto0m2nSoPKXai9sw1c9Pdjc1JKVFB3kLA0I=;
        b=Dv7MMJG+GybIuiVXi8HmCRRM+gddvsf0mYQjY0PsdGQ0wBCur+V5/f+XF3JeTwhBqu
         +EKPf5N7s1ORTdTz8Dmny3U4ATg94k7WX6Htt09QrixwCqofQGnP6gIc4tVymWMdRJ8Y
         +JKXLJbKaye7D4dRCZHXeMGakA9uHhyF3luqCANAg9q1IFl8vq8OStpNcTmATbRaiAai
         /RCxJ0Z/NlJDKauwVie5gVXduD2NS3nZFlW/mnqJK6i9ZtsxP39m9CgBBC8DakjEMNLw
         vIVs3DgWhpikM3bC/CujlJlndkkLxeDeNHDe+iFEs8IGMS5NnbnAoOG8Kh1s+E/K/gkX
         jQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PCir+pXrto0m2nSoPKXai9sw1c9Pdjc1JKVFB3kLA0I=;
        b=NO2eRrvwsc7hVDtiWtXNqXNlVYUjlHkHk0WXaZqD90lZPeHMEu/9RLjGCkbIG+qjdc
         J+0UUZNctJDbBrdtSFZDqU+Awb87cwUZWc7acKZeGBdC1hLka/1FhNtSFymdE9g57Zzw
         OVeuAuRDdQu9qnqlJ8CL8Gl6C8POUYD5DphBS0eaT+ytvJ73HaJ3fAjz9l4t5gelMPlr
         Hfq/f2zRmxf3q14UbCV7csh8hWS9nIVfwQMi8Gzgvooh8fPgM0aH8N1DCNqcIM4U9M4Y
         Sz9Q8aCl0+qPyQBkYUNVRGAUhAY1d6D6acMVPaWvXhTYmYsfJ2m5655Vz7Y35Wx13Vyz
         IG/Q==
X-Gm-Message-State: AOAM530M1b68ZbAufRu1MVXO+2AaCdzTuQL9HyCdZkDtGkzhJil4vSYH
        GwsXTYoSayvfzF3ohOdvqIyLaNK95AJ/aQ==
X-Google-Smtp-Source: ABdhPJzvoyXeHqAmDLgGys0AeSFX0s6EjoWsUdagQnANS4MBkF4AyUMxA1bsC1WD/3IWSTRztstlTA==
X-Received: by 2002:a65:5a81:: with SMTP id c1mr224309pgt.111.1622736781253;
        Thu, 03 Jun 2021 09:13:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ev11sm2736864pjb.36.2021.06.03.09.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:13:00 -0700 (PDT)
Message-ID: <60b8ff8c.1c69fb81.c3c67.8528@mx.google.com>
Date:   Thu, 03 Jun 2021 09:13:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.270-71-g4ed727b2f422
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 4 regressions (v4.9.270-71-g4ed727b2f422)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 4 regressions (v4.9.270-71-g4ed727b=
2f422)

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
el/v4.9.270-71-g4ed727b2f422/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.270-71-g4ed727b2f422
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ed727b2f422d4c2d6116bd5cc0cf4f1b6daed14 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c6a9d5110b115eb3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c6a9d5110b115eb3a=
fc7
        failing since 201 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c71bab69e54ad3b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c71bab69e54ad3b3a=
fa4
        failing since 201 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c6bf62100917abb3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c6bf62100917abb3a=
f9f
        failing since 201 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8d132c4c6f35d15b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.270-7=
1-g4ed727b2f422/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8d132c4c6f35d15b3a=
fa1
        failing since 201 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
