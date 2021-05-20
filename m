Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ECD38B99A
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhETWr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhETWry (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:47:54 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677C7C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:46:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 22so13074703pfv.11
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3uAdOjLEga+X/6B+BBRSaAY/7soAHDRqAWPyGNKGEQU=;
        b=aQBb2vPjD6T+23jyfaoBpoWB1nyCMghJWLLWil1Uw+iXvT98b4A7IIfjGPuq/6DkCC
         AcBu6I3t8s5J9+FzkTzaq4e9RZlrMwAvNK4qCLW+W+Nv+RFi99Nwlx0Z/DlA5J+I8Tgf
         BnLfqEncaDurf0VOlpD7N10TVqcxQt2xfTdvkHfB3YZ9KLY+5cy992cDZDqrkCfOi7bg
         2iU9Ei4H535ldDUyXy9mwVcgHa1f2TgvhtAMyzkpXgDx7RFZ6EFp10kfhG+MSc9/569f
         bO45B0Ri8Fu+t6yFycPaB9rLHhrw/8exl7ooX6VhO+ux1Y4Ax9Rcrm6GbOpX/A94Tytm
         lptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3uAdOjLEga+X/6B+BBRSaAY/7soAHDRqAWPyGNKGEQU=;
        b=NKQvwq1HFE+d6IecXBpGzYOTTms3kNfVOnXGOSTgtF6FOyH9QvlVU6ONsRsu2rMcOE
         MIss6Ffl5disrV+zIW+ONiYuv5GVf9Fn2g4fKpUK78atr+DElXFmJyYdJSqbEyi7Psuu
         muE7RMVxcBA+UhHNkXUgnrJW57xb/T7FM6lPyuTwAKU1y0/gVIlIXC4HL6Ne0QxChb/T
         FdPcNpULCewY3O0U67VKcGPs1bEdGO9+lK2BPJXuKrsNXKFYwq0RI7YS7K+N5XMo0oIQ
         Y0aYlCSj+89uFTtwjZu08HQp2+z4vxuVKUjgKnS9x8x2S0fu9NIRhxme9A+Yoijk//gR
         TiNw==
X-Gm-Message-State: AOAM533VaMdVZjokzbo83Wv2urP/eeABaKHB+CAp1dmR1k3/ss0IM4Am
        ll7nUdRRGX0IUPPhBBpNfLrTrBHsOUochUF4
X-Google-Smtp-Source: ABdhPJxhT+uxxtbuXbFATSDjcRIXryFpYSLWrhnTeoQXdFcCp9SiLshnhdllL3TqCjpwH3Jpjc1dSA==
X-Received: by 2002:a62:d409:0:b029:27d:338:1cca with SMTP id a9-20020a62d4090000b029027d03381ccamr6729186pfh.25.1621550791767;
        Thu, 20 May 2021 15:46:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y26sm2854323pge.94.2021.05.20.15.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:46:31 -0700 (PDT)
Message-ID: <60a6e6c7.1c69fb81.d8f03.a420@mx.google.com>
Date:   Thu, 20 May 2021 15:46:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.120-36-g00db9685bfdd
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 1 regressions (v5.4.120-36-g00db9685bfdd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 1 regressions (v5.4.120-36-g00db968=
5bfdd)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.120-36-g00db9685bfdd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.120-36-g00db9685bfdd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00db9685bfdde5a1c0ee90a6775c6e2d2d3c8fea =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6b6299d87524498b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.120-3=
6-g00db9685bfdd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.120-3=
6-g00db9685bfdd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6b6299d87524498b3a=
fa3
        new failure (last pass: v5.4.120-30-g8052a8ea3ed3) =

 =20
