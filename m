Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B2F3A07C7
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 01:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhFHXcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 19:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhFHXcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 19:32:12 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51044C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 16:30:07 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v13so11547715ple.9
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 16:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tBB2IKXQs/6nA6rZFGN2nnZH4ctVZEvEcJVdjP6wmpI=;
        b=1H8HnJmWMnZUNHsuGs+aFjqZPZcWAQmp6wYzDH/Xx7v3kS25a29q5SsIQlV2VvG9F1
         xM+fCqJJy7iaNXgQAtitTf6YgORD5BiDSGLv/sOYNSiXyO+i7WmiGA0GNaS0XKu2DVbG
         lP+NTA+434I6YZ50tuL5paUo+umTYFi/OmtQVH4vU3JZGcGAKL6jZMfoyCyQG59YN5MS
         hmGcqCT4ZlXnDy+f3TjPczID6+gvcRL46aSgUMFfy0Kbz7AnMYgedEIirRSTHhHT0/JB
         6bKsVEPrprSx96rEl/bT0GijA6/SlAeggP7r/11Aee/QPPKntBgr/cjA4o3WP0agsqbw
         +XgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tBB2IKXQs/6nA6rZFGN2nnZH4ctVZEvEcJVdjP6wmpI=;
        b=KblOqTX78BvCqav3z6htc1KZKWwo6wcCUhVAq1Gg7+OdlRSp5jCkIc8KO1ExP4FH5U
         NOr4N49rRGZLGZWGWub23KZeE2+XUGXbh4hJdM/P5Qspoe1Il6I7jTb4Dslectw7S4Iw
         aKgjiNLa43+X8DCq2pF+IQ52AGrBM9273esY0kx2XOLYHmgbf9GQGN1XYDWhV27finDG
         IW+dzKiWgmKAkypjWDRl0OYKSE1sbEUSLIn7bNY0UqeK+3H7ZFQHaSmFOlPN7LfT0pOr
         Kl/VU0m3qVcCCQ7wMFgW0SQFcPiQnpDOJQScNiBbGDYJ/vwoWVwSWCacTbYqto13L/SS
         M1Fg==
X-Gm-Message-State: AOAM531S/Jsvf+U+UanlU5knTaaAjhn3ruQvwqBixUCN36O6IiiacVwt
        md6Q0ju5RJgb/G2FCie2DPkqYQtWeVJbhw0i
X-Google-Smtp-Source: ABdhPJyukJHUg5+TXg7js0GX1+PWhmLmU5gR8HEJ2vOnnMj5qTNnkCwRjeV/WjP96BFZgOVTScW0Tg==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr826692pja.114.1623195006418;
        Tue, 08 Jun 2021 16:30:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fw16sm3219421pjb.30.2021.06.08.16.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 16:30:05 -0700 (PDT)
Message-ID: <60bffd7d.1c69fb81.c8ae4.af5a@mx.google.com>
Date:   Tue, 08 Jun 2021 16:30:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-47-g48dc1a31f151
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 128 runs,
 1 regressions (v4.14.235-47-g48dc1a31f151)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 128 runs, 1 regressions (v4.14.235-47-g48dc1=
a31f151)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-47-g48dc1a31f151/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-47-g48dc1a31f151
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      48dc1a31f1517e6adff6395c35b2753f4e2460bd =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfce71f721c2bb8c0c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-g48dc1a31f151/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-g48dc1a31f151/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfce71f721c2bb8c0c0=
e03
        failing since 99 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
