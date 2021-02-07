Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4203127CC
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBGWQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 17:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGWQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 17:16:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDF4C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 14:15:27 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e12so6802670pls.4
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 14:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ystoqZkTdQR+RzhMVxnrqAqeF06f8KNxVmWqH7mMw9Q=;
        b=rqsYJU4lqakG8ohx4QdKe++0dAt3j1ustCEKAHS6cjnX6pJcXCVEcCGjsK3YXEAerD
         zWoBgQWrfuu4+Oekaz3wNakLLHbd3qlK3W87VGP8CwhrYPWOozsGaXuUiuGeRyAPFMLq
         6bp0DDwtWNpEJwvw1KZGFtm0t5oOAca8ya9yNvaDlpLmZqRgjG0NdIWR5SIfmFJfD6Wi
         4d+XXXVj400zw8ye/1sgZy9oPjeEoRjqF/kEn0vcU0Mo0uYpyzyfiVDeLpe3kMCEeRou
         QHcmxAt9JnSQ7m3Sw+EAmYhO1ypGEqsFK1KH25RbonCYVS59XsJ4CpjJS5aCo4ke/m5f
         wfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ystoqZkTdQR+RzhMVxnrqAqeF06f8KNxVmWqH7mMw9Q=;
        b=d1e9sKTZQc2lu2BI77KZUvEArf8/pTiXzjXrwxjN1UJDOTDXrSt4bqouZT1zLQI/kZ
         Ay88kUcbzx0PnBAJoExSE7pVS2EVey9Ub611um48aScrxAfu9Cj2d8OIRO524LTVJHR7
         oT+TqZOo3hgvLUCBxEvzuUg15VHggGt3mSnCy0heGiz+6TXIqoSYVQvpXRfb/BH4tB4f
         jUtLPAsve1TJKCtBQZkXmBzp/ZpJsJEzSEiP1gba1VMbWYjsFws3fL4KNQrkly+bTHP+
         qsDP83pkLorsO2sSpwjPRBXtt4I/fqDqP3AigOKembW8qaP/VeOno8+hzS1ELglp2iLQ
         cm/Q==
X-Gm-Message-State: AOAM531toO6nAt5RfnA8+uBN2oF/KJdKRpQrLHXIhLG+Xs3pVztt5CBL
        Jcd4fgnMBjHa9yFhZ2MoE2jtSgNDGjXB3w==
X-Google-Smtp-Source: ABdhPJzend5/bu9hITWHriNCGuCoswt4U5DhLv3MuMGHbpz92uB2RTr5utnZ3euYlNEBbo1sLSTuMA==
X-Received: by 2002:a17:90a:f481:: with SMTP id bx1mr14410480pjb.35.1612736127266;
        Sun, 07 Feb 2021 14:15:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm4780678pfg.159.2021.02.07.14.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 14:15:26 -0800 (PST)
Message-ID: <6020667e.1c69fb81.8874d.a9e2@mx.google.com>
Date:   Sun, 07 Feb 2021 14:15:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 183 runs, 1 regressions (v5.10.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 183 runs, 1 regressions (v5.10.14)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b0c8835fc649454c33371f4617111cb5d60463e1 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020377bfb01cf39f43abe78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.14/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.14/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020377bfb01cf39f43ab=
e79
        new failure (last pass: v5.10.13) =

 =20
