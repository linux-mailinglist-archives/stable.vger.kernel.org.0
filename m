Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671D24EA0D2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240941AbiC1TyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344873AbiC1Tx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:53:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2101456425
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:50:08 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b15so13732144pfm.5
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jXuAs0XXAQ+dlLZCVBDPAGoIAdpQuNA5TUcEUS6NUfE=;
        b=dDcncNu3piYQtPE/ryU7BN7KPTBvxikqA9Q47vxQ5mv/5PSc7HTkneGaF4PTzDntBa
         a2ZmGigldiUiJr45ZPHvbOmGYHz9ZLismvGzQc/j5XHdVMAs6lVfyYcWiv0qJMKxsfxZ
         tv62GYcMaBodMKN22uY1un7jaVe17EwIAICRJDFVoOOqeCA+v+y/OwIEGiYDH6dwQ8Ww
         72icoTd2lBiMKVtjG4e5sVbV8HaOUY2SI/Rran9Ac8eGa486FSHACu6PbhrE7bB4gDy7
         m1RAfXDpVAkCnubFHJgESF4KO1oq1EvBUe7waT5bhe+xU7OoDuZH0S0PZJe2OMEK8nUL
         PgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jXuAs0XXAQ+dlLZCVBDPAGoIAdpQuNA5TUcEUS6NUfE=;
        b=f1ZyKiuY67HwUFUdTqJidUNttbzmAtzgb4huK8ZaGWR6miOYvxnJGUJBiCXuGR1gXi
         4ER/39RW8tBSrmZETlyFt4jH3cnjU6Vvudd13QhGE2aCDDaVuwjE5r43Ngk3yiz/kR/G
         kJX37Ydgd5kK7yMCPiXJXT8CsndX19MrC7EqRTp7fhdKtAMBKIXruOMkw22BSFoFwc3v
         gkXdcml159pIXYzCUDqG5oYRku4USFK9ZWK8EkL/nwM2/xYYJ8ghYwGpCrtdoMF4Kxjy
         KzwWfblMcpaqfeAAPOqe1fY9+gxku2+3sluzJ/i0pwfl896B41zOuQy3FBTorU4B7X5+
         zNUA==
X-Gm-Message-State: AOAM533hbK30GjFC8vWgRmSyjZfdlyYG6NztECK9l7SqhLmCvscHDQPi
        zlR9cg4GKh2DMnJ7x9gOFnIu+RpYDgTtKkUEU5k=
X-Google-Smtp-Source: ABdhPJzM4hctDoVubrBRDwsYzzIi+cXHE5ynhcJnE5VEWNPtyKAYMw0xKHHE79bZU9/94e8WcTKXdA==
X-Received: by 2002:a05:6a00:2448:b0:4f7:a138:29c7 with SMTP id d8-20020a056a00244800b004f7a13829c7mr24753368pfj.32.1648497006392;
        Mon, 28 Mar 2022 12:50:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ob8-20020a17090b390800b001c6a1e5595asm324373pjb.21.2022.03.28.12.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 12:50:06 -0700 (PDT)
Message-ID: <6242116e.1c69fb81.2d1a6.1475@mx.google.com>
Date:   Mon, 28 Mar 2022 12:50:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-25-g95da2d57d331
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 132 runs,
 2 regressions (v5.15.32-25-g95da2d57d331)
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

stable-rc/queue/5.15 baseline: 132 runs, 2 regressions (v5.15.32-25-g95da2d=
57d331)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-25-g95da2d57d331/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-25-g95da2d57d331
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95da2d57d331066024a26b6e62ef781833d822ea =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6241e1c3ce13aec260ae0695

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
25-g95da2d57d331/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
25-g95da2d57d331/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6241e1c4ce13aec260ae06b5
        failing since 20 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-28T16:26:22.311957  /lava-5960883/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/6241de310a38f1933bae0680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
25-g95da2d57d331/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
25-g95da2d57d331/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241de310a38f1933bae0=
681
        new failure (last pass: v5.15.31-27-gd9c80877ee26) =

 =20
