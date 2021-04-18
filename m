Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44D4363698
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 18:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhDRQ2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 12:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhDRQ2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 12:28:39 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D40DC061760
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 09:28:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j7so13145534pgi.3
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 09:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=STeqWbPKW5YLqYAqTluLZqpackNetMwtFLj79xVImq0=;
        b=fA/fxY+JJKkNS69u1qAkgNgSUdY+RJfRjxpVzs4zxmFFdJw1KSX5o7NAWyKd6nDtnK
         ZdkxihPb3uaG6ci/u4B3OQP5gFLGBZ9UWot7O/I2+sVp8MNVBm2jNpa1lQBC4xv0aaSy
         7p5wmVBSYgsNXzCo2FGQBNUuVkQVT0b1iW9d+T9DtYdAnbKN9ghnxA9+AY6qkizdGel7
         V1i1mRxtCcgDWwEY9ZRh4mmNfNc1i9tdhMVXPQf8POErZiBQRzLlJ7XaLz7zl1pjFuPC
         5nCCY96Lag/BCMt2QPseBlC3phbQ32puvUuxiK3lDhbIMdcKKcaGCzgQwX4iZzW/y+F/
         uurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=STeqWbPKW5YLqYAqTluLZqpackNetMwtFLj79xVImq0=;
        b=WQY+yIV/3y79WOc54SHCX5VBoDvyH9J6JZsPMGdW/QHaeDCIYdHcEx4ef32BTk+srD
         sM2cMBlsRJpAWTgcXIRG00yBspPHx3TytFHsRSx+XUt/lPwjoo9fg2XyutjrLyNTfqmX
         lAhMy2zdu2Qr+4d2PI9SMddDgdNQAJPdMyN7IaQvlxePYHIqVI6WPHrgnJTXC4aVkyIL
         YX9YqS94oDOjF0XAItPl2IKmO2iqUFIMr149p1U13Vn59RiVDrwz3K5tnXTFBQ+k2b4t
         DEYl7GvchOerpFsmQfKaWwLiff0fn2IfLd+A0Xamf/QKQEXYY0rPk0Gv979fTYd9O9pu
         U4wA==
X-Gm-Message-State: AOAM531NfjAJ0txDy8U2Y7fKENDGCjN6VxauXRNXUGOyIS2RC2CQu5aM
        0zUf0MmDJVHPALiwn4n3r7HtTwTYSho6jdEl
X-Google-Smtp-Source: ABdhPJx14OaWwbdz6gG+YmWOY9ZJ9oViq5zQw+l2EudKzkNXFcWIQPeQbjGE6i28ScxLA2YkZOWb8Q==
X-Received: by 2002:a65:47c9:: with SMTP id f9mr7884471pgs.78.1618763290332;
        Sun, 18 Apr 2021 09:28:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u1sm10298430pgg.11.2021.04.18.09.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 09:28:09 -0700 (PDT)
Message-ID: <607c5e19.1c69fb81.6056b.a3be@mx.google.com>
Date:   Sun, 18 Apr 2021 09:28:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.31-55-g2cd49362ddbcb
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 137 runs,
 1 regressions (v5.10.31-55-g2cd49362ddbcb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 137 runs, 1 regressions (v5.10.31-55-g2cd493=
62ddbcb)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.31-55-g2cd49362ddbcb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.31-55-g2cd49362ddbcb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2cd49362ddbcbe238a4a0a85fdb3f37b94706580 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607c29c6001ab7818fdac6ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.31-=
55-g2cd49362ddbcb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.31-=
55-g2cd49362ddbcb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c29c6001ab7818fdac=
6f0
        new failure (last pass: v5.10.31-45-g3f647a3134219) =

 =20
