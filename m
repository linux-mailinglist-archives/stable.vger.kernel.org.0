Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958A23E3FD5
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 08:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhHIGYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 02:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbhHIGYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 02:24:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31331C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 23:24:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so28604842pjb.2
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 23:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2UVH/kCXVaDsTAfF5BSQ6BRT8Y4G2F75yliGNN5izyM=;
        b=dawOh85hw0ptaJMQFoNFWrvzIoauS0WKfd37mqC5pCjjkbBwZNJUxc5egXupnkFScN
         JI5r/TUja63WFNF5oFmTfPTZmQWekUUkM/Oo6l5/QBR9DKR1cdLtnLHg5BTuuPMg5e/C
         PMcj61iw/RBWJHho0id0CdUAh8R4q+YsXGAAyOH+1N0ZBxhezhBSn/lXdT1+mPfiTk+X
         YY+bYcBVBBEBJMm5b90zwJ1Zep4guNZNeeJlmfNsG90rBRljkEB+1bcYePxEAL91CmDI
         Txz2eh/wkz9KEMudYizoARqeb5ce0Vz+vQ6Z0be0Ts+T93JxXuyjGmmSg35nekLccISw
         BJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2UVH/kCXVaDsTAfF5BSQ6BRT8Y4G2F75yliGNN5izyM=;
        b=OWKs6IV5zwwraYn6+JKGOJS23+V7FRlpoUtBqKBOhde/WKPgYrppMR1bx8NIl0Xsza
         +yGPwhHN4SmWYzJ4lEj87BizPIUSyXV34ie4J6BwMPzb56cvtL9iGbB/NuK/r3Nukp+Z
         42uVRcPnhUcZ8xsTVu+/tv3RP9cP5xrKyp9RZ+2nQwRyrlWZ1bjmnO04D29gNZcai3Ys
         YXavFVmWAmR75ViAmu3h4oCRiZ7sKkOYpAXEdYCkRNFMyQrifC0lJGRgNYzoqBPQ07kI
         rdCbY/0rTfi9HlI4Gmmc7zIr4r0NAQKnEAOfK5ff5s3R3emPbgl80ag96nZL+BNWvNmq
         Bnkw==
X-Gm-Message-State: AOAM532iIledrWb7Sn5AcAxhgY2Py9aOQUjnCnQqXkEaGmOrEelTvaZ6
        sTNXm55+ZvSPLCsVwLGhu0uzOF8gGVKkgqbQ
X-Google-Smtp-Source: ABdhPJyfy+6uIuNFv3szJaqDSFx3mR2xmmML3OpyMalUd3lCbwEz5s2xSynXVmQIsB2eraVCXdq/Tw==
X-Received: by 2002:a17:90a:2ec6:: with SMTP id h6mr34029484pjs.9.1628490250580;
        Sun, 08 Aug 2021 23:24:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm21349731pgh.79.2021.08.08.23.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 23:24:10 -0700 (PDT)
Message-ID: <6110ca0a.1c69fb81.d5d46.04db@mx.google.com>
Date:   Sun, 08 Aug 2021 23:24:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-49-g039efb5682ed
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 135 runs,
 2 regressions (v5.10.57-49-g039efb5682ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 135 runs, 2 regressions (v5.10.57-49-g039efb=
5682ed)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
fsl-ls1043a-rdb         | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.57-49-g039efb5682ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-49-g039efb5682ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      039efb5682ed2ca69c2471c5947f51678ddd4c00 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
fsl-ls1043a-rdb         | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/611093d212a0b21150b1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
49-g039efb5682ed/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
49-g039efb5682ed/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611093d212a0b21150b13=
66c
        new failure (last pass: v5.10.56-30-gd7270c12d72c) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/611092bcf1328b2f0ab136b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
49-g039efb5682ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
49-g039efb5682ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611092bcf1328b2f0ab13=
6b8
        new failure (last pass: v5.10.56-30-gd7270c12d72c) =

 =20
