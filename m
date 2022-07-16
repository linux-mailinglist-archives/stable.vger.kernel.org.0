Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F4F576CA1
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 10:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiGPIu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 04:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiGPIu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 04:50:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C31D32F
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 01:50:25 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c139so206660pfc.2
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 01:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7O89YROp1gm4KbhXd8oWc8cWesEPKKn8aMMobbKtVF0=;
        b=a2u+eb366ydNKTUxIuxdUksvsekvwOuzzNsAimIMkxnVBsD7TSv2ctx8Vn6AnNrf8p
         DImsJobnF4xwNHHGNQPUagNCCYW3JFgBrr182TSSfdkfTJ9LVQYv0S1h8pGvyI6aGatV
         QroEfZdOhyxd3UWb+XCBza1FPMpnKAzg3RMUfylutF75eSc4/3E16bIvFn+N3Z5xWZi/
         7q+ldo6xpYchvcOG62SgT0yL5Db18d2+B98APpcKih/UrFINsFrmsiwDXvZl74NdDEJs
         ApsPbDwsRoX7/6pbjkx6jPhfr+IQRZQUjwHOV5NmDG23GJbexXzl3785yFAJ4qRgUgGV
         ysyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7O89YROp1gm4KbhXd8oWc8cWesEPKKn8aMMobbKtVF0=;
        b=xVhZ4OHaVviANViuOvB0F7sepf2zksPJXQjBu4ljcaZzjBMAR8i6F3TTeBgSyCRcdS
         7U/YgFBy9OKVRFKh8NhYWzeM8II6TxX9KzbTxgf2zgWAeFmuGIv+UQ8xNDJXcLQlQqZy
         4btA4TQcOHyYzuKhDQiZWec/mwzFykkA7CW28imaLWLD7yQ+7zoCCGGjKLwwb56hklVb
         P/fIVBju0OIXh2WGD4wREqcajIiT96N5v0o7bDdGV2MHG1OSnGOMEVLq4OlpbwzUBY6u
         N3mLv/soSr9a/nZO5O1tZ46/TvtYsF2iKLeN4Djv52hZx1w/xEcxX361i7A2QkPjZr1X
         IwhA==
X-Gm-Message-State: AJIora/KuTXzTV5P2vyqlJ+gEprA+lFziwlA0eCxYctpeknJo/o+F2ld
        S4o1fh81Curno6TO+nys8rlro6o4kmJpTKAy
X-Google-Smtp-Source: AGRyM1tqS0GkY2iL1Pnr3iF3TRKsTY6/xPfl8SMznIjv+7vqYKBP81mEEQ0lcyyzrfJaxgOy817wvw==
X-Received: by 2002:a63:5964:0:b0:411:4724:e618 with SMTP id j36-20020a635964000000b004114724e618mr15500873pgm.484.1657961424772;
        Sat, 16 Jul 2022 01:50:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1-20020a17090300c100b0016c4fb6e0b2sm4938145plc.55.2022.07.16.01.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 01:50:24 -0700 (PDT)
Message-ID: <62d27bd0.1c69fb81.d9689.7d13@mx.google.com>
Date:   Sat, 16 Jul 2022 01:50:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.55
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 126 runs, 2 regressions (v5.15.55)
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

stable-rc/linux-5.15.y baseline: 126 runs, 2 regressions (v5.15.55)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      baefa2315cb1371486f6661a628e96fa3336f573 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62d24a6755d4c121c8a39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d24a6755d4c121c8a39=
be4
        failing since 18 days (last pass: v5.15.48-116-gadd0aacf730e, first=
 fail: v5.15.50-136-g2c21dc5c2cb6) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62d24d718822aea7a2a39bf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d24d718822aea7a2a39=
bf2
        failing since 3 days (last pass: v5.15.53, first fail: v5.15.53-227=
-g71721f5974f2) =

 =20
