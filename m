Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD018331194
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 16:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCHPDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 10:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhCHPDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 10:03:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB2C06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 07:03:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so3131144pjq.5
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 07:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G6Glgjf8QvCTBUDanYCFKkNFh5RCt8ML5K2pZwfR/5w=;
        b=LfK3Hd1TEBoKtDZ1PLQTH8YGNWwZBmNWC6CSyP1WsNqmLDunOC6kvPvYkcaRGpJpP7
         BZVU4uVDAB/yHxobhuqSqjehBRxKTPwlqfMsqVue9XZdnuXEr0E7iGbULY76DUPEpnco
         3J2uqpICuh/rLU5un5l7vsgBQpnxCRB9UHPhGRPJxHEJVGLS9yhyWn/6Vob1m6oMPveZ
         DaFjtBc/PWnYG2uN05XErzdLRDOEV1eHywzEZ6mdO6hsfPluGvDNjTrG0nw6u/4pWCHQ
         QT8FXdT2I/cziQWdK6j0V1ttHxgIteK9jzoFMKWxHbat77Dxs4CM1eQ2OtjNTnAyMz4Q
         O0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G6Glgjf8QvCTBUDanYCFKkNFh5RCt8ML5K2pZwfR/5w=;
        b=Kfxtd/zizKZReyfeLzTFE2+w1Q9XU5X8E06jeVHweDb2YXERNi9kpXiJpq5iorUXmT
         GG9EicZOrkkmsN96iM6yLr9X253pj2oIfznbBtNeqWVS4ZBNZVNuJcx1hALRXi/vApvZ
         zHq45Q9l25LX8HBZ/s4K58J0YwOiDAqKGN9rRzPej9OXNLgtEHkORbIMGrQ6385O31K4
         JJ/CDZnXSaW6y7h1CovfBpX+dx6XAplgNRhchs517FqtcT9mTCBO0MBR3sj36tiyCTnI
         rkqvb0y9Pma7qf99cfQnYSQMp11SNBGGCAunTzqHISMykvfM1xmrgHFyytzYAEaDDaV9
         wt4w==
X-Gm-Message-State: AOAM532gI+194dlMy3U52Y9qVTNl+e+JzSnNqy8swYEtCne96SvOy8Bi
        jUr4HQGOJJdBTGkyEu6BnBgAEG4MYz909Y0j
X-Google-Smtp-Source: ABdhPJwwdNXb3lnq6S+NWNP7LZV0EWpDLkjUafT+Jqqk64pfj+DBYnFwJO1EJtlZlvyO7BY4RT2Ghw==
X-Received: by 2002:a17:90a:6385:: with SMTP id f5mr25760963pjj.91.1615215780318;
        Mon, 08 Mar 2021 07:03:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k63sm10879268pfd.48.2021.03.08.07.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:02:59 -0800 (PST)
Message-ID: <60463ca3.1c69fb81.26a44.ad7a@mx.google.com>
Date:   Mon, 08 Mar 2021 07:02:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-6-gcde092bbe336
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 77 runs,
 4 regressions (v4.9.260-6-gcde092bbe336)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 77 runs, 4 regressions (v4.9.260-6-gcde092b=
be336)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.260-6-gcde092bbe336/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.260-6-gcde092bbe336
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cde092bbe336518bd9eb5c1bd4e2a3df8604c12b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60460af3047554be18addcb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60460af3047554b=
e18addcb6
        failing since 0 day (last pass: v4.9.259-42-ge118f9b98b96, first fa=
il: v4.9.260)
        2 lines

    2021-03-08 11:30:49.189000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/119
    2021-03-08 11:30:49.198000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604610c6d56985e211addcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604610c6d56985e211add=
cd8
        failing since 113 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60460a7df07335805daddcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60460a7df07335805dadd=
cc2
        failing since 113 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604609e36ebf49f62aaddce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-gcde092bbe336/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604609e36ebf49f62aadd=
ce5
        failing since 113 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
