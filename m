Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE11E39C598
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 05:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFED6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 23:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFED6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 23:58:10 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F93C061766
        for <stable@vger.kernel.org>; Fri,  4 Jun 2021 20:56:08 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r1so9373949pgk.8
        for <stable@vger.kernel.org>; Fri, 04 Jun 2021 20:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9qOC68Mq/YvafLLaxJsqykBw/hc0g8T3tj1M7K8SNu8=;
        b=GlsFA+WLCc5zo/QMdO6DbdB1BuNU66RZHtvcjSVvXVFvgf2Pvlo7TDJA/aTXMOODDM
         i7whRFxWB+z4cy7TnifQviM2+wnBRSJOC4ax4WHwK2Z03CDqUCPhWb78OhFvQoz48zuX
         KmL4i6YQeh6AD6/t+j2HSeWuLgXQwAOZ/p7rrTSgrHlvAmCPOY9Lcque02Y1JgtIL5PH
         ad5nEblgceGKniyznh4b9pq77GZhWKaNNUR1LmoXIbJPrL3BqV9DWYgbZ2KTh5L06LF+
         qglz/StTLG4Yrc0zVIKuuWn7qLq1KbOBb+npmLADSgVWH/ipprDc/4mv5ppcB5z0ezSy
         3ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9qOC68Mq/YvafLLaxJsqykBw/hc0g8T3tj1M7K8SNu8=;
        b=p7/5zKlZt23CGuCXo8gujptWNvHggWgRjl2FXg0TzoIml0kSEjCGpgmR5yrfr2uMb6
         llIsjNH2QCESuvLmrr3TP4sBkC+KNXTtTngxks06RhaPp/PEVq95UT1HPxdA4wbd2fzi
         pF3lLVg/gC3oDhMhKgckWEgesI8F/NoHIaNvasvp7Fqtbj39EXJMSJfOjHzndobM61jg
         RNqIWxsMbuPP/SqUbMp/igfrkDvlTYWdxBv848aFF2l1lUAfeKj/yjZV9Ft3ZpgMQ9g7
         BJ5Yz0NjCGgM7KGHaKa3cEGgfOT/jUMPu/Cfjdl/rGl7JP6b9z8G0AwMjhVB85N0lH+j
         ybfA==
X-Gm-Message-State: AOAM533iipO4qksLj50Bvk3cMAlghfK83bxOqnq+6l64v0bjmG3S2HLh
        B7Jkzs1C/plm6hTxOOlppxxJiCbVH71nSMiR
X-Google-Smtp-Source: ABdhPJxNC8a4+atx3QGo0BQ/CCgqjGTv4L/6j7GBq0p/RPZjsgxsAkvx/bkq2ntz5QRpMDlVZ/9JcQ==
X-Received: by 2002:a63:a1c:: with SMTP id 28mr8094517pgk.440.1622865367087;
        Fri, 04 Jun 2021 20:56:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm2971028pfk.145.2021.06.04.20.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 20:56:06 -0700 (PDT)
Message-ID: <60baf5d6.1c69fb81.5f9d0.a94d@mx.google.com>
Date:   Fri, 04 Jun 2021 20:56:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-2-gc17d124ec70b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 197 runs,
 1 regressions (v5.10.42-2-gc17d124ec70b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 197 runs, 1 regressions (v5.10.42-2-gc17d124=
ec70b)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-2-gc17d124ec70b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-2-gc17d124ec70b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c17d124ec70b853c6025a0704b3ba46f3a9148a6 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bac2433f0a3b96f00c0e01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
2-gc17d124ec70b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
2-gc17d124ec70b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bac2433f0a3b96f00c0=
e02
        failing since 1 day (last pass: v5.10.40-261-g8e56f01eb8e7, first f=
ail: v5.10.41-251-g1360515527f5) =

 =20
