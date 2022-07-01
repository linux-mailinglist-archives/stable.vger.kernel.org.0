Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF475632FB
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 13:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiGALyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiGALye (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 07:54:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1017983F06
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 04:54:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v126so2176516pgv.11
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 04:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xXOnqrkIRecxvAxS3AhwFl7t9myXDi8W/vypll2EPlA=;
        b=hYReQ2hI8e+G7+4MW0EfIJedf4AFPDrlNuDYM030ANs6H2GSUhCHlu1nqVnKFUMQ0e
         fn3zkrudc6iSjnUZjB3e33Qm6FawHWZ82ASRPlgBOlYUyT9I+/YFNcmlarCBKyviix/i
         u1wRHvZ6xrPabEN5jFxuJDmlIyE2FpLcdIqpvp23y+f/KACnxnm3uzFg23+qJHmtJTGT
         pWGKgT+KN7bAaicCj/147LmQr5RVqoZEOGtRakmbid+j5ASHGSqhhn8nSbHE/9CqF0ES
         PAikPqr9m27Ef6AVUgKtlsx4HysljuZ/NhP38dV9FFq5kS7K6eq5OP1BY/TgPHXe4r3c
         2Pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xXOnqrkIRecxvAxS3AhwFl7t9myXDi8W/vypll2EPlA=;
        b=jMOmVMfwd2gL7NvNbvoAx0jcfTtxfseqvXxhfh65Pm1DkrA1G+yCGV/Mu6nQ45ZmdD
         mb0vBPNZOwr6eHyVi+IyP6hYuceZ3VX8gB7YdTxvbAt53WEs3tuwtU+y3VYs4H0hEc4x
         h2Hd2N6I1Ie4aU01wxGPe0Nw8N4lDMObrjtBJLb80nE4aSvUT0eJ/K4h+LHABW0o/MC7
         j3xBKUd7973d3h6QnN3lFvMYJRQTHsJvfxxS7bA2QIv64wjUAGPUS0dVxXRW9PGJ46q6
         bAbYDHQsU5CKVXlGz7E5qu+8d172yOQAphG/HzB29mjBP3cC8DDtsWap2zL6SNpol3Hy
         uUpg==
X-Gm-Message-State: AJIora8C44vh4bZaVNHYmy0YWUoZKXUyTb8HgIHnBUXxq1PshHVp6401
        kq5t4Bn1baktDMLFqd1vMD3Vb8WWcMpsu7V9
X-Google-Smtp-Source: AGRyM1u9CsO6529INX6Yf6WRRD8YXINZ3MV2AYwkVZ6/tYL86pfRhq7e+TB0EneYJdp+KmPJDX/4gw==
X-Received: by 2002:a63:8f54:0:b0:40c:b225:6f92 with SMTP id r20-20020a638f54000000b0040cb2256f92mr12021564pgn.554.1656676472411;
        Fri, 01 Jul 2022 04:54:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15-20020a63e30f000000b0040d376ea100sm15161154pgh.73.2022.07.01.04.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 04:54:32 -0700 (PDT)
Message-ID: <62bee078.1c69fb81.858b2.5ca1@mx.google.com>
Date:   Fri, 01 Jul 2022 04:54:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.8-6-g1a24fb22be7f
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 162 runs,
 4 regressions (v5.18.8-6-g1a24fb22be7f)
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

stable-rc/queue/5.18 baseline: 162 runs, 4 regressions (v5.18.8-6-g1a24fb22=
be7f)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
at91sam9g20ek           | arm   | lab-broonie   | gcc-10   | multi_v5_defco=
nfig | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.8-6-g1a24fb22be7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.8-6-g1a24fb22be7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a24fb22be7fca6227a20188aabd6335c25869d2 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
at91sam9g20ek           | arm   | lab-broonie   | gcc-10   | multi_v5_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62beaa5d94bff549cca39fe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62beaa5d94bff549cca39=
fe2
        new failure (last pass: v5.18.7-181-gcfa4d25e33d8) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62bec444649f344f27a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bec444649f344f27a39=
bd3
        failing since 10 days (last pass: v5.18.5-115-g6f49e54498800, first=
 fail: v5.18.5-141-gd5c7fd7ba94c0) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62beaf4c1892870669a39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62beaf4c1892870669a39=
bf8
        failing since 3 days (last pass: v5.18.5-141-gd34118475c49a, first =
fail: v5.18.7-181-gcfa4d25e33d8) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/62bec019aa6305a3e0a39c38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-n=
yan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-g1a24fb22be7f/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-n=
yan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bec019aa6305a3e0a39=
c39
        failing since 2 days (last pass: v5.18.5-141-gd5c7fd7ba94c0, first =
fail: v5.18.7-181-gcfa4d25e33d8) =

 =20
