Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC0B401D71
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhIFPRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 11:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhIFPRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 11:17:23 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B29AC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 08:16:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c17so7133433pgc.0
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 08:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PJZWMhxgGXJzdktgu2Wyd25qqjvzyJKbybf0bCXJii8=;
        b=mY++1wOgYZ0nRRg3wZx4M7sO/iqTgSPA7bPji9Lrq+n2gA9qSPRa36Ob2EFVnIqFQS
         Abg0tDKi9aSeuwvrugWmg6aV2dy8fyieev74FQtAV6kQsFNxfxPVywirFJdhlYFUhwSv
         lL9ImLc4DXyUuzcXBQa+OnyJqthx6taEpSFRtUt4niMfzW+kBrAAY+eSjE04+A3tDvFq
         fMx4nRXnBK6e9bGwYNaGCdvyDJfTCXWrSQdamDrQ5bQ7uWMnuooni9OMRbxjs/zXFYHo
         vdE4thGXKX54L/l4P7DpfTvL7ImV4OG8h9ZsI7XVBrSFpHeWgth9W7A4k8Q2p0PpMN6/
         szdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PJZWMhxgGXJzdktgu2Wyd25qqjvzyJKbybf0bCXJii8=;
        b=Lx4z33edrK/ZAn2ymQg4BlSfD3XBvVBhInenxX49tekJQTzDrZh1JOniWtI3mDpBaw
         NYTlqy/xJDcV8wpMlACP4j+VoPEeyS0kQud6E5JlppbVK0/2cZAV0nhNdYf4XBQAdVUy
         LVVlzPWBu7hJgwhJVEfw9CLK+OnETVbDb6ymURbgV2XiPtWHVQzo8u4L/5X2RZqzMtIE
         UZsr61oxfnv5+OwJC1W223B0Qa39jkK+QydBPJ1cM5Z1IStDpj0bylfl9VTfEmlcylvd
         gCInAh8myNdrZz0hFyV1i5ZowQUiBcsNhncvWj3tzJ0liTRBS+9HggJtnwYclBwdKVHH
         XbVQ==
X-Gm-Message-State: AOAM532zPQDWemcz7hvDD1Xwo/ITtYBdYpeBa0vn3G/kTc5x9JTkzwUB
        SBoee4i0IZficPVmxYpLvSYHAl2VyHe9myjL
X-Google-Smtp-Source: ABdhPJygo2DQ3Om+r7KJHKhhWe1DEVdoNiAnGEyaLhnI9kiRZtb55Y+xLEkFH4U/aDfwTOkHIRVHVg==
X-Received: by 2002:aa7:9e8d:0:b0:406:be8:2413 with SMTP id p13-20020aa79e8d000000b004060be82413mr12289356pfq.66.1630941378506;
        Mon, 06 Sep 2021 08:16:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l13sm219594pji.3.2021.09.06.08.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 08:16:18 -0700 (PDT)
Message-ID: <613630c2.1c69fb81.088c.0af3@mx.google.com>
Date:   Mon, 06 Sep 2021 08:16:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1-14-g8db0ae7d7076
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 192 runs,
 3 regressions (v5.14.1-14-g8db0ae7d7076)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 192 runs, 3 regressions (v5.14.1-14-g8db0ae7=
d7076)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
    | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.1-14-g8db0ae7d7076/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.1-14-g8db0ae7d7076
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8db0ae7d7076a6593b6e2b6f4e4d55bc21c065ee =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613600c0c3e5c5bd28d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-g8db0ae7d7076/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-g8db0ae7d7076/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613600c0c3e5c5bd28d59=
668
        failing since 0 day (last pass: v5.14.1-2-gbbf2e6a216c0, first fail=
: v5.14.1-2-g1f34a835c69c) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6135fca719452f798ad5969f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-g8db0ae7d7076/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-g8db0ae7d7076/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135fca719452f798ad59=
6a0
        new failure (last pass: v5.14.1-2-gbbf2e6a216c0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6135fba3d4ae1d524dd59678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-g8db0ae7d7076/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-1=
4-g8db0ae7d7076/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135fba3d4ae1d524dd59=
679
        new failure (last pass: v5.14.1-2-gbbf2e6a216c0) =

 =20
