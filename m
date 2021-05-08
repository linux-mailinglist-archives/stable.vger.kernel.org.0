Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995EB3770B4
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhEHImi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 04:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHImh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 04:42:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2379C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 01:41:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i13so9685996pfu.2
        for <stable@vger.kernel.org>; Sat, 08 May 2021 01:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eHApP1UBPfJo2xTeGAvgus2ldqsS4N3oZU/ItBJP5SU=;
        b=SfTiQcT/IDuV33IhQzMTLpC8gvtny+sPoMlRTcoOVa3xANrVCzuWjC5A7wBMI1W3BY
         ZqjPayJBHGOum9GbubHtNlxA9n5JvcHe2KqadAOUUmB1mZkVidJ6YdhaW+ooN6m/U3nP
         849XuyuTxIb4a9ikdaSULWSaVZotyeTIRrcy+98XyaVjCR76X5Wt6ypMCOzjg0RYxLwn
         o8u7Jhm6ooaZZqDMkrWn9WVyT5xlpivVevM0LlNbzGOE8Y+MAw8mEuVYcOK4kqMCK0L4
         5MY5G+hpmDOKIqHJSPT6i1Lk3wjYBr9ZhsSosYiNonU2haTLA8Lf+wWoTlml8YBoA9zj
         Gz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eHApP1UBPfJo2xTeGAvgus2ldqsS4N3oZU/ItBJP5SU=;
        b=Ujx/Zxp9/VvQEmuH9R6wPfi4xH+wlW7HkASGwyITjEDSJDcWug9AR2cbsujwzieTFz
         QAEeEGtw67I5tpapTJDZKciNNgHRVcuwCmrtIRL9eWV8YYmverRtdF2t8zjb7HWAOIGW
         gNQBbv40WEgfNYl+usGBmOv/SYHddJMGWMUnsKUE/lBq+9Dvy71JrKZOa/4f9ziDL+Bf
         +gdd92w7zm6bvHSr1h/QTJUfL3dgMgApCEzyvU427zKi2k5Az3B1a94NNJxnTeAzXHns
         s/iGNgEaiy+CkoE8DuHj0N4rVL5eEAvwTJ6+TvZdV8qJxwoiGa3omBQRFKAsBhM4p6xQ
         +IMw==
X-Gm-Message-State: AOAM532AkaxZ51e6DGDnJS0Nw/UCqmuCtqnO65RqfIZFMoK3DewVKguE
        y4+DDkpKaFNuuBoNZ7rD/XuzsZFiRKeG3t9g
X-Google-Smtp-Source: ABdhPJzofe1iraybB3rsR7gFMVh384SoivqXqXA63KmJBsPjfqQ6HeNEFNMOp/P2PbOOm3ShF7KSUw==
X-Received: by 2002:a63:da0a:: with SMTP id c10mr14590298pgh.255.1620463295014;
        Sat, 08 May 2021 01:41:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm6058836pfv.6.2021.05.08.01.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 01:41:34 -0700 (PDT)
Message-ID: <60964ebe.1c69fb81.9441e.3359@mx.google.com>
Date:   Sat, 08 May 2021 01:41:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.117-124-g2d45ffe1b8b8
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 142 runs,
 1 regressions (v5.4.117-124-g2d45ffe1b8b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 142 runs, 1 regressions (v5.4.117-124-g2d45ff=
e1b8b8)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.117-124-g2d45ffe1b8b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.117-124-g2d45ffe1b8b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d45ffe1b8b80287a0bb2bfb162e17b7bc96287b =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60961b891bcf01d9896f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.117-1=
24-g2d45ffe1b8b8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.117-1=
24-g2d45ffe1b8b8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60961b891bcf01d9896f5=
468
        new failure (last pass: v5.4.117-37-g3ce53db340367) =

 =20
