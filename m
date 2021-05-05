Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C21374B84
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 00:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEEWsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 18:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhEEWsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 18:48:20 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE717C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 15:47:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so2082196pjv.1
        for <stable@vger.kernel.org>; Wed, 05 May 2021 15:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=etTYWrNAKvZkc/RSGQB3w8ZCHVjjekSxAELurbWXsGw=;
        b=D/ernfMqFyCMep6uOG4DCXYwWNF3Ropj7f/aVJgwdEF9LQ8ohy54mIMnwxU8pb0N2Y
         cddmhRtSz2N5mz/dhWu0Z2TnQQicNcDUPnDiXJ5hpRLMpv+hzXTjKDXWaMxQz6x3XcBl
         FK87QomPfgkrjnyxDMOtL46LBLfdPTkyLYlQCdTWawdwvBYaz0nEW1bdaWZ0OmHpqNCr
         W7EarKAd5cxYLYByYlERGyxdpnw/PIsKI6Kh3/xXOwBL6tvbLM/h+AB+kOjHItNi52ec
         Mnyuqddxq9sLXRm5xzjYVEcrOEv0OhCWZT5n5GpOnggLmg4GirRyegGa+4jj/gtKS+yO
         P1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=etTYWrNAKvZkc/RSGQB3w8ZCHVjjekSxAELurbWXsGw=;
        b=fLYK2ZSE9uDWIoZR/D2GLSMSqdEV+iBMro5wLAY1nGR3/QkOcn2nLxTnsTlfba87Mf
         fDKSEJvoFY+O9CF/tSzRO5O16QN9Sx2IfygSDb91IXNFVcv/ADjsarD9SrJyqZXbMMc2
         jXIEvOY9wPWjP2JK67aNEONM2lm/MrQN2hScFRYu5WaPFjYfp7yKNjUzvTQqL4gav9lP
         td2Jt2K8yLVj+chVjmsBksrwbd8ZNGVgmiJiwrNGayG0To5XNF9ukcHscUZXzi6FY3DO
         CITVG0yrJ5cJ04X2BqsBi8oDSjXZndbqEts5Ui2GgxafPa41r92GcTne1GL3PxCNSG2V
         Qd0w==
X-Gm-Message-State: AOAM531szdJL6oZusOA4xbUD6+iXbpquR4tgMnegXgI/vOYTAywS6u/K
        xyprKFG+fYx2A7s2lzJQF2YVT9OuZlT1tLMi
X-Google-Smtp-Source: ABdhPJyJ8Mou/TdnBEKgIVjVRsFVKJcd7pJjQzNE8JUnK/SF4n0ZWAFKG6W2R02R/464CP0lRMx2jQ==
X-Received: by 2002:a17:90a:f40f:: with SMTP id ch15mr937351pjb.113.1620254843237;
        Wed, 05 May 2021 15:47:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm8087607pji.34.2021.05.05.15.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 15:47:22 -0700 (PDT)
Message-ID: <6093207a.1c69fb81.45199.32c8@mx.google.com>
Date:   Wed, 05 May 2021 15:47:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.1-17-g97d3e23be21d6
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 84 runs,
 1 regressions (v5.12.1-17-g97d3e23be21d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 84 runs, 1 regressions (v5.12.1-17-g97d3e23b=
e21d6)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.1-17-g97d3e23be21d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.1-17-g97d3e23be21d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97d3e23be21d66e4d0f8fcb0cace05759045d057 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6092f1df7ce0afe8f66f546b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.1-1=
7-g97d3e23be21d6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.1-1=
7-g97d3e23be21d6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092f1df7ce0afe8f66f5=
46c
        failing since 1 day (last pass: v5.12.1-6-gcc8057a398c24, first fai=
l: v5.12.1-7-g47de21d5d220e) =

 =20
