Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE23C42D498
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 10:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJNIQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 04:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhJNIQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 04:16:33 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA3BC061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 01:14:29 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a73so4847038pge.0
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 01:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XWXQd9a0LV9GK9GqZz/uk3B2OOB5PGvDObddXdOXYkM=;
        b=hlZc3sgsCWKATQTmzOmRTjXZU8pjJlMbUS+sLAb4+wtHDOfP4GXIpXKWdECGhS1XT/
         d0BECcwVCIYmVTJlARyGerFZWIov+ovsMCNs2xWat/vCVrwQzyhDztf8sW9HAq3+702d
         WK7y+G7ENCduNYiTOFkFpadqJhXRK9qMN0L2qfvw5froQ/QbVFVE6TYakjB6PHVAp67J
         dIXXH9PhDTFucNyIoUjrs2ntpfhAdShZzHk4+a7cvBF7+wXMAM9wUUycTg4gP2Ify1bP
         2SVH4BzNLKE6/uuv5fE1iBxq5RQ0oaCtINxEIMwglqm0CkVSmLlqXXLc6dPF+a+Tgw1L
         kk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XWXQd9a0LV9GK9GqZz/uk3B2OOB5PGvDObddXdOXYkM=;
        b=72OtJWgTKLeD3GVLV0hI9DyeOjn193yj8vcfozZ6Q9Bu6pkuemjt44ux41xxOt7X4r
         tVD1M/pHPSwAQr4w70I7S3U+vuK9wrSpMWErGmT4wTHQlY/jKN1ilKRknW+5mJjB1Uq3
         oOOlJkDMVR6qNvvvlgHwe6td3oxE3KS3u88nk1yQr2EARkg+oLmXf9QKYcd9kdn4uMFM
         cmI04P0O1IOK6++mh4LfHeqe2/tGixQvYR0efsZFrLr4O5AeggJPCQp4bT5bcJkWD+AE
         sDJnuD4LUJbeJ0Y4q6htcL1/2wPoChpfLXu2UYhXOJL1ID3G82d3Q2qSsID9Fga68m9w
         NVLw==
X-Gm-Message-State: AOAM5316m+QH/MJLbH8HIeyeak83UPPkjTJeH7OMRH/UFzpOaBAAkYSA
        WXGKWjoqaYAPkTTl4dRZSzK2ckKDnz4bniTOqhg=
X-Google-Smtp-Source: ABdhPJxa7xYXQdMhIsBG6RY652ZTDbpArj4UHBdMa33hBBxKDJUvNimMeDvqnYAPqG2iCYi+VAGZPw==
X-Received: by 2002:a63:f313:: with SMTP id l19mr3226501pgh.40.1634199268371;
        Thu, 14 Oct 2021 01:14:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17sm1683538pfu.22.2021.10.14.01.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 01:14:28 -0700 (PDT)
Message-ID: <6167e6e4.1c69fb81.7682.59e2@mx.google.com>
Date:   Thu, 14 Oct 2021 01:14:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.73-23-gaec8cedeb05f
Subject: stable-rc/linux-5.10.y baseline: 118 runs,
 2 regressions (v5.10.73-23-gaec8cedeb05f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 118 runs, 2 regressions (v5.10.73-23-gaec8=
cedeb05f)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig        =
  | regressions
------------------------+-------+------------+----------+------------------=
--+------------
imx7d-sdb               | arm   | lab-nxp    | gcc-8    | multi_v7_defconfi=
g | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig        =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.73-23-gaec8cedeb05f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.73-23-gaec8cedeb05f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aec8cedeb05fb1fc0b8888b71a8191b879df6007 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig        =
  | regressions
------------------------+-------+------------+----------+------------------=
--+------------
imx7d-sdb               | arm   | lab-nxp    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6167adfe16aecff80508fac6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-23-gaec8cedeb05f/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-23-gaec8cedeb05f/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167adfe16aecff80508f=
ac7
        failing since 2 days (last pass: v5.10.72, first fail: v5.10.72-83-=
g0d59553e5bda) =

 =



platform                | arch  | lab        | compiler | defconfig        =
  | regressions
------------------------+-------+------------+----------+------------------=
--+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6167ac683ab1e632d508fab3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-23-gaec8cedeb05f/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-23-gaec8cedeb05f/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167ac683ab1e632d508f=
ab4
        failing since 5 days (last pass: v5.10.71, first fail: v5.10.71-30-=
g1164874f979f) =

 =20
