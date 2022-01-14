Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C671048EFB1
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 19:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244061AbiANSLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 13:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244041AbiANSLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 13:11:25 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD9BC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 10:11:25 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo14922991pjb.2
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 10:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9D8Mz5n74RCeYr0S7w+85pAr04KeLChFQ9U0gy/Xwlc=;
        b=DOWhoXiOyfE+wcsm+Re0eeknksTACptGruWME/5SBn5IrcFAmpSN3LpihL0x6E6xrc
         gBjIw/PUtIqboSEDiCXuBRj0uUjQV20ciTinT5JHQ7ipKvRyJ0VToRrOrNPsOWKRNW/I
         1nXV+FVmSGUbSF7lmp59Uiv45zd4kzGyk+LnCzSotmSRyuxnFfDjJWDfuIy0wuGiptrb
         X/zbkEh+OmDdeMQxxXRl/zOCo1Is9suvnEvUdO//71S6xttX3TvoXbISqydbqt/OeSjV
         sleYhFf+tqjgAsdArB1dyYF0CI/hyYjVoaiJBQQ46UE49Fmm8XBaQRQm4RmxeK+HX3r4
         CtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9D8Mz5n74RCeYr0S7w+85pAr04KeLChFQ9U0gy/Xwlc=;
        b=TaOhyszPiexgXWuimlH15Wgp78k9Pz1UFr27Om/5tVr8pnbZoQvPDRmDmJIDBx7sqQ
         HmIPy/2tzByD4D/weHLRr81KfkNaTzOVwXB18FzM8AAcNgkg2zxCBIyqBAby+vHLr3wu
         AKw7+wNQQLKLpydHof3rM811AFYV32hP/AzSpcxwtKiX28prRef/gCtgIxj1u17unyH6
         3xurP9oJetmi5wBuDfIU9ZUG4JZclP/S7svFh2NZr8rsgyv4YmyGJbdy5slfb3frpTeP
         y0teY6UQaaCC83LpbiZKLFGVHxUNKhvPHPzUzaFvp+oh0rwJW9UO0OfOpsr5y3Hz3OxP
         GkIA==
X-Gm-Message-State: AOAM531EfrqOrbnSo/OhofTEihlBDCrxR8icB3KRWOPsczXqI857nyKq
        8FnwQaCOaiAnZA42pyPQnA9CdhYCp7rYwKzz
X-Google-Smtp-Source: ABdhPJzVPXzg2zPnfZtM3l89uji2DRi9S7e8aOscucgkDOlE9geNOSwPiRApto6vuAKSB1+N2ZcAdg==
X-Received: by 2002:a17:902:76c1:b0:149:989d:c6e3 with SMTP id j1-20020a17090276c100b00149989dc6e3mr10384454plt.127.1642183884329;
        Fri, 14 Jan 2022 10:11:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y64sm5020160pgy.12.2022.01.14.10.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 10:11:24 -0800 (PST)
Message-ID: <61e1bccc.1c69fb81.9ec7d.e114@mx.google.com>
Date:   Fri, 14 Jan 2022 10:11:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-19-g8821fbf93a8f
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 151 runs,
 5 regressions (v5.4.171-19-g8821fbf93a8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 151 runs, 5 regressions (v5.4.171-19-g8821f=
bf93a8f)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.171-19-g8821fbf93a8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.171-19-g8821fbf93a8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8821fbf93a8fcee78fd7c2bde7674bf0e34adbf7 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61e1870ace7c2bfe92ef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1870ace7c2bfe92ef6=
753
        new failure (last pass: v5.4.171-16-gf92eff28192a) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e18bd96bb9a2173aef674b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e18bd96bb9a2173aef6=
74c
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e18bc363d2490e28ef674d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e18bc363d2490e28ef6=
74e
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e18bebc0ace99234ef6747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e18bebc0ace99234ef6=
748
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e18bd5aaa3efdd93ef6740

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-19-g8821fbf93a8f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e18bd5aaa3efdd93ef6=
741
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
