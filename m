Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93F43D9B2C
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 03:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhG2BnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 21:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhG2BnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 21:43:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364EAC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 18:43:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so6824644pji.5
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 18:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GPIE9V2aiKjfnLzfYQJaKtXx8/BvYxddac2PHaHDNok=;
        b=z1u78YHkCvFR8wUGBP90tqzlALY2Pho5TEwCpgMizl97oMj3Vrrw/DGgSFCf5rGPTO
         WWfe/Vi7qHRddQb3OP0Fi8fr+9KkPyCKWDBbjHeUDeKzhreFM4q9RqsBD3m1q9aPj98W
         JnDgw8hmvXI6o8UIeniJKJTMLqnjXODa1G43wx5zlCAHAC/qMMWzaWjbrreKbcN7yDcP
         ttd7BFNN+DoINLVSHBHYCZ1xjnyOUzH75P5r0Z2FInZFg7BH17jxDrD8dM19FQJUbTuZ
         5nqKiy5TZLejv4d87EfDtaKepsz92c1BatwngPvIROu/c1dVcxqhCskyxzQWgKrtgAmF
         wrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GPIE9V2aiKjfnLzfYQJaKtXx8/BvYxddac2PHaHDNok=;
        b=OPgEZF0BX+LxLlrcuBhdEqL7xpPl2O46aO0tYdUOpWyE3uvmv81ni0MO6jDQvIEjX7
         696h53d2mdgETI/Dqq+O4URWThF6t9Qj2/+bTbLRS7vWJTtYlRGQxhdf8jvACm2ZMZ8X
         rjqVPzGG2hRavJ8Cq3NxJj7p2Z89BuyDsp+LKM0z3FpdxXDoJykVqd0Y96FCACCMKnGz
         a1iq0hkH5wtZlIngqJvgAu1pAEkPP1ysodZk+lB035fbuNsEQr0Y/pQ/sPgV5EGb7+WG
         1wkIJfr778zk2dFDCpoG6U8xy4i0rCmKD5XV7j370iauTvD+KvD3pWDz/lutRUuKjj9x
         xZRg==
X-Gm-Message-State: AOAM530rTVH4yz8z27QOtaZyuf7MADRDaPc+Nu2GDcvVvkoljgOcNnqv
        2tYEih3wFcJirL7oaO2ItiUC8k/7q2dK/XkE
X-Google-Smtp-Source: ABdhPJxfcSdKoitwAAuNN5iZnkmMn6GRLyt4uxw0ubPHch6dAWN0MP1ub3XbFxiw8lO7UZaHMZUpgw==
X-Received: by 2002:a17:90a:4417:: with SMTP id s23mr12353547pjg.228.1627522981620;
        Wed, 28 Jul 2021 18:43:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19sm1325883pgj.17.2021.07.28.18.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 18:43:01 -0700 (PDT)
Message-ID: <610207a5.1c69fb81.278a2.5f19@mx.google.com>
Date:   Wed, 28 Jul 2021 18:43:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.6
Subject: stable/linux-5.13.y baseline: 157 runs, 1 regressions (v5.13.6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 157 runs, 1 regressions (v5.13.6)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.6/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6fdb13a7e573640853c481ddabf7a192fff42bba =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6101d00e4fd66e8c155018d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.6/ar=
m64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.6/ar=
m64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101d00e4fd66e8c15501=
8d3
        new failure (last pass: v5.13.5) =

 =20
