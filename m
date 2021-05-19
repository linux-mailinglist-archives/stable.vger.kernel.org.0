Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937C389506
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 20:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhESSJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 14:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhESSJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 14:09:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92906C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 11:08:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t193so10035502pgb.4
        for <stable@vger.kernel.org>; Wed, 19 May 2021 11:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=94MhsPT8I8MPp97dtVlwXRGB1CCzJhdUKxuLpGLcaME=;
        b=OUCS+WRVHRS8qOtct+WmEGlyZxiGsCSzQsWrAVx9y2UYJUZEcK+vY9vcjEMA8wYaFk
         EgzRkgQcGfP2LTgiJph+fQogtKnL5WCLgdbs7hN0iTrWhXrayRAfWHOTjfnKhPMjxYgw
         Nczy41fqkn2Yh76S2XCrO+MPgWtrTPykjtBD+G+4NZZD9GrfYqsYeNTTFWgn2XCwcHaS
         EyqUFVZj31X7cqaJYlmQ+X5Um02ShCAzV0QH2/buTyHOmYa51mR7vnTg8c5AyitxkySs
         +keUZd9x5G45T8RNvE7HffKPIQDhT2gIg2dRLM9LSTiCbrioC9CTkU5t8Nfj1uo8CzYh
         cYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=94MhsPT8I8MPp97dtVlwXRGB1CCzJhdUKxuLpGLcaME=;
        b=HH4RuAhDjhlHFD4XJnzpvUN/qynmPw7xtRYaccVX+D+bmZt9zTeGJkGU7PPU0FgHo0
         IHih7YN5gTtQTDbsB/sSV3QUDeSaaK31FdLbUdgkTwauTrMevK/UkOIRFLy0uGhnZfeY
         FzjbLLVgr43e/uSRRnXdZU3AK6REqeUl0qrCVx7v8OexgF7jO1Ym9KaC4qgfUI/kplQg
         bLcVIiSHZ8XtYP8OBgs+J42wL7+XS7Dxr0+fNJ++spiiwt9fFKa0JGATspzuGgHBC8Et
         tVp69ep+0Hu7h4F2330ZxFN1ev2MI8Au6PH+WoKvkiuLPvIfu86IpC2T7bDAuceaRo/R
         MT6g==
X-Gm-Message-State: AOAM533tvioomKDGtI1YHQzpEsi3XiHEQUV/rzpZSIjKxJMoEum5cAlR
        i09UHe0f14q9EMmN1T9TSWgqZIUdz+dB2Q==
X-Google-Smtp-Source: ABdhPJxfhtkEGdHxLS2aYO3A4WgG5On1XCqGkALfmuwzmkbbYc4c7aoMvVxCL+FNQpYWWwp6NCfIVg==
X-Received: by 2002:a65:6402:: with SMTP id a2mr374520pgv.49.1621447693789;
        Wed, 19 May 2021 11:08:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z23sm121435pjh.44.2021.05.19.11.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 11:08:13 -0700 (PDT)
Message-ID: <60a5540d.1c69fb81.d3e18.07db@mx.google.com>
Date:   Wed, 19 May 2021 11:08:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 167 runs, 2 regressions (v5.12.5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 167 runs, 2 regressions (v5.12.5)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      761ea31e416adf1291edf31c8daa0f9b1b94f03d =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a523bef0171a7a0eb3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a523bef0171a7a0eb3a=
f99
        failing since 1 day (last pass: v5.12.4-343-g1fa9b48b0d6a, first fa=
il: v5.12.4-364-g8c6ba5015aff) =

 =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a522ba8326af8475b3afbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a522ba8326af8475b3a=
fbd
        new failure (last pass: v5.12.4-364-gd9d51f8654b9) =

 =20
