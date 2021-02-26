Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB683268DB
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 21:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhBZUr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 15:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhBZUr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 15:47:56 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DF7C061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 12:47:15 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d12so4503254pfo.7
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 12:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RlPDgnecdzjpMNktuFCWr4yNrxX7wpjfxTROaplTIKQ=;
        b=ePcwTVSDG9fep0d0WOrvqB2mRlk5M6ZWY7soS2+7zoAv232Fm5Gpz5ox9xnio/UJqR
         CBhRMIkFn2Fw1JAgvDsHnOlC0Z82Bi/7y9WXfJ1n8DeY0pzolYy5/0qhz/OnPw59AZvr
         J7B+dc6exQmoTqlTXOd8YGgCOqnPEBmj1vK419wOk9pIAcf2t5NXOgtL10FYWNf7qCLe
         lU9O8NDP8+GQD3LB9vcCEg8b2yi8MksTXWs2lGLc8X0hy+cgfAuM5VSRXV9NU9A+6GdO
         EChv0oGRMv6xFOpRkL3RxXYmuQXzpneHLx8QE1uPnspjwRq6DxHnrQAaTNPScy9Ca8o7
         uKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RlPDgnecdzjpMNktuFCWr4yNrxX7wpjfxTROaplTIKQ=;
        b=kmq68OJizHXYBbiniblA+8aA/SWp9WLi5knUlJTHOcRW4YScccR6g31vlcErnNKdPe
         +8hDlBEajymNvXU7z4vFMtKpvUEBI9JjeiHOwwiP30QjS1h+UQgbgmpLqeIkcNG3JdaR
         /hnQEVkDBJIiKxsidEJuoLAolBnIF4p/4jEFw1z0L+KbNP9jT2lkSReg9img95LHtXpo
         g84BRb6ALgJzWK3mVoSC5h3zI7G6v9P2hpqQASuBfuXGSYUZh4Vb1D5G0KTeyapDwdaa
         kNbdZuCjOxuVmvvExUcnv5T+8lADZpC888WgcpkD7F26WhFvb73lID9CK+h1mp0ZLSXj
         Gdfg==
X-Gm-Message-State: AOAM5338fXZHxLbg8HSO4scojID7sOoQiZWfe0Czr3Vn0SSERQ8MSVXq
        OBtwJ25eU4YoRbnIdyxCFsMB/01wnK4nUA==
X-Google-Smtp-Source: ABdhPJwGVcumkUo2fWdQDsjH1Zz4+CoxcnF+zpBhcj3tAXbex5JUl9BpyQ0PnIzt0f0+6fcQBhJrdQ==
X-Received: by 2002:a63:4e26:: with SMTP id c38mr4465091pgb.81.1614372435127;
        Fri, 26 Feb 2021 12:47:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16sm9607705pfu.76.2021.02.26.12.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 12:47:14 -0800 (PST)
Message-ID: <60395e52.1c69fb81.f9774.6499@mx.google.com>
Date:   Fri, 26 Feb 2021 12:47:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-8-g03edb35f0ec4a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 60 runs,
 2 regressions (v4.14.222-8-g03edb35f0ec4a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 60 runs, 2 regressions (v4.14.222-8-g03edb35=
f0ec4a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig       | =
1          =

sun8i-h3-orangepi-pc | arm   | lab-clabbe   | gcc-8    | sunxi_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-8-g03edb35f0ec4a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-8-g03edb35f0ec4a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      03edb35f0ec4ac8f8b5b96e3f296eef624bae667 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig       | =
1          =


  Details:     https://kernelci.org/test/plan/id/603938e661b6588c62addd76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g03edb35f0ec4a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g03edb35f0ec4a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603938e661b6588c62add=
d77
        failing since 80 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
sun8i-h3-orangepi-pc | arm   | lab-clabbe   | gcc-8    | sunxi_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60392a79a7db454a32addd3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g03edb35f0ec4a/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g03edb35f0ec4a/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60392a79a7db454a32add=
d40
        new failure (last pass: v4.14.222-8-g6815f667af2fe) =

 =20
