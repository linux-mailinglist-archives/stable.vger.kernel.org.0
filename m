Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E4B3A037F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbhFHTRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:17:55 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:33550 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbhFHTPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 15:15:55 -0400
Received: by mail-pf1-f173.google.com with SMTP id p13so6906631pfw.0
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 12:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YxQSusmx8T5L8S7biIXV1dXxO+941V6yVdwZYVYn9Ls=;
        b=s8wMkRBbtHIoaBlXU3Tsibz9fJHt3qAgmRZnOytvmKJtq3f7Smrs3VdvKoUaVCchog
         67RL8XvYiecbaKXGBtTmWZLmDv/r+7aGhe69IFVVhqhbDMKtyNgTS88q3cNNiWa8oQaA
         hpUJIN364gcTzADNOTYejCaVBcQgcStsd0VKD4rxUGPlptpk9zzVADpWHd38o2JeU/U0
         SgovR1IR5lRfqQOTCyE5NzQEvmZcFgplcWy28C8htSz9vdBJ7DLi6gdELKYYI3I9KdLZ
         J1hpNXv5EFcTXaor6m5BbmSX6l7Q5lFPXf2jhhLUGQVaEZQyrmVNo/pXATlCb6Kcuw7I
         vgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YxQSusmx8T5L8S7biIXV1dXxO+941V6yVdwZYVYn9Ls=;
        b=OXrBM8MkP7nJFZ8+kgW712PaPLAGAikGsSQkU4PtfMgFp3MTXVQosBTLBN1y5aZvKw
         68d0hHSUVU49A+NLZ4nbQ45Yk1Oktyw6eBZ7lyCpISWlgmCsWDPITZv/lRMtqPdX+30B
         WJUB56EnApO2foY208XswR6407+MQxhTg5cveRuVBqveCrXVbOwoONMyYgTBWsoE0TTd
         xHBO0mFcjL4Kr8Q3QAa68fddE4cWxVNWj40EVbkfSxs7CeioYO9AniUQh2oLP0zz7aZ7
         bLP+wwUbujgVwYQJnuvz0kvi3PI3eB7qo6qxAfV8oNH5wjPNqdwEq2aNjS0uv7MJ/JcA
         TuuA==
X-Gm-Message-State: AOAM531I8OzVa/tyhxVU5Qm8e2Ug5ZMB5gujIIA66BUbWhyuNXqbtsdy
        aZbKqUkn8VAa/es8cYlE2LPQ5dqqwtIp+lGg
X-Google-Smtp-Source: ABdhPJw0kbcvi0/zN/zm6qEeKC/zuTS+RVlM4pDH/uYWdjLbf2srXjWAbGcdA7O2DqliFIdjiTFs9w==
X-Received: by 2002:a63:1022:: with SMTP id f34mr9117161pgl.334.1623179567949;
        Tue, 08 Jun 2021 12:12:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 60sm16151663pjz.42.2021.06.08.12.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 12:12:47 -0700 (PDT)
Message-ID: <60bfc12f.1c69fb81.625f4.0978@mx.google.com>
Date:   Tue, 08 Jun 2021 12:12:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-26-g02688240b8ec
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 135 runs,
 2 regressions (v4.14.235-26-g02688240b8ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 135 runs, 2 regressions (v4.14.235-26-g02688=
240b8ec)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig | regressions
---------------+-------+---------------+----------+-----------+------------
hip07-d05      | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-26-g02688240b8ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-26-g02688240b8ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      02688240b8ec6e0c75cdc65fee1f79921235b56f =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig | regressions
---------------+-------+---------------+----------+-----------+------------
hip07-d05      | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf880e19e289726c0c0e10

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-26-g02688240b8ec/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-26-g02688240b8ec/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf880e19e289726c0c0=
e11
        new failure (last pass: v4.14.235-21-g36ad1594e5ec) =

 =



platform       | arch  | lab           | compiler | defconfig | regressions
---------------+-------+---------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf8b330e40eb5cec0c0e01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-26-g02688240b8ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-26-g02688240b8ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf8b330e40eb5cec0c0=
e02
        failing since 99 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
