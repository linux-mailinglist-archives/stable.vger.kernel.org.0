Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B89C40CFBC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 00:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOWs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 18:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhIOWsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 18:48:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672BDC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 15:47:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v19so3205011pjh.2
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 15:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/de6gnzRyO+X30ABMBN++JEnims43O4t8JpJmd+TMlM=;
        b=aooxVji8Fyelgl+45EVLsznRkHoskdAHQkZmtaKSj4FxLFJ8zdCKfUOaFDOa1brpAu
         nkfbC76KlyT6Os2gsv526szmrNEWuLX3xNXksO67Acaw6PMCe7QnC95dDhZEZwDYl7CS
         2dEO28JMCew8xMAAuJDm3w/tdp0elY0hbDgHtrwwCVXtFhJDbzk2yhp5gpsll4FYPPxX
         KP+KljAYpzZU9unAepY/besKFN1F0DBDiWxt9PflTe6H5Ymw9UXxybUZd4TvASZcMAwL
         zmER3aaX9plm5cAr1LPSF+Ze7nbe95DQMXAPEu/EvDIuccqASNCgyZrAOm33DyN+ZNDz
         MWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/de6gnzRyO+X30ABMBN++JEnims43O4t8JpJmd+TMlM=;
        b=V5IhMVgsmRNlgMjIhfGmGC4lhbWRA0gxuR/yPMcI+HG5uc3mFKNC0YX6kR8zS139md
         ElRN4AiEiGjDiDHEV2O62i9WN5acH2pDxFf0fwr+sROlYRY7+r1gmMqDyhprhTzdBQ8e
         EDk0gL0NCe2Q7ok1yrJWJKKJy0FjsXEIayCETb8RAj5GyaR6Cm4KeZamFTL9urbYhiqg
         rttjwjbkm+5OWe0WeQIRmTbLxWfCv2vVzTJb44297sNx+djZ6H/0RsEQMFEYn9VZTAcr
         ZiRkpV2q9RHc8oI8xB8MavxA+kpN89cu7/6ucxCZBC5V5eZXdBI+fQn9Hfcg9DLKW7Or
         /DWA==
X-Gm-Message-State: AOAM530F/EHrSffJ5pByBccMFCZ3IaC669v12ODth+cgmfzG8Y5cxn0n
        mog63/9qLEtWcIGhlmnl8yuD/uWKvso0AY72
X-Google-Smtp-Source: ABdhPJx2061sgYOsn3LnWhBDLbvrfXUxQuVunRWk6VIAHxarIXfN4O00a8z4EFeFTJ+OYnCS+VCZxQ==
X-Received: by 2002:a17:90a:1009:: with SMTP id b9mr2304605pja.184.1631746023598;
        Wed, 15 Sep 2021 15:47:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm786093pfu.4.2021.09.15.15.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 15:47:03 -0700 (PDT)
Message-ID: <614277e7.1c69fb81.b29d8.3cb8@mx.google.com>
Date:   Wed, 15 Sep 2021 15:47:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.65-54-gb135f9e6506c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 133 runs,
 2 regressions (v5.10.65-54-gb135f9e6506c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 133 runs, 2 regressions (v5.10.65-54-gb135f9=
e6506c)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.65-54-gb135f9e6506c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.65-54-gb135f9e6506c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b135f9e6506c86c4fbaf766d63bb7e74169dd7f7 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6142486536d3e9579c99a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.65-=
54-gb135f9e6506c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.65-=
54-gb135f9e6506c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142486536d3e9579c99a=
2ec
        failing since 76 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/614247203d0e7adffe99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.65-=
54-gb135f9e6506c/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.65-=
54-gb135f9e6506c/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614247203d0e7adffe99a=
2e1
        failing since 2 days (last pass: v5.10.63-26-gfb6b5e198aab, first f=
ail: v5.10.64-214-g93e17c2075d7) =

 =20
