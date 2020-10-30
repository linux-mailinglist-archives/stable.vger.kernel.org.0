Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D45A29F9B4
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgJ3AaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3AaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 20:30:20 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29FC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:30:20 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y14so3755460pfp.13
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gDJne+p30TNvhfawdlIFSv1D2e7PN8Mji4eOjDLPz1g=;
        b=ldJGZBql1MCsP2QwQtL3K1c2QME0lmBWDhaRLQAaH5C+kE3RdrZzNe4CtXB/t7Da4D
         +JF8v3sbCSRjBDO0auRghcOzZ+4tTxUuy35h1Azji1kaDrZ5LfgUHOAsxI1RvCc7L544
         Ba3KU9Dm+2rLAuGjzDkptU5AA7Hky3D+GZ+ZxjVfn9WhmWfsYhhrfbkya/o7MxtwcWF1
         cX3TDXzlJGtS+gfqpaJJN/Iu0BtyKcbVm4+yycOHdZw7o98oMGNaOUyop+OUesmoHlcw
         ERtCyIzN9K3Fiq1lVbk97gmissARbyzgu2B67iakVCmfz7TBtlzwQggeRSc5EsNyy3+G
         Njkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gDJne+p30TNvhfawdlIFSv1D2e7PN8Mji4eOjDLPz1g=;
        b=PBZcBmbDI7oQjQcrClqsPtKkVxKVK8PwUMOvI+CICoZyDeUXZdmo7tDpsj2bIui+7f
         0LjpyxrRRZo5zQ7qcgZSIlP5z4ZjUMkVG8sAafYZY4BsOzTG1wXYLnhAkLDJvXmMdAhD
         6Q5i8Ti/w7B4U12mO3UVSGLTBPIxqd2eqtks/iqSnlIhfSOWCCNHc79T72tvDGslfKHA
         1O64wauG4nPd3oMvSKSod5x7JyKb0la9mwBXS3gRuxkJ/Mp4Tl57ldVmz1i9DOVOY6s3
         Fb535y8ROkJ5H9WlR+rd1d9SlHPftkTm9CsOPToIXsE633MV7jNUgRnd6QYKHKBfEyMC
         mpVw==
X-Gm-Message-State: AOAM533j20ABpLBIVLwXGLZwWEe9bMANcdMMD1JaGYquLzczNx2VQGgI
        9voBgO2VE3rka9B0oiFGl6zB0MHbjxRg2Q==
X-Google-Smtp-Source: ABdhPJwILO3qkW7XVpOct9LJghmaYpuqeyA7BNmsWJ9gu2+FJOJBbs8p/HzsWuNf74CGSDkn6NS5tg==
X-Received: by 2002:a63:6243:: with SMTP id w64mr6078609pgb.228.1604017819255;
        Thu, 29 Oct 2020 17:30:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm11sm1057985pjb.24.2020.10.29.17.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 17:30:18 -0700 (PDT)
Message-ID: <5f9b5e9a.1c69fb81.a6102.2fb1@mx.google.com>
Date:   Thu, 29 Oct 2020 17:30:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.8.y
Subject: stable-rc/linux-5.8.y baseline: 200 runs, 2 regressions (v5.8.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 200 runs, 2 regressions (v5.8.17)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
gressions
----------------+------+--------------+----------+---------------------+---=
---------
beagle-xm       | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1 =
         =

stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      33156ccb29d933783595deaab64b13ec5303a22a =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
gressions
----------------+------+--------------+----------+---------------------+---=
---------
beagle-xm       | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9b2cad47392b583e381032

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.17/=
arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.17/=
arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b2cad47392b583e381=
033
        new failure (last pass: v5.8.16-634-g5be39e9f29ce) =

 =



platform        | arch | lab          | compiler | defconfig           | re=
gressions
----------------+------+--------------+----------+---------------------+---=
---------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9b2e2b0df24cf919381016

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.17/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.17/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b2e2b0df24cf919381=
017
        failing since 2 days (last pass: v5.8.16-79-g7b491c4b6b5a, first fa=
il: v5.8.16-634-g5be39e9f29ce) =

 =20
