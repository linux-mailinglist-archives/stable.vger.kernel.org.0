Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C0C26206E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgIHUMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731141AbgIHUKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 16:10:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D06C061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 13:10:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b16so171644pjp.0
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 13:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WyE6uhWME3HwiOc9jPZ4NED6wVNmBcFSU0BVPL9gTno=;
        b=Hd4KTTuzlwy2oP5iMIXhph6pDYKJIL+48HNWdm1FOqY1qBrQcCFWC4rFdamHm3sEmO
         KuFq5x6DRR6cNo1dRWx5Z6K718hAkwxJYZQF0wOtM9k9S/rgJjXBbc+4tcKgToSs6RWo
         H8CZIiwoQ3cGbqGlfF1aHDKaFxrkvByznBOzDs/pZFfJ9s7vrKjvX1nqxVv8nzQWJX9m
         OG+K1wI8Jwn8VMVEw+sXGYgm8a794LeDfQVtuXMJ+VV68e+IqbNGqVGaltLHbCRkQJbY
         gRfvvFoIQVpzheAR12eyo8AJfIf6qpijDy1ACXk2pLe46TJGlOeM+5z89NNasbqyX0dn
         ourA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WyE6uhWME3HwiOc9jPZ4NED6wVNmBcFSU0BVPL9gTno=;
        b=dLRcLEf7B8NT154OvnIW+Z0cV2IfCOtHa9Z8m/GanexsGjXgW4RJExWla+KbUrsDw0
         KFeJpHExYu2g5fRwsSagYKNDn47VNxU/dvPLVPsn3MggiX8Sllu3jlEi8wH2A1ABUeV/
         6ekeEvKbH6/XBdZW27JU0vcuwJY50VS4uXr2RdMmrFjLLqndOquMzy4vLh5ytTRJjX1P
         kQXAaQ4sSGTgiueAa1QKD+nphrduZF04+jeniAqxSd/Mhh/Q5p7IMkbh9BEsnxAojWTn
         NZFFIm0rAcer4W9cNBrZL+mckQlMDWtcs7MFDgZi+ie8etCDBxXc4+1D1WYt+b21LtTx
         TZTw==
X-Gm-Message-State: AOAM531LxZnKisaZ5K2gCjKtS/x2dW/fXe7cZl1QvnzWa0e/ZcgsZ7AT
        6MqgdfMUNo27mgojaILvT9ZR6B7gbt1Jsw==
X-Google-Smtp-Source: ABdhPJwO22udBCumEjjbNo74ryf3qv0mpRShJjonsAY05O2FmXqphGndy5/fjvhJyaPCmiPOELjN6g==
X-Received: by 2002:a17:90a:8d85:: with SMTP id d5mr423098pjo.45.1599595843267;
        Tue, 08 Sep 2020 13:10:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g192sm242018pfb.168.2020.09.08.13.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 13:10:42 -0700 (PDT)
Message-ID: <5f57e542.1c69fb81.e6fe6.0dff@mx.google.com>
Date:   Tue, 08 Sep 2020 13:10:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.196-66-gd520aac0cd79
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 135 runs,
 1 regressions (v4.14.196-66-gd520aac0cd79)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 135 runs, 1 regressions (v4.14.196-66-gd52=
0aac0cd79)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.196-66-gd520aac0cd79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.196-66-gd520aac0cd79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d520aac0cd79e557dd7d2ae06370d104a9f48645 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f57d2d96aadc99284d35415

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
96-66-gd520aac0cd79/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
96-66-gd520aac0cd79/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f57d2d96aadc99284d35=
416
      failing since 161 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
