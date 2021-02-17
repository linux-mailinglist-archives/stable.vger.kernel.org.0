Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67AC31DD1C
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhBQQQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 11:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbhBQQQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 11:16:07 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816EAC061788
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 08:15:27 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id 18so15507152oiz.7
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 08:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TwLeQxDSfIqq2qtyUcUeG7OJbY+qgzWTmuh1BYiTm4U=;
        b=o87I/GC/waQGOhLwh2fOkptrU0SX3lO1dFKWJcP4ngZsw6HMnfcFQZT58Ai4nI2BIC
         v9sfr0LJ7Ye1q1HyZRrblSQ5gsxmccQ4WcvGcBEPVV9/Jf0cEAGHqLDNy3c6Emo/Wpas
         ZY7tYyJxcaCa5C+9dqSd7BYJVaQdwxh38tyd0bknnjPtP5pRqruathFvx70p4Tkz72+p
         dxQvYPYNrfbjY8cp2+v3C697N+QCa6Oh+qK+XqK48Ijya/QKhOyKgiOSGbDlac6eGkM5
         34++1IaoTN225MHIX0SM1kJW7x2lXggc8YuHLBJ977Gstp9xm47maniUevKQtx2n14Qn
         cQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TwLeQxDSfIqq2qtyUcUeG7OJbY+qgzWTmuh1BYiTm4U=;
        b=NO4bk3O/QsYDzPBNXTmKtBdnCqWKpUJJS95C11Mb8aFdgZ1nbQVqpS5jlCwukY6sZo
         tpFgFgXKzV6R6c9rQE0L7OlyEr7EblFB9dTT7rwTDyfgnCx3ImRzxHbJz7WPOW/M79L0
         iSjm1laJ3kdRTrQqcMZVXTEHvAe1udDm1upkQHQfH8Wc7SZIxNc8eOYMm0P/SPedW/5o
         nm3NtUaKxBdxNAp9euKslFsGjBwDMENh4EDjgGCrf9wDhlm3+C0BX4IqlWEH+3IVkELp
         DkFDViTmeE5tvC5uB7F9VDiU+aptFrFYXi/Rz1545r9GhIg3bC1ZlSr2S7TqEh6YmsBJ
         1GJQ==
X-Gm-Message-State: AOAM530wC4VLmPf1mqUK2+rgH0gpKQ7n0335L6I1IE359NLkXDhwjZ6O
        yAzKppYboof+KJuAg2guJZ9JCWKiMo03hw==
X-Google-Smtp-Source: ABdhPJyu98KWsy97ZSCL+nUWWcShemkdJciuIjXhSB4dmJ76/J+VYOH26XzXncM67qiWEaE8/aIi9A==
X-Received: by 2002:a17:90a:2a84:: with SMTP id j4mr9551522pjd.26.1613578063376;
        Wed, 17 Feb 2021 08:07:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f28sm3190216pfk.182.2021.02.17.08.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 08:07:42 -0800 (PST)
Message-ID: <602d3f4e.1c69fb81.47cb6.6a20@mx.google.com>
Date:   Wed, 17 Feb 2021 08:07:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-gceb503b53409
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 64 runs,
 3 regressions (v4.14.221-44-gceb503b53409)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 64 runs, 3 regressions (v4.14.221-44-gceb503=
b53409)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig       |=
 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig       |=
 1          =

sun8i-h3-orangepi-pc | arm   | lab-clabbe    | gcc-8    | sunxi_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-gceb503b53409/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-gceb503b53409
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ceb503b534092302bac1bcfaa3b6418ecd42db06 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/602d07bd0d5e11e9d8addccd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gceb503b53409/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gceb503b53409/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d07bd0d5e11e9d8add=
cce
        new failure (last pass: v4.14.221-44-g2c371b544ba26) =

 =



platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/602d0827542837d28eaddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gceb503b53409/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gceb503b53409/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d0827542837d28eadd=
cb5
        failing since 71 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
sun8i-h3-orangepi-pc | arm   | lab-clabbe    | gcc-8    | sunxi_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/602d065cc4cde78490addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gceb503b53409/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gceb503b53409/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d065cc4cde78490add=
cd1
        new failure (last pass: v4.14.221-44-g2c371b544ba26) =

 =20
