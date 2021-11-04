Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910014456B0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhKDQDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbhKDQC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 12:02:59 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E874EC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 09:00:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k4so7945194plx.8
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 09:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b0VSTFBMlnf5zwoBM6ykSRQI+/3YM/nhrMnmupmmKUQ=;
        b=jHWh8FIngQihYr12RRnH2tScY6+JLQx5hvAo9uzV0onCVmKWyqXEMl7wsK14jD71ba
         QDvl8yvHc+5/li4154duy/MpqiK91E42UwQ18cl37ToljryHUbCbjUd/GPqCy2ycTqnm
         0n+fKDuNwPjnkkBMu+fEJWZEgIXi9qzHDIdfWM8mR3Bgm+Jx29xR1ZtMLg28qjtKIy5a
         pCsqyiP0pWXUmW8XWNdZPojvr2Q2H9hlZBIqSyXh5uj2myBT9FRfmpCTXnP12OX2/Uhw
         gQ0sFjMPg9lYHZ5XqUYNzM+aGDE/rDSF/jh10SeO6fpOuWCoxQFdEktVo90i0afr6A8D
         F9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b0VSTFBMlnf5zwoBM6ykSRQI+/3YM/nhrMnmupmmKUQ=;
        b=TD5qJmvLNa1Wqr98XV1XKXq3sJYZyeezujX5UtOTh7GM4ci8TMsFLT7js2aUOspe3p
         6xQ9MV2F0XGLmJ11qrwFjgRQrC7zNGn1DMrkSsoRyKVuhL0wmHNTADDiTSWQi4WEqWmd
         LYNsO8BrWcE0L28ZSVfiZJj8tiAKwoxEdpxIKuQZpscS2wCyvFNpjvte/9v4n6xmpESh
         2docq8KCZjaL+n+yS3xalGb57mmzTWZx0BhXaVb1Dd20qUzrNnulSSVpeGLfeOByRYU8
         m9tAikQX2Xe7wGj0PG2RaozmBLd4ppOM4uGvBmRVbVHmRM077yp4RKS0RGRat0zrYIFR
         /7lw==
X-Gm-Message-State: AOAM532t9E/pDjAmr1YdByjoXWxTcF5ur8DSFgliJU0gQJRRx8Wk3cvv
        1RlGB1Wwck9NU2UYMx2+zTW2ioXQWZgRDRP9
X-Google-Smtp-Source: ABdhPJxYV1E4MYJYPiQnU2smwVNCfvSQJenqo+CLCtAPqdTuxl/GS6oZoTgiOw5ogY8a8RMrVajzbw==
X-Received: by 2002:a17:90a:a101:: with SMTP id s1mr22516634pjp.48.1636041620795;
        Thu, 04 Nov 2021 09:00:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16sm5419489pfm.58.2021.11.04.09.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 09:00:19 -0700 (PDT)
Message-ID: <61840393.1c69fb81.de984.2190@mx.google.com>
Date:   Thu, 04 Nov 2021 09:00:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15-11-ga4272b976767
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 181 runs,
 1 regressions (v5.15-11-ga4272b976767)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 181 runs, 1 regressions (v5.15-11-ga4272b976=
767)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15-11-ga4272b976767/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15-11-ga4272b976767
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4272b976767749ba1d43befc90b846d1e533a46 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6183cf017af48556a13358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15-11-=
ga4272b976767/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15-11-=
ga4272b976767/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6183cf017af48556a1335=
8f1
        new failure (last pass: v5.15-2-g20f1a3c1df71) =

 =20
