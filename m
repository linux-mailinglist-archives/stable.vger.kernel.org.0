Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935A53C3FE2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 01:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKXPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 19:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKXPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 19:15:40 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6590C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:12:51 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id w15so16286074pgk.13
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W0pRp18S989YA/MQziyVKFFfS83oS3P2vSt60L7cRAQ=;
        b=uZkQQwBbSL0Bwrw07fGUrOIWmb+ETXRNyg5J9UQbV62NGOmk8SntAUg24QwMoau7gH
         Wvg0yH0IylHvsuWOAOO9TFqQuU/S5hNnhLhpRCbL+mYmxnRgj3cQiuYY6B+uoq2dFK4i
         gJ2lAzcYMoqK2BXMrGcBy2+LZIVCxuNoceof5IcS8WHnypf47R3HV8l41ghd0mb7f5m3
         iuXrFgdGX1YaNwtwufAS18hs9K9mphItpnCsq/eRaqpXEAKGZlg7+ogDUB+mFPMRpabS
         8SA8uHoUam+aBYZPF8zunsGeJC2QJQuF9CtZjqxNNEmi6azfD67+BmAy+DXwRnsszJa8
         iy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W0pRp18S989YA/MQziyVKFFfS83oS3P2vSt60L7cRAQ=;
        b=b33qnnDVz34wf9vIIi0B4vj+9xDd79qOpZxG5JlbyrYUXpy3HJm/wIH/a9s/YYlXh4
         SUeD00SB41GvaLemBH/qKCqoj6zbqENl5jCQUba5yKDGKHn6vo4hsW46AGybOXspLSgz
         ujdaLt/A/b0LC+Y5iOidhGixmYyNq/43casfTGKj8areSMAKiG0f0blTnX9y9+Gtaeub
         UcWJe50Ja5iQlme15te8m6ifOVa/QzhBdHKy+TsGscxCstWnvdHdLXTrC7EINiowFjkU
         YWpnPRdXrP3tETmT6TmhunAxGIaNkPeganA+DLwZIHAPYjMokdz3hcTK3tkyVSJYm+0f
         m2oA==
X-Gm-Message-State: AOAM532R2QntxgJIDgrK33Fj/YFBCmDKQpX0Y9IFwaLR0pV3/H7u+fdC
        +pSG+xHXPfXICqyuSZPovp6OoE3NRh0rr5QY
X-Google-Smtp-Source: ABdhPJw0uCmLgJ2wOLktufU9DZfeesSQnZoP9RMerO2nqrhamoeGT2woX4PEy7BkiYLofESi9TzxdA==
X-Received: by 2002:aa7:96f0:0:b029:312:8eda:61e1 with SMTP id i16-20020aa796f00000b02903128eda61e1mr50387268pfq.42.1626045171292;
        Sun, 11 Jul 2021 16:12:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v27sm9735658pfi.166.2021.07.11.16.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 16:12:51 -0700 (PDT)
Message-ID: <60eb7af3.1c69fb81.49fd9.be63@mx.google.com>
Date:   Sun, 11 Jul 2021 16:12:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.239-158-g685789d7bbb4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 143 runs,
 1 regressions (v4.14.239-158-g685789d7bbb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 143 runs, 1 regressions (v4.14.239-158-g6857=
89d7bbb4)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-158-g685789d7bbb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-158-g685789d7bbb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      685789d7bbb46b645b09abf665409c85520fb976 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb4d10ff537b6e76117973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g685789d7bbb4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g685789d7bbb4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb4d10ff537b6e76117=
974
        failing since 132 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
