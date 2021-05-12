Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B59637D206
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhELSEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346760AbhELRQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 13:16:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B09C06138C
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:15:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q15so14418219pgg.12
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=leclahC6V2O0Iti+ZPqcrPXd8mcUY5sSF6REcFskg8A=;
        b=Ypz++uCCf8T6n9zNVi4/o2BRAVm31NrAmJowKtuXgpBBU+5PmBgIHp0kloj12mHf/z
         vjIEURJ2bOX7aG7hxQBEwtSlfwvb2q4qw1lKSzu6FT6K9XZTF87suOy2lfpLqA2jpVbr
         nVZkZD22ON3h1PSQlY8AX5rn0dYG1c4ghIQfzhkJ+eAeKO/XY8qVXCo7cVkTQ1f7JW5C
         npu3rCe+CD3kajSW0TRl/UZwI06iTsX1QZ+MBFa9HbT28DhW3wKDyUxqPGRhAJqgIgW0
         1KuBDPJ1FyrSb33h3/lqx7ajHFUyJaJbzfNWu9RE82eiHNSBTzPCJkV20BIY0m3XtYVd
         bmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=leclahC6V2O0Iti+ZPqcrPXd8mcUY5sSF6REcFskg8A=;
        b=JtuHpygr1sQ29FfWM+1/J2vw86NDOE/PAxC2eFcfx4UqvJz81Dk+QI7HorWo/eDoXI
         hgzx8qvMGIMk6MKLoAVpg6/Ck2K8OtaUj/8Zx2eMWi6dW34kF/dnjEeyR7BUQfT/rILo
         EZusN+oQibMmiL5xsldXtfuCjNivz1YqtcG9JMr4Vh+9wzi/phBur7X6cYvmT+gqtGFR
         Z6v/g9KYj9k5RIaHWSBHhY2v1ns6lZDphGBsqqX7NatZtI79NG+yizRtmO0zCsUzt2ND
         qgWpnwX4dGlRfPxeNIBrCEuPSTPTJdhR5q0apdPt2HGDNowIjaDvAYB86L4AERC/QlQu
         LBDw==
X-Gm-Message-State: AOAM533cGGEhQ5e9ipW0JFu/8J07jTF1MVnrMROOgH46qUWVEKlsPRd6
        4JV+F9ZNF3pNSvVaovz93Or8vynUUzN7KJux
X-Google-Smtp-Source: ABdhPJzTNmW5LxpHbjTvjWgKM023LlJoGwUn2xUsb0xxVU51crjsk7ojGVnpl5aMP6SlY7cStZgO0w==
X-Received: by 2002:a62:7704:0:b029:28e:358e:fa8b with SMTP id s4-20020a6277040000b029028e358efa8bmr36728215pfc.38.1620839735957;
        Wed, 12 May 2021 10:15:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 33sm356118pgq.21.2021.05.12.10.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 10:15:35 -0700 (PDT)
Message-ID: <609c0d37.1c69fb81.3791.14d6@mx.google.com>
Date:   Wed, 12 May 2021 10:15:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.2-1059-g186fb6dfb37a0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 164 runs,
 3 regressions (v5.12.2-1059-g186fb6dfb37a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 164 runs, 3 regressions (v5.12.2-1059-g186fb=
6dfb37a0)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =

r8a77960-ulcb      | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-1059-g186fb6dfb37a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-1059-g186fb6dfb37a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      186fb6dfb37a00a1958467af10799e1c47e355e4 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/609bdad6e3a7b28b21d08f51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g186fb6dfb37a0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g186fb6dfb37a0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bdad6e3a7b28b21d08=
f52
        new failure (last pass: v5.12.2-489-gf332a5e050fed) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/609bdb94f9875a716ed08f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g186fb6dfb37a0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g186fb6dfb37a0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bdb94f9875a716ed08=
f23
        failing since 0 day (last pass: v5.12.2-383-g508b08e40956, first fa=
il: v5.12.2-383-g4da1b11242f4e) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
r8a77960-ulcb      | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/609bdaeab7a7e66403d08f30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g186fb6dfb37a0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulc=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g186fb6dfb37a0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulc=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bdaeab7a7e66403d08=
f31
        new failure (last pass: v5.12.2-489-gf332a5e050fed) =

 =20
