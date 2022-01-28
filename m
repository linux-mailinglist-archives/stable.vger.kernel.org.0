Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B414149EF26
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 01:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiA1APM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 19:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiA1APM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 19:15:12 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE88C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 16:15:12 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o11so4932818pjf.0
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 16:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wnlJHYaPAF5lqcJddK2d05M5csX0Lr5+htup78Ubs9s=;
        b=oPKQHgCUpx9yO8PtW5A1dwsAJNh8d15MH36lN62oVkXnoCZW4TJNTDJ/FOxgcBlJDa
         8zATMVHXFevLOXluzUgx9l5r8PE8Yy5v5JflvIyhx9mFoliTWCRkijXPJD8ITe42PZuQ
         hNLqdMP66kHjK0D/LAR3KTGBQqHgG7TSkht9TZ2IuMdcJDE71//V+GQyEFtCojQvXz4q
         aerUwAS91akbiSqqekHgzMfXJz8677ocC1ayMcOIYQWkB3k5WDB3opLzjhH3AnAQMUKS
         AFSkcM3QlI2wy8ks0evSQ4OnHjFmP04487lm83IqPsNI/Gx0K+HkZHnX7O+WiqmmTNZ2
         Zfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wnlJHYaPAF5lqcJddK2d05M5csX0Lr5+htup78Ubs9s=;
        b=nLbUhqB7G5LlrxWSegXmnbXbUVaSl4IT4t0B7TOr2KibOXJpqxgsWfK5b3LvB+fiu4
         8AIQD2yQ1mZn2lLrh2rj6fkve1pimULhzCfaveH6TKY/Y5CxsaJs9u9VtxcFzPZrOwO3
         2CeEEx3DGVzQHGtrFBBCAIy/GS/1dlOjxxC3sBzo9TN+Rnc8iDyhxsufB/blaCC2Af1S
         mDrSV6PEAcg+mbW05ezLJcySJJFWtKNExBxetx4VJtCLmHZVPL39Vtq7wbPDCmgfBrpm
         9oNI1hxhJXd6jWyGOKD5qL/nSHHIrvpQmQ05ExG0ynL47Q4ns8dNOwwbRQqOhzXHD4rI
         tqbg==
X-Gm-Message-State: AOAM532NZoOUGw2TmCGPgvHe7pSiL4/08YxUZLBR/T2S8Cmea9fAOSRt
        oTPGweVDzdbxrJ0+i76q6SeDDLa3szuXVO+eRAU=
X-Google-Smtp-Source: ABdhPJxyZA0wxsxMiwoR4v0+xJW2ZoxmObeiKBULsEN4JEoIgb+zPr0PHvAlnYvh2YCUh+rIemJZQw==
X-Received: by 2002:a17:902:868a:: with SMTP id g10mr5754321plo.80.1643328911474;
        Thu, 27 Jan 2022 16:15:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm7433194pfu.47.2022.01.27.16.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 16:15:11 -0800 (PST)
Message-ID: <61f3358f.1c69fb81.d002a.4ecb@mx.google.com>
Date:   Thu, 27 Jan 2022 16:15:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.174-12-gaa3124a3444f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 89 runs,
 5 regressions (v5.4.174-12-gaa3124a3444f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 89 runs, 5 regressions (v5.4.174-12-gaa3124=
a3444f)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
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
el/v5.4.174-12-gaa3124a3444f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.174-12-gaa3124a3444f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa3124a3444fd7cfa588271ffdc7d3cb77131142 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2fa63d613f98fe6abbd47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2fa63d613f98fe6abb=
d48
        failing since 7 days (last pass: v5.4.171-35-g6a507169a5ff, first f=
ail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2feeba0312e98cbabbd34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2feeba0312e98cbabb=
d35
        failing since 42 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2fef2a9731270fcabbd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2fef2a9731270fcabb=
d21
        failing since 42 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2fee9abd755faa3abbd41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2fee9abd755faa3abb=
d42
        failing since 42 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f2feefaef0e75a85abbd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.174=
-12-gaa3124a3444f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2feefaef0e75a85abb=
d15
        failing since 42 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
