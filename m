Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922773A3797
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 01:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFJXFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 19:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFJXFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 19:05:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01500C061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 16:03:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g6so2869406pfq.1
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 16:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Y1BKZerzBOy6Oe4UHRFVw0WLq7VOurM+Gtaj/kVeGg=;
        b=jG0NdB0msoJdeY8dmA+QepUbYmR8onuVtVn7gfwrtzx/wyZ2VpFaCGjD+Guc0Wo+bD
         8ppdjjz2mbgnMx95rLGW352vk14uqwO2+Ii3mhGZPDoOaBMM3WD/ouZFMc6i78OGjzf1
         vEhPrS70W40FkgoHD+hDRXzi+suBKd+Uj02MpJmruJnACpk/m4ZqlYpiI7Y6NjbUdD4B
         7gSU1mBw5L53PKPRB36VbgiSAXiowahFtceacWKAjYjADFg6o2/pSUJRYzREWArvAeBq
         OAxqQprLxlrXWrBH9w30StMBuQonzduStYAKtztkERTAyxxG19ySqJkIcUoRFhO10S76
         6UEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Y1BKZerzBOy6Oe4UHRFVw0WLq7VOurM+Gtaj/kVeGg=;
        b=L4HFeVDNbQ3O+1AEh9BkA62pHzxcy48w6nt7QW/UoCg5uxiPvQ+vFQgMpx6HejUyqu
         Ou+PwHCVj0Ux15tHA4RhWma54gtu5BI2iwu9z2CCxKtih8huB0uw1xmsYcfkrhkQtRnQ
         FCrCFt2824J232Q9Xsx1Kpdh2HWIFJSdnQB5vWpSFgzMl/5dJPpYm4BKqNz3SeKDcdP2
         lXoZffaTU+ZnIcGOn+5/XlUIpFXH7uCr0yEtTv4jcyrlsnSDAUrE/ckkvZizeFt8+fbQ
         R9QXfK/ZN5qNUAaW+u2CENpTB8JREhBbzRIz/eAcNK9EueXCC9DTb7uYJzMnyQ3ktFnS
         hoFg==
X-Gm-Message-State: AOAM533QXmy/Erdwfq7+0cHf4toTWsoYoIqatnyH893AaERhUXFdQDf9
        Nm4shOM6a6zgPpbYYIyldAYrGj+JKLNfZQJ1
X-Google-Smtp-Source: ABdhPJwUMZT5bYDZ8tzBtOXXJfljYgfBWFrZtP1yx0q1Qp25qGb5uiIau2kyjnPZ/mgfzgU8kt4ryg==
X-Received: by 2002:a63:170e:: with SMTP id x14mr663157pgl.452.1623366222409;
        Thu, 10 Jun 2021 16:03:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm8427831pjg.48.2021.06.10.16.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:03:42 -0700 (PDT)
Message-ID: <60c29a4e.1c69fb81.d8fe2.a862@mx.google.com>
Date:   Thu, 10 Jun 2021 16:03:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.10
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 160 runs, 2 regressions (v5.12.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 160 runs, 2 regressions (v5.12.10)

Regressions Summary
-------------------

platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
imx8mp-evk    | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a901e19407d3424ad6362c59755182440b939e4 =



Test Regressions
---------------- =



platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
imx8mp-evk    | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c26939547f069f060c0e11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c26939547f069f060c0=
e12
        failing since 14 days (last pass: v5.12.7, first fail: v5.12.7-8-g6=
fc814b4a8b3) =

 =



platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c267f3e5ab03e9d10c0e11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c267f3e5ab03e9d10c0=
e12
        new failure (last pass: v5.12.9-162-g5a0a66f4d817) =

 =20
