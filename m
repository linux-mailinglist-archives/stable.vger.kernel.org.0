Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E92C4070AD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhIJRzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 13:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJRzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 13:55:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908C3C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 10:54:11 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f65so2520163pfb.10
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 10:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BUDWSXg+MvaU0G7BtD+LMeepGP/WE2O5W3pU882oOnM=;
        b=z3hUw8kzNkyyX0qVCfad9oHi662HS26tzBRjwablkz3ujnkZJbBxkUlvQVGe5zqqsz
         4P8j8Fw5Jwk+XQqhumbWoRTzkIeeNvrO4QT8Guvrdc6OnBWOqa2uZmm9Wz1vXS/RZ9QC
         tNW2DyBhteGgOCJ1pRnaVsL4iyw2mSaDebY7vByEd5rQAGtdW+zSqtwza4s1vcqeM7+t
         D0sfnbL/IUf2zaXRDtdkFtsudjpqhC28qkqfRWlfNTB59InpOJ7Y0HcYSxayc+4YDPcY
         16D12mk+1EDMTlEg0xqCqs4AQ7P0Wbgtd8rSIwOTYOOfDzjl9SlNePQv9xsaUvI0xbKw
         N66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BUDWSXg+MvaU0G7BtD+LMeepGP/WE2O5W3pU882oOnM=;
        b=wPz50xiGxf4vT4Li1w3fISk4k00k8K5XMVR7B5k1YpHr37sLR2T1BOxyfwfnT0joiQ
         hsUqTHkss5OOno7Tv9MVqNPd0ylvs7dIICPYQOkL6AaD4pOGRDlqVY57BD0KwKLnfySf
         fOCEanznLn5lPn+MT4w9Dk+ViTNrzZP1AFn1d/dwNO/2BtPzDaZcwQlCbUrSUw8qrmn0
         zyefxhFn9N2pC4arZdaYUMo0fcRINGbhzgPtoUcTWC6S8Ewi+kGyUt4dR3DuD+Au6mj0
         yOFNzUjLzRQglBOqXtGffQZNWoSRl7+1pXooJi28xHa3KeKLr4RzfM25A59ccIcpHTJ1
         viBw==
X-Gm-Message-State: AOAM531k12Rnmd+Yeo5gbVHZfVPlDN9/lYiLiZ4q9BC8EtH5JkUbGUSz
        sYcTx5iViZF/lFSoVgIeZzNBRUdPw9vtZGtX
X-Google-Smtp-Source: ABdhPJxc9nCnccO5Qt4sHZTQJMelviDDEZVxvKVWUnlzflNHSfEMy0H/NKmmQgir1KdfclBvXuJWqA==
X-Received: by 2002:a63:b007:: with SMTP id h7mr8176118pgf.443.1631296450896;
        Fri, 10 Sep 2021 10:54:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w24sm5585146pjh.30.2021.09.10.10.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:54:10 -0700 (PDT)
Message-ID: <613b9bc2.1c69fb81.865f3.01c5@mx.google.com>
Date:   Fri, 10 Sep 2021 10:54:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-23-g7f3773195533
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 190 runs,
 3 regressions (v5.13.15-23-g7f3773195533)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 190 runs, 3 regressions (v5.13.15-23-g7f37=
73195533)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =

beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.15-23-g7f3773195533/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.15-23-g7f3773195533
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f37731955338b3af99536b085718d0ea73fdd16 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613b6bfb12c1a41525d596b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g7f3773195533/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g7f3773195533/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b6bfb12c1a41525d59=
6b6
        new failure (last pass: v5.13.15-23-g950636fd38b0) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613b6aa7b19bd0bd3cd5966a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g7f3773195533/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g7f3773195533/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b6aa7b19bd0bd3cd59=
66b
        failing since 56 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613b6cd58e8ef34fdad597de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g7f3773195533/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g7f3773195533/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b6cd58e8ef34fdad59=
7df
        new failure (last pass: v5.13.15-23-g950636fd38b0) =

 =20
