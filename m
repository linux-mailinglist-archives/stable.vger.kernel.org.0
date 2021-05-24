Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4238E88B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhEXOU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhEXOU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 10:20:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C43C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 07:19:26 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 27so18899202pgy.3
        for <stable@vger.kernel.org>; Mon, 24 May 2021 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hn+BPr3ST2j5imbSUXQGMKTkvI+xiXy0z1Ix5Ghb4xs=;
        b=N+D/QPSRrXNmfZXQ+ASdAuolEYazc6lZ9o1gvKzdy2v8Gxh5Rv6h+9fLjNCb9d9Hnd
         wizxUiQoIrp317hGLTa2vjTkKEOiMccg2pjBAzJoOJBcUwio8ZKlM5L9zoJtKbUC6HG6
         BZs6fhNod4RRzMMEQWHJaiJ+NneAFn/FrJtiDhXEqksRMJAy9T+4FVd7IDGk3VY4kQsP
         8lH1hd4auqcZIuIMiKCA4qOw70pu6Aoq/odIbmg03d0O4/N9ZSpin8cJcgEj8rP5hFJv
         P7YhZ3bVjYV+IQ96kLzVVhfCIk05uRlMMCfadN3cdHVX1/G56KosFAlz2mTEFQkjbrr0
         E64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hn+BPr3ST2j5imbSUXQGMKTkvI+xiXy0z1Ix5Ghb4xs=;
        b=tAWaQDBYFJDFrZxGHqkR9ECYcwUnEP3354kY/aEM2QvB8H6p4uQU6bdrEJfRteFi7a
         /252vtGXa1uEgM8xXL1NgEcWyldqBsue1dzHj5HltPSymMx5IYd2bVBFR6+x8GVxgQCJ
         8ls/31kBV9myItiuAx0wmCQaVpy1SukqMqhvvxFe/wha9VuaZLJzDrss8gdS63ASNhcG
         RDTAYiyJhFlbELaukBoiBiB3prUopgkKF3xVbaNsZPWj+OK7OPrUWj1EBxGFse/Qs9lD
         jDDgJ7LQ475iz/7rM+pSWajU01g8iGI/dVRY10bGFVM+qilUdYot30RxM7Q2HY+Q8hfT
         kWNA==
X-Gm-Message-State: AOAM533oZS7VFVgbgDv7hMwm9XxNVW6FMzaz4nZZffDqMGWjzU3rqLIR
        UnBmERu08ovQGH5ts2fY9+6PE5sq9k5Gk4R+
X-Google-Smtp-Source: ABdhPJyLF6PlOkt/NCHOnGs+RXCKB3ZLDiU+y9p0xgj3b23/bMDBlJTdCbSg0Tp0avwcBbd2MzpbGA==
X-Received: by 2002:a63:9d43:: with SMTP id i64mr13481539pgd.205.1621865965724;
        Mon, 24 May 2021 07:19:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 204sm10997668pfy.56.2021.05.24.07.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 07:19:25 -0700 (PDT)
Message-ID: <60abb5ed.1c69fb81.963f.3e34@mx.google.com>
Date:   Mon, 24 May 2021 07:19:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.6
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 110 runs, 3 regressions (v5.12.6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 110 runs, 3 regressions (v5.12.6)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =

imx8mp-evk               | arm64 | lab-nxp         | gcc-8    | defconfig  =
         | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c84df89f0476b1616ee3fe9de6030f018ad002c3 =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab849a6b33a957dab3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.6=
/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.6=
/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab849a6b33a957dab3a=
fa6
        new failure (last pass: v5.12.5-44-gee71fa12d93b) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx8mp-evk               | arm64 | lab-nxp         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab8365027ad42631b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.6=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.6=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab8365027ad42631b3a=
fb6
        failing since 6 days (last pass: v5.12.4-343-g1fa9b48b0d6a, first f=
ail: v5.12.4-364-g8c6ba5015aff) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab8259e4e7f6ce9ab3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.6=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.6=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab8259e4e7f6ce9ab3a=
fbf
        new failure (last pass: v5.12.5-44-gee71fa12d93b) =

 =20
