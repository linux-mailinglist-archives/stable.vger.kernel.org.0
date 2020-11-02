Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6830B2A36C8
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 23:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgKBWv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 17:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgKBWv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 17:51:28 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7112C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 14:51:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 72so5775423pfv.7
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 14:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zBm0NUBIEdzf4J74peUX3jNdxUXnTI9tpQtXmEcp2ck=;
        b=EK20XlJTo3tRNCqpda2eMnTfnyV44wOF6KS7DjX1QUEgLdyl7I2MLvyySmx7eT+X6C
         ZPqbYBohD0wb0kEDGFF8+jbn1zT/70AhbjIz00ZM0vTlCCN9ezGXN6KkDvtDK3/8XeSX
         Z/CQyVI9zvRZi9FfCKDsd0do9zy5aphWU3r3kQsJ4fEVdNxX2Ek3bk9+1bNejo7HrPFG
         LPqjHdmOO9+ceU1EbDo8NXRK/rH3iHPTsI0KDj47K194tro2KjSMpVYgJ0EWHW+zoV6F
         41tAt2e0f3XM9i8ZKrTk7wfl4tAQpnWfzVRNe6/Ea+SxLeibkRlrznd34ssasuKEBaV9
         skRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zBm0NUBIEdzf4J74peUX3jNdxUXnTI9tpQtXmEcp2ck=;
        b=SWPdhPgfqEvYE1KnSogvwKR+En4wG0kKYH1ynbrwKloW+/jqN7ZWKNhofVHd/e+VcK
         WO3Ne9UNQokyn+TMReRDPXSVD5YjswhI/ZEKvyaHS5sbEKtCEC1ka4oVrpUXlIiBQOuw
         PJycsOQFi1Cmwme9yvUYbqCH+yecJLXc/tAh+eNmS9jyBYO3t5Tda23iuzMk1N19DplB
         cSfAxoJu6WuitW/u1212D0P4B14buTcmehtMoE3wp3TFU9IzTIi+/hblPeCi8/JFIsIe
         6ZKafqh75egotEaY6nv8H5cGS0beiCTN5i6MXdEjw7A0nrfGvp6MaDVVDmQjhtx1tGrz
         6gaw==
X-Gm-Message-State: AOAM531XzV3hGdl8ThRFoCzRFZ+gDAGBWJZb/IKTJZeDz41gLd3vxt2k
        PiCcAZrnbu2v46ZwMtofUsu0oyXEx15l6g==
X-Google-Smtp-Source: ABdhPJxETTCjHR9ofJRz9EG7+ufn27hYNmEYqbye2tRZdul0FxfBnP+F4/M6u2mYt27HWwC9fNqo2A==
X-Received: by 2002:a63:e650:: with SMTP id p16mr5721785pgj.295.1604357487977;
        Mon, 02 Nov 2020 14:51:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm13763699pgt.77.2020.11.02.14.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 14:51:27 -0800 (PST)
Message-ID: <5fa08d6f.1c69fb81.3936a.4422@mx.google.com>
Date:   Mon, 02 Nov 2020 14:51:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-95-g49cb9af04b0c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 208 runs,
 4 regressions (v5.4.74-95-g49cb9af04b0c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 208 runs, 4 regressions (v5.4.74-95-g49cb9af0=
4b0c)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
     | regressions
-----------------------+--------+---------------+----------+---------------=
-----+------------
at91-sama5d4_xplained  | arm    | lab-baylibre  | gcc-8    | sama5_defconfi=
g    | 1          =

hip07-d05              | arm64  | lab-collabora | gcc-8    | defconfig     =
     | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconf=
ig   | 1          =

stm32mp157c-dk2        | arm    | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.74-95-g49cb9af04b0c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.74-95-g49cb9af04b0c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      49cb9af04b0cb05cea07fe8e0e25feec7d0d05e7 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
     | regressions
-----------------------+--------+---------------+----------+---------------=
-----+------------
at91-sama5d4_xplained  | arm    | lab-baylibre  | gcc-8    | sama5_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa05a52d9a613a90d3fe83b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa05a52d9a613a90d3fe=
83c
        failing since 4 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform               | arch   | lab           | compiler | defconfig     =
     | regressions
-----------------------+--------+---------------+----------+---------------=
-----+------------
hip07-d05              | arm64  | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa05912e98d8d4e203fe7f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa05912e98d8d4e203fe=
7f7
        new failure (last pass: v5.4.74-82-g6b43b55dd0d7) =

 =



platform               | arch   | lab           | compiler | defconfig     =
     | regressions
-----------------------+--------+---------------+----------+---------------=
-----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconf=
ig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa05a5a869217a7103fe7df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa05a5a869217a7103fe=
7e0
        new failure (last pass: v5.4.74-82-g6b43b55dd0d7) =

 =



platform               | arch   | lab           | compiler | defconfig     =
     | regressions
-----------------------+--------+---------------+----------+---------------=
-----+------------
stm32mp157c-dk2        | arm    | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa05bf4ac94b8cd983fe829

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-95=
-g49cb9af04b0c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa05bf4ac94b8cd983fe=
82a
        failing since 7 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
