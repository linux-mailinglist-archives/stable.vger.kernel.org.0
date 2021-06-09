Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C9B3A0996
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 03:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhFIBro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 21:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhFIBrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 21:47:43 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EFAC061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 18:45:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id md2-20020a17090b23c2b029016de4440381so433394pjb.1
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 18:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yp5yDvooF/LiluCLDY71f5K3xkEdcCKW6kksrwbkMtU=;
        b=0RI1ZS3gmTGN/TmM8cWzZTSBZwLO8abaXFTVa5UmgcEg27vQe5d0Dke8+iw0DUNJdl
         wCHcOV093NzI1zd6flikxwSaZycyhb9MQRvwwxUhbPUlmUVno+bY/j3FjAItUKOk4nli
         qQ2khtmi9BRcmMgW76PwnL0OXrqfGycCnaoqGhWy9LVDyQdRA3KYPEuWwAm8cGsmWksN
         gG/3V6vvmR5pu2bR2CMOhpPO4HOaWSdJ2fxWQJ8Ew4F7GYfctDsgahYY1yrmsM0KXSgW
         Co/3cu/2nDh3+gD6aIFqD7NWfe7+mV9HI7p2xh2zTJRPOpEvxfJyJLjvac3i3q/huNQQ
         TfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yp5yDvooF/LiluCLDY71f5K3xkEdcCKW6kksrwbkMtU=;
        b=pj2yr2jDN6w5xjxFx1H0lS5Tm5PA2KMm5Y2LLT8L7Lpp+HeHAG3247sUEB14wCgVTm
         OiGWbSnHV1uyhhKbOWgb/mmvRGJ4RozPrwhNWegHrrZF5FEpVhbsNmIYDddMtqCY2TTt
         h0wexKr6Ilx3NK+wYboDAB+7VQ4jUTIdhA5QlSY0uXKNxINhQbBgZAfZlDoCogDWSdpf
         +yzSJymS30uGe8Z4Oh9cXsAmqQcLABad5u4xcnoIFzLPYPYS9VHu3AiaSQ5rgVKwWBrM
         j9EaKYV5TRewm/Ykndk3QcYS+Vu79TaFITGTIwQNX9YpvcSS5r0Z5MRFL7/CPKeNSmj7
         SZLQ==
X-Gm-Message-State: AOAM530SSSJrwwBQarPqt1Rz1CLFwspuVGxs2tqsts9xK4zScgv90xIj
        8jszXphwCsXK3G+ivH8Y2zN8iIpT/DopEMjl
X-Google-Smtp-Source: ABdhPJw1NpRZnh0S+YoIYF302j95bKKzur5GjEUVgUj2grktQ16qADQBDazVHn8eEbXBVditpVchDQ==
X-Received: by 2002:a17:902:145:b029:10d:c0d5:d6ac with SMTP id 63-20020a1709020145b029010dc0d5d6acmr2649646plb.9.1623203136530;
        Tue, 08 Jun 2021 18:45:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r92sm3566592pja.6.2021.06.08.18.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 18:45:36 -0700 (PDT)
Message-ID: <60c01d40.1c69fb81.4bc25.c037@mx.google.com>
Date:   Tue, 08 Jun 2021 18:45:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.9-162-g5a0a66f4d817
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 158 runs,
 1 regressions (v5.12.9-162-g5a0a66f4d817)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 158 runs, 1 regressions (v5.12.9-162-g5a0a=
66f4d817)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.9-162-g5a0a66f4d817/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.9-162-g5a0a66f4d817
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a0a66f4d8172bcb8ac3bf155bc524dc467c0071 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfeaf9c37c5728030c0e08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.9=
-162-g5a0a66f4d817/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.9=
-162-g5a0a66f4d817/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfeaf9c37c5728030c0=
e09
        failing since 12 days (last pass: v5.12.7, first fail: v5.12.7-8-g6=
fc814b4a8b3) =

 =20
