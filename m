Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BA642E581
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhJOA4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 20:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhJOA4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 20:56:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F38DC061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 17:54:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t11so5317531plq.11
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 17:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h5QokH1yq2PL1hvbX8V+xWR6o5nxD2zm4rQkf+els/8=;
        b=FHcMscIq3BSqD7yoIt6wjRyxyoMQZfV/kjaWIawhTwEPkplB5phK1mDaM2KHujtaNz
         eyLjPsIQ94poHEVFPBtF1xyOyPyQm/LrFWn01qpB8KiVmAq10552FblQnVy4bq+E2lGo
         jOkmH3PrppY99LutbjquqycikGifLU1zfhjNxejlermgoNmYXo/ikdErlYYMkxjTBO0l
         Dbpo0iZk0RK/MUADmL/c8PCo0NEyTc0gl+zBK+l6E5XkmbT7+nNPRjNEpKCpjGFppJyJ
         voZHOIY/Y5fL6fGSMwWR98i/r0jjWszbv+6l5f2PvPaa4YjgJefo5pNlx4uRFRZ86tg6
         gIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h5QokH1yq2PL1hvbX8V+xWR6o5nxD2zm4rQkf+els/8=;
        b=zllua0n5BUl6mFeFhIMy9d7AU2Me5eDVBkpGYJ9qxmizlxAKEPycLd9ElAxE2e9E0Q
         FIgsojetc1q3XgKX1+CSwjYUIemqgL+pG2HKw2zhjDefaoxJ2mrmVA9Vjo6iQ+kWJ6G+
         Hn2Sz+PUqwY/Gd3A1w/rdd0Y7XkrY0iljjzt/5Cj92rtBHssFHq7RX031IiQ0XAFXTUH
         PfNheNBDZIYwtVd3TK1N1J/FqURspFywGExYzdPUPA9eskNKxH3GlTbflmojXbpPtM9T
         cBI5UUmkZjlxAkKqJxUsTod2dePy3u/tFoFg4hoVbKNQ50d8FmAu0ddnNX79KOrXYRdH
         yvuA==
X-Gm-Message-State: AOAM5336ZWEdGGcBfWlu1xshRkc4QTokmn9mnKBMWxnFClXP0WJ1Fo6f
        7dNGZeta3l0V8ni/f0b7aKrKfVQ8wGg4Gv3qrsE=
X-Google-Smtp-Source: ABdhPJxozoFgkKxPDphCFkNaOXb+tpPGchrG20nQOdQgYQe/ViViT4c35FCC6G8LMeupDoNiE7fnAQ==
X-Received: by 2002:a17:90b:1c06:: with SMTP id oc6mr2080465pjb.142.1634259250387;
        Thu, 14 Oct 2021 17:54:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oc8sm3716814pjb.15.2021.10.14.17.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 17:54:10 -0700 (PDT)
Message-ID: <6168d132.1c69fb81.6a6eb.bd53@mx.google.com>
Date:   Thu, 14 Oct 2021 17:54:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.73-23-gbcc91adcbbcd
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 87 runs,
 1 regressions (v5.10.73-23-gbcc91adcbbcd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 87 runs, 1 regressions (v5.10.73-23-gbcc91=
adcbbcd)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.73-23-gbcc91adcbbcd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.73-23-gbcc91adcbbcd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcc91adcbbcd65b4413d295cb433daa73ffa3700 =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61689a70605ffc5fab3358ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-23-gbcc91adcbbcd/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-23-gbcc91adcbbcd/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61689a70605ffc5fab335=
900
        failing since 2 days (last pass: v5.10.72, first fail: v5.10.72-83-=
g0d59553e5bda) =

 =20
