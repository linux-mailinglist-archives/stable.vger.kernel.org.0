Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1544D4039BF
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 14:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348327AbhIHM3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 08:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346096AbhIHM3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 08:29:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A12C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 05:28:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso1139299pji.4
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 05:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x0+kzuCEHqtsMtEY8tcNMYaTqjNRjU37EA0/fWQ0oBc=;
        b=sLjv4IqJpVLjjWYOIfhlLULVIE1xe5Fcy61LO3/GGROskqNjO4INjRdrdbVg/aaSGC
         vTncdLlN5eDKpbTf1uaJzJzpJLdOLEstHQsHNaPNz6pQ94orlyZ/JEb1NeiqHOZwbchM
         M8Ojeae4jjGCFy7HqLxHfGbLmi+ijIjsdfFKo87JSeI7Gx/H85TZY1tZFr5Lh3t7UiYb
         rjetXgP3Hh7vpMm2gABfNn+eB/b5TYNpQR0MbYALzcH2fb+K/RQoQXuTRfA8G9dWcXQX
         Hglk7ATsc67JtFQJ7jqpCGKqJX4jG8Hk3+3ZgJb/b4nHjkAfWYOWQNsF5nPBrz9AY82d
         GC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x0+kzuCEHqtsMtEY8tcNMYaTqjNRjU37EA0/fWQ0oBc=;
        b=C2uJWF2iKuzc04fcHb7fF2KfAWPzaSkH+ZnJyv+CureAlQqGZjbAk1PaiZTp8yf4OZ
         k/YRvcfrZ2v7k81pT9aogGyILPFieok/D0iOgLaDFQ12gyngjilgMx89TkNROipOr0FG
         D5wgf9D3umpdsK20cDrRvbn1t3doS6pK2B5dxCiW9bf7YAxpvFY8ufU/diPi2OeFo0Q4
         nCshO/usKbyx/mvnezuFWP6CCtHUznhzBMLzPszEWsRCP/TD1gssRdWCbJFwAlAm/t2r
         Ssy01BzYOeRd5hVGhDbZK1BGg+1jwZDlCbxnc6+4XvDPIQTnIp8GMoSe4fbENiKR7itt
         7UNQ==
X-Gm-Message-State: AOAM532t4ltXc2eYTivixdq5va+aFIDPtCdI4rsCfay1KJh97VcBO4Va
        k5723ahl/7eBqPXomm3mGDymmbMSQ4PGKKRV
X-Google-Smtp-Source: ABdhPJzToSZi/SPxxXqo4NYoO54fqXEo/NdcUg5Ju8bcCdlOplnMWjkBLkZNA6YIxpAnEcM6Oc3Jgg==
X-Received: by 2002:a17:90a:f2c1:: with SMTP id gt1mr3864858pjb.224.1631104125917;
        Wed, 08 Sep 2021 05:28:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4sm37129pjj.44.2021.09.08.05.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 05:28:45 -0700 (PDT)
Message-ID: <6138ac7d.1c69fb81.2d6c1.014e@mx.google.com>
Date:   Wed, 08 Sep 2021 05:28:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-12-g5b566ac7a021
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 167 runs,
 3 regressions (v4.14.246-12-g5b566ac7a021)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 167 runs, 3 regressions (v4.14.246-12-g5b566=
ac7a021)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-12-g5b566ac7a021/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-12-g5b566ac7a021
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b566ac7a021ad0422f023baf033d41db0100e4d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613882a7a5dbdec09fd59675

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g5b566ac7a021/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g5b566ac7a021/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613882a7a5dbdec09fd59688
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613882a7a5dbdec09fd596a2
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T09:30:01.435774  /lava-4474515/1/../bin/lava-test-case
    2021-09-08T09:30:01.441021  [   14.348165] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613882a7a5dbdec09fd596a3
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T09:30:00.416770  /lava-4474515/1/../bin/lava-test-case
    2021-09-08T09:30:00.422025  [   13.329283] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
