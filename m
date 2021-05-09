Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DA6377601
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEIJTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 05:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhEIJTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 05:19:22 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B070C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 02:18:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t21so7717020plo.2
        for <stable@vger.kernel.org>; Sun, 09 May 2021 02:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y5b/E1vBEvTwR2uUAiBLCM8guLczDlUGLYgZiqZ1dRg=;
        b=ddOMt0h/5SUP4lVNHsbrE7FEBS1gns5BdgKRHVv2NDp74tR1hILLLPm8MwCQOdY2r1
         FMnOmsKXlXWnyCtamxk6FAViHzMIRaWyVqMPT2GGcUPLWoKB69Yf2GuwSOu9zGzjNsv7
         4/lXFb0+xw0yiiIgChKV0SM5ytbZpI+3Oco5D/PlmZ9sPLwISqCajf+LZTGZDxFdxu6U
         o90Hm3i9SlMQy5bKvQnLYRCzidELuNpI7hferUoIjSeq0NmGHBGKE1P02iN/H3U6dhkH
         gXkELCeihWTdJeQRX9i0/zhaiJ0Px4fT27Rbdv99DPVEMZDz1cuekNKn0ucxOsi3d/7X
         ovTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y5b/E1vBEvTwR2uUAiBLCM8guLczDlUGLYgZiqZ1dRg=;
        b=JU6pBJXgYEyVGCLMsDc8vgn5mMvxBPNqCacabOaEX4u01Sk/oiQOhBx5ZhikGkakgD
         f13J8FOm3bb0RSlLf+BpRm/SNb4fBR2k1f4gHvmiorZ1eEwByg+kjuIRkGgqt3OwkoDj
         pXU8eAurqbx3bGkB32/3tlQHsVNgsKyX4St9IjGy3m4HyGRSRa/xQimoK9OC7fhbqe3A
         ss3BjUItNSRvXorash3keAMHnI+43ZRapaF+dJK/HzCv/gBQRT3L+guRiZPxgxvgxb1n
         ZGAqRT5s/8VNpIQklCnTmKw74GGYCmrJnj4j6w0FcRQlwmd/la0aTAE+SjKBFItqT1D4
         bMgw==
X-Gm-Message-State: AOAM532NAbZeiHhwvGO76CZ61psXe8Hq702UokFOMcXm4xf9alK5x3ev
        QhimQ59xyJwDMvNED2bjWuVoe4sSu2B2j3sG
X-Google-Smtp-Source: ABdhPJy+EtylNzIdTbw9zVjF3tIilNhqQUrjTkLT2aMtinJQQbZA4iUZEXFFC+D/FoL2y09OGxrdtw==
X-Received: by 2002:a17:90b:347:: with SMTP id fh7mr21416884pjb.23.1620551896509;
        Sun, 09 May 2021 02:18:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9sm9267513pfh.217.2021.05.09.02.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 02:18:16 -0700 (PDT)
Message-ID: <6097a8d8.1c69fb81.ea138.bf36@mx.google.com>
Date:   Sun, 09 May 2021 02:18:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-286-g4dbb1fd7ec8e
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 149 runs,
 1 regressions (v5.12.2-286-g4dbb1fd7ec8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 149 runs, 1 regressions (v5.12.2-286-g4dbb1f=
d7ec8e)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-286-g4dbb1fd7ec8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-286-g4dbb1fd7ec8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4dbb1fd7ec8e696774c1dde4b5454351ed1169e7 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6097776910680060466f549f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
86-g4dbb1fd7ec8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-2=
86-g4dbb1fd7ec8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097776910680060466f5=
4a0
        new failure (last pass: v5.12.2-273-ga7ae441f5332c) =

 =20
