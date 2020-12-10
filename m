Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165552D695A
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393860AbgLJVEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390934AbgLJVEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:04:39 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE9FC0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:03:58 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id w5so4619325pgj.3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5UkEtkz4sn10zwHlSIa0dVNsROuKotnCqcHqKbi3pu0=;
        b=BSU+qFsBLmJqFaFlyzolPvaAK7BN7PmFSQABfqJbrBhHtEDo2BUvEZ4F/WiF4OWOIy
         HJ9cfUZi3FrGGyXNJeAWDEyRj4/lgBXvyRSftJlNY846T6DQkxOdIjIixJsI0evcoEQK
         3vVJCTEk0BuEWhCJs2shuT/yeJ/+rf8PS74CXbjjBd7ki03Y+M8HrqrTxaBxdK/ake6x
         IIqhehmSp/b6Tr4kCskwuWrsE4uD7XtyOJR6HEFYN83xZRKU0wzVLMKohexZ9cCvMnEk
         USkcf7mJZDrNh9CKc0YsN1CFlSqsfRjnzIXZmPWLvbBBdOyu03rexjJv8MA6g42XZfLX
         QMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5UkEtkz4sn10zwHlSIa0dVNsROuKotnCqcHqKbi3pu0=;
        b=Vp164Z325SUqmQVz63YAPUWTN5Ij4JiQG6RFRplRHizxCNNZ9gw6rxTZyGPQsFHBGA
         AacPMUjVj5FwomDl5MURozcmyiAq61neRzr02qEdQyml052tzHhYgUN81ulZULkGcaBr
         w2sJMXH6gm4rgajB0N1NSOoEQupXEWqjMMZx94BO7s8AR+/LNRHOHfmzOoMjzHIRy5Yk
         MlIRd4+Mm6FuKkJip+5lhIiuhLYyVcCxpoiTH6+MMPvg6SoyVCFymSHs/aFix9kC66S/
         Nh8vKMzvayGmDI3B+9prcGmNYtw+KkwxTyRwCZwJY9o99Tws2w6PTIjc1DfXCNDlucX9
         CwGA==
X-Gm-Message-State: AOAM531uDsYGlvNIxSPvq0DqJWJS3sxTYXP6GjBzrBH654GLi5WUj5I8
        EC4Y02LNrhV/hozsWFvi9r57Wk+jVTcNSw==
X-Google-Smtp-Source: ABdhPJxfxcpD1chtLRp6CCeM3AspxTzlgHJjQsVmAwtav9LTWCLCr96o5E49PvnfwwOe4IyS0XlGyA==
X-Received: by 2002:a17:90a:f194:: with SMTP id bv20mr9522659pjb.11.1607634238013;
        Thu, 10 Dec 2020 13:03:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm8265596pfq.57.2020.12.10.13.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 13:03:57 -0800 (PST)
Message-ID: <5fd28d3d.1c69fb81.ea73d.f383@mx.google.com>
Date:   Thu, 10 Dec 2020 13:03:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.211-31-gad2d75a4fc6e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 108 runs,
 6 regressions (v4.14.211-31-gad2d75a4fc6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 108 runs, 6 regressions (v4.14.211-31-gad2=
d75a4fc6e)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig  | 1          =

meson-gxbb-p200            | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.211-31-gad2d75a4fc6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.211-31-gad2d75a4fc6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad2d75a4fc6e81e11297320a54abb176b5de8dca =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25431fceeb58247c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25431fceeb58247c94=
cba
        new failure (last pass: v4.14.211-32-gf4d9ae6d47a42) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxbb-p200            | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd252c88b82302c91c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd252c88b82302c91c94=
ccf
        failing since 254 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd250c364665bc066c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd250c364665bc066c94=
cba
        new failure (last pass: v4.14.211-32-gf4d9ae6d47a42) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd253e56f3a3620ecc94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd253e56f3a3620ecc94=
cbf
        failing since 26 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25419929355e103c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25419929355e103c94=
cc9
        failing since 26 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd253e36f3a3620ecc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11-31-gad2d75a4fc6e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd253e36f3a3620ecc94=
cba
        failing since 26 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
