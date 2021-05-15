Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8479A381723
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 11:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhEOJZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 05:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbhEOJZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 05:25:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57218C06174A
        for <stable@vger.kernel.org>; Sat, 15 May 2021 02:24:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q6so1055110pjj.2
        for <stable@vger.kernel.org>; Sat, 15 May 2021 02:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AVmKDWhxY/rdvhQs5U714ZHE9rmH3NN0m6xCVMZusRQ=;
        b=ITyiYDaNfR8ZKH7LonuOJRVFFQRgyjozoRfmzLr6bw4lb9gE5n8rOk1nzB1DANKMPu
         Y7aRxWoEHjEcOfju/Ox5ZnoiaowtL1zqYqehaBXmRNt9+zFr3zzBRXz3SMtGtKMjQEA5
         oBoHrr5vpFdMuePOYO39n8UfG8hzd9LLgMd0kgI3u9zC5CIxXYZ4rt0m4nvPvxNQy0IY
         I7Lbe7VsQCbHM78/Dga1iKCI4uT03cJWj5f+86MFsHCZfi3v9m3M8ntURxcZ2JLBepFd
         lKAfpiM2b4cKF3QtmuDr4O3Hl6dWeNLZn1QHq/egOP+kmvNNQKtJWfBeMr2BaLmCCZoc
         VYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AVmKDWhxY/rdvhQs5U714ZHE9rmH3NN0m6xCVMZusRQ=;
        b=RuANJaFA/NxXjVGc91mlRsrxbHyyiHs/qXIYCi0MiNCe2wsn1cS5azitz/P7N+35mj
         5TE6EJvWEmNCi9EHJ33RfTG+IilCWIKRk464IppoH536qu5b9mV9+G9EZWjtoO9idqv4
         WumgGMs5ybnN1OXfIUCOJt48PpZqSqXMKp9S08HjK+GDQR2gX9BCC5cXhxM3IDF7xGw/
         T8+5Z0cBTv7GAvrwQAr+jX68urXLNPOZ/+U3xYkRzd/44VHXgAyZjJir4/IQKEfGZDS4
         e1uXNiriRgQpIuhyWdMNeBiRPn6QF9N3fd0AofpkEGzws7tRmp7hQIZdIcbBjr4/DsFp
         PIHA==
X-Gm-Message-State: AOAM533rhi6oPUcIvq+mdsIlMM9KC7gT/3ilUSdX2r2IlLNI7Sgx+BTl
        FKrVwZR8yk7g8zSK2FKzJvJNJ3CdjK19zQZF
X-Google-Smtp-Source: ABdhPJxOFgRmu4eQVmHp5PsyxlfcMIEfYrmsVk3De+hnhXuHYWwmt1TbJlFHwlvBpTZOB9erwMUCPQ==
X-Received: by 2002:a17:90a:c42:: with SMTP id u2mr56495896pje.76.1621070659346;
        Sat, 15 May 2021 02:24:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m84sm970079pfd.41.2021.05.15.02.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 02:24:18 -0700 (PDT)
Message-ID: <609f9342.1c69fb81.31894.33b1@mx.google.com>
Date:   Sat, 15 May 2021 02:24:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-228-g8fe740123b47
X-Kernelci-Branch: queue/5.11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.11 baseline: 131 runs,
 3 regressions (v5.11.21-228-g8fe740123b47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 131 runs, 3 regressions (v5.11.21-228-g8fe74=
0123b47)

Regressions Summary
-------------------

platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig | 1          =

imx8mp-evk          | arm64 | lab-nxp         | gcc-8    | defconfig       =
    | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.21-228-g8fe740123b47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.21-228-g8fe740123b47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8fe740123b47470837ba5bab0b7169a1e14475fb =



Test Regressions
---------------- =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f5fae3ab0cbb1ccb3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
228-g8fe740123b47/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
228-g8fe740123b47/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f5fae3ab0cbb1ccb3a=
fa5
        new failure (last pass: v5.11.21-11-g31d2d8ce497c) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx8mp-evk          | arm64 | lab-nxp         | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/609f60d6ed128ec320b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
228-g8fe740123b47/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
228-g8fe740123b47/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f60d6ed128ec320b3a=
fb3
        failing since 0 day (last pass: v5.11.19-941-g171a1cf2230e4, first =
fail: v5.11.21-11-g31d2d8ce497c) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/609f605caf144154c8b3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
228-g8fe740123b47/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
228-g8fe740123b47/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f605caf144154c8b3a=
fb8
        new failure (last pass: v5.11.21-11-g31d2d8ce497c) =

 =20
