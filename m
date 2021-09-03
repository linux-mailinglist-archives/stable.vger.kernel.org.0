Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0EB40039B
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350066AbhICQmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 12:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350010AbhICQmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 12:42:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361EAC061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 09:41:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so4140115pjw.2
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 09:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fGA+iZ33nTWv/TRV/XUstdflvnW4eDCThDnIfeJWTto=;
        b=YV3bjwg5hTzuk956sLLiet/smTcuyY9qMx8vrfeCexROdbIyUFbud14GeDV2PNxzxi
         QcsZmQVyO/B9jvjnYzLBmpLVcv2fWlsvoYnCbUhKwoqHolcy5E46WAogOdiAfy7rxe+U
         HY1KJk4w0Ye8WJk0rwAFb9gxbGG5PIorv8I5G0SkUtouYT6V54omh3sYNfY2GnMD6avH
         327+vrT91cI5SmHMi+7f0FSc7BIBlz+bzPF59z/X6ovwXHjzLUVjA5FYnfpzTB88Woaz
         Z3Yv2mMYID72RsESBl6VsYbYxqMM/GHiEafILIeNvfovIavb8ywQgVjblOk1xKFiOTJd
         MWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fGA+iZ33nTWv/TRV/XUstdflvnW4eDCThDnIfeJWTto=;
        b=RrGBqCqCNDRlJ8DxYFEdceYk3IQcenDBTPyuPoDZ1s/CSrprRaBvX1jfcM/elPywA+
         KbKZ4qhH9X6tUUE8IzHYY0CO92Pt3C95lrRrgrEUQ0RCpJgYh1wzZW2xpdQ46VPPwngy
         efYEeZ/m8wwMtqAFTjLtlHCvFgbkVwyrjUHl0hb2yREti+ubaeO0W4TT8zNK+Z4XZ+Bh
         0T72SguNp3mxyM8qkhEdkL6Z8T6vnXywfIpyDn/USKgLiH1kkU5oTgWxL923alYTkyKg
         OkwdnUBv68q/oPpPjeJJ3xefTzG0kLbKTf1kaWwIgWF3AXuiExpagfJp1Lg+x8GZhE3a
         B+/w==
X-Gm-Message-State: AOAM530s+SneNUFwidj9svMlC3yK72CZ88jCL/wQxN5GfOAyh1i5HS6e
        +sWtJplxU0u1ph1uT/fI0/JrtM9T0DuGYglE
X-Google-Smtp-Source: ABdhPJynHtx5w6ePL4Wp5CmmDq+X/7hMPeW1KRxdTjQASDVR7LlBE5NDXnknLW/zYuGYZz5bRvuqiA==
X-Received: by 2002:a17:902:6848:b0:139:f3b9:acda with SMTP id f8-20020a170902684800b00139f3b9acdamr3968509pln.39.1630687311471;
        Fri, 03 Sep 2021 09:41:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw14sm5310573pjb.48.2021.09.03.09.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:41:51 -0700 (PDT)
Message-ID: <6132504f.1c69fb81.2097d.e24e@mx.google.com>
Date:   Fri, 03 Sep 2021 09:41:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
Subject: stable/linux-5.13.y baseline: 179 runs, 4 regressions (v5.13.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 179 runs, 4 regressions (v5.13.14)

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

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a603798fb16829e56f80f57879611e67bba4910d =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61321ded364b308c22d5966f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321ded364b308c22d59=
670
        failing since 34 days (last pass: v5.13.6, first fail: v5.13.7) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61321ff33495e203cfd596aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321ff33495e203cfd59=
6ab
        failing since 15 days (last pass: v5.13.7, first fail: v5.13.12) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61321e8e334ac7ad19d59694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321e8e334ac7ad19d59=
695
        new failure (last pass: v5.13.11) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61321d903f7b8461fed596f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.14/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321d903f7b8461fed59=
6f9
        new failure (last pass: v5.13.13) =

 =20
