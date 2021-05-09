Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73650377801
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEITDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 15:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhEITDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 15:03:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408BDC061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 12:01:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gx21-20020a17090b1255b02901589d39576eso2468226pjb.0
        for <stable@vger.kernel.org>; Sun, 09 May 2021 12:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hDgeL1wutyLVZ9Yt0o/bfg96PE5/NCPybaXmsx3m10Y=;
        b=Uac2lHeUu5pnTw2cuB/DeJZ8rJzEG8g+G2nN4WUDPHIBU5yK/UdK1NnTkbwDcjc1W+
         BECMJNpG3qRxm6x3ZEiqgFkho0Fl3mTgmh+F4Hkj7+WhWxlixMmHiUimuojq/sBq6oXG
         KtfYqaWk3rKQLByuqx9P6+ouNaNtAEHmMKfIh9aUzgmiNdQBgjmQ2sqWhdWMOGTBYlQp
         9WKB8D7btHl6fKReWRISRkAen/chfdCo5o6p8ba2c6owSyXmKAjmwvEEfdFyVzv1TqTj
         MvifQ7hENZT/+PdKycmR1Gf7+diQ2QSvVCtfinO46H3KlxoqgapnCa1Uu1SqRyDkQ+wH
         urXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hDgeL1wutyLVZ9Yt0o/bfg96PE5/NCPybaXmsx3m10Y=;
        b=qQWS7sBc4/IuK52lsQCt2tHsyoksdQ8pKC9PU7kiarEN3nIoZ+s2JsBmoAI/vwyPXy
         hsNgpzaytYeNTAQ70RtIGYES8TBCv6xeaGsxDrPCteDktZ+znJiUL5Z70ZnwfMwj0fxg
         3LEIMhE6p/ScEGTcpwdUkuevXuSoMnJZIBHu0eKimHp2uTI/PwqnSLND+S5WmXc2kEk+
         yJhY1lpBtUk1CUVJcx5A1K4Cu0WtHxqkFWXHQZjeosSa8I/GBDVij1j+hg0w4RMQSwYu
         RULg18yVD8UpzmSoFTHIK6jsjRJf0C5xpA8QKPTtYU9TOMw7sN4oE6kIFvg7I1s1eeLT
         SBUg==
X-Gm-Message-State: AOAM533ferWe7WHcX8PMR5YeXw6S41tUQiOwK3ibzZ9ODQq2BZhUmutD
        6CaIwdM1TzZ/utGQ7R9hUEw/eZr6IKVxW2JN
X-Google-Smtp-Source: ABdhPJx53fXLrB4Cxp6CPw5F/W5nf+WISXRwqQUvQ85hofXGNvRCjUT0b38WKnzVkOWqq9mNcNcb8w==
X-Received: by 2002:a17:90a:6587:: with SMTP id k7mr559423pjj.86.1620586917698;
        Sun, 09 May 2021 12:01:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x62sm9417502pfb.71.2021.05.09.12.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 12:01:57 -0700 (PDT)
Message-ID: <609831a5.1c69fb81.78e9c.c438@mx.google.com>
Date:   Sun, 09 May 2021 12:01:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.117-156-g1bd2647670b9f
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 140 runs,
 1 regressions (v5.4.117-156-g1bd2647670b9f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 140 runs, 1 regressions (v5.4.117-156-g1bd264=
7670b9f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.117-156-g1bd2647670b9f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.117-156-g1bd2647670b9f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bd2647670b9f2208a228e2f62aeb462b2997fba =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60980133e57ec38a2b6f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.117-1=
56-g1bd2647670b9f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.117-1=
56-g1bd2647670b9f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60980133e57ec38a2b6f5=
46e
        new failure (last pass: v5.4.117-140-g0d2e469f4710) =

 =20
