Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CE2D7AE7
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 17:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgLKQ1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 11:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405273AbgLKQ12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 11:27:28 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5918FC0613D3
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 08:26:48 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g20so3999061plo.2
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 08:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FleDO2MGKGur2TxMoE+oA3MnAaIagAZyIOq1ushGmG0=;
        b=yZfqhB2byj1FhSbN4KtVNUJF7P5xHH4JZVCsO3XLoEzFtpDUg3gQQ7MjHxO/UurF+f
         MvDGBKOXEIapwLZwj1ETnpEPshO6P2B4PpHpwuWaXD68s5E7amgQWCf63wM5Md9BkTMq
         2FkNlSPy1J/JbwXTqBGF117mei51JiNCP9/DnxG+s+pTyeu/+PV4FtqOdj1jdBIUxC69
         3m8JipIwVePmNWxxOjeAOqNj5bVbJ2qHp+9fFEhjTAutTFMxTNitCcOWR//5grgF1wb6
         wSz5av6rbuezAfBktMqyVEHnzwf5PebQ+/89aahXBNMEdNaQTDIP84hagBOhuo02pJeH
         g0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FleDO2MGKGur2TxMoE+oA3MnAaIagAZyIOq1ushGmG0=;
        b=tZkgoKPkBOdfmWUYs7mTny9KblyIhyEuWsFushvbNudEuzZLTdZUoHkBmSmA+Cs0zf
         57uA517yuIwhU3QPNY0bPwhtnSEDcxtqPm0HadYB5wsj54R70jQDV/XwpMuM2F8eSTA8
         dMtbmwQ6vociEuiTb7HAN7vrQGfM9AzTPjYO4eDAD+UDrviyk6b6Ctha18wGBEUc0y/D
         1keALCGYYK1jSS8Wln4VqkZOofEJ4yD/Ccf+IVRwnwvd46VWkx+1Rvs/NRXBq0lQOr0O
         toAze4WkHOUbTrc8QZ3tCIFVbZQH10b07B1eD2q/XvXfzAH+xcanQS5UeETX/7nys45e
         9zJQ==
X-Gm-Message-State: AOAM533PvOcOLiKufrrfmN1wYwBpYnFARsbVY0SIJ7lJzl42IxNrwhiy
        5O14hLTW27PLfUcP/eN+TxRcgzxRXDW0uw==
X-Google-Smtp-Source: ABdhPJzL2+jGpnmRSBrPV0AhUDYqKhjWb0OQAll7/kcWz9XU+x3A3sDfQHrPtnLymGRz/IdQwNETfw==
X-Received: by 2002:a17:902:c193:b029:da:ea4f:af79 with SMTP id d19-20020a170902c193b02900daea4faf79mr11946707pld.14.1607704007564;
        Fri, 11 Dec 2020 08:26:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm10674753pfg.192.2020.12.11.08.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 08:26:46 -0800 (PST)
Message-ID: <5fd39dc6.1c69fb81.92ddf.3e88@mx.google.com>
Date:   Fri, 11 Dec 2020 08:26:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-44-g2e0dfc09419d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 5 regressions (v4.9.247-44-g2e0dfc09419d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 5 regressions (v4.9.247-44-g2e0dfc0=
9419d)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-44-g2e0dfc09419d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-44-g2e0dfc09419d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e0dfc09419d4b270412b0fe923d437aa3345430 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd36a8d00c3ea8761c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd36a8d00c3ea8761c94=
cc8
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd36ac9c9b0f2736dc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd36ac9c9b0f2736dc94=
cc3
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd36b30708beb2df3c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd36b30708beb2df3c94=
cbf
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd36a5e3836172b7dc94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd36a5e3836172b7dc94=
cd4
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd375e5a8e79fe725c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
4-g2e0dfc09419d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd375e5a8e79fe725c94=
cc9
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
