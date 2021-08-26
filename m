Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB54E3F8F4F
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 21:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhHZT4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 15:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhHZT4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 15:56:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75CCC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:55:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so6579476pje.0
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Uy8m00DmvUQ+xriC6+8k2Ut4iogOjlCLgAVm1WQsL2E=;
        b=EF/oT1IZv5Y1B/MCr3jmmPgjnnVv4Ud7/Z0gt/j0dU8VoblA97TtVcwMmGBRW28anK
         t0d9HTpfL7Dw0zLup2K+1VvZaW19AVqX3u49HPxix5B1IVGzowgK0xRFn0/wASCQz6Bs
         +P50T0OB69BV1CpCHMgal3T9NmD+jnBbK8+w6n0fbJGnnF/BZC8fHhzotNcEX2GIhkG2
         KhB54IwCkT2nxzR5i2xcBy0fBiquV8HDUJTAc845PRfCfSqy17q/DSSIFXZGsW7/oqAN
         YGPnad9jNUzTE3bkFfUoDqrHriGnYcha4uPL8igIGCEB6BoG8rMuw/QM9fNfA2nJpdB2
         t+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Uy8m00DmvUQ+xriC6+8k2Ut4iogOjlCLgAVm1WQsL2E=;
        b=Wf+xpGEIk5oaiTFSGS9DiGSe1sgN7x8Zqj8ABwndIgmF4kkA8MkDeb0OyKq9pyGzMo
         bov1cEKotMp2V37jBFVC6JKCwTF/deSlaSzFsXUdwNYTLAj+Pg1EV9ewtzTeiHA6ZVL9
         BcTUajrPTrYkcldB5Tx/y+y9i+ZWcmpLH455eSxvKqx0iW92OqGWLMUm9G82lZQ+9WGz
         lc1lVVTcGbDSAl86f00cRDNuK37WShGF3FPp+6VhemLyxh0s2OpCPnngrx8dvWErUvP8
         aIYblObAcGAj9rRU3EfpXb/FYZDKj1yAxULJqHuyd4Nbile+mPv6277w5whreZx3bHmH
         zCxA==
X-Gm-Message-State: AOAM530nv5U8JH9x4rYsoKIxi2qC63spMxxLlHwY5hVpaX7mG0UCz3iw
        Ix3SK6Gjp/+1LsAqv8OXRUBTL7dNElB9lw3r
X-Google-Smtp-Source: ABdhPJwLWcLQVv3+LOBTUYouL+3kHPooAIKErROhvVItGLlj07eEnvQNGTE0D1i3X5icBGbkeNBC8A==
X-Received: by 2002:a17:902:7607:b0:138:9422:5122 with SMTP id k7-20020a170902760700b0013894225122mr453845pll.75.1630007751289;
        Thu, 26 Aug 2021 12:55:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z67sm3834373pfb.169.2021.08.26.12.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:55:50 -0700 (PDT)
Message-ID: <6127f1c6.1c69fb81.21440.a54f@mx.google.com>
Date:   Thu, 26 Aug 2021 12:55:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.12-125-g0bca906df054
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 186 runs,
 3 regressions (v5.13.12-125-g0bca906df054)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 186 runs, 3 regressions (v5.13.12-125-g0bca9=
06df054)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-125-g0bca906df054/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-125-g0bca906df054
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0bca906df0541ff6a74c0279852438970e05656c =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6127b7d4bf2c744f648e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-g0bca906df054/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-g0bca906df054/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b7d4bf2c744f648e2=
c7e
        new failure (last pass: v5.13.12-125-gf6c5dda713c6) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6127bed5ce89c690638e2c9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-g0bca906df054/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-g0bca906df054/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127bed5ce89c690638e2=
c9b
        failing since 0 day (last pass: v5.13.12-126-g61c83bccf008, first f=
ail: v5.13.12-125-gf6c5dda713c6) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6127b9849468d1cdff8e2c79

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-g0bca906df054/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-g0bca906df054/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b9849468d1cdff8e2=
c7a
        failing since 28 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
