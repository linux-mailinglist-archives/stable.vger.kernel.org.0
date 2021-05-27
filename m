Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE0393253
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhE0PVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbhE0PVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 11:21:49 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7900EC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:20:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e17so833238pfl.5
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rFM5mvRySO3O1lZMJCwVNKVNoYmg380uW8LYLVXsPvk=;
        b=QnLV8iGsF+7is8tXyMMdnqYZKTRpWnGRhsC/n7lUdDNiZWfq0w5RUiVoQwKVSEH/df
         nCc4BKpfuE2YWjvIbf6jrABcILpL7OCol60tLHGU2xglR3x3/DB+qvlN8x9gnqVdZg+S
         STN0CutiQHa3nBOIBym6d0oeuiGW1ME6rCfn0RXIpDjY48WvXwgLge4YF+52V5eaEEfG
         ZiY3WlnST5BwwFE0MYFLpzeT9srJHCXx3h1vtoLTgt/8yZRaVTmvStbbFNpZZXFkzwHV
         +kVk9xWPGJQH16fiqFKzRNzbru3igO/Z3q2cZLX+lncQ2Gbd0YL8mR0uW8e2HhKYGy5l
         HklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rFM5mvRySO3O1lZMJCwVNKVNoYmg380uW8LYLVXsPvk=;
        b=PyAAP/8EUl6Uu8ma0shhywu3UrQrQ8UkIkpJAvtY2SLHUPEX+FUxFrWGZc+q87bWKj
         uJY1RvJuZKWsiatqndXeN1dZxjVGGyVNP84acg+z/dRA3aosRl2e+Mo+yQNofVB6abRV
         45c9+WUxH0MZiLlblyPkZTtttA1+CZnBSmfProGLFHvIOSsj1Vntl+cb8YNJd9zyfwGA
         MPPsIo+I9HK69KmPNGU46CktsTYnHaRQ/EG0T0oFcTyQXNG9qXaa6KlkKXhYALKUqppz
         TeXQe1ddXAMAj/ome0s8Nt8cdf3Qt2aoD/Jw53ibBDWq3PZ/vPlaIgNDiYGYLWTYyPul
         T2UQ==
X-Gm-Message-State: AOAM533qQ841S4fhpADu2ku25Q1sNj+npEC05118xGVx8xFGA+aCBTKj
        m1AwtwLRJQaecIWuQdudoj70VeGyoK0RLQ==
X-Google-Smtp-Source: ABdhPJwvSz2auhrtB9Dnx2iDyRYzlpGkbssGTM5kUwdQoXAqMFVH34s+ATVZMPacxxOMQC7AeTKLAw==
X-Received: by 2002:a63:3d84:: with SMTP id k126mr4135821pga.121.1622128814814;
        Thu, 27 May 2021 08:20:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm1987321pfv.149.2021.05.27.08.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 08:20:14 -0700 (PDT)
Message-ID: <60afb8ae.1c69fb81.ec573.6cf0@mx.google.com>
Date:   Thu, 27 May 2021 08:20:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-6-g71f64ab23af6
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 148 runs,
 1 regressions (v5.12.7-6-g71f64ab23af6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 148 runs, 1 regressions (v5.12.7-6-g71f64ab2=
3af6)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-6-g71f64ab23af6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-6-g71f64ab23af6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71f64ab23af61ed1cd2da78156f217839c13caef =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8264cbe30d8b26b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
-g71f64ab23af6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
-g71f64ab23af6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8264cbe30d8b26b3a=
fc8
        failing since 1 day (last pass: v5.12.6-124-ga642885de2c1, first fa=
il: v5.12.6-127-g3e985cc005fd) =

 =20
