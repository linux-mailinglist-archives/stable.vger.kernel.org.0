Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10AF3A340B
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhFJT3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFJT3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:29:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BCEC061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:27:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so4361239pjp.4
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9XmP7FiY09eV3hWyk2wMh4tQVAXpuks0oc2qlh3XKBo=;
        b=SAbi8yxlxa9ywsUg2H69JmGm4IQGVA1shMDl1CCrm98ZtGttXi7sJLuypq7B0BjsYx
         2fzhqx2e0wPGA07tm/McbZ7OLNf0sQdbsoalKZxXVgs6hNb94oz5cT3Bd+N1KZbK/Tnn
         WMXyoPGyqO04hFupgwfBnsMm0lH5RfeY8IpTjHfW4E6PAHvNH6yUit6ZrR9ni8e1MaqZ
         OHEB3QuFco3hHRRWzajrsSUnL/iIFCEtrg4WYvx0iyRnzTVStNeMgSFAuJUDZHD2P6T7
         8Dkvrpm2fmL6J+oVUFZm56XRcuFbWfjyRc4IV+MynL8JKl2qQoDcxs60XfnDEqpPqTin
         6Uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9XmP7FiY09eV3hWyk2wMh4tQVAXpuks0oc2qlh3XKBo=;
        b=Y/7YWX1X1BAmZH3FOD+HM5pwrC22Pm6l7+PcUhCxHi2D++6jpJyiAlclASuLLL5nmV
         RrhYFl9zoDAav0PUZKMCicqNSYd6U+mJrMx5f/nwQD+bLZaYorMxRH8+8YZXgdxQ6uRV
         AH7YNFPioFQeA/yA4lI7dkIlKjQGJGYkSYiVE6JScXuIsvUvsGRLn8I92tNOrpHa7nyO
         P9B/lLqZNwL8EbRBxYg5HroBYh1iUwhKc9ko/ATRE1qO1Yf+dC+JnSesCRRfve4KQ0ON
         FK2w1ncUv8i2fHu2V5kHbYJhDnxl5LLqYRKNre5lO0MhyjXoL5nWy5GLYgoBFw3jWE2b
         GGIg==
X-Gm-Message-State: AOAM531kGvpxAxlcNCNAS08TR68T3iDsmHN6swoqRFJ7NELmAHuu3Gco
        K7WBKSh1qSaLHnYO4LENf4AXfQwqx9ZSC7H9
X-Google-Smtp-Source: ABdhPJzHkbYFS4qBjRkMTsorn2XZOWgAxoLsi8bmiXrI7GrZ5xZ81d49o8kPJkyuTro2bWGa3Yynpw==
X-Received: by 2002:a17:90a:c20b:: with SMTP id e11mr4959383pjt.67.1623353237625;
        Thu, 10 Jun 2021 12:27:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s10sm2884834pfk.186.2021.06.10.12.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:27:17 -0700 (PDT)
Message-ID: <60c26795.1c69fb81.6bd31.91a0@mx.google.com>
Date:   Thu, 10 Jun 2021 12:27:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.10
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.12.y
Subject: stable/linux-5.12.y baseline: 176 runs, 4 regressions (v5.12.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 176 runs, 4 regressions (v5.12.10)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
 | regressions
-------------------+-------+-----------------+----------+------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
 | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
 | 1          =

meson-gxbb-p200    | arm64 | lab-baylibre    | gcc-8    | defconfig        =
 | 1          =

qcom-qdf2400       | arm64 | lab-linaro-lkft | gcc-8    | defconfig        =
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8a901e19407d3424ad6362c59755182440b939e4 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
 | regressions
-------------------+-------+-----------------+----------+------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2318b50e6f8ea070c0df9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2318b50e6f8ea070c0=
dfa
        failing since 12 days (last pass: v5.12.7, first fail: v5.12.8) =

 =



platform           | arch  | lab             | compiler | defconfig        =
 | regressions
-------------------+-------+-----------------+----------+------------------=
-+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c23866b7af3a28bd0c0e2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c23866b7af3a28bd0c0=
e2c
        failing since 12 days (last pass: v5.12.7, first fail: v5.12.8) =

 =



platform           | arch  | lab             | compiler | defconfig        =
 | regressions
-------------------+-------+-----------------+----------+------------------=
-+------------
meson-gxbb-p200    | arm64 | lab-baylibre    | gcc-8    | defconfig        =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c23802ac73724f200c0e14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c23802ac73724f200c0=
e15
        new failure (last pass: v5.12.8) =

 =



platform           | arch  | lab             | compiler | defconfig        =
 | regressions
-------------------+-------+-----------------+----------+------------------=
-+------------
qcom-qdf2400       | arm64 | lab-linaro-lkft | gcc-8    | defconfig        =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c237610adcafc5040c0e16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf2400.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.10/a=
rm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c237610adcafc5040c0=
e17
        new failure (last pass: v5.12.8) =

 =20
