Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4DA3F89D7
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 16:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhHZOLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 10:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHZOLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 10:11:38 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385C2C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 07:10:51 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fs6so2285012pjb.4
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 07:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7r6QjUXMDhI82TFmDweb9AW8+n2BvSz9qpZw2e+p3ck=;
        b=c15RhXERNwmunszl3Rk5+uBxETU+wo0pqSz2VVh3kB9RIxSHD9anRuzmiNM52RJ3ZH
         RbMqZFvy/wunqR+sIHK6TRrz5nApGoDSc0gFHpsIvyeuHOEiM6ESKflR3Xk4q55hiRpU
         VoGd1mxr93ril+xTwjVewi9no0QPgzORXgyalb/GORpZ66BhoxwbcEtBWE+ClYJXygnv
         dQwDeCpI9YhKy+t9L8BcCVUWbeA0M6CG8etZ4KY32vPoiiQN1YH4pLycpUflMCznmsYo
         lMU5d4B4zSY/O21VB14yr3yn+XdIqzA2UK/Q0yhYCg5qcGI46ku3XE78bagZA9M6ZSF6
         vOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7r6QjUXMDhI82TFmDweb9AW8+n2BvSz9qpZw2e+p3ck=;
        b=Wd0O3A1vq6jwiyRPcB7uhNK9nIDMQpjMnmG677SkBn63JpSdRu2xEaWEFNqrbDLJSi
         +L6JyvTZdd814QE5RHLFxv/5MrOeUvpMgpugZmYimD6LkPawj8AEH22IcJsw/rJ8QQG8
         qNY31KhnscmdeU28GGsI/uB/QGVr8vggEv29a8eTZqMEpFtndKQmOYgZRpExrBH5yWHO
         eMtQc6SlpkZW70tr+KNIltZyRnBWqVPmzWJJOxVmEIBZrAqJrQnLnuGq1wHWnKsie898
         GDseBXhqDUEWw8kVTk1l9s6M9rqoocz8ES8bQls1Njs6JRViikOG9mK/M2LWbLdNC2Hy
         VjBQ==
X-Gm-Message-State: AOAM531Pd/tZ7tkVwi04aAsADx6KdkE5XZvbjSczH6Y3sFT8qrHHmWnI
        1Tfns9X63ClBpOseUC1TTwTuV4xPBA6KpBws
X-Google-Smtp-Source: ABdhPJwVbVD+owgEJsA2q0mCL59eg5/l8ZysI7z8qk0RpRk4ZiTNiedv4c+EO0ha3knfn4kseIJaog==
X-Received: by 2002:a17:90a:e64e:: with SMTP id ep14mr4464814pjb.113.1629987050562;
        Thu, 26 Aug 2021 07:10:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y64sm3842420pgy.32.2021.08.26.07.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 07:10:50 -0700 (PDT)
Message-ID: <6127a0ea.1c69fb81.42cfc.abfb@mx.google.com>
Date:   Thu, 26 Aug 2021 07:10:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.12-125-gf6c5dda713c6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 226 runs,
 4 regressions (v5.13.12-125-gf6c5dda713c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 226 runs, 4 regressions (v5.13.12-125-gf6c5d=
da713c6)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-125-gf6c5dda713c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-125-gf6c5dda713c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6c5dda713c6895c6f900d81197c1421e6a42b4d =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/612770ca0bc1cde4ab8e2ca6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612770ca0bc1cde4ab8e2=
ca7
        new failure (last pass: v5.13.12-126-g61c83bccf008) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61276cf749172bd73a8e2cae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61276cf749172bd73a8e2=
caf
        failing since 28 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612771234880b2a20e8e2c8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612771234880b2a20e8e2=
c90
        new failure (last pass: v5.13.12-126-ge8b42554dff1) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61276f4ffe3665189a8e2ca9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
125-gf6c5dda713c6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61276f4ffe3665189a8e2=
caa
        new failure (last pass: v5.13.12-84-g256f791101fb) =

 =20
