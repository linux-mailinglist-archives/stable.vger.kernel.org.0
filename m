Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6182A376A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 01:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKCADS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 19:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgKCADR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 19:03:17 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57788C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 16:03:17 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t14so12235051pgg.1
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 16:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/LbCAEGKXyvcDahACSqDYhFoHE4SXXIMMoGy5TWl0gM=;
        b=vEdlNcAbuMTAw5W9TpErUTiapyuoe6HTxr9OgY9l4oZL/hBMW+We2w82RcmAHd1tRj
         xRHJpIjyKrEdiJ+GVHgLgJaasymhXrEuBMTE/htAod0Nz/D5h/YAmkKbicUvrLOXksfB
         fAe+uHcnIPVuy5qw3oLZaoDWovBdeNj4ozajHIkKOc+iFj6eKkkvZySsjkfDDe6i1rP5
         3w9PVC+c2rI9rY8MHRIn3qtdiaT8l6cfGRw3lb6LmKNhYxKt9M1jPpz2SXMPVj/8bLG8
         Ryc8dkqN42UsYpnk6JcWDuf1RXh+/dg5T9FgQ9MkLI+0YhxJO9pxanhZDMuZbiOzSZEz
         Ni+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/LbCAEGKXyvcDahACSqDYhFoHE4SXXIMMoGy5TWl0gM=;
        b=TOVSaSjp+Y42n6wx3NVYEe8mGDnlxQpjCZpv3zETKa7ABhwWMmb6AFtbRahtg0quLh
         1gwm9HZhCO0qFQ3avdSC+Aj+p7yEMxUNGqRByK88lXSJYC1/HXp0yZWAtspCBJAzfNR3
         HxK3GCTl60ndg8SRJfrFlQiN8r8C0zwhEg7eQHAMKUguJpRCGmOe5uuRWXFFRAFtXNiw
         dhFpCV7m5RHd7140uIlrfROAXR4NpB2pJCL5DtKYHSCRdKYV7IDpRRdyDBdnwptJqQo1
         tJ17pg7yUiBwzPu1iVwegK5Tm5udrrBl85+25/87U3wDRga0o6Xts5wD3fI702CyjKPE
         hCbA==
X-Gm-Message-State: AOAM531TogptSqKIKgeTVwnfwGnba3MkRfkikacCdxyqQTbeX7H5TgkZ
        69mT4AQOalBPSSQsJtn1bGkYGELSfsknsg==
X-Google-Smtp-Source: ABdhPJxcr9RgGpoFebkwDqepbao37vbUHes65aeaWq9HJFCBujhatvtId5mo5Kuh/73AsAF2+GErEg==
X-Received: by 2002:a63:4b1c:: with SMTP id y28mr15104541pga.382.1604361796491;
        Mon, 02 Nov 2020 16:03:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm587851pjz.44.2020.11.02.16.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 16:03:15 -0800 (PST)
Message-ID: <5fa09e43.1c69fb81.3a591.223c@mx.google.com>
Date:   Mon, 02 Nov 2020 16:03:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-44-g29192a9a3096
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 150 runs,
 2 regressions (v4.9.241-44-g29192a9a3096)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 150 runs, 2 regressions (v4.9.241-44-g29192a9=
a3096)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
  | regressions
----------------------+------+---------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
  | 1          =

rk3288-veyron-jaq     | arm  | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-44-g29192a9a3096/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-44-g29192a9a3096
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29192a9a309647259bc14c52222527beb78856c3 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
  | regressions
----------------------+------+---------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa06cf09239e9f1493fe7e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
4-g29192a9a3096/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
4-g29192a9a3096/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa06cf09239e9f1493fe=
7e5
        failing since 4 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
  | regressions
----------------------+------+---------------+----------+------------------=
--+------------
rk3288-veyron-jaq     | arm  | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa06cfe9239e9f1493fe7e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
4-g29192a9a3096/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
4-g29192a9a3096/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa06cfe9239e9f1493fe=
7ea
        new failure (last pass: v4.9.241-14-ge7f356d87b35) =

 =20
