Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B766B22049C
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 07:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgGOFrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 01:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgGOFro (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 01:47:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487CC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 22:47:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b92so2413984pjc.4
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 22:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BGq6OmcluwIUh62RFcp1HE6MIQZZtTZdTaJ3UCnx/bE=;
        b=KSMpVgT7vb8EiSUOcwBO6W1b9tK+Nt42pMSD/DlOLcBv2TO2rzNvqHJ8IR7DwsWWxw
         0wI3WuAg3AFH/UfPteqZablEr3JumnNt/Jv78yvM7FrNqPHEddn/HVEu3auy4ZT9FBQp
         OeINYiJUEf5zaWG+IOc6hM864i4vWjjj6vm6u+dRAiL4IFZdlbuJ7k6vPPsYNn4uW1xG
         oPVAiop4gL4a2016sNt/jlPb2LO0hPgUjREhxIzWh7wJhF5GBWsU4GUQXmdiQH6GwrVo
         TxKrG+maqDOY/w/FWLYgon9Hrqp2gr8ptwIg5mYwzeEJqCObdf0nMe+qh6ONuFbkqcSO
         hivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BGq6OmcluwIUh62RFcp1HE6MIQZZtTZdTaJ3UCnx/bE=;
        b=a5nyzcz+MG7veXwiX2xEWkZXTifBKns5WjmWgVB5w31dFTGq5mkZkhrxz5i+Kkuu//
         6qsGFV6A6isVB+PgFzXchO5hW3Zeri+9dvmAJZHj1Nm0EhEIiwBbsmatViZWglp2EpPU
         L0Kujb/g9xSJ73tAphGJriM0iTemsrefTncRTaECTL/bboHBHitSssXf7Q90QYZOSjd9
         HjYVqIvAnCfvxgMM/tD6uRa7Pfw12cXozelYWb3/KDA6OuPUFLJE19JGYxADjCfs/74o
         qjovn6kW9IDIxMdv6M1o8LTB7cjq7dgw7pR/M3SXDjB9wxlilELoY6WO9B9DxYPEtrjr
         ohXw==
X-Gm-Message-State: AOAM533edLX1+6Lbhk7XnH862rWZDw+YFVeoAnI+KNXCR3h4sB2fbtZp
        EKycYPUcMZsV4retZqj5io/f5lzUIFM=
X-Google-Smtp-Source: ABdhPJy44J64Qq77wHi8XRF1pH56xmnQ1nwXFutkmiVGRfJzDNnrKkYSHRfP+YI7wSjcCRv1x7Lbpw==
X-Received: by 2002:a17:90a:ba05:: with SMTP id s5mr7780551pjr.132.1594792063831;
        Tue, 14 Jul 2020 22:47:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm907948pgb.82.2020.07.14.22.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 22:47:42 -0700 (PDT)
Message-ID: <5f0e987e.1c69fb81.93420.3586@mx.google.com>
Date:   Tue, 14 Jul 2020 22:47:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.188-41-g729c22dbf5d6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 111 runs,
 2 regressions (v4.14.188-41-g729c22dbf5d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 111 runs, 2 regressions (v4.14.188-41-g729=
c22dbf5d6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
sults
----------------+-------+--------------+----------+--------------------+---=
-----
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig          | 0/=
1    =

omap3-beagle-xm | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.188-41-g729c22dbf5d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.188-41-g729c22dbf5d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      729c22dbf5d62267c3d938de1e86f741b73a573e =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
sults
----------------+-------+--------------+----------+--------------------+---=
-----
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig          | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f0e603a86a37dc95c85bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-41-g729c22dbf5d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-41-g729c22dbf5d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f0e603a86a37dc95c85b=
b19
      failing since 105 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =



platform        | arch  | lab          | compiler | defconfig          | re=
sults
----------------+-------+--------------+----------+--------------------+---=
-----
omap3-beagle-xm | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f0e65c7480a1419f085bb29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-41-g729c22dbf5d6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-41-g729c22dbf5d6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f0e65c7480a1419f085b=
b2a
      new failure (last pass: v4.14.186-78-g27e703aa31e4) =20
