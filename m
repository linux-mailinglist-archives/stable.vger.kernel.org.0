Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B5B3FE438
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhIAUrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhIAUrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 16:47:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4386BC061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 13:46:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g14so799954pfm.1
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 13:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RbDNNXI+6oHvMEjaMzTFD0bg0MrJPmavZOthp/lTzE8=;
        b=tBMuR2ZqUCbridCLocok5YiaQtkXe3ZLYkFjvlk11kFfE69zZZ9k9B0Ypm5AwSuIM7
         DSo1WrMYMs5obivlUZPwrTvOZgwPCWGCyIrRmuQS1m3QGFzPCDhdq3TwFNcPeWwx/7JJ
         3KciP6il/IuZaTssKB4VEeuAN3zWEvewC8NvpzyamWOQaKv5pYjqavV19Q8C1Mgd2dw9
         NOawhqwQfgxCdTGxNADprqCypp6bomUd5RXPB8H7n6p7LLfFzH0MfOwOXnV20VQkUjcE
         8fGLVy35rxHQSaCfMa9MbkAyAN3indfM/ExpCCVnnWPfnE0LNi2yMMO8ZwgNE0jnpjyE
         1K4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RbDNNXI+6oHvMEjaMzTFD0bg0MrJPmavZOthp/lTzE8=;
        b=K0BzNn8P/mXwkTnFuOJKfyJ1WC/HNTc7aD3eedNXomDs33FeZHATYRreHiLiYaHd3a
         5nAF9c3RnGvxwNZ7EU2wYhNSsI7M4LqnLwIiBJUyYL25tlTPPNSMIqAhbFiEP+zpFdM0
         KP/wPdod2zoXvI7KZiVbcPp/acQXIcopFRAnW2HHUHpC2AMMJXO9SDZ3A2QDmWVjywU/
         2mtVEFsMGEp/kFSVAt20YUOiJElQR7PpoUOcY8qVdMjcs3IGtEq9zllNm/GENwDbwDDy
         CqINGgGDO+a6Bs4JIpAnNXrUGVyGbW0/yV8lJuO3CqxnwskgjpFe2/vyjaPmE0wgf5YP
         wy8w==
X-Gm-Message-State: AOAM533SczslBNTLzi+48IgPya3whXXjsSa7++4ZtWuOVsy8fFAwfPLq
        h1FvRwy9duMIWdiLqsFS87mc/V6NeTZv87UJx6k=
X-Google-Smtp-Source: ABdhPJy2aMNNN88I+LDc0PYh1eM35VNFSrZjWT4QW/y/KRlzQRt7RIoBgXjrnBM0YxaNT6o6VK2Xhg==
X-Received: by 2002:a62:ab04:0:b0:405:c1c0:543c with SMTP id p4-20020a62ab04000000b00405c1c0543cmr1217749pff.36.1630529165347;
        Wed, 01 Sep 2021 13:46:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm619389pgn.6.2021.09.01.13.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:46:05 -0700 (PDT)
Message-ID: <612fe68d.1c69fb81.d103.29b2@mx.google.com>
Date:   Wed, 01 Sep 2021 13:46:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.13-114-gd049bfc3077d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 196 runs,
 6 regressions (v5.13.13-114-gd049bfc3077d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 196 runs, 6 regressions (v5.13.13-114-gd04=
9bfc3077d)

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

fsl-ls1043a-rdb         | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.13-114-gd049bfc3077d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.13-114-gd049bfc3077d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d049bfc3077d9ae46a73c99a7e1db0efe01d55c0 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb7cf24775feb18d596a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb7cf24775feb18d59=
6a5
        new failure (last pass: v5.13.13-74-g5a5b2e290019) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb67b6685c259c0d596b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb67b6685c259c0d59=
6b7
        failing since 48 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
fsl-ls1043a-rdb         | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb77d8ec09aace6d59670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb77d8ec09aace6d59=
671
        new failure (last pass: v5.13.13-35-gaeadb98365a4) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb77a60d708bc7bd5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb77a60d708bc7bd59=
68c
        new failure (last pass: v5.13.13-35-gaeadb98365a4) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb64a2e2050c836d596f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb64a2e2050c836d59=
6f1
        new failure (last pass: v5.13.13-35-gaeadb98365a4) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb6663406faa0a9d59678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-114-gd049bfc3077d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb6663406faa0a9d59=
679
        new failure (last pass: v5.13.13-35-gaeadb98365a4) =

 =20
