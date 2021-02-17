Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC42F31DC4E
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 16:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhBQPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 10:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhBQPeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 10:34:44 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C0C061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 07:34:28 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c11so8617137pfp.10
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 07:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mWjmNQoHTLFb5lu+D2BdmJ0KwFtxbtWnAudaREoZbg8=;
        b=0vrKi1GcwiVlWN8zd6mCoeUvO2U4wkHZFF+3Lvo4yhKF5YeWoW8D1cpfXFaSyigMr3
         Xr8GLV0nSznXl1Gz/38GQKufCXztcnTm+AHC9Zg01N8bzpUfh5kB0n9c+I1gW+DpUpi5
         fTtTMq57m2xMgF1iZViduHmBhMNPdsGWDWUkdB2w9k4BE1WyoPsLmg7a063JQr0GzR8t
         llj/BQ7INX0WGCj5vEIa6Pzrl3GzIMd0oM3r9eH7vzKBylMIy0N7vY5Gg8s155Hg2Rh8
         G/CXP7Qz4IzQV0FWsQMo2iu3lxK25RuK7S0M+EjH71PiaSgH5KVtK1bNHLxJVNZa1YY3
         p1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mWjmNQoHTLFb5lu+D2BdmJ0KwFtxbtWnAudaREoZbg8=;
        b=SZpQpmK3ZuVgINy27Z3rdX24GceBP8o53SCdrHvYMrJH/eqLQgiEkpqk8t9l7yrXXB
         WlZmWi1P5QcHsi1ano8tAEeeI8XTTZaQX2f3F8U4INXO5Dc7B6JdWfjgb+Cnx0ZXb2XT
         IK5iTBmpbShiu2sPj8Aj4/oG+p6rMomyuh041igdRtlvoFNJIpQH72rTQKvNdDBwB2e9
         KX2dmvA6dqgj8AXi/CTjswo9dcT/JsGcc3S/cJJpyHorK1dWQNjRayIr/QTNLKvwbxOz
         n/+2qEtZiFJ2pgF2vHFpgOsyT+6pxiDw11dVa93xQ5oUrt46zLusrJ9S4Bus//BBrhpr
         LktQ==
X-Gm-Message-State: AOAM5315q5e+eJc/hyEFDwxVgBfzlenkCL4S8YZlcw1DbwNk4eT1n/vA
        kr7Z3dZLCdt+UmDFg/Dr8IQEp6mQnVyxpw==
X-Google-Smtp-Source: ABdhPJwiVEPwGefVZP6tWFCTHZXViOcgT1EUlPuUP/oyMaaoVgY5dO7QxWu54NzBhM8YvXEnDiC4PQ==
X-Received: by 2002:aa7:93ac:0:b029:1e5:b52e:314f with SMTP id x12-20020aa793ac0000b02901e5b52e314fmr24384111pff.45.1613576066856;
        Wed, 17 Feb 2021 07:34:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ob6sm2404988pjb.30.2021.02.17.07.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 07:34:26 -0800 (PST)
Message-ID: <602d3782.1c69fb81.6d886.52ef@mx.google.com>
Date:   Wed, 17 Feb 2021 07:34:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.16-102-g2d89c51d5e5dd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 76 runs,
 2 regressions (v5.10.16-102-g2d89c51d5e5dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 76 runs, 2 regressions (v5.10.16-102-g2d89c5=
1d5e5dd)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.16-102-g2d89c51d5e5dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.16-102-g2d89c51d5e5dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d89c51d5e5ddfc6ca61acafe1afc07298ad55d1 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/602cfccf3dc705bdbdaddcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
102-g2d89c51d5e5dd/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
102-g2d89c51d5e5dd/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602cfccf3dc705bdbdadd=
cd6
        new failure (last pass: v5.10.16-104-g1cbf162ff83d) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/602d2122ccef102002addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
102-g2d89c51d5e5dd/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
102-g2d89c51d5e5dd/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d2122ccef102002add=
cb2
        new failure (last pass: v5.10.16-104-g1cbf162ff83d) =

 =20
