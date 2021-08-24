Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924EF3F6BA2
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 00:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhHXWS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 18:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhHXWSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 18:18:25 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B14C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 15:17:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g14so19593268pfm.1
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 15:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VnJCK/VTmngpYLFzGa0kGWio7rX6J1e5zAW6ZUpFZz4=;
        b=VjJNe1BlTXyQNLAACEC7RZbywfc8bQy/PFEMIE5fvxaa/0ApIicTjlwYUvhYji4wx1
         InnM5X+c6/dmT1nziBqp92XW7s/STtPaO3B0y8YxwJUakhCjpesUS+eoYi2NrPw0FhHp
         eklD38tYMOTTYCS9v6ve2E+QzUrtBmH2zjp0OSi6VLVfzIOlFJjAWh2ZX71JGwTBZZLs
         pPfUjVpVjIHvtVydGX8GuLIKqG111sz9vvl0/us7iMNE2zp/7NMW22PiFo90xoyAc8ea
         9LVj/rbTtzL5Lv08ZkzffOtjB5vJQiR47M3bIMGd/N1qM6kHDm2FMa2i/TdLEC5g/ULs
         D17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VnJCK/VTmngpYLFzGa0kGWio7rX6J1e5zAW6ZUpFZz4=;
        b=W/xxa9MEj1CZ8SpubXEFzgxMj1HRlJ4i43HMtDzgmsUbzhDerXeH/w3YLa5u/D9Sqp
         eg7Jk9nvHkxU+rDX70ls9NkN4REElnXOuh+OqDjvNJD1/YNGxya8eFQrn5X+3RDCrjDf
         BqY7Yx2rharC9UnlW7rKX7fAsXFFzO6ZBU9/2UGwp84ObV62UR3xmliHME5t8kf9cONr
         WzUtPQCX4dzW++MzljlskB4Hau8uRNUwinVZ1D+k8chqOPllPMEtxhcHdg8YQtL45U2F
         h8muXnYpoMXnLLjBLe/hn0bqI8hbkAM+20cvyTXORdR2ersUz7FIpSGAdOStSjn0DFpG
         Fp9A==
X-Gm-Message-State: AOAM530j4+N5Zu1lhTnZS4C4FionJXdKG1pJIt5z/31OSX3nKyob+XBA
        yE3qrq6lZhG9Bu8hX/mninRccrDBuMWWpFq6
X-Google-Smtp-Source: ABdhPJxWKnjIgg0ZSrNzndH4X7vIGxa3175OLtVKdaFPea0m3XrLEkbjMBfUCvHlaOAaXR8vC0kiJw==
X-Received: by 2002:a65:62c1:: with SMTP id m1mr39079830pgv.339.1629843460098;
        Tue, 24 Aug 2021 15:17:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm20477724pfn.173.2021.08.24.15.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 15:17:39 -0700 (PDT)
Message-ID: <61257003.1c69fb81.15d92.b553@mx.google.com>
Date:   Tue, 24 Aug 2021 15:17:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.12-127-gb85f43f33b05
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 203 runs,
 3 regressions (v5.13.12-127-gb85f43f33b05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 203 runs, 3 regressions (v5.13.12-127-gb85=
f43f33b05)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =

beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.12-127-gb85f43f33b05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.12-127-gb85f43f33b05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b85f43f33b05cc36ebcb5b64122a56c9fb949a79 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61253f3bcb737f386c8e2ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2-127-gb85f43f33b05/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2-127-gb85f43f33b05/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61253f3bcb737f386c8e2=
ce2
        new failure (last pass: v5.13.12) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61253dd3bdc303c2748e2cab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2-127-gb85f43f33b05/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2-127-gb85f43f33b05/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61253dd3bdc303c2748e2=
cac
        failing since 40 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/612540cc58af313d988e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2-127-gb85f43f33b05/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
2-127-gb85f43f33b05/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612540cc58af313d988e2=
c7b
        new failure (last pass: v5.13.12) =

 =20
