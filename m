Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359234CE5FC
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiCEQqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 11:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 11:46:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9046D972E7
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 08:45:24 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id k92so670533pjh.5
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 08:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CiAbqgCi+Jy69hhgarKayW7rJAlr7vrpvsxBVC4FNl4=;
        b=1KfErYm1OQXjcO/IV3ipH8kXQH0gp29Ay2Ds3h5CzPRNafSONQ6HBV1fALmw+EQRgv
         C38GVnlG0dQd0vIhAQFSLgw3PONISIu13CY37JGsFR4XFTry56FP7K/M7nl9crcJRIfT
         MgOWs0t18Jx5aH5TzxAAmRR2HWBrvWJ42ja4CQznpu4O5FPuE7+SVxPVQbjmen+r8/Pg
         hsoan+KVbSx6Ekvzb1ZpU7awkbC+aMPxSmUi8kGk2zDfVuk4bykOf9XWAcc1Pu6pwzTU
         2AQQJxBD9u2oOANH3pyTJNwrb2tuuJ0cyWpHxLJNy92PR58WqM5EwP1Mlx3LRg0jf/LH
         7JyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CiAbqgCi+Jy69hhgarKayW7rJAlr7vrpvsxBVC4FNl4=;
        b=1pELhiV5Pj7mJTJAW60PzY9O3U5D381AMnuLySXDapHkYUSjO6eHn9XzRPEi1GfghY
         okQbEyygm2KtQpCGxq45T4w0Vbcsq4gOD3D2BndeGT16eEWBg2WH5d0OFwA6EhNpKCvD
         apieXxV2LBD5InUjbmBwvkMMNmyQoOMG95Svx+xQbmTRfXHR06lHathsJ0lCJcLe38uT
         GmPnd6J1iqeKYIPPxBRT52YNegHL6EIomsU1c8Wq4apZamRTkuJJvFkap7SNkv1k/C4C
         SmKPSz6Cx5E0E7N7c5tWdY0c7J68kJbgKUNTKiPlOO46U3zEiYXaOznx83AdNJTcRB2h
         fmrQ==
X-Gm-Message-State: AOAM530tpDprSx+eyTmMYRwJ80IJAr6K2u/ud1cBghQ5ZtjsdfXnGqgQ
        pDECLqZfIzpde4xBSsy0bCPKtDFCEudWC4aht6U=
X-Google-Smtp-Source: ABdhPJxaStgLOeDhK7on2jmYyFIxqRnH+v6gP4zmJoIUzkeTiu21D29gpMpUcRcSvsi6lxmoUB5XRg==
X-Received: by 2002:a17:902:c40e:b0:151:a264:288c with SMTP id k14-20020a170902c40e00b00151a264288cmr4176502plk.42.1646498723869;
        Sat, 05 Mar 2022 08:45:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj2-20020a17090b4d8200b001bef79ea006sm12106264pjb.29.2022.03.05.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:45:23 -0800 (PST)
Message-ID: <622393a3.1c69fb81.80399.ed10@mx.google.com>
Date:   Sat, 05 Mar 2022 08:45:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-22-g33c17a134af7
Subject: stable-rc/queue/5.4 baseline: 86 runs,
 3 regressions (v5.4.182-22-g33c17a134af7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 86 runs, 3 regressions (v5.4.182-22-g33c17a13=
4af7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
hp-x360-14-G1-sona       | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-22-g33c17a134af7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-22-g33c17a134af7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      33c17a134af74d153d0e27359328c8ff3b676586 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
hp-x360-14-G1-sona       | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62235d9bf1d3097821c62974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-2=
2-g33c17a134af7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-2=
2-g33c17a134af7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62235d9bf1d3097821c62=
975
        new failure (last pass: v5.4.182-14-g25d84285d53b) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62235b632055cd35e5c629b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-2=
2-g33c17a134af7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-2=
2-g33c17a134af7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62235b632055cd35e5c62=
9b2
        failing since 79 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62235ba3a3d10ceb92c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-2=
2-g33c17a134af7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-2=
2-g33c17a134af7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62235ba3a3d10ceb92c62=
96c
        failing since 79 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
