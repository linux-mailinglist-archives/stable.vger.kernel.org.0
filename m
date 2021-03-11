Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293ED336AEC
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 04:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhCKD6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 22:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCKD6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 22:58:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D034C061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:58:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so8407978pjc.2
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k4ivZtuhtp9YOvfLDrsu0JOzn/x8L/0/HUFJrK/sJE8=;
        b=X/vdfP5Mt+miDd8YBjhD31G2GQLeQURjb4qa6moeQNUgOo+WpX9SDvf/fKCJ14WfpJ
         5Y2zMRqxmnlH41IkifTELinzU/ZrtQLJkEM0tLfJb2RU9ZqBUtEZooYTo/3HHd1q+t2W
         snkbDz1jDGJyNQ9dTFC436wBHX12KkvAWUclZcV/lqcY9LmjB5pkri2P+7+uAvc2oby/
         /1cxx1GQRcoiKNbYSjmvjbeAQEz1xhOcaN34WtWPvQWdQYkOumcFeIEiVNVI6Zv1uH2L
         Dd480MuPMBv9qycXdCKgbgpZ/LLokeIojZDrlFXHMd+k9IHZ+Lq5/aMB7y9+PbQ/iny7
         pjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k4ivZtuhtp9YOvfLDrsu0JOzn/x8L/0/HUFJrK/sJE8=;
        b=OTV3VrHRfsu8Ovon9ataVTFpjoF2qUNuLr4FFrl7ix6fwAroNBFhBpOHBsqHuDyZ9O
         ImZsjiNVhDyRQxoxMLuHZoYGTueHLDeBT8a6mLGzfMOqlQ+BYmyIprK2jMqcbERJodwB
         lJJ1IFJ23dJ5514YSVAzP6NdwLW92EcrjNGSpZF9ZX5K4HXrKyn7jIJ/1PvEHo/EZSrq
         C1S89lY8CeBh/Zn5emsjSCtv1hyefbC2frTa7VS+X20hSazG5PE7lQN2m1IG8WT0tPCO
         QovI2UfRkNGEbauYosdiwRnYfx2lW77q4qG4V5bPxAkAnoOJNX2lWd2c5p7muu/86PFU
         y8lg==
X-Gm-Message-State: AOAM531BhoFdYjtockt9FKnibSth6ZWRCyPDbog0ngrNpLZv5mmE4FxR
        p7AVhsAlnI6FdO+RZZpUjQpb0jD9COWeqNV0
X-Google-Smtp-Source: ABdhPJyM6UAA0SUxnplEUHSZdnvCGCFDEmlykG0BqgN+Ly7v7hdTXf+yQZg9lziJcWR2oCikD8lzvg==
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr6763404pjb.147.1615435104258;
        Wed, 10 Mar 2021 19:58:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q25sm848581pfh.34.2021.03.10.19.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 19:58:23 -0800 (PST)
Message-ID: <6049955f.1c69fb81.2eb64.372d@mx.google.com>
Date:   Wed, 10 Mar 2021 19:58:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.22-47-gf4bf7bd9b1cb7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 116 runs,
 2 regressions (v5.10.22-47-gf4bf7bd9b1cb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 116 runs, 2 regressions (v5.10.22-47-gf4bf7b=
d9b1cb7)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.22-47-gf4bf7bd9b1cb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.22-47-gf4bf7bd9b1cb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4bf7bd9b1cb7d9111363587c17523ef0f82c28c =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6049624215daabe986addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
47-gf4bf7bd9b1cb7/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
47-gf4bf7bd9b1cb7/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6049624215daabe986add=
ccb
        failing since 0 day (last pass: v5.10.22-1-g3a720b3b47d5e, first fa=
il: v5.10.22-49-gf5829772d607) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604966101c2a76319eaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
47-gf4bf7bd9b1cb7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
47-gf4bf7bd9b1cb7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604966101c2a76319eadd=
cb2
        new failure (last pass: v5.10.22-1-g3a720b3b47d5e) =

 =20
