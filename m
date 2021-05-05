Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05545373306
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 02:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhEEAUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 20:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEEAUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 20:20:04 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B400C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 17:19:07 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d29so525803pgd.4
        for <stable@vger.kernel.org>; Tue, 04 May 2021 17:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+qspILFbn25pwIzjhgSzcMXyFEYCYi70HX01sUMv0Aw=;
        b=n7CiFi5f+5Q6FqWh51tQIdM6m/D4n3Nm/zqwS2xw2Q3q2KljFizK4BD0yn2bxBpsHn
         xkjGlXIQDWwbtiiHL1x7/G9jXU+u9qfIBg7G9PmH/7hfMB995EzVRjvxywjM8Sv7gCr0
         0/vnqGjSJN5det0FAOcgHNCpIFbSn/qhS3FMRe/W6/cLiku9BjOJoNG03XD6jQVGO76v
         SwWDEioD2fULTV0Zl9bLqjn0KhEVKi4NQe2Hhbdh7UD5o82fgzNkqYrMpA1nGfS+4QoE
         HmTs9aJtVQ4av3sl9A5LgcxWxaxJLWTTt3rTR771I298r1iYUgFhLT4KwIAUV3uF2k0a
         R+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+qspILFbn25pwIzjhgSzcMXyFEYCYi70HX01sUMv0Aw=;
        b=Epywxe6Atke4C5igfltIYmMwrj1x3/Le0BgP4nNl4nen0HKLabaP4Y/bQkHr7U9FUl
         pYa5IaznztaY9GhJ8czDH/GNXIzN82qUUBqgLr2tYb2Z3mFJWZNyZueSuLrkMMoGSjLk
         DPPRghzydE6c3kJRQvqw4u7akivx89WFtUVGVFCTekgCNB4pqUXunShg/q/EViOF6Q2x
         ah4hbgVWRwQZhp3pISkIKvoBRYzl4+rE+Buf7w83gJQul5Wyqp4+M7BwDpGS3dBgleZZ
         z9VA5cwDHDtlNUlrJ3bAHEqhuN7QO7JoSCDNjlSKYl25VjOk9bbm080dOlSnAG0oKoJr
         gyJA==
X-Gm-Message-State: AOAM53287/v2aNyAc5iD7nvwukZXaGU52fTZq2p07jbCQ2gvs+6PPAQE
        QxTpm0wZv5STap5QRafAyXBWRyTvqCl128eh
X-Google-Smtp-Source: ABdhPJytP1N9IRWND2gHHBWgUnm8esbw5xOBQlqxzsHgXi50y6AMFB6X2yGCCdvn0pUUnGOnB1g04A==
X-Received: by 2002:a17:90a:ca93:: with SMTP id y19mr8738701pjt.210.1620173947050;
        Tue, 04 May 2021 17:19:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm15312186pfk.144.2021.05.04.17.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:19:06 -0700 (PDT)
Message-ID: <6091e47a.1c69fb81.bb534.6d2c@mx.google.com>
Date:   Tue, 04 May 2021 17:19:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.11.18-12-gb0e2a2f653128
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 89 runs,
 1 regressions (v5.11.18-12-gb0e2a2f653128)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 89 runs, 1 regressions (v5.11.18-12-gb0e2a2f=
653128)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.18-12-gb0e2a2f653128/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.18-12-gb0e2a2f653128
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0e2a2f6531281cebc48a812fae5a551600bd8d4 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091af3c5de789fc25843f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
12-gb0e2a2f653128/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
12-gb0e2a2f653128/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091af3c5de789fc25843=
f18
        new failure (last pass: v5.11.18-7-g1b15e1a9a6fd) =

 =20
