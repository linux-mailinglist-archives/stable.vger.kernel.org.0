Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5541562C0CB
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 15:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiKPO31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 09:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiKPO3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 09:29:25 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479E21BE9C
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 06:29:24 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 62so8456793pgb.13
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 06:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Bp8GJYlSgUanf9HcSIyN4M6PlwoZ1pebWqizG+piS4I=;
        b=y0lKDoPS0wYF9hyBvfAtkZr1q7x0lxOfk9YYoOHgwa6UlPymqdMmAh/eRcjboCakF8
         Rs0LdVZEn2S6Ljn118OI7BtP+wS4K/852vj4DXmJwS6Nt7+9+EO7LHI/5LHVhzyoeXJw
         GjWibImpWiqkMhoYjjWvNFpBdwFeok62e05EEx4VZeX1wLtGLWQdbYT8dwmcOEaW0JH+
         cR7t/IfHZVqtozBRTmbFGGNlJS09IbzgFiXTloBDWk8NU4km1HDlBg5DvXmoeu+jdxXu
         OBgtapDwi7X1nV+CRGXHAyWULFtFd54GTrkVDWuaP1e4lQpF13kYWe8OihoyqbERMFue
         Wh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bp8GJYlSgUanf9HcSIyN4M6PlwoZ1pebWqizG+piS4I=;
        b=1tDxhXHSrsJkzyNXIwgxFto54dL9TrCkb9qoOg9Z+CbjNOW2Y8IUz8Z+b6IGabOpHC
         OsY5Nq6aSRvHogH9hH/iur/xjXwtUhBOHDRCCzJ1GC0X+BQQRd1bCN2aMbrm1G2rud2C
         K/WPYqR6XeJjuE3kiajMCu7qTUl4r9USsn7te0ho4LkTQuiEgUt+/rPzxVGaCcTDpVsS
         +mWh0UJupxHZaS2yqFCn7FGVA6uLoX0MLx5HSU8yQc4sKwzj6X3gSyEF/L0KJldughVx
         zXYdwxN2S+RftqswqaYVIWXKFBLCtWMAykLNNT2zPHNnbhwbRYjqPi5RkqaZXgNRAwNZ
         aezQ==
X-Gm-Message-State: ANoB5pk0D6feGKPH7KWkHTDFVZTiwmeysh+IHLEGW6+J54EyLLMgqsB4
        n8w1ggOKR4a2eUBAHBSMy5L+iNkN7uheLuhI/pM=
X-Google-Smtp-Source: AA0mqf6PJjnbqHX3gqCfn61inz0MFgKr2zTvfo5uuarSGICgJYn1QOasbcAhUIIHQP1/QVxMGgMtEA==
X-Received: by 2002:a63:cd55:0:b0:476:eee6:d394 with SMTP id a21-20020a63cd55000000b00476eee6d394mr1976620pgj.228.1668608963568;
        Wed, 16 Nov 2022 06:29:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b67-20020a62cf46000000b0056d98e31439sm11244026pfg.140.2022.11.16.06.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 06:29:23 -0800 (PST)
Message-ID: <6374f3c3.620a0220.aa5e7.0f2e@mx.google.com>
Date:   Wed, 16 Nov 2022 06:29:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.79
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 148 runs, 3 regressions (v5.15.79)
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

stable/linux-5.15.y baseline: 148 runs, 3 regressions (v5.15.79)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.79/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3df0eeae4d9a547c0f19924952ccb8290582e5d0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6374cb58166e6819b52abd34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.79/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.79/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374cb58166e6819b52ab=
d35
        failing since 49 days (last pass: v5.15.67, first fail: v5.15.71) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6374ccc17b61cb9f0c2abd38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.79/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.79/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374ccc17b61cb9f0c2ab=
d39
        failing since 41 days (last pass: v5.15.70, first fail: v5.15.72) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6374c1bf660e425b352abd48

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.79/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.79/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6374c1bf660e425b352abd6a
        failing since 252 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-11-16T10:55:35.334378  /lava-7997451/1/../bin/lava-test-case   =

 =20
