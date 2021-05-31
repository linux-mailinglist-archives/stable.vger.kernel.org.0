Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26378396838
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhEaTDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhEaTDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 15:03:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CF5C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 12:01:53 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q15so8928106pgg.12
        for <stable@vger.kernel.org>; Mon, 31 May 2021 12:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2oLNqQLwPRAvL9eaUm6Td4vP4JSSp/qH98mUFC5nmhY=;
        b=wkf4EDAubKQfJx/95jt4OBRfV7THJ6Fav3HQnVRNtdHBuWzm01uAoN+vYUCTVvNIE3
         oHs6mEFT2jEi77rfPHKHMT45Ch1ZFZt+nFPiZgzoGUdtrlt/Ls/jK0FMux6OAc2mD4at
         POpQBKCvSRfNtn7F7i+LiCsDLjA/Y7SbcVdE5+QmJU8N8+Y37eP/J2vkH3ToaI9nto64
         ypOObG0U1onZsG6s7/5EtkGLO5LIZEmoLB4bZtpWn5C9KaWgUdlZn673JLvfIoAsdVCq
         RbRS9mE4sg487K0A+qNP6zrTEI5BZOXKM7J+kxUk/JWNlepfGRmtTQ2qrBpaU4dHAQlW
         cpUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2oLNqQLwPRAvL9eaUm6Td4vP4JSSp/qH98mUFC5nmhY=;
        b=lpAnK8VkNSdbBUiASNI/QK1Bewtiom3bnTgTOn2fz1dkhZm8h9hfUq5ySmPUMjc7TE
         zFRG44cuzjo/GfC4LJUSpBtzHIoVox2hvQCPkWmSIw5CiCGvCnq1wIQCwr/XbQlL0HQW
         mLgnfIBzziNS4BzC0Vro/wiUYe2ODmQtGKhwoS3KmoBvgYU5FaJTqSmjXZUXK2AmmqXI
         ASfYk4V15gCWkkNm1yGI/M2YX3G5i3mHVL18MVvI+TlbS56g8qXMMFcogCSsTwl8t+bc
         Zj8853/kG+ZrELbv/D5X/mKTaPe/ScMx5x5bwwXShcNg3bLHjDNY6vz+Sr1YypFTsL/L
         ehIQ==
X-Gm-Message-State: AOAM5325og9xABfjARhmkxk/QEdr/txVjZrtQLyL074mAa6BhZGE7otq
        9IuVPYPr61n3clTmRGMmIvkAP15Q7rE+ETnC
X-Google-Smtp-Source: ABdhPJxkPFsv3iQrJZuRFISklpgt5xNpqEOFyV/PEvQTPDMqsMLf/Aa9zur9y7SjQBERxAgPmM76wg==
X-Received: by 2002:a62:55c4:0:b029:2e8:f854:d31c with SMTP id j187-20020a6255c40000b02902e8f854d31cmr17982202pfb.59.1622487712746;
        Mon, 31 May 2021 12:01:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm11577857pjh.27.2021.05.31.12.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 12:01:52 -0700 (PDT)
Message-ID: <60b532a0.1c69fb81.45354.4cfe@mx.google.com>
Date:   Mon, 31 May 2021 12:01:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234-79-g1cf75ca15187
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 132 runs,
 1 regressions (v4.14.234-79-g1cf75ca15187)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 132 runs, 1 regressions (v4.14.234-79-g1cf75=
ca15187)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.234-79-g1cf75ca15187/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.234-79-g1cf75ca15187
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cf75ca15187afbd1e23baeaa9737f7751253ef0 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4fc0db768712867b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-79-g1cf75ca15187/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-79-g1cf75ca15187/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4fc0db768712867b3a=
fa9
        failing since 91 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
