Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEC528FB6D
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 01:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgJOXIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 19:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729904AbgJOXIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 19:08:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7607C061755
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 16:08:06 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w21so213915plq.3
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 16:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iX9OtlnVbJiDBsSrMy9xWzffHZ1ZDi+cluXueefPtQI=;
        b=ZMldKopttV7XkBCG72S8BUXlh88R1l9ogChqX16ivX8Sw9GTF3cSfwEb6Y6ieFz/9r
         G5xnVGZo2PToYCR2aT727UI39d8expE7oYmpa/ibvqg7XMw3C7UePFlh6TULCSgPJGOe
         VNzgDQ8rKfsiZdPZwKUXKFupuLU1px3yLdrqEmD5aAJ+cvX+Lq12Jtgz6nBjnqXE/c2i
         D3zvg7Bk475CZgWkYn1PEuySPcIXau9DUWXJ446KrfrWmTK2ygvlcWjuLpjelEIaOZsn
         CBSJZ4jWm+/c0pQfyHdnropscVtt8IncR7e8RPqPS1PGDOhGFJQSKU/i0OHYeumo0/GL
         adew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iX9OtlnVbJiDBsSrMy9xWzffHZ1ZDi+cluXueefPtQI=;
        b=BR3k04QNb/JFZIdUbdSiIhQwrFrxZ1v/1o8UoLn3sBNFGjkTx4s2v9+P3P5trlJ2kw
         8m3duhsUacROT43S+TrM5ei5/xjqsMS2y9rs4fkKYbUBB9ZnOnoApfStZl2UZgt24y9f
         gy8hhI649Tp9XgNPKxU9DsrSLeeiI98KgKLGcYRNVld1JKcyTA8sA1kiXQiJrJM8GRyX
         4VQlH3DWZbdSDmbriWquQDJaACHmMduu/4H5Trq2ctEg604jJRIM07NKg9Z+yLap1Y4l
         VBryz+3zc2IgEbVAnIUPHwS7dpZ1vhWcN9ZlG9bWLH1eZtt/YcFYEOP9IgURcFIuEaJr
         Ys1Q==
X-Gm-Message-State: AOAM533ty7KciUQj86seO2bSvyZa5OuAqWjnDgySH0qeLdaHCts4LoSx
        Tdtg7WII78iaxTpprv3ORAA2H1bX/oVC1A==
X-Google-Smtp-Source: ABdhPJx5oPAlCgCvZaDIlK/REHHa6io+8OeTIO1aePnfoHYY1pqMWnNG8To3Y6M2fgQXOlYtMnPnzg==
X-Received: by 2002:a17:902:aa8a:b029:d3:c9dd:77d1 with SMTP id d10-20020a170902aa8ab02900d3c9dd77d1mr1036644plr.0.1602803285791;
        Thu, 15 Oct 2020 16:08:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18sm319239pfd.210.2020.10.15.16.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 16:08:05 -0700 (PDT)
Message-ID: <5f88d655.1c69fb81.e6baa.0fd3@mx.google.com>
Date:   Thu, 15 Oct 2020 16:08:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.201
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 168 runs, 2 regressions (v4.14.201)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 168 runs, 2 regressions (v4.14.201)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.201/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.201
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a21a9b514b8821af1230fb1a751600d847aeb1a2 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f889e7d3909f7374f4ff401

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f889e7d3909f7374f4ff=
402
      failing since 83 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f889cfe23016f04cc4ff3f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f889cfe23016f04cc4ff=
3f1
      failing since 198 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
