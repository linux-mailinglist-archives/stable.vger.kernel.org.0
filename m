Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F480382015
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 18:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhEPQyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 12:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhEPQyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 12:54:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABACC061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 09:53:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p6so1878055plr.11
        for <stable@vger.kernel.org>; Sun, 16 May 2021 09:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=um/AbS8o+8lnd9glu3bo4sFgE/KwREwFyZ8wcPenoec=;
        b=p98yZl+gJxFgymgtcFJ7IixVshX23nfRaNJL2fI+5sxOIHA5BUVTxoCqtNlNRkYCqj
         3IsvECWxd5uq4hDWLSG9GwzyrVV8Db4pZBiSJGTafbPdGw0tWBvvNN3hirvvBXeP+AEY
         DCxzpKCDUzpSSGFy+r2mxUXWkCFbn1Kimp0Iy3SBQK+b+38AagoS8A99olDH9t62lrPq
         Y2kB0tvqGJKmdNC4ZhWs48fp3kTjfcX8YhmQ7tZydFPyh2/yuw5yyA5FkUa4qW/K8+c+
         qFYiW1L2ezhrbRAS3rMr2MieWxPks1bTcbwB0HyoBQN33jgLzOre6D1jw81SMVQcUbGt
         Zvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=um/AbS8o+8lnd9glu3bo4sFgE/KwREwFyZ8wcPenoec=;
        b=AXW3pq/Cpko+7pslRYFXrXjtzgiI3uNHupEOO6oeWfpGNrTGi0nPQqrz/dQTUt52N7
         6YOB2kXAN/iKbU/OoSy5TTWqRSjWaVRV3Qr/Tq+ag6Rs0FH4+u28VzzINYj5cRV8rj0Z
         vz05bcAkqOX7STx7ACvOMhFLItYD/AhSbmbGfddQUxa5RKn4nahbpvSrixUjWc6ZgchG
         0JsMTdC3ghtJRtIVRKtTwPlDnrVMJeBe6jUz9xbJYg4/BPBvrC/gBqUGdTNNa1tAVsAF
         F8gi7qxzI6ZnSedEl30wqG7Vf4dhyndw0BgbqPB5vSTNqfMo2U35EtBCHb1KrDblpoIt
         KCTA==
X-Gm-Message-State: AOAM5319UsbmVCyGnHMPknY4rIOPVLeoHs+tV7AiithX5lmfsGM9Mj28
        d8xy6jDVumk3R1qvwETJiFNmw+ui75DsfB32
X-Google-Smtp-Source: ABdhPJxpLLoNHWhBCWss3yTfvOGBCtLWLWJ6aZN9YOsfv9M9qpo8R6z0Qz0blEYdRYjMT8p7nzbhOw==
X-Received: by 2002:a17:90a:4298:: with SMTP id p24mr22124830pjg.144.1621184001778;
        Sun, 16 May 2021 09:53:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm8038631pfr.213.2021.05.16.09.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 09:53:21 -0700 (PDT)
Message-ID: <60a14e01.1c69fb81.ff5a5.b502@mx.google.com>
Date:   Sun, 16 May 2021 09:53:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-273-gd5d304081053
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 134 runs,
 1 regressions (v5.12.4-273-gd5d304081053)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 134 runs, 1 regressions (v5.12.4-273-gd5d304=
081053)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-273-gd5d304081053/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-273-gd5d304081053
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5d304081053df34a6788ac140493ad160809077 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a11a8df11cce3794b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-2=
73-gd5d304081053/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-2=
73-gd5d304081053/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a11a8df11cce3794b3a=
f98
        new failure (last pass: v5.12.4-247-g1c297c9df9fb) =

 =20
