Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3B38F287
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhEXRwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 13:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhEXRwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 13:52:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF73C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:50:44 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so355942pjr.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NtiDQWsVzs6Vn1oB5ar0WNQVtmLSwrbNgOhwgf1xTH8=;
        b=w4QduC5QashQJiNrCsCeMH7Vbfp0/2VlzKYSaIQ4zuJYzQ4INAHl5PYBcBqOfSkJsk
         n5F889DyTqN0CioaFY6D4wOKruZBYOpwbP1+xEK7V44nRXMYzQ2Hf9f4hGzwj9Ij0exK
         m1IVAmmx9wsIh+m9XHbyp3OAd0nMsEh38WoCtGK7MyEUq6AokeV5wn3xqABRjMgZUaii
         g3RcmjBHaomqB9yGqIzDQiNYGqo4w85vFlAoxIUtQImO45aScG8JjCFFGZwCDF0TfbOr
         5/zw9KK6EpYYYjVUjBuBXX5e65QbabPBPchgIcB+HiybiH0nq8aeK9QqZ2VT8M1j6mnn
         Gv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NtiDQWsVzs6Vn1oB5ar0WNQVtmLSwrbNgOhwgf1xTH8=;
        b=gjzlEMgZef0385Hu/McIIG72NCoxFqpAmX9ZOugYEC6zO6ds7jozdr8GpUzIVbJk7M
         qO8WuSVtRCjSCMMLROHdn3anjrTsX383T+Hi6xbDstaAN5Pq1xK69pK9kJ3dKouAJBiv
         tubOzoutAxuoiOsZx3c4mIf6d5Fr9eZ+QqgkCKtXKjosaf+dlYd/ItOFlwuFizCbUPCw
         lJs9zXYzYANM7wATIaaR4pavzLogUSubdNASMNQ+G4pgngrzDGNEDn8ChXVWONoI4/4W
         h2xmX8Om2IYDuT0L3UbM+JcqSGeaAWFTyi71DmDbXioM32p9k1haY1NTDZorQgF+B9Eo
         D0cw==
X-Gm-Message-State: AOAM532UmeCiTWRy4/5xIX2teO3R8ZilyEW08YEu86tqvo6kfr/jOs3Y
        WLmtIdQjtI8NtnAiGa+1kOQOG9Hk4awzQBUe
X-Google-Smtp-Source: ABdhPJwCMbnJVWmxCV/JjjAnyyJYYKdp0VLg15hodKYvlKwYeJtXQfWtKtRP1IjpaFmnsJxv9OF4Vw==
X-Received: by 2002:a17:90b:4b0c:: with SMTP id lx12mr17862012pjb.88.1621878643728;
        Mon, 24 May 2021 10:50:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r11sm11662938pgl.34.2021.05.24.10.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 10:50:43 -0700 (PDT)
Message-ID: <60abe773.1c69fb81.6e4a2.6683@mx.google.com>
Date:   Mon, 24 May 2021 10:50:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.39-104-ge6a8e1f816d9
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 108 runs,
 1 regressions (v5.10.39-104-ge6a8e1f816d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 108 runs, 1 regressions (v5.10.39-104-ge6a8e=
1f816d9)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.39-104-ge6a8e1f816d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.39-104-ge6a8e1f816d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6a8e1f816d9047f329ef3a093d26f9cadcafc7d =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abb4f0b20907cdc2b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
104-ge6a8e1f816d9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
104-ge6a8e1f816d9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abb4f0b20907cdc2b3a=
fc8
        new failure (last pass: v5.10.39-72-g588486aa172f) =

 =20
