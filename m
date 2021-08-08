Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC803E3AE9
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 16:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhHHOua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 10:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhHHOua (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 10:50:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3A4C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 07:50:11 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so21534633pjn.4
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 07:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vNGH7On5KW+2HDT90IqzZbjfVIBbpgBy0AQpWmUHYuE=;
        b=RJQY449Cv26PKsk6RdI4z2LSAZJlfmhe3CtTAB4DMtziAcjq7HlkIofduE8WBvU4ke
         XrQwT8GiBaeNMJ1JvlygmcQbXij+oUyBYUDYx//mszx9Ucq+Q53T9YqdEVVI+j/KFivD
         5p1DvsmrB5Tnli8gp0mVBkkOWVUNneslxBsKr+NvhAM+tkyEG+yYtIO7txtF1wHhFtgJ
         87/CtEIDaoPuRe0OfnT3hWiB10G6UlO4YqPOchX7L/0dNWsSNVgAu2NgNg+5CsoE8A08
         PzwkpwB5s1w7YycFsMHf9fvPCOth3UGbgPETqBPl9UvvQUz/Pdt0uW2fIjDpT6SRDTUq
         WJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vNGH7On5KW+2HDT90IqzZbjfVIBbpgBy0AQpWmUHYuE=;
        b=k4lStkbRbNcEW9cRWFIqZBChbWCIt5Pql0vlO7e90poeQlg4C57uCP1D3ww92zXf3l
         TOsX/mki261M+XIDilzmYYXlN8MbfkxnRw5h0t+O618JOHdctOJ+i+wK6U+J/Sz4+Lkc
         E0wkg9F3BTqj2OhShsANVFj4gSNi6iENXsfLWWVOxh4ErkUvuwmkh9RTUcXIwxzqLmcE
         K3o/g+RD2EDMnh8y+L/y76fWLTdZw8QQ13/VUk8MOWBq/bsmTxJ+eJVwlAlINczX1nDs
         MhUhnJWPbwnO3MYvGIwSWkPcwA3WfHDvvp4f0nfMe9ZSi0OfcMiawVNBWtvFqdVZWVGT
         1xgg==
X-Gm-Message-State: AOAM532wJ7zkwoW/dib/kTPyOZjpXKp9gknXC0396pB22WwCFwMVycyI
        PLfFiHve5Bip4JL/cNabekLCVxpTgTDMWdtl
X-Google-Smtp-Source: ABdhPJxeQrlKPpnSThS/txOFRAk3Ioife0DR/UjrpprD0um5FLCf27IuMrbOraXbyc//trynjc9cog==
X-Received: by 2002:a63:5509:: with SMTP id j9mr39633pgb.329.1628434210904;
        Sun, 08 Aug 2021 07:50:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm16759211pfi.199.2021.08.08.07.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 07:50:10 -0700 (PDT)
Message-ID: <610fef22.1c69fb81.fbe4d.1169@mx.google.com>
Date:   Sun, 08 Aug 2021 07:50:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-35-g164564160b7b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 122 runs,
 2 regressions (v5.13.8-35-g164564160b7b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 122 runs, 2 regressions (v5.13.8-35-g1645641=
60b7b)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-35-g164564160b7b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-35-g164564160b7b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      164564160b7b5e0536c127aaf13368e839c6575c =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/610fb74fc93c6ff862b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g164564160b7b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g164564160b7b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fb74fc93c6ff862b13=
662
        failing since 1 day (last pass: v5.13.8-33-gd8a5aa498511, first fai=
l: v5.13.8-35-ge21c26fae3e0) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/610fb70974e1311ba9b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g164564160b7b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g164564160b7b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fb70974e1311ba9b13=
66f
        new failure (last pass: v5.13.8-35-g0d55d58934f9) =

 =20
