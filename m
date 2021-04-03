Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BE435348A
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhDCP0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbhDCP0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 11:26:52 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91B9C0613E6
        for <stable@vger.kernel.org>; Sat,  3 Apr 2021 08:26:49 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h25so5368100pgm.3
        for <stable@vger.kernel.org>; Sat, 03 Apr 2021 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/m9qiD6FtsTeCMHLwQlLNx5fUnumTvgG0b49k4RWRmY=;
        b=Bv4uy/6+9zU0VhI8HC0NflUeVBGJVU9kfm5A+yG/wVUvYUgoiwlc7Qp2T0br1qdVBD
         pugPHx3MestcQLi4hwjcK4KWHBbpaQrpUjMpRN0R8KtjrkS4MEhM9tapzEsBedBVdOt6
         A7Gn4ux+VdxcoKBlqk6TOYsSJNzAs2xwzur3i6+elflu+MlN4LEu9uddlehRxHap+2Sk
         CICC5Uf5FhH1fYdGoNSUs/eETWEJCJ6z+APp20U2zcfJFKf9ev5i0Qduf2MGicxJU3dL
         xFnCsh2mRFRsYnq5As//dq1JMMgaY6K3XaTJElDEehiZ4cr+PGK/CS0HBIj+wfkLcbwy
         F/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/m9qiD6FtsTeCMHLwQlLNx5fUnumTvgG0b49k4RWRmY=;
        b=iGi+3+7uBKadfRrVp4b4r0/JJo41b8YJpZlaidq0hjSHz/HSTKpObkK7fAswgJVPZ0
         nFXxtOLsYqfIPCa8cTxuxtbXBVCGFXjgGsIJl90crlFU/VXG1ugA9ZCo5l+3lCNcxxl2
         towygonTKSyofBZGGRioNAFbsDiIz/3gb3Lc8IhFvSq0nZGrsJJSXN7uJYwFSTXftdpf
         jxZaoI6SgLjL+AwwGjdEf1oD7M1tiOooM5e/pbnIQBD980tRx5yAixd7T28bqycLB7xu
         ecNAHPOZ/KnTAGtnGHiXh8qrYg6gw/Us1e2naNiQlsGlW39fVS2fLY/cKjyuRK6EiGlp
         0tpw==
X-Gm-Message-State: AOAM530s3nQZFXa87XpG1WTP34sLhFZcKAUaNHKO3vMTP8Bsoiq4O+gq
        upY+B7bedFLmahSXB4gognyDFYy5gwDSNg==
X-Google-Smtp-Source: ABdhPJyUyIzQ/N1XrswCls3WnCqnOd6WelDjrSydnyky1dY5rXFMMFihfxloYs4UWN96XoUqdv8vHg==
X-Received: by 2002:a63:6f8a:: with SMTP id k132mr16676770pgc.59.1617463609060;
        Sat, 03 Apr 2021 08:26:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 76sm11083003pfw.156.2021.04.03.08.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 08:26:48 -0700 (PDT)
Message-ID: <60688938.1c69fb81.4f8f5.c13e@mx.google.com>
Date:   Sat, 03 Apr 2021 08:26:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-81-g55bd33bce71db
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 167 runs,
 1 regressions (v5.10.27-81-g55bd33bce71db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 167 runs, 1 regressions (v5.10.27-81-g55bd33=
bce71db)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-81-g55bd33bce71db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-81-g55bd33bce71db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55bd33bce71db14d0991b265465ce6d8eea7b888 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60685227142dcaa88cdac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
81-g55bd33bce71db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
81-g55bd33bce71db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60685227142dcaa88cdac=
6b3
        failing since 1 day (last pass: v5.10.27-36-g06b1e2d598020, first f=
ail: v5.10.27-53-gcd7f2c515425) =

 =20
