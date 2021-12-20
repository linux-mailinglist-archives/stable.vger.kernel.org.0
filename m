Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9643347A8D3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 12:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhLTLgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 06:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhLTLgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 06:36:05 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E6CC06175F
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 03:36:05 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 8so1560923pgc.10
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 03:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eB1jyeOzAQutnu+gtVO2B4uaiFpHMuRJeaEany3yJ7w=;
        b=rlAVOlE36Ssn5JSNpIkHgpDVI91xcjU+CPVX4PBwjEGyKL0jN+v/rNQ4m04SPPY7e7
         rVokau6YcVCyamK2236FHpluA3dl0vbHm9yie3TQ1qGYgDWYhdKuFpaSIUlQa5hQJ+O3
         ithCEF3flkm3sis62GYwvzlIC5C0k6VtVCiuXouUMDKRiSxeLfmJVb2RHOavrU75PjR2
         5Wnl4iJtIP3I+gyGBpeOllSWdSMeeETwZktXZKHkr+L0HJLgRMuVYseM1iVOg8Q5azhZ
         k58rDNTMeYJBAb0Md2P+pMeDpGGesSdb/YJsvsyuaLBRFud1KKh07zteBrpg4nMIGAaH
         s/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eB1jyeOzAQutnu+gtVO2B4uaiFpHMuRJeaEany3yJ7w=;
        b=yed2491TfvP2w3gm/adTkbBFPL+PNcojYpub2jk6wV5FoDtt+QpNukdM2hNsvq6xh8
         nPiar/GhKTDeAhOaxrxa3ZvBR1gztjAS4ECcX7P/2KG+9GgsUO4EraI3HetWIIkNmeqa
         ZNwbS41ZWji4/Vf7GdXF1B+5C/HJOOeDKg2DpTktzfcM7aOGsZubXfp1m+/eYAofP+Iz
         wSgQtRxSf1ua+3FLUcCB8RyY4j7v6j4z8xA2IqEUUA5jnSMvSm+TxK2WgxeOBiuC4Viu
         lzJzklrBPyusOLksN59sf79jEbtrl5SKsUhmbh794nOXIxGT7u/aFD4bGAkiu4LdPiB2
         q+Cg==
X-Gm-Message-State: AOAM530mFr4Vfv1R4o9f6wRxSuYwja8GGGQssIdt4VNzpQHjTOzgVEzE
        WgpaVYZEOXB9KAOo/WHFsGggPCd0rQKvnkxh
X-Google-Smtp-Source: ABdhPJwpoM45ymT1dmCZ3dEsry/EUMi12AYB4m+EuluyPTdhRXT1u0ZUl4c70mZLuGtkWQrlBH7hSA==
X-Received: by 2002:a65:4c43:: with SMTP id l3mr14689028pgr.398.1640000164419;
        Mon, 20 Dec 2021 03:36:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 80sm6648155pfu.158.2021.12.20.03.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:36:04 -0800 (PST)
Message-ID: <61c06aa4.1c69fb81.a117e.1ba7@mx.google.com>
Date:   Mon, 20 Dec 2021 03:36:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.167-44-gbf5283673cbd
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 193 runs,
 4 regressions (v5.4.167-44-gbf5283673cbd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 193 runs, 4 regressions (v5.4.167-44-gbf52836=
73cbd)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.167-44-gbf5283673cbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.167-44-gbf5283673cbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf5283673cbdd7c614eb87975ae9f1b37a0ef3ec =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c034a31aada103da39711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c034a31aada103da397=
120
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c034bf54b05ce5803971da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c034bf54b05ce580397=
1db
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c034a4ac6c4423ed39716b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c034a4ac6c4423ed397=
16c
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c034c2f4ec94d4b3397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-4=
4-gbf5283673cbd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c034c2f4ec94d4b3397=
133
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =20
