Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A995B35C722
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhDLNKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241725AbhDLNJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 09:09:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85E1C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 06:08:49 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y16so9175914pfc.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 06:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QA1DxoHxjx0Weo0n2YuGqf6CPMbJeeXcOHpIMz+h0y0=;
        b=qR2wpBJF2vjoZpmpNJLTSoW9jcAxSt6AI2JkIyjDOKCOP1DJbEBw4MvCih1So7CpmW
         Bzyq+n4OyqTzEBXH4UNj8ETrCPmip9vwFuMA/0Z0Runz28zyMR/NoDp0x2y31gmUk7xB
         yZd0bOyh3W9Cibz3V0ocSqVX+L9izFdbUU3cGevrYjwJmWvruwbVx4kpLPBdK/OndabD
         1Ebssag25bg05DUEwgBn/oVxyGeh6oCYyTs3lbbjHl/FoOqKSRMQpIoyzvbtacB38Xh+
         yjt8vydDjLhFo7n3bvVUFa7h1ehBJAOr5YSt8tlYkh8tWPUfTAuomogxE1zWlVKFEQUF
         fJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QA1DxoHxjx0Weo0n2YuGqf6CPMbJeeXcOHpIMz+h0y0=;
        b=M1wZi44nr9Kys3fsOzoH7hZ0j9Ian1gJ8lh0OKTJM6prm8OpPezx8Id9hVt5UxSFeJ
         O4Qbt4feWlPZTiJKKr6iQfg5d+dmijJLzaB+2kmm4DBFK4XsUTbSFzouvBfsApmI5np0
         +G/pBbUWSx4q9gfwENUqLvfmWAJggyHtfLNJIka3wf2GW5PPHK7rhp1EVizuUzNH4Vqm
         rKrYiJpTbNDQQ++nUTHcJbhx+VJWV7x3P1PjZCJvC8fGOwdPYq9TIeLAAEWWvvVTV7cE
         /z+RMmn3FrsWD841W6hgRVuCgG0Z+ErdhLQiTTl+5n6jk/yg7JH0e5lOosy1jbzrZyWa
         +d2g==
X-Gm-Message-State: AOAM530OYnqV4pAePGcpnrMYqm5vV6M8CYO/PBmVq9wrEZaSMSNM690U
        sSo4IJgWeW3ryHca3I7JdB900h3rQIiuQrSw
X-Google-Smtp-Source: ABdhPJwtoqO7RhnTptoFcMN6p2hxKIL5uNsfZ3CLKLt3IlUdq+dN0crPVaareyKmmQRsD6rfUT3LwQ==
X-Received: by 2002:a63:d58:: with SMTP id 24mr26958328pgn.171.1618232929268;
        Mon, 12 Apr 2021 06:08:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fw24sm8997288pjb.21.2021.04.12.06.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 06:08:49 -0700 (PDT)
Message-ID: <60744661.1c69fb81.34322.4b7f@mx.google.com>
Date:   Mon, 12 Apr 2021 06:08:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-42-gd1dad178aad83
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 4 regressions (v4.9.266-42-gd1dad178aad83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 4 regressions (v4.9.266-42-gd1dad178=
aad83)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-42-gd1dad178aad83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-42-gd1dad178aad83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1dad178aad836b015f3d3c4012b4be342d205a8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607412c8ee6091c6afdac710

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607412c8ee6091c=
6afdac717
        failing since 0 day (last pass: v4.9.266-17-gbef36b8f37175, first f=
ail: v4.9.266-17-gb18de8247ff14)
        2 lines

    2021-04-12 09:28:36.224000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6074111649087dd8d3dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074111649087dd8d3dac=
6b2
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6074117dc86faa9e70dac6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074117dc86faa9e70dac=
6d7
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607410be5fe004dae5dac6c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gd1dad178aad83/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607410be5fe004dae5dac=
6c2
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
