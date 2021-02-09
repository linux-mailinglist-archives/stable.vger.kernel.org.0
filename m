Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8731493E
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 08:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBIHJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhBIHJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 02:09:25 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C8BC061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 23:08:45 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 18so9176932pfz.3
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 23:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qcDAain5FN5xzli51keZdiAITFzS6AwEY6ml58Fp/C0=;
        b=XlLDL3Mw43qgP29poZkGUHDlamlpmL74RTTj5nkdQKe3OpJsn52CdGpMHBYXbI2WnG
         S8N9EFyPRXr0+46ZTy+AMGhTLKNkqGzPIRdxHaqav+ZNH9A5v7pwrMeJUwQjr/7xLJDY
         PUL2rhO3BfS4eWA6Tgm/J0EMcKAwxuNPHdPUg2V+zaSUVNHp85sumkX62IJDqqObMbox
         YP1QLgq5M+mYHHIljq6Eiy5CXunv5EpaOm1ilWHl3bpkptCpPuHjVrqMQZxLRQtjnNAI
         hKKvEmfjsO5Y0qNsujEQN/JuTYOPtoPCUEo67c3B3Lwmyjd1oGmgi2cXulckCcVvEap4
         5Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qcDAain5FN5xzli51keZdiAITFzS6AwEY6ml58Fp/C0=;
        b=hCGXGeoTYssl6BGnKOzXH6CJtRB60uGctoXGvbNxEIctVi2sMevoQmYbKlvu8+p2d/
         B3QvlkGr0mTn00BZx/2FHd9IDjITl7gbgqQDiOSGk38syJxJGFt2zQQ33xAImE/BiO1y
         C5CyL8kqKpkaKb35o1Ol2dweF/Lk1htuyUp0HERrA2BVyYQmM3kVESuJKoQqeZ4EMnpO
         agYmQsdSUgZYsLrftHVl2NYTnP2CNLRVtQmkelvYLpTt3lBOAv3tOnLOKwBTbAaOw78l
         RgQ9Kim0855ufE3J8RNjGyXxNNwQPZllW85TEr+vx4254O9KKqU8BkGUGmEn7pYGrVca
         lXug==
X-Gm-Message-State: AOAM532WWAT2w3JeHFoJ9kb9ssAkExY8+ly55XR7UclU1M4dxW144/60
        ljRbVbBcIqSjfWE4ZKsv0zmkBY7DeZ+eCA==
X-Google-Smtp-Source: ABdhPJxKZzS9RJadBLw5v21GM76DPP+yxueyw3ImM+AFNKP+h7lzy9r3Hu5SYppVrx7wXAQPKmMkPA==
X-Received: by 2002:a63:65c5:: with SMTP id z188mr20095553pgb.332.1612854524361;
        Mon, 08 Feb 2021 23:08:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm1091815pjk.26.2021.02.08.23.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 23:08:43 -0800 (PST)
Message-ID: <602234fb.1c69fb81.4e2c0.2e2e@mx.google.com>
Date:   Mon, 08 Feb 2021 23:08:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.220-30-gccd5ad5cf53b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 64 runs,
 3 regressions (v4.14.220-30-gccd5ad5cf53b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 64 runs, 3 regressions (v4.14.220-30-gccd5ad=
5cf53b)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.220-30-gccd5ad5cf53b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.220-30-gccd5ad5cf53b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ccd5ad5cf53baebcb3d385e8feb2eb2a05fdacaa =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/602202c37dfc8bf9153abeeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-30-gccd5ad5cf53b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-30-gccd5ad5cf53b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602202c37dfc8bf9153ab=
eec
        new failure (last pass: v4.14.220-6-g6e064cb4e2690) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6022023774127a056b3abe7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-30-gccd5ad5cf53b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-30-gccd5ad5cf53b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6022023774127a056b3ab=
e7b
        failing since 62 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/602201eca0b9b9c7a33abe7c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-30-gccd5ad5cf53b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-30-gccd5ad5cf53b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602201eca0b9b9c=
7a33abe83
        failing since 2 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-09 03:30:48.689000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/93
    2021-02-09 03:30:48.699000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-09 03:30:48.711000+00:00  [   20.395477] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
