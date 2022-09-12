Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6FC5B614B
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 20:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiILSvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 14:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiILSvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 14:51:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13A615A05
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 11:51:20 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g4so9145320pgc.0
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 11:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=xK5gsMo48LBo/gJZ+C7FIC1jtiTb5p575xoKdHlW3OE=;
        b=KYyr9wbVXle7ipnq93hZNZ2eOI0R2mop4jejrt2AenwKQOQhDAk8b6hmh8maDQXCzg
         01hTgvnz5eVGzPSZvldLngfHc0Xd28LsdAqAYAf696l7TitTfFnwrTTn8Tok6Y5IXdq6
         WonqgseRx+PurjuTFpbT8I0L4fCpFlm0WrfNpzCabZnqmOJrkX8tiV9OrBUmhasRU458
         9S5WuV7tmnSjFnTn9X3f6NnB2OsfbHMhCv4EXUcWtZYsl+B1fzoHbM3D/Z4TwtnS+RAT
         48pKdBgD7UaJgs7uDVIzUSDx6rLPPSvON3yfQJvgOnfZayNCMOcDFPD/tie9Sy3Wb16F
         ffPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=xK5gsMo48LBo/gJZ+C7FIC1jtiTb5p575xoKdHlW3OE=;
        b=ixEylILLoZmdZlH+h/KUZAN535kYVOcdC/wnGT5nbNuDAtQTvGTQtjxjuNvWRj8Jj/
         vkto1PuOmiFuKKFIgONJyHMTDzCVN9BKQ5kM8EEHM3p3NagbyAz/KtxRO5y35AhtkxRf
         ofGoTMtTTKFWZssQGQQPPIR/ApolZk1NLmQYn3GkRr3ppgK6CoVyC8J5iFqgE2qHP8Yh
         +wjqjlI7YVtAL5aQiDxo/kiOmjRxHLPPLjjcdfag7Gw+guom9P0LmaUqb3RwHzVhHSRV
         wNZCAlsGRzn7j95gm7su325HE+1C+Ip9zpNNfeUJl7Up6VDhcIv/FiN8yokFr+iWA3Tq
         6G8Q==
X-Gm-Message-State: ACgBeo3xONh2De7+uY5+fV90S/ZLhEaG0GBIfR51rVuJ/Do7b1wIcXIv
        HohTZ+5/nBEoyX6nbhTwP9EFcNSgGBsdgY1qqYQ=
X-Google-Smtp-Source: AA6agR4vs/PoXSloIXnbfAYRgDXVyPakX9F7pQ9gvHOg/ksbCDhLxRzqApWL4yZfQm/TLsbiKdlc8Q==
X-Received: by 2002:a65:5941:0:b0:41d:a203:c043 with SMTP id g1-20020a655941000000b0041da203c043mr24123925pgu.483.1663008680124;
        Mon, 12 Sep 2022 11:51:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903244c00b001743be790b4sm6338413pls.215.2022.09.12.11.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 11:51:19 -0700 (PDT)
Message-ID: <631f7fa7.170a0220.d2cb4.b00f@mx.google.com>
Date:   Mon, 12 Sep 2022 11:51:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-186-g25c29f8a1cae5
Subject: stable-rc/queue/5.19 baseline: 132 runs,
 3 regressions (v5.19.8-186-g25c29f8a1cae5)
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

stable-rc/queue/5.19 baseline: 132 runs, 3 regressions (v5.19.8-186-g25c29f=
8a1cae5)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

imx7d-sdb                    | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.8-186-g25c29f8a1cae5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.8-186-g25c29f8a1cae5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25c29f8a1cae5cae859f939b1b7193b764d209d6 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/631f4cd4a1825474353556b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
86-g25c29f8a1cae5/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
86-g25c29f8a1cae5/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f4cd4a182547435355=
6b2
        new failure (last pass: v5.19.8-181-gaa55d426b3c1) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7d-sdb                    | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/631f4ad3818110c356355680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
86-g25c29f8a1cae5/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
86-g25c29f8a1cae5/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f4ad3818110c356355=
681
        new failure (last pass: v5.19.4-389-gf2d8facb7bd4) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f4c0583bcff1b1a35569f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
86-g25c29f8a1cae5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
86-g25c29f8a1cae5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f4c0583bcff1b1a355=
6a0
        new failure (last pass: v5.19.4-389-gf2d8facb7bd4) =

 =20
