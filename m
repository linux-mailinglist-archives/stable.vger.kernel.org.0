Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE445E9558
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 20:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiIYSME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 14:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYSME (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 14:12:04 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9122CC92
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 11:12:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t3so4393620ply.2
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=vdH4QpbcigKhH/o24Sl6sgaVipuNJV+T+JiUp0UFs9g=;
        b=VeX2An+Tkel+o/wlU8pwrB9ZV54jegvaNebsuStV3vkSSGYZL1D8QR+0WAnc+CwTTl
         EG0mlZBNYevuT5ccH3nRs13fXtp/vtJwOhhAsUQk5G4ouq39ng/0VMkNsePULCednOm3
         dR7pYMfcjX5O8OFYhchkjThkXW9KdWg61hMYAyRelhLJTgk/SKf8qL6YC4uo8H4KkDN9
         pXgtUYews/dlU2tB9sUK5dGQ7rLUZWFST0tFc63PTJMOPx9ngc6HZXbGDIBvJueW1kIT
         YESHEusDH4dgHsh1oKmLHIUGsk8qJyjv4Ntr16tmzgwijIU9r46i78IfIXjmZmnpsImG
         g6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=vdH4QpbcigKhH/o24Sl6sgaVipuNJV+T+JiUp0UFs9g=;
        b=5yOG1Sx13g9TnUly4e5xoSjr68jWxEdSrdhZSRfG265wm21l/GUOwSN2J05YHmOOd0
         GY6vjJ7fBO3gFfAAAQCPsxq1Qx0Q1+pG9J8R0ugxmAL2bCKVoCbpMDwBATyXS6qO/O4T
         CsJd0GxVlFjQk9FRQmPAcGCTi1FhHrwPcNuNqv0wct58BAbOb+chWzAEfgGaFDkecPgZ
         bcXBTmYvX8KSWREnZ0c8TQg8+sPXP06AZq5cbusHa7AG70s29L3nyrGVMUVbIp5o0Rwf
         RQwiVQk5BXbHKQnSWzdE41gZIPplzMbJVgvr1wILjxBZUuD4/Z3hU/W+Iwlhoj931dmy
         OTJQ==
X-Gm-Message-State: ACrzQf0oF/xUEjEgSlO4TzqFMg6+SdFeHYHB4uZM9PbXOVLaF7gXxiDU
        zZuU54yG9ZJF4Bsbr0/BfgtoAgNY5Hgrdt1tYhY=
X-Google-Smtp-Source: AMsMyM52Wq2j8jaPwEkpnqec5Lg938ARpUwU1trLuq8md0CArtX+VMR6zhlx+O72a6xUq9YHKkpsDg==
X-Received: by 2002:a17:902:f683:b0:176:cc02:ce83 with SMTP id l3-20020a170902f68300b00176cc02ce83mr18298785plg.88.1664129522482;
        Sun, 25 Sep 2022 11:12:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l16-20020a170903121000b00176b3d7db49sm9728711plh.0.2022.09.25.11.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 11:12:02 -0700 (PDT)
Message-ID: <633099f2.170a0220.5e7b6.1f62@mx.google.com>
Date:   Sun, 25 Sep 2022 11:12:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-123-gaf951c1b9b36
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 5 regressions (v5.15.70-123-gaf951c1b9b36)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 177 runs, 5 regressions (v5.15.70-123-gaf951=
c1b9b36)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =

imx7ulp-evk                  | arm   | lab-nxp      | gcc-10   | multi_v7_d=
efconfig  | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
          | 1          =

panda                        | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig  | 1          =

panda                        | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-123-gaf951c1b9b36/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-123-gaf951c1b9b36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af951c1b9b36ecee96d9b76169bddf4d6314d22f =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6330667d0cd5a2c6c83556a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6330667d0cd5a2c6c8355=
6aa
        failing since 3 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
imx7ulp-evk                  | arm   | lab-nxp      | gcc-10   | multi_v7_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63306a46558149d2d6355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63306a46558149d2d6355=
646
        new failure (last pass: v5.15.69-44-g09c929d3da79) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6330677f580eb0acd6355687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6330677f580eb0acd6355=
688
        new failure (last pass: v5.15.70-117-g5ae36aa8ead6e) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
panda                        | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63306a61fc7ab9dae4355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63306a61fc7ab9dae4355=
669
        failing since 40 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
panda                        | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/633066b5c9876c7636355694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
123-gaf951c1b9b36/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633066b5c9876c7636355=
695
        failing since 33 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
