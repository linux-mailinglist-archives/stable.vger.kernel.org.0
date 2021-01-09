Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243C02F03C3
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 22:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbhAIVRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 16:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbhAIVRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 16:17:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC34C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 13:16:39 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x126so8538123pfc.7
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 13:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WjZR31l8NUR6tGIAKqIq+GundJcnG6LTMsj3KxAAWWs=;
        b=cUgQb+oDjP2Vl/tT9dv1sjkLmQzoskD41H+V9/BNzv6+7/0YAuuHwkESAEcun+helw
         3rvh8edWqT2hsKiyEm6C/0j8xavCzJeSqToPi9wzCKrcslh1x29zAC0r1/a6udIWRrwU
         F7QL8hmOKBLRnpJaldxo4YVUTBqJZ8A4zw4UyN6S1krAcmD9Lp419jX8cAiXU3pYF+PM
         W7+02ncC+8sMOYG7eqgdoaCe7d4s35OLqjQs3LgYJJb8B42DKKO3FT11M2l5/5HKhtOj
         RJa+pWo4+PXenJfu7MLxiZG0x8H38z4L0ZyatsRJcjW/85BFo1WFEkCV5iHCL5W0ARbE
         UrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WjZR31l8NUR6tGIAKqIq+GundJcnG6LTMsj3KxAAWWs=;
        b=Z2bI0MOf/i+Rmc5omo65AfDTqHE+4vwy5NCzHw+viPtuWmf/eC50gwtXI9am9TnrGI
         SNaO/6VRJcknPMtIYe6dpw82EoPaTvDuZ44/puSL+4LHa3RXB/OPBxPWMRe2tCgf5DZB
         anBtwopWxD//MkAxF6GLQ+iWQyENJpiZfIGxTo11fGcnJUuwuc1rvuO/5ucJVNn51ufo
         9K+EwERGw6YPBfU2lG1KdbroRngVjqq6VeO2UPr9riLL8DuFASyLkOrRiY/YWhL9lDdI
         Vc+TcK9Y2DmuoDaAljUh0BcEL/GxKtTli2+PYVYBTbzTU8L3/hgKck4vt+lE30/WgrDs
         TdwA==
X-Gm-Message-State: AOAM532apSWzgR4CUBdAKGIuRel+Li/OVUL5Gz/+cvTHyg2uxOz5xGTO
        4bVLObIUtUN6DwGWa3vgP1RnHEDqU705Sg==
X-Google-Smtp-Source: ABdhPJzrBpWU7VPwdBHMSlfm++l2qa4ZkYSwAYUpvRqJkW5a63tCqDYNLa58lQ2WSp8DqT68/5MGnQ==
X-Received: by 2002:aa7:8423:0:b029:1a8:2c01:88f with SMTP id q3-20020aa784230000b02901a82c01088fmr13232447pfn.74.1610226998748;
        Sat, 09 Jan 2021 13:16:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4sm9156566pjz.28.2021.01.09.13.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 13:16:38 -0800 (PST)
Message-ID: <5ffa1d36.1c69fb81.90636.4686@mx.google.com>
Date:   Sat, 09 Jan 2021 13:16:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.214-5-gaf0f9a704068
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 129 runs,
 7 regressions (v4.14.214-5-gaf0f9a704068)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 129 runs, 7 regressions (v4.14.214-5-gaf0f9a=
704068)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxm-q200             | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.214-5-gaf0f9a704068/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.214-5-gaf0f9a704068
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af0f9a704068b4bf38383918977cad82a5606f33 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9ec145f81abbeb6c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9ec145f81abbeb6c94=
cd8
        new failure (last pass: v4.14.214-5-gd70de3dbd6983) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxm-q200             | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffa00e8fa272c2f0bc94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffa00e8fa272c2f0bc94=
cde
        failing since 32 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9eac70da8817df8c94ccf

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff9eac70da8817=
df8c94cd4
        failing since 2 days (last pass: v4.14.213-25-g4d76bd8af5ced, first=
 fail: v4.14.213-28-g9affacc59660e)
        2 lines

    2021-01-09 17:41:23.883000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/106
    2021-01-09 17:41:23.892000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9e9fb8522af004ec94d48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9e9fb8522af004ec94=
d49
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9e9f78522af004ec94d36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9e9f78522af004ec94=
d37
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9e9e549355e5a04c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9e9e549355e5a04c94=
cbd
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9ea18f8da91111fc94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gaf0f9a704068/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9ea18f8da91111fc94=
ce9
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
