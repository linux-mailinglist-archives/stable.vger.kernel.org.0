Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA66B3777A5
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 18:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhEIQoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 12:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhEIQoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 12:44:17 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76DBC061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 09:43:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k3-20020a17090ad083b0290155b934a295so8721465pju.2
        for <stable@vger.kernel.org>; Sun, 09 May 2021 09:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XckdrP/IoA4VAUgs0GaHC9+728N0XLtAf+FyFoYkTOo=;
        b=R7bioJkL5VLa9Xe3HFa2ENXZAA93+Tw+49CgV6ki0+0GwV1xU6uPPF75ZxPkOP9IBa
         5I3nK0K+di8mg6yiiORkitYDlLx/WYNQuV/GeKZz/vNatx+Kjn29gjU39KRZAnOFDf3o
         XV9FSHOkUkdAO25o1sTIoE5aOMsUY5spUSCbK9duvUrBIuyRboZb24PI7cpSsCRE30mK
         kEp6cozit7VTEpGCJMzBLLMn6AlDQDom92UR0JnXVbC6ayyRl+FOGBaveTTkrkSCsX12
         eclSRhi8T6VNrCemF5uYzP+NKU2n8cuQFLOxdRPu0ivk1CAsgYCU9X/aNMho6VstdltK
         Z3gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XckdrP/IoA4VAUgs0GaHC9+728N0XLtAf+FyFoYkTOo=;
        b=tmLsqdKOvBZ+bVfHiJpqkQ3QfhfqHgEMmewCHM4kzMqo5Naaci3ayEcweWT+kQONDc
         GsAUpXym3DjKJbkm39loIyWwVyPxEFyARmkCOUJmw2BNHFSK2sBRYz618DSAGF6702aC
         5ooGlrim2RgmAkA5ZgBNkZr6zAq0Y6XxxKQDiC8lk+KEvwPETYoQ9Fbk7wAvNco3/5lN
         ZtqTV1AsPtgKcGGAIvNNAKhEVR8hQuE6bFOCgy0DZ+mVwXyR3ndcxLWlcjh7BeOq486M
         LApIDHqzdXYBhZeGhEXLEQALqED/r75EQG4Ht2SMri6FvMgvSihmJLVRf+5dFtcmRm8g
         zHKg==
X-Gm-Message-State: AOAM5315+BlNdgo/i8UBBxGBue0/nJQ3v39GtyFYgv1onTJq4eLlzPxd
        rdudEvA+y4pllsy2rKX/I5FfocbSntBYjDFi
X-Google-Smtp-Source: ABdhPJxMJEjAI4qLgIcwktQP7xfnTpvfBjrMwv/ZFYlIf2JiJWUYVj3mffVST3OKdpSaCXg/eD2B9A==
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr35538373pjw.138.1620578594160;
        Sun, 09 May 2021 09:43:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22sm7927864pfp.138.2021.05.09.09.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 09:43:13 -0700 (PDT)
Message-ID: <60981121.1c69fb81.b60b.7efa@mx.google.com>
Date:   Sun, 09 May 2021 09:43:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-295-gfb352930605d
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 159 runs,
 1 regressions (v5.12.2-295-gfb352930605d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 159 runs, 1 regressions (v5.12.2-295-gfb3529=
30605d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-295-gfb352930605d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-295-gfb352930605d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb352930605d7cd050bb7d36bde8553429807813 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097e151d047ca1b7d6f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
95-gfb352930605d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
95-gfb352930605d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097e151d047ca1b7d6f5=
468
        new failure (last pass: v5.12.2-286-g4dbb1fd7ec8e) =

 =20
