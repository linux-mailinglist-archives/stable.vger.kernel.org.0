Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99D938F0F4
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhEXQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbhEXQG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 12:06:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697B1C02B301
        for <stable@vger.kernel.org>; Mon, 24 May 2021 08:37:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k5so15050530pjj.1
        for <stable@vger.kernel.org>; Mon, 24 May 2021 08:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nnnY0qZzpyWcYz9t1GkFET0OrIiyqld6FF+Y+aPvTG0=;
        b=cUOhdh9MM0K2wbuqZ86fVOugaamMJ94MV/vzlOZqmXQwS2zL9wHykERlY18pwJf1RH
         OOWJGJjeICzSXEyYMXzLQRgASV6dx5OW0sbVvAqNbJMaWW02DHwudNiSJzCD/p08nNj+
         jR8SL0amYvjusDc5S5OUX4jgsLm4lpWF+/uAzR6hR9R1q7gontkexKZNZYoblQal+tQD
         KmajUIoijeJTA+53jQ7/UOdvAHN10/t3BUusiQzafn8RUoNjLCtVeAmbZXuGdUl3Xdss
         q0VDvHdGr8t97rPeZyTRKb4gtYyEqEarQVKW3keqQydHWg42NmG8UbucNo8Amj1fJbMw
         F8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nnnY0qZzpyWcYz9t1GkFET0OrIiyqld6FF+Y+aPvTG0=;
        b=CaGG/896x5Hvgwz7jfc8dirzlMumg5a323S7pT9FcTr1zEQSRsDZeDazedAZ7Pe/4a
         nMnES8MklUita5Axg0UwhqR3/OPDKsJjD8x79L8lmTpp03ebqDv7Ap9oRjS87JFqSGHu
         z+HwVNhIlR2OUWwmt44QiVWuuUAMdYM37Re2tEvN7lE0oK1Zsl7he4AQdf1LYz3XQrEs
         I+cipigsGRv6ZvnIACNWC/qe91LHaf9M3JgH0x2dwgYypbwSz6lFBaZhtVez8lSJtkj7
         pFrFa2Zh77nyty5ByDapT5WhgO77DUFW9qxh/tggMIUkygpd+4KPq9jHtu5eUfBBUpHV
         ZHBQ==
X-Gm-Message-State: AOAM532g+5ak9pXxBdEtj2/wwRMz6toAVFGaWGApPWQ9qdIsdm8fcEgk
        G03Xv2TJ3XuNjgCy9fQn3ZL/biB28KJxPAwN
X-Google-Smtp-Source: ABdhPJwzcx6wzvsrT27pVVUEOHH5wvZ9yrjirMmH9wKNE34QjeYKj7AnYVcayTobzW5YdCW6/Aralw==
X-Received: by 2002:a17:903:1cd:b029:f0:c1c2:9e75 with SMTP id e13-20020a17090301cdb02900f0c1c29e75mr25993165plh.54.1621870667607;
        Mon, 24 May 2021 08:37:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm12036277pgt.42.2021.05.24.08.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 08:37:47 -0700 (PDT)
Message-ID: <60abc84b.1c69fb81.f57b8.7b6f@mx.google.com>
Date:   Mon, 24 May 2021 08:37:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-14-g858d860b7028
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 76 runs,
 4 regressions (v4.9.269-14-g858d860b7028)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 76 runs, 4 regressions (v4.9.269-14-g858d860b=
7028)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.269-14-g858d860b7028/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.269-14-g858d860b7028
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      858d860b7028de9dabaa1e47753680bd2adb03d5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab951d3e8455641cb3afe7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ab951d3e84556=
41cb3afee
        failing since 2 days (last pass: v4.9.268-239-g6707ab3bcf1e, first =
fail: v4.9.268-239-g7ec3767d9eb2)
        2 lines

    2021-05-24 11:59:21.609000+00:00  [   20.418212] usbcore: registered ne=
w interface driver smsc95xx
    2021-05-24 11:59:21.648000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/123
    2021-05-24 11:59:21.658000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab95330e69d8555ab3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab95330e69d8555ab3a=
fa1
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab95547e27d1a22bb3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab95547e27d1a22bb3a=
faa
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab98ed7f2e36d2f4b3afbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-1=
4-g858d860b7028/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab98ed7f2e36d2f4b3a=
fbc
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
