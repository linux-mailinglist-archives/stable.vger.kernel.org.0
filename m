Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A1D37B045
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 22:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKUtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 16:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhEKUtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 16:49:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508A4C061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 13:48:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 69so6804449plc.5
        for <stable@vger.kernel.org>; Tue, 11 May 2021 13:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oYzXs5EHHs4DSUbism0caWTdX5ujU1uhoAvIkNAJPwg=;
        b=sAVPa6f9aZXFofnKl+PI3z4cep5SwCVQAyzY0JqkLDSjvERT1hUUuX9h6Ivmpx8PfE
         hMMBWxtNtY7bmk66qSqjy3l3iuKoC20f+YaNBuyU92TDwYOZSoDAsKirNuG4qmP0HV9l
         wxliLm3mGI/GqJWVQlNFYTSbN9ioHf1TriI2V5xoikmX8xBuRbl89iiaSWKuTYCSoQtr
         qF37rm6L0ze/2vVYTfm28ojxANUxOChYjj3zNqTq2L/6tDzAkUvYFSNppFisi66LWbIP
         8caMOqzgdB215NE824edCpjotRid7uJLnmSXx0pj6lFzXcg0qPMlHSFjYlDx0C9tdH6+
         nUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oYzXs5EHHs4DSUbism0caWTdX5ujU1uhoAvIkNAJPwg=;
        b=nai1NgecxMXCMeONa9KS7XK3pjpD8RfiFYRSuXC/1TXPbYiPsL5Jv3qU3JdXuO2zSE
         2jJNFwx9ZDFE+84W3kxLY99Er4Wq0st449FjsF4mpOq2D8eXqOnDmknpIEvOtjRRtHzI
         wIH659M2fXIQrqCKw6P6NncPZqMkL0UHXBIO70TNOcYe/4FsIfDoeBrDfb9f6kUD05fW
         Tj411cETuwwtH89O9r2tjdj0dzxc+Gy3uKDJ3UcxrQSLSKF9Lp/Wj3lW+3SQ7JRdvdyI
         4laVr1X6uwBPfb3C/5tvs6ZcUGmTcj1rwGTeQvcJmhDSXlg2WnIOkgZHhqllrgTcFbyj
         rmEg==
X-Gm-Message-State: AOAM533dNTvx8i4p/2RdtEaV6dG85ngrPjBgGgbTCXGLb6vUu0U5f+wt
        r9aG2Am4lHqtFVQJTA/cyl6Me7l569etyf6r
X-Google-Smtp-Source: ABdhPJzsqTAAIfzfRS4t7eabtXOwLVxnbgW5uCRsferW+z6ern3tH4yZ7e3AzWWVXh02flDYIRjP5Q==
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr36259666pjj.205.1620766113796;
        Tue, 11 May 2021 13:48:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z17sm2811490pjr.31.2021.05.11.13.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 13:48:33 -0700 (PDT)
Message-ID: <609aeda1.1c69fb81.6c6f5.9213@mx.google.com>
Date:   Tue, 11 May 2021 13:48:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.2-384-gb0def16b48b3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 181 runs,
 2 regressions (v5.12.2-384-gb0def16b48b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 181 runs, 2 regressions (v5.12.2-384-gb0de=
f16b48b3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig           |=
 regressions
-----------------+-------+---------------+----------+---------------------+=
------------
beaglebone-black | arm   | lab-collabora | gcc-8    | omap2plus_defconfig |=
 1          =

imx8mp-evk       | arm64 | lab-nxp       | gcc-8    | defconfig           |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.2-384-gb0def16b48b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.2-384-gb0def16b48b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0def16b48b3688969cbf5fbc78bdb8460537779 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig           |=
 regressions
-----------------+-------+---------------+----------+---------------------+=
------------
beaglebone-black | arm   | lab-collabora | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/609acb4c0684bf48c8d08f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-384-gb0def16b48b3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-384-gb0def16b48b3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609acb4c0684bf48c8d08=
f1d
        failing since 0 day (last pass: v5.12.2-284-g66353c8ef656, first fa=
il: v5.12.2-385-g47db4685df620) =

 =



platform         | arch  | lab           | compiler | defconfig           |=
 regressions
-----------------+-------+---------------+----------+---------------------+=
------------
imx8mp-evk       | arm64 | lab-nxp       | gcc-8    | defconfig           |=
 1          =


  Details:     https://kernelci.org/test/plan/id/609abc01aa06e8d724d08f3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-384-gb0def16b48b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-384-gb0def16b48b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609abc01aa06e8d724d08=
f3b
        new failure (last pass: v5.12.2-385-g47db4685df620) =

 =20
