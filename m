Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C8040BC8A
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 02:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhIOAVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 20:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhIOAVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 20:21:38 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991DEC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 17:20:20 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q68so905859pga.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 17:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mizl1pLDj/Caf+tK/9bkjXhK7grqurO3WILcA5emVH8=;
        b=fphQ1AlqVZn1Vpf0bbynFuHLq2CH77pjgd1c6EbnUjRtJw8uYZELE7gYk/8OsvYjcJ
         rH3tGVoJjm/PXNuxVTMu9YpUz2p8MW0PG7bROvkTWzswKdbLUExJSvuaGUVzvERdKX1q
         3nJTb9rZDlSRDlwbcNFpECUZajhVWYTiZ2RUBOeMSrgGWyQYGsKoI9eQdnDULiKPTFn2
         SEDsgXadc70mpxuPoD8UXStE3BVBhwYeptUsXm0eZnGPENnH/VVCTc6u/FPSOM5GYQli
         WGvp5iJqfUKFs0xN9bt2R9zKtfokEnoC/8o4oG9qVkGXnsUgWYQkw3CdJh1AT594YrYk
         Cjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mizl1pLDj/Caf+tK/9bkjXhK7grqurO3WILcA5emVH8=;
        b=LEu98Hi2jGQzhFMJq64f66Renw4AlyMN7JjWboy9Cg8kJud4oxuMouFYDkkOAFisfr
         2JGioE4A1gY1AIAhKXU9awuhmr0ejP+JY3mtIs4NFjRvDgflWSVx0y4OeDhDEWx95mgS
         MmGS9U3CvK2Ge6lkjQkUqP75b9w3GeR1XTK+N7MtBG+RLXPldDXegoVWKIlNDC5kh6qA
         zXdI02AP4CNORCJoBemN7KNB73+O80MHrK9gJ05fgI2zbHVlltoxlUg6k/cbHi6ruA4p
         rHyrqbS+9BKrSApxRr0zYtUlV00xvhZjMa45T7Aaii4jARkELv5mK1osZeKrff3lcJEM
         fn+Q==
X-Gm-Message-State: AOAM5330bqGq+D55TWDkPwVm0G9zrlK4U1QEnflY1vEH2LkE4cMwBqsI
        Vok2lA5EKcgkjg+xaXW01dJO7Wbai7N69Hnn
X-Google-Smtp-Source: ABdhPJxyFk4nAR9/DZDxC47vgrm0Ab/1z4VbJ3WVwbLTMD3XkoZzQLPGmkREpXdf3qd1K0+0bpZLKA==
X-Received: by 2002:a62:7508:0:b0:43d:d9cf:1f95 with SMTP id q8-20020a627508000000b0043dd9cf1f95mr7357043pfc.4.1631665219917;
        Tue, 14 Sep 2021 17:20:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm13052353pgd.84.2021.09.14.17.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 17:20:19 -0700 (PDT)
Message-ID: <61413c43.1c69fb81.2f1cc.65d5@mx.google.com>
Date:   Tue, 14 Sep 2021 17:20:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.16-300-ga7725771a72b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 129 runs,
 2 regressions (v5.13.16-300-ga7725771a72b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 129 runs, 2 regressions (v5.13.16-300-ga7725=
771a72b)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.16-300-ga7725771a72b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.16-300-ga7725771a72b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7725771a72bb715154e1998e23d17987f16f177 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61410c0c6d3f433c1199a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-ga7725771a72b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-ga7725771a72b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61410c0c6d3f433c1199a=
2de
        new failure (last pass: v5.13.16-300-gcec7fe49ccd1) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61410978c76e7821fa99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-ga7725771a72b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-ga7725771a72b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61410978c76e7821fa99a=
2e3
        failing since 5 days (last pass: v5.13.15-4-g89710d87b229, first fa=
il: v5.13.15-6-gd33967f7a055) =

 =20
