Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06CA5F9E63
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiJJMKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 08:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiJJMKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 08:10:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7E658DF7
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 05:10:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so12908645pjs.4
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 05:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PnDrntg9FRxZgjPvPumhzRHYnD8TrwvvN+eeUcVszL0=;
        b=2vm6AiFO3PC712+VC8DCqtRK8zr42T/7EJMcqucS4eFC1JSnxfE0a6xo1q9g/rBXjW
         WWXzN/2cJi9IQOPFNStugihvshUa4Kgp74eUyMmflWH7RRa1kBPFZdWaec2hzD8ey7JX
         FFuwy4+2l2wpHgpX0nMs3PBBxuiaGsLWKxBEBEY/0BIi3+ga4bjMcinSEA1RAjnrjBNO
         Lx8d1/vdbeNPAoKDFETaDiECleDnVr5Qy3OX+NUV8v0FAfnTyis5wCzTdptGRdvnm7nv
         60ovvK+3kgjauwf34QYihQWdFde8fe1XDhAF/aoYnKA4Oe386Jm7yJRu8lNIud0XCD67
         LoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PnDrntg9FRxZgjPvPumhzRHYnD8TrwvvN+eeUcVszL0=;
        b=gRqtlEo7/2dKbQyhavZYOaJrqMaHeipLqfZ/5Q37WQ2nfCUa3Q3C3wGhcRLJaFY5NP
         pyY35HxRwlJa4/uuqwoKOshmJWo2Dx8Q3wP/e4lVI6iuUNzypR7VO7NKi5ZuB6AozaU3
         ZbX1YdBU98ZDjv1+rw7O0Nx+DWgX5R/bvk/sdM3QyG8skeslOzh9oet/Ym51yBUNgnc6
         YKR/iPfMIVfOToPwf+g/aKZcGvCETRNLv/S/kjLGealF0MjkqaexFFeO/Q8PTaHEiBPV
         VPkx6pnTdLEdH7ZMNFzPEK9BXoXYjPQHGMbG2KupABT8idozZlUYGZI4IpB7Iig+9n6u
         DBzA==
X-Gm-Message-State: ACrzQf0SjFJ8+bz4wD6l7MsFZflr4Bs6rt+xbnTWl385ubebAwFhftUI
        +SUvokURGVSvN0hjD4j95aMnGeiCd8EdQz4pU2k=
X-Google-Smtp-Source: AMsMyM7zSxwC7jTnGQbPunQp6bIX9whRp48nCBc1pVisaxu6cGIpoWzUvT2VNX0bRYv3Qy4UXXhb3Q==
X-Received: by 2002:a17:90b:1808:b0:20c:8409:2007 with SMTP id lw8-20020a17090b180800b0020c84092007mr13921104pjb.226.1665403840223;
        Mon, 10 Oct 2022 05:10:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id je17-20020a170903265100b00174abcb02d6sm6432177plb.235.2022.10.10.05.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 05:10:39 -0700 (PDT)
Message-ID: <63440bbf.170a0220.a5ac3.aadd@mx.google.com>
Date:   Mon, 10 Oct 2022 05:10:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-49-g2e79dbde2710b
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.19.y baseline: 180 runs,
 3 regressions (v5.19.14-49-g2e79dbde2710b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.19.y baseline: 180 runs, 3 regressions (v5.19.14-49-g2e79=
dbde2710b)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.14-49-g2e79dbde2710b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.14-49-g2e79dbde2710b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e79dbde2710b3939943c5d2ea3028329b820e9f =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d943ac0310c98bcab5f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
4-49-g2e79dbde2710b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
4-49-g2e79dbde2710b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d943ac0310c98bcab=
5f8
        failing since 13 days (last pass: v5.19.11-208-gf962b265cecbb, firs=
t fail: v5.19.11-208-gddfc037235223) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d8280620402075cab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
4-49-g2e79dbde2710b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
4-49-g2e79dbde2710b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d8280620402075cab=
5fd
        failing since 13 days (last pass: v5.19.10-40-g8d4fd61ab089, first =
fail: v5.19.11-208-gddfc037235223) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm   | lab-nxp      | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6343dad4df56f1a25bcab640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
4-49-g2e79dbde2710b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
4-49-g2e79dbde2710b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343dad4df56f1a25bcab=
641
        failing since 13 days (last pass: v5.19.11, first fail: v5.19.11-20=
8-gddfc037235223) =

 =20
