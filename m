Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABAF4953C6
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 18:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiATR7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 12:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiATR7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 12:59:21 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE25C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 09:59:21 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so2236513pjt.5
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g+syfSnVuf1E55RCi/VOHcW1TcdwART9VZqSUAFtVac=;
        b=7d7o5P15YGgW+gyS4rGq23OU5hh8NYbUf2N+FsP1FT7IiQMEUQr9OCZejfPAQKKsEi
         OyuJrwmn82ZP6jjKjWJxhBgXHTYusVF9SWnZ6yYAFUUyeVNr379ekk2WxOLpY8UToLj5
         lT4Aoef34zVbKzb4i9ghNl+pmU9D37lxIrk77lzoOWk7+PQsNR6KYNeWb/cLUJt2h5Ms
         NNTf/b6IaQfqalWvYcx6RMakn4la7n8Bl7jpCnj2PIumk7o8g+6sliTHM0CJu+xT7+xV
         xFTfiX9ridK4H1nZSzF53m993LedbrtyHF7myFtl7An11kyWar9sMbNLj2P7+uNJxyW2
         EIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g+syfSnVuf1E55RCi/VOHcW1TcdwART9VZqSUAFtVac=;
        b=hLvJV+D1xmWw4J9SPLiMj+7dgym46FTlC8F64mE24L0p3IjljTLxjEK9hTVjSkJ2PU
         XUimqOKy1LSIhYz5WcvxHqsYPbtZ+k9HExseKisztCVD3pZqU/LGMuU7tGxRbl39wFcv
         p/AGTOVfG29mFA0g3vv/gjnJRxVHsLOA9iw6RajznroTg+5DGvrNYBU0ZhMwrK55/V2h
         99oy/qCoHt7q9A2OKM9B4TqjFwjMC0Uty9N2Kp2uGQTpbKj2HjDPU90kJyb8NHD4V+4H
         Cevy8RR3w3w0pu0teViVDPvlMtTh/UBZBNR+N33Ni4oxxG+E2q2o6S81kLCYhx1yiOCY
         obOQ==
X-Gm-Message-State: AOAM532uKlu28Fdf34Ovm3Dz8gM7AmcdsIV8AWMu1MJ6Yz9YJGauu7vV
        1XvvkCOZa36dZ+QhJfSceyPodPEoJ/VxrVt/
X-Google-Smtp-Source: ABdhPJzK26FrvnO3IAPFUVd+grVRFBYayv4dfPW3ZC0kMlYQ39M6BnmlCwBdwG/IPclhwtzW4BmuLA==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr109320pjb.153.1642701561083;
        Thu, 20 Jan 2022 09:59:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m38sm2859224pgl.64.2022.01.20.09.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:59:20 -0800 (PST)
Message-ID: <61e9a2f8.1c69fb81.2a40e.855d@mx.google.com>
Date:   Thu, 20 Jan 2022 09:59:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.93
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 199 runs, 1 regressions (v5.10.93)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 199 runs, 1 regressions (v5.10.93)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd187a4925578f8743d4f266c821c7544d3cddae =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e973190bf518a212abbd50

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e973190bf518a212abb=
d51
        new failure (last pass: v5.10.91-50-ge0476c04ea89) =

 =20
