Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31565425713
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 17:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbhJGPyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 11:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhJGPyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 11:54:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB182C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 08:52:12 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s16so5748918pfk.0
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 08:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nXxiIFLxsJSR4uaKc9j91h9X8VCW6KWKzM6++NTDIgg=;
        b=VhyV2HwDqPLOnwkMqeVAlkVgINRNzKFGpETJXlKIxXqE8db7uGqF+7A0oKrmItS6nK
         twO7aHLr0I70BAcq29yW8zpH1pGPT0rqht8h+UDAgPgKhB6fdSMCdF7QQbK3bBgvVPPj
         3HUpctXViZB8mqB3UGCMZxhZbygMfJO6qaTH2b0jlsf5rVsX3Oc3f/LkJK0JCulsi6D8
         pUafVdL2C2RtoXmnO3kteVB5vPcHD8JkCn2w1H3IIMJFY/aRNzLDDHNwE+GXPzitzr9g
         zTpq9QlXvR8uo/YxYeZJ7xMiTF4OCcjyr/nYE+mxI96hnn0oZEBT+E30kBQjnkgr4F3w
         dBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nXxiIFLxsJSR4uaKc9j91h9X8VCW6KWKzM6++NTDIgg=;
        b=yvanJLrCgqTyZ0CS3uKdmt65yyj5zCJghMRunOUIlUAG3MsJqk7cJCFgp7AWX8sNRw
         2UDUChYFA23DU7fFkItHWlzjK7zw+/BNCyx+6t+TY0PdOELhBAcYvx7VumdlJHHZFg3d
         Fen/h7+4HwnQaH7FusQgE7B3h06KXurRJNUZLLo5BP7/6fCIU477xMZGmiIXpvGEILbQ
         CWWx7tq2/fpmVaHhu1V0015hqdpi0NxnYKTTjbqWdHXCGNhsBqexFWVmW5Iq7sz/MP1k
         Og2RvoZc1GSPRPFJBC/8NgxyIoWRluxdeTGwX+j0dlQ1ZnmISuCjtJ/7OHbIcEyU5MQU
         7FgQ==
X-Gm-Message-State: AOAM5313RMmSzF4vwtS/qHfRYMZoCX/geM3APhm5qShfIld+aM3R1qF4
        dRvD4H2MPa/HKxPZAGD6UUWAEq6p8FNgywKo
X-Google-Smtp-Source: ABdhPJykf145af0yNE9rDlq0Nm0FyMq211xhre0PM4PGD/goFpOm8xQYXcp+WLeUI6nIeFc9atoFxw==
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id l14-20020a056a00140e00b00444b07751efmr1012166pfu.61.1633621931994;
        Thu, 07 Oct 2021 08:52:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm8679819pjm.14.2021.10.07.08.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:52:11 -0700 (PDT)
Message-ID: <615f17ab.1c69fb81.942ff.90f8@mx.google.com>
Date:   Thu, 07 Oct 2021 08:52:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.10
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 158 runs, 3 regressions (v5.14.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 158 runs, 3 regressions (v5.14.10)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b133f076639b918bb6ad157f6308b0f595058959 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee51f699379aae999a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ee51f699379aae999a=
2e8
        new failure (last pass: v5.14.9-173-gd1d4d31a257c) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee68388fdcc1e0599a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ee68388fdcc1e0599a=
30c
        new failure (last pass: v5.14.9-173-gd1d4d31a257c) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee5e7253e373f9e99a318

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ee5e7253e373f9e99a=
319
        failing since 30 days (last pass: v5.14-12-g95dc72bb9c03, first fai=
l: v5.14.1-15-gafbaa4bb4e04) =

 =20
