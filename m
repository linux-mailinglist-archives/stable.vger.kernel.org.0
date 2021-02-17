Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1816431E2B8
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhBQWps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhBQWnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 17:43:42 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B90C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:43:02 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id o38so9419323pgm.9
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AO/UcXJQsoEwRGAUUfcnxMSMgnlzjr77mCVKrgTeK6o=;
        b=pNY7OZoRIv7+iCtGR84RWsUMKKsAtcGTPa5qVC9ZaQ6x/Qq0DJS3MTPEXDBih5o/nu
         I97UF0wULtTFcj+FvvyzlRtcgjnFWh8beO/yHHhHSL3t3KkRXG+RcWQRJRY4GfYd5god
         BVHYgDQri4xVB/t8dLaZ6p1FSzRQY7Oy1jBj9y+YtCXn9bTEYZo2UL8/rLLWGXkwzBN9
         nh3U8hJv0xnTuiygEnuM4ymSPzPppc8BS4TMjbFJIIJ11RZRTzfuNL5tWcQXXl4V0EHv
         6PZjzS8XovvO2HcRH2grn2zBOa+G3CWzkM2ywfq1JDV1TfZ9HehTktF8GrdaY6cuVyW/
         +gsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AO/UcXJQsoEwRGAUUfcnxMSMgnlzjr77mCVKrgTeK6o=;
        b=E+yYFafUBqmrlBoY2nCeLfPuGeB2bgBnLg4wnql22LNoi59gmEljkJTtpKYCIxUenG
         ENfo+eW61wuBSjaxhyDUg56MpDQvGeESvGwzOueLqifdZelVKz59nbP+yacAs6EeYNYp
         Fb6sVU18kHCV/UEi7kc/2CgdU3ZoK2jB2i2LYLgTWja8p655umyjFZoQf+Qh9WSZk/WF
         kb53fYUdP8kYYCfpU88SAFqi+WvFZc7H1c9hvRghXVURNCIUkYJYJBh7SpXm06As6VTI
         /lVtW8XiMStEpxQZ4pobKkQmR8Lc7ZTFoQUmzAYJivXCFTMIjydME1x8BYjQpzsKK5mB
         8sxg==
X-Gm-Message-State: AOAM531wsAW6HDdfqOw9TdKEtoad5yzl+wNZEQL0Zya3bORlwovua7nb
        46v3CnPnHIPWJipQ5fB3EifU6XB+zDIyjQ==
X-Google-Smtp-Source: ABdhPJwQQipSbADZmqXR3Jr1n8EoVzMvA0P7SJ+SnG/qyPbPebp6Xn6P6VwHnTGwl3sGD0pjCYEGgQ==
X-Received: by 2002:aa7:91cf:0:b029:1cb:1c6f:b77d with SMTP id z15-20020aa791cf0000b02901cb1c6fb77dmr1300881pfa.74.1613601781891;
        Wed, 17 Feb 2021 14:43:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2sm3933913pfk.63.2021.02.17.14.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:43:01 -0800 (PST)
Message-ID: <602d9bf5.1c69fb81.85ca3.899d@mx.google.com>
Date:   Wed, 17 Feb 2021 14:43:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 81 runs, 2 regressions (v4.14.221)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 81 runs, 2 regressions (v4.14.221)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29c52025152bab4c557d8174da58f1a4c8e70438 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602470901bc2f79dd43abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602470901bc2f79dd43ab=
e8e
        failing since 316 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60249a3b3fff1404873abed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60249a3b3fff1404873ab=
ed6
        new failure (last pass: v4.14.220-31-gc7c1196add208) =

 =20
