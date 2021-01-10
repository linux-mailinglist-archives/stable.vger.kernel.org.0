Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDBF2F0923
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 19:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbhAJS4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 13:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbhAJS4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 13:56:37 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005C0C061786
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 10:55:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b5so9122233pjk.2
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 10:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zPjHJ+3ibJ9X9aHVW1CgwKF2e5Cdd2Dghh3sIpV63OU=;
        b=q9aoFMl3ZZDK4J4kxdqW/OLjcCjtdoFk5idKpuLdudcZvK7E1Js8k7uWrH1+G5mBOK
         ae98r6yimfLPcz9s4H83QRI0WJfodaXIFRaKxRS7SmbPFFX5koECLZYXhr6WTgNvxkOJ
         s6oO/M4d+3DNOGZVBfWifXvEdgELoqdS4N53cfU2UFogquigSEzUbIQPgLEd0bexAAap
         b0t3nsiNSObuLQt0cjv9p7XXY6fvJmBHBb+7BvKgY/N9+PPBO0ctxM4tvS355mRoyKtP
         c7YR7iKwpfX15U03ZCJX4jFjyOG90h2ce+2tZRQ8nsrXb3aqM/p2HH7Hk7AE5ACgFtkU
         bnxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zPjHJ+3ibJ9X9aHVW1CgwKF2e5Cdd2Dghh3sIpV63OU=;
        b=g80VEYVkKxJgeQrRGFzP/yJuQzfNQ9sw47KGMMq4cNiVHpdSedglZdcibCRdqcz3DQ
         1jy54KLlOKZL3O0GG7Bibykf3nSgP/hHYqk8lg5pMk7QLATIQlnRfXQIFd2Vq46ToUaV
         OM+RbbrDYYmz+HwyIJfqIEvXWbCAL9tUW/LsWpOUwz4D2CSublZ96cWeheGgxbqJR9rD
         mv68gP8un6wwpa4MUcNHNH9GFWZOaSepEXftCIXaRq4oJYK0uxRLZ1SKV3/Nv1B9yihc
         H0gNtb1sqtPNERPh1bJh6dwqaWGixpNCph2SMOVuALXHaK9X8xWqyvzH4o+o/vMvcotd
         UqKA==
X-Gm-Message-State: AOAM531361/XYGqKpZTqW9dK+35h6+PK42zNLMSzkZquLUsGu61z8Vh0
        dtsSLhLze7htVPGz9df1kaVsWZaOt5O8nQ==
X-Google-Smtp-Source: ABdhPJwylfY1EgLXDEz9PJtFPwTk2zqKENm3Gg6SwE6dfEErsSTP/JMvfk6ind+Q/ZoNkU6ijODtBw==
X-Received: by 2002:a17:90a:950c:: with SMTP id t12mr14418834pjo.226.1610304956045;
        Sun, 10 Jan 2021 10:55:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gp14sm15845340pjb.6.2021.01.10.10.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 10:55:55 -0800 (PST)
Message-ID: <5ffb4dbb.1c69fb81.8e86f.1dd2@mx.google.com>
Date:   Sun, 10 Jan 2021 10:55:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.250-21-g3f172b628d9d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 7 regressions (v4.9.250-21-g3f172b628d9d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 7 regressions (v4.9.250-21-g3f172b6=
28d9d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.250-21-g3f172b628d9d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.250-21-g3f172b628d9d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f172b628d9df317889bee3db19ee71cfa77ef24 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb16a61a96fccee1c94cb9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffb16a61a96fcc=
ee1c94cbe
        failing since 0 day (last pass: v4.9.250-3-gad22df8e1d0e, first fai=
l: v4.9.250-4-g5c199034ff75)
        2 lines

    2021-01-10 15:00:50.083000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-01-10 15:00:50.095000+00:00  [   20.448547] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 36:c0:43:a8:8d:26
    2021-01-10 15:00:50.102000+00:00  [   20.461242] usbcore: registered ne=
w interface driver smsc95xx   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb13a65ea821ef27c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffb13a65ea821ef27c94=
cc9
        failing since 57 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb13aa52d8ceaa03c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffb13aa52d8ceaa03c94=
cd0
        failing since 57 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb13b152d8ceaa03c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffb13b152d8ceaa03c94=
cd7
        failing since 57 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb156ffe5343524ac94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffb156ffe5343524ac94=
cc4
        failing since 57 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb135c127ded5492c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffb135c127ded5492c94=
cc0
        failing since 57 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffb1a6537efd982f9c94cb9

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-2=
1-g3f172b628d9d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-probed: https://kernelci.org/test/case/=
id/5ffb1a6537efd982f9c94cd1
        new failure (last pass: v4.9.250-4-g5c199034ff75)

    2021-01-10 15:16:45.823000+00:00  [   19.771791] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Ddwhdmi-rockchip-probed RESULT=3Dfail>   =

 =20
