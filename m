Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9618394B1D
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 10:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhE2Ifj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 04:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhE2Ifj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 04:35:39 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA534C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 01:34:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q25so5056668pfn.1
        for <stable@vger.kernel.org>; Sat, 29 May 2021 01:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=23Z2M5vCGBysK/zSrwTDHppsvHuSrjk6a2wXWlKOEHY=;
        b=mxGEFGVuXaAyBJrrAFTcHchTKPAsLVl8EG/fjH1hfZzwUr7mGd1HqjdsHB5kOOWJsI
         BOHwi9zvxGpbADveKN5zRNUIrECAw+3qf9Es4Wo8VYrI6mNOonOcpBIve6C/sYwZ+1yr
         jogFmi3A63A/mxwYKr4K1B1Vb/bQpxEWBK8KOgJ8ZnQ9nI85Is7b6SQ6Wzd4CCScHFEi
         u44TeCjF6xf6ml0mxI9blQ0/avJRU8fTw0NTyt++5TQSOXhBYqFY74V9YbmH4kxMQ7m+
         3kGdhdT4uxWpmjzl/iGSsDC6+ro2wSgKXW7X/n+wdptXYHJlAxXDGoG+pHLvmlUJ0oox
         V6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=23Z2M5vCGBysK/zSrwTDHppsvHuSrjk6a2wXWlKOEHY=;
        b=KOaoNmnsV/vEa8+ibTNLmYvFOmacXIwEF+7dx+z3kgjk5zJ7iNLHpQEQd/lS179eZb
         lDnyPBDgw0YLleRZCOHMwrEKpXl5dcBgPZmXhCbtGTLU2nSXVlIrXResqzumW9IULSRN
         DIBBg5YtRyUW6DdU14OjiQ8d21bUQgfK4VJAwreLZ6eetdozR3ZRypEAFRs7reDwasOy
         CgNlyG1jOrYUC8abHh6k2wk2RJjkwC5qaiHhDd96K3m263nIWwwp/X7LHMMWFckZK7GE
         rQgcvgI/S6lOWSRwX9XzmqDaYK9TCASH4WLhKOEdQF1H+hnouBrGj319BrpWN6ZQGGrP
         xmOA==
X-Gm-Message-State: AOAM5312UtlanuiiYM+/KYFcNy8cTfdsMC3C9dp/34okrbcnCa6C2twa
        /RzEtx4Cfg64LfpuiXc6JCv1qV4VGwDnM4Ql
X-Google-Smtp-Source: ABdhPJyMAUv88qgIgX7DSg9MANmcDcCUi2NqODylLRSbumb7rKvGHb0n9ca/GGj4NKRLeRJPwqCT3w==
X-Received: by 2002:a05:6a00:22c1:b029:2dc:edbe:5e9 with SMTP id f1-20020a056a0022c1b02902dcedbe05e9mr7827772pfj.51.1622277242242;
        Sat, 29 May 2021 01:34:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n21sm6402831pfu.99.2021.05.29.01.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 01:34:01 -0700 (PDT)
Message-ID: <60b1fc79.1c69fb81.49824.5f3f@mx.google.com>
Date:   Sat, 29 May 2021 01:34:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-13-g6de4069bb3a3
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 193 runs,
 2 regressions (v5.10.40-13-g6de4069bb3a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 193 runs, 2 regressions (v5.10.40-13-g6de406=
9bb3a3)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =

imx8mp-evk      | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-13-g6de4069bb3a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-13-g6de4069bb3a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6de4069bb3a38352cc9d2d90fd39582781a2ea65 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b1c595ef114beafdb3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
13-g6de4069bb3a3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
13-g6de4069bb3a3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1c595ef114beafdb3a=
fb0
        new failure (last pass: v5.10.40-8-g1b534e285a7e) =

 =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b1c5922ee7150878b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
13-g6de4069bb3a3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
13-g6de4069bb3a3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1c5922ee7150878b3a=
faa
        new failure (last pass: v5.10.40-8-g1b534e285a7e) =

 =20
