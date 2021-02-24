Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29D7324181
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 17:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhBXP7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 10:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbhBXPaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 10:30:46 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45D4C061574
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 07:30:03 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id f8so1394346plg.5
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 07:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rl0QdY/UVEim9so7pPs/fGcKH/l4UHUXa2EpamEeXw8=;
        b=1XS6dO8XJWTuDk3RQJtz8Ff6bPXzrvEqMb7m80+1Bz+w/IHhwC79fpmrH+V7IAfrlk
         NXgyeU9v0tW7cJavnF1SG9YvVo1EU8om8CNAHCq5QR0z9pRTgynWYWu1TXrTX+QD35Zz
         erWIQn4bXwPQAeFluwz8Fl5qInjrJFx5fDHnq1fOGxsEl9RsSiD9W7Jg9er172FLyx++
         3aX6WqARCGTfdqHpfsWN08ee/+ZdHDfGGeMTZMQyEhJ10YjewBrR7FazTG2/RAYZv2X3
         NAcy7nN2UwYMu70InG7BHoLIt8FVYzQ8NGYRPGD6vHfTnrbBQjfAIbALX1JBSXR1L9xR
         oVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rl0QdY/UVEim9so7pPs/fGcKH/l4UHUXa2EpamEeXw8=;
        b=h0VSM2w+mWvRUnllS9Mbd3ygj9FJdaQsOwBKAJKdbik8YsPSm1dmOtmsZjjzmbgsjk
         vdNz3zCjJfWe1hEpLRkO7wEfCgMFHtbLy/SwhxRutX/wSbPY2fVDk/nPkb68gcMBo0jb
         HCEKM+woDUPoFI1ratSrPCAEQoFI4cwVTtmTikEC/rgyApr1+FijWaS4xtW8LPZ0rOEl
         jwXvYdVzoBU8LnBFzkc/m0W5UsR86EUIfAjjac/Sffg8kap6BBhy/e2geq11J8Qm+S3C
         QYvrH7xARFezpTeM8B3kRuy3e4/xmTW8/W/i9w7M8yuomyutC/j1P3bnC9c7H0Gr67uv
         766g==
X-Gm-Message-State: AOAM531Dq1irTxm06RLN+e4avZfrAKxTa/xk3OKTWyngVYuYD8BZZgQo
        y4mrUyRXEqgDJhLbXtwE/kv8rG5Sdh/bww==
X-Google-Smtp-Source: ABdhPJwZd9LPfX1/96dRxztxoaPlMk+xNATMPa8pV8B1FkLKG0MjI4oDUyRc1gqVaAMARCiuRhdxnA==
X-Received: by 2002:a17:90a:4306:: with SMTP id q6mr4969188pjg.138.1614180603012;
        Wed, 24 Feb 2021 07:30:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm3006646pfv.164.2021.02.24.07.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 07:30:02 -0800 (PST)
Message-ID: <603670fa.1c69fb81.6451c.61d8@mx.google.com>
Date:   Wed, 24 Feb 2021 07:30:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.18-6-g7931b7eb2357
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 115 runs,
 1 regressions (v5.10.18-6-g7931b7eb2357)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 115 runs, 1 regressions (v5.10.18-6-g7931b7e=
b2357)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.18-6-g7931b7eb2357/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.18-6-g7931b7eb2357
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7931b7eb23577235bd95925606a5d3722858d558 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60363cbc0219ddd658addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.18-=
6-g7931b7eb2357/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.18-=
6-g7931b7eb2357/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60363cbc0219ddd658add=
cc0
        failing since 1 day (last pass: v5.10.17-29-g1b13e2554bc40, first f=
ail: v5.10.17-29-g17962b3a67b5) =

 =20
