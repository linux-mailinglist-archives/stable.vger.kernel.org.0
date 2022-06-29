Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA355FF25
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiF2L6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiF2L6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:58:37 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9C31ADA1
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 04:58:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id jb13so13892679plb.9
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 04:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xjrjVt1UM36rt3opzBN0DJ5wYNA3cpxDP4xDlLhTeq8=;
        b=HYHD2LJxjVbRjPVV+vxdtKufNx9xPfI6h4uXPPYucZG3eYsCyw2lW1DuLBrfWUnQy3
         pZqPNCS5jGqgeH8UFvE+qsatQNqUoiCAE5KNeYJX3FFW+qH3NmyjwmUPI0He0mw1gPYF
         uMRS5cYWEmAFDt1JICqHI7v8xcmuWmmd+/ZoVVdyoLyVa1S+8vSI5PgBSpta244Snrnd
         hWyGU+us2RLQw2CZDQ8MqUiMZRkugKfBf/vUfD4mdOulBRT3ON8G9l5KWhsJ9jmB3VMK
         LDrDx8YXzWP19SIWB0NAbSCIEjMkny2+jViKCt0yqdPkPjjvJlBNa8D+G6u2B0ywaKAx
         chfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xjrjVt1UM36rt3opzBN0DJ5wYNA3cpxDP4xDlLhTeq8=;
        b=WjzQvD+cw1iRs7SgjZL8+o1Qvvs9aEJWfDigdOSrqgRPC0bymXq+OvGh0BBJMEpkrv
         O/7/FOGcQVuXvGnvMmYpTXIMk2XvLoan8IKB0ODh0eWYYm/N6CTHfkDJn3cEtZ45iRwQ
         U3RQq7C4IemZ3epvYJJA6ZshGi+MWmceaP6qbshyJKj39oQ8s27hZeyd/mUJp8WbxbB3
         Tt1VS1fn28SLjf57kSdpp896KCWEEemyfzcWkJ6YBG6qC8VgrixfMQRe/ABXOoUYhzem
         ej08L+t3/o7eXD4ktCjYBo7Y0IstTJ0ozL+miC2WIWAi74+ELUS+IEzPalN8LfMM2WIb
         D11g==
X-Gm-Message-State: AJIora8F92Fix+4xgnn+KIVAaEJNzxaAI8I2xysTVhL0uCiheuhzcANV
        pMdpTNlaAGRISUtupI1aYnut0++wH3p/KH/M
X-Google-Smtp-Source: AGRyM1uWkOrQ1Hzh2r2la+v5q72MgP9SMATfiDnq8xQztBwzoBSg5XQEOUupg7c6p2g5SMxoEzt0lg==
X-Received: by 2002:a17:90b:3d0f:b0:1ed:3dd0:900d with SMTP id pt15-20020a17090b3d0f00b001ed3dd0900dmr3567219pjb.191.1656503915477;
        Wed, 29 Jun 2022 04:58:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020aa7824d000000b0052527e3c5easm11302952pfn.87.2022.06.29.04.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 04:58:35 -0700 (PDT)
Message-ID: <62bc3e6b.1c69fb81.b0a50.fc15@mx.google.com>
Date:   Wed, 29 Jun 2022 04:58:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.8
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 168 runs, 1 regressions (v5.18.8)
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

stable/linux-5.18.y baseline: 168 runs, 1 regressions (v5.18.8)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.8/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2437f53721bcd154d50224acee23e7dbb8d8c62b =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc085f7f24d8ae19a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.8/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.8/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc085f7f24d8ae19a39=
bde
        failing since 30 days (last pass: v5.18, first fail: v5.18.1) =

 =20
