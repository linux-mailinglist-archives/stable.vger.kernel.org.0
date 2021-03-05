Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5412232E082
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 05:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbhCEETQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 23:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhCEETP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 23:19:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC30C06175F
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 20:19:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ch11so1131941pjb.4
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 20:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=++9jMs7yDkttmTIsURKXh055y8AzbP1PE04SPp6bHe0=;
        b=JT15K4hQXo9MaiRxmUNaz7+cql21pLoHCBlzwmBbMU+TVqJrUKZf7Euo7mXZfeDByo
         Tus5s+fdFe6x3NrNk7B/NT3D95I/R+wCaurog5cQSUW06QxXDF+dbn7N0sEGsLpolxDy
         Ku/fo8udbTAZA4YrlKjBY5teo8u5vCEf5vzKCAe0afvVbKyPjOl1pNc+6xEoUYEnXA8m
         aBxgD0o7j1YUiUz8/Ss+2jbNRaUfwROXlMNL9x3yYaBkfhr4kj4YL/3tZ9kejfYJO3qz
         VfYY1Ia2mxM9/KUesQfUygk19U3bI9jvFUgF6i30XUJkOiBnrFltqol8N8dktQ9Iwv+J
         genA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=++9jMs7yDkttmTIsURKXh055y8AzbP1PE04SPp6bHe0=;
        b=IgW47aO0yXwvWOl4y0sanARtd3TB5Ddx6V4AJv+m1PDtYhIVaK5h5BIjxt0cBVzcXJ
         vl7NN/7Z2JEGqRA2RTFYr/bZcSWuW1OgTJWIS0whsiPUaN8x/Fz38Q+BpZxJUY6minDk
         436nlLAOZmScLR4GYlufyY21+x+UC3Zc/VI0CZUHSv5UsNCXEkeLvzMS7wtI/pixNJJr
         Kdtup5nGBhAygvsRbaBQQm1skNIw9KP90eiqRFonPfdJmEN0+I0/pM7llKjQ5QZNHqXV
         gvdoh3YSkrDo75VqDmlRvCa/SD6kXkGS9yf1QoySgZGHU34UP22lDKz+sq7Tr0/XNcWE
         7njw==
X-Gm-Message-State: AOAM532Nea/X9oz8tJdYZbrebjrYulZIKRtQVbpDIxs8wRvqK8P2xCe4
        8ofAWWnvr425rNBnFGvj7Trh1WOLKFoP4rQJ
X-Google-Smtp-Source: ABdhPJzFFDvsP2cojdDhwzJlO8pSj50KPZ3IY0LYXrCMJTht0vVEznkMqN6767sGiTHz1oO/lEkYEw==
X-Received: by 2002:a17:90b:609:: with SMTP id gb9mr7920183pjb.209.1614917952680;
        Thu, 04 Mar 2021 20:19:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm719850pjv.18.2021.03.04.20.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:19:12 -0800 (PST)
Message-ID: <6041b140.1c69fb81.9eba1.3516@mx.google.com>
Date:   Thu, 04 Mar 2021 20:19:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-40-g925d40b7c48fb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 120 runs,
 1 regressions (v5.10.20-40-g925d40b7c48fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 120 runs, 1 regressions (v5.10.20-40-g925d40=
b7c48fb)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-40-g925d40b7c48fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-40-g925d40b7c48fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      925d40b7c48fbb529c095de3d9e214e9cca06b8a =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60417e64ae1a7c73e7addcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
40-g925d40b7c48fb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
40-g925d40b7c48fb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60417e64ae1a7c73e7add=
cb6
        new failure (last pass: v5.10.20-35-g4637f55e38e2) =

 =20
