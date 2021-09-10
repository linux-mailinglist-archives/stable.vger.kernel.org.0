Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD67406FC3
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhIJQjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 12:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhIJQi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 12:38:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB6DC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 09:37:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m26so2353009pff.3
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 09:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WIcvlpwPJIz/PBtZJQlTtLNHwdC8XwI1xvaP2Vhs0PY=;
        b=df9GefoYfTX9mgVOub73HUIA28OL7cZMK1sEnvrfaEFx/VBv5HOXpzxUvYb7tLNJBr
         z38zc6F5y1LjMXWNLztrJAUnBzp6uyCI8U9HN/clqoSPy+ahN8+AJvpsLMPFrDOajdAt
         bV07oxGfSY9QJ3H1EE1D5VtNKzIKLsNvS/sv0e92DSqM63dQ5DOWd0iW+bq2wscvNjiQ
         EhwpNaNE8snjP9VpP0f9RWDQ5cizoljKLtr8mZe0fgdU/eY+Msw/5XeGY+HNc5c2LVlH
         MoK6Tyi6JEEx/9onV/KZc4jt2FQVP3J7ZD/iqu9bGinvapeMWVUhtVPhQ/M6jJ0bSCpE
         IhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WIcvlpwPJIz/PBtZJQlTtLNHwdC8XwI1xvaP2Vhs0PY=;
        b=H3jiMt62jM8itGXgTTfgwwjoa5kAVjBjJwq/4pX3lEA93qOg6O4gOfuTa+vnpEijr0
         HaJi4YtZQIdlCkxstYjWFkCa4qXO2tXoG2PjZWjRrcZU14Pfcgt3dVyXzuOFWNvE4dkE
         HvTUHNG1N9Ll9qT2Of5gI39JvBb1+0RvfQyRDi+41hkWhfE7iI/ZGTgeohEsHq6zGJ9D
         jT/txZ+ovFxlk5//HwrhVKyawpacXlAV8zSRWsA+1mVtuL/4BFF2nRdiYgKtzP7n2hOn
         VSZcjBK9UmRpjdE9NH0q6Z37JaYUKyqrcAhkTW850L6+0NkOWUJ+7myu2e36kx2XGCBd
         //Ag==
X-Gm-Message-State: AOAM531Zc0MYXt0CUJf0CfRhWM5+8RzHu0veAu+eHGuisljYhO87SSQh
        lS4ZdVZrVKJdZlkNCqrb53RO15l9ngpHL0CT
X-Google-Smtp-Source: ABdhPJxDQl1bZCjx1xvXosyG1uW53izOLc/3QwzXNlZieA7uxNLc4NCtgxz3TAYA+2IsMRHkMo3YFw==
X-Received: by 2002:a05:6a00:a94:b029:384:1dc6:7012 with SMTP id b20-20020a056a000a94b02903841dc67012mr8906048pfl.53.1631291864738;
        Fri, 10 Sep 2021 09:37:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x16sm5828069pgc.49.2021.09.10.09.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:37:44 -0700 (PDT)
Message-ID: <613b89d8.1c69fb81.91840.0c2d@mx.google.com>
Date:   Fri, 10 Sep 2021 09:37:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-23-ge6845034189d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 164 runs,
 6 regressions (v5.14.2-23-ge6845034189d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 164 runs, 6 regressions (v5.14.2-23-ge684503=
4189d)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

i945gsex-qs             | i386  | lab-clabbe   | gcc-8    | i386_defconfig =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

kontron-pitx-imx8m      | arm64 | lab-kontron  | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-23-ge6845034189d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-23-ge6845034189d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6845034189df23c17e999e2f3eaaf8e123eab69 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/613b58876e25d0497cd5967b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b58876e25d0497cd59=
67c
        failing since 0 day (last pass: v5.14.2-4-g7e05d47c1c8d, first fail=
: v5.14.2-23-g1a3d3f4a63ad) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b59d9700a5fbc7ed59689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b59d9700a5fbc7ed59=
68a
        new failure (last pass: v5.14.2-23-g1a3d3f4a63ad) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
i945gsex-qs             | i386  | lab-clabbe   | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b544e84fe2dcb64d59689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b544e84fe2dcb64d59=
68a
        new failure (last pass: v5.14.2-23-g1a3d3f4a63ad) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b576f8f4c2d3af0d5967e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b576f8f4c2d3af0d59=
67f
        new failure (last pass: v5.14.2-23-g1a3d3f4a63ad) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
kontron-pitx-imx8m      | arm64 | lab-kontron  | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b57aedaf32de03ad5966a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm64/defconfig/gcc-8/lab-kontron/baseline-kontron-pitx-imx=
8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm64/defconfig/gcc-8/lab-kontron/baseline-kontron-pitx-imx=
8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b57aedaf32de03ad59=
66b
        new failure (last pass: v5.14-11-g2f0a46dcd4af) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b570a704fdf8024d596c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-2=
3-ge6845034189d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b570a704fdf8024d59=
6c8
        failing since 0 day (last pass: v5.14.2-4-g7e05d47c1c8d, first fail=
: v5.14.2-23-g1a3d3f4a63ad) =

 =20
