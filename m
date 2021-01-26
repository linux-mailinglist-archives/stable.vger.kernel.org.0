Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C1B304C23
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbhAZWBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbhAZVHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 16:07:05 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151BBC061573
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 13:05:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lw17so1862192pjb.0
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 13:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cVBb1Qkvfsw2wnFpkUfJVS+qCG/jlwN6125+9xvoHoI=;
        b=e1RDE6xWju3PDmIQjhPtBB79uyzdhRkcOVxlBoca7iyNVNAa39y+tA7CtCkMT1D3x6
         BjU78atNXFZmLHqcNVQn1lG8N3Il08ijdFysmBBAAHfWoIBrDSFx7q9NStANfatJbanT
         t31Si+Ckb51EC6BB/VmWWdMTg54zy8MSXKBa6Q4GLcAPcJs/eiURnKqpWn5El3K6mBbC
         ks4ZCF/B/5g0HNBlp3I0xOoa4/5dDcy3/0NM+MxWHv/E7Ca/D1MgiIioqSfZ82DFC7cV
         FUUeFuHZkUl+q4kRW5nq52BNHiOAA88wUWcLAz3gBOZKudIfzaQGVVLCuEHKNy4Ekjgp
         9Iag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cVBb1Qkvfsw2wnFpkUfJVS+qCG/jlwN6125+9xvoHoI=;
        b=WdIQNsgIAnkdIW3iZC4wLgTlkT4FhD9rXy5EPak5WTqcewJwm9QxedqZ6n2s4Npy0F
         2Zet5inUDMPyUzuelTw/3qgsWX+KsQ3FBUXOm5K7mgNmQkdJVmSVRIzBJFkkUSxQK0Wo
         hq10nkgbIlm2otvuaOxIOHkwpD2ADhMo01g8G8tvmWwZnQ9ExMFtiNxLJX1MXHFaftSK
         yuz8aER/NxhQ8VT+GHDj/jq0wMZpqIQx3Nrp/B6iC+uPhujoyPomx11vtTY+RR0YpmEP
         vaOJX+vhC92WjlzKe+ZaGyPf5OItmLlquwM4cDxreWVdOTsFTo930F2qIq/Qb2+WV/Xz
         I0Qw==
X-Gm-Message-State: AOAM530p2wt9Ffi8zZDtRxzq14NDuHI2FD4+I3KvU2RyCf2DW81erEtV
        cHFlkoHePEykE3eijRpQp02qHN0lnbtm4PJ7
X-Google-Smtp-Source: ABdhPJzHz4VzqRT47JzH0Cywntazh2aMksVJ47x4h+L65Bo2HNV5voKzwQo6AlBvoOg4sEpNjeR79A==
X-Received: by 2002:a17:90a:7e88:: with SMTP id j8mr1689370pjl.217.1611695148184;
        Tue, 26 Jan 2021 13:05:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m77sm33562pfd.82.2021.01.26.13.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:05:47 -0800 (PST)
Message-ID: <6010842b.1c69fb81.bd19.025e@mx.google.com>
Date:   Tue, 26 Jan 2021 13:05:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.10-203-g7b2d1845e2139
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 186 runs,
 3 regressions (v5.10.10-203-g7b2d1845e2139)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 186 runs, 3 regressions (v5.10.10-203-g7b2d1=
845e2139)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
imx8mp-evk                 | arm64 | lab-nxp      | gcc-8    | defconfig | =
1          =

meson-gxm-q200             | arm64 | lab-baylibre | gcc-8    | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-8    | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.10-203-g7b2d1845e2139/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.10-203-g7b2d1845e2139
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b2d1845e21395805add41fc896fb22ffde8f03a =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
imx8mp-evk                 | arm64 | lab-nxp      | gcc-8    | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6010500e6db82e0915d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
203-g7b2d1845e2139/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
203-g7b2d1845e2139/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6010500e6db82e0915d3d=
fca
        new failure (last pass: v5.10.10-199-g7697e1eb59f82) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
meson-gxm-q200             | arm64 | lab-baylibre | gcc-8    | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60104f09b852c8594fd3dff5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
203-g7b2d1845e2139/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
203-g7b2d1845e2139/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60104f09b852c8594fd3d=
ff6
        new failure (last pass: v5.10.10-199-g7697e1eb59f82) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-8    | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60104efab852c8594fd3dfd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
203-g7b2d1845e2139/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
203-g7b2d1845e2139/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60104efab852c8594fd3d=
fd3
        new failure (last pass: v5.10.10-199-g7697e1eb59f82) =

 =20
