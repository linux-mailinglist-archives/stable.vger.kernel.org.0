Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5763770D9
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 11:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhEHJX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 05:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHJX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 05:23:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30543C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 02:22:58 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m12so9114013pgr.9
        for <stable@vger.kernel.org>; Sat, 08 May 2021 02:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bWzOom3KyuGhojCbLaRSlYAt2fSRHAvW39TqLEcGLoY=;
        b=jq8GTVL1tVkUo+dRLg4T9O67M3n/BAKjOA4AS2BCUQXKUU/QZ4lLONQqHffZMh0Eoz
         4M8QoQcieQl/vqfbJfoFlaKhvsr/OwHghVPnRH5OpruPoYJuBoOxdZ2k8f++37BrEyg1
         q6bWLsr+rfRdYxg0cvKP+ktQaZi563b8NT/13VKhS5Qi5sn6+KtdcwSNK7h9jW+T8tvP
         83OrkpVFEKqCuTvy4/ea2x8KPAxUTMErD59zsMlNJJ9duheIuJzXv6RRrYr5zYDaxNU4
         Q9czakj9Hi9VP/Kmos1Hkedmq3vugiPcxQQon4T5LT2rSkDGvn87ieRMDxFmU1QKUy0y
         hXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bWzOom3KyuGhojCbLaRSlYAt2fSRHAvW39TqLEcGLoY=;
        b=encXEwcQ/54lVSMDVmQv1CpZCikGFJ/kc2n50B4ixzYqwNAdOEEQdwIR2pEmmAwhR+
         dl9E44k6Nong5MTDbbsA7PUPIvAdQAlQWE8i8PbWTBpnLaSFz7jX+LqCFC8v7AVp5z5a
         heQmDz6Aa/nRNfDoxYL9FsJX/SS9OaAuYtFsMz9m02JZHalqACAcLjHe/ZcuNzbA5rGL
         aDZknDfrF7ze0rjm352flMZHEOlr9s2sd2MqRfsOdXA5WZpdwt6R5fH0eWWudhumMh5u
         RbhCShI3lR0Zsgi9UOoSYkNgr3WICDcvT0xxdo5HTLLzRgiU9ua8uSfVwW4niECO7Eij
         roPg==
X-Gm-Message-State: AOAM530SDX7aq21qRk7yRvoTR/Nf2TOdSDFajm/RGXsxhNE9qT+aUxJn
        VDrtIu1bQmXUgk3qJiObkoBbW0emiYwdMKRc
X-Google-Smtp-Source: ABdhPJyZu7qp9wagki5AkBP7RCtuEHIGVkxWAotO9gJA5ZWYVgb/IsR4gGnKIAw48T7PwX77K3AhIQ==
X-Received: by 2002:a63:dc49:: with SMTP id f9mr14356932pgj.361.1620465776679;
        Sat, 08 May 2021 02:22:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm6932205pfb.27.2021.05.08.02.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 02:22:56 -0700 (PDT)
Message-ID: <60965870.1c69fb81.c1e0a.5683@mx.google.com>
Date:   Sat, 08 May 2021 02:22:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-210-gbc817a37cd8f
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 2 regressions (v5.10.35-210-gbc817a37cd8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 146 runs, 2 regressions (v5.10.35-210-gbc817=
a37cd8f)

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
nel/v5.10.35-210-gbc817a37cd8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-210-gbc817a37cd8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc817a37cd8f9db2ca509f4535fa4bacbf5d5121 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609628216a84b8c02d6f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
210-gbc817a37cd8f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
210-gbc817a37cd8f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609628216a84b8c02d6f5=
468
        new failure (last pass: v5.10.35-50-g87378cbb264a0) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609626cc7fc9afd7bd6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
210-gbc817a37cd8f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
210-gbc817a37cd8f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609626cc7fc9afd7bd6f5=
469
        new failure (last pass: v5.10.35-50-g87378cbb264a0) =

 =20
