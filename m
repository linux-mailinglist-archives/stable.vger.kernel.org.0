Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A62909F2
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410672AbgJPQsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409417AbgJPQsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:48:22 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D95C0613D3
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 09:48:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d6so1567458plo.13
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 09:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qPYF2i4/rKscxj2cv3Dcv5wZes3P1Vvvfh5vajxEjfQ=;
        b=w2o0w5jewVDyUNZ0lLEWVPG/6EMnxS9f1eQWKvzuthzYd/Jh0sDtDdYs1PRE6Rwbc0
         nH2MJFz2nCD6xY5hNpso4cbot23Hu6cynz9FvAUOzooVoMTmio9czxDleJCbHBXa4SZM
         O0of5eMMlSk683UFxvlSzMv+7aotyM3l3yLCC7EsCfWxoXa6VC9p3buGFuMJjhNuvdGH
         nyRFbzaTjs1gE//UdKedJJZQyMqfzQXy3CqWbiQ+dTj6dBtjkxFI9rNUHr0b6MNqkG0I
         iqsLQYn8vGp/IQ0SfUky81vCQN9pvYxYiWAI/uwtRoVQ6DQgNR1vTEKbH1Sqd6eax4uS
         BxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qPYF2i4/rKscxj2cv3Dcv5wZes3P1Vvvfh5vajxEjfQ=;
        b=dFm2iQneiKio+Sf4djHR7o3N/GWzASnWfEv+X/B2voygBi/9yHU/QQa7rbh7lCEC//
         d9qfSc2FnGTx77MMMfJm1+UBP4DxmB+u1jgYwqX6WMEL9pWTSS1LqmjSi/vGsCvwn29O
         a61ZED3sgtb1sSCbY0u8lZaCCYiuQ3k7jQNJ2zwqqxnsCXuJXBENWagQ4l30ssr3RS5R
         LqlSgmSM+wc2UquA6HVSea6GcLQ3WrXHlMuvVq/2Q6rcQIpz4ox1QT50ryG2vxRxU5wY
         KV6JEQJEU/+XdwMWjuHqnFGaoONpdcqQ5JlW7+eT+UCt8Yq9O3IcjfgbAbKsDcn7xQSe
         eIyQ==
X-Gm-Message-State: AOAM5314417PZnkUzg08FVXAvS49dU7C0Z/wV+tClqEVFF/m58lpEy+5
        su03VUDTZQpQzlpWlVeRRzZ6seCO0eM3EA==
X-Google-Smtp-Source: ABdhPJx0cPs8Roz85iSbO20PeDr6JoVJtO+ptBO76fFfGXjZz3AqkwKhIz66LjQPejDLvzPPHKpRTQ==
X-Received: by 2002:a17:90a:fd93:: with SMTP id cx19mr4750855pjb.37.1602866902740;
        Fri, 16 Oct 2020 09:48:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c12sm3655602pjq.50.2020.10.16.09.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:48:22 -0700 (PDT)
Message-ID: <5f89ced6.1c69fb81.b1e22.75cd@mx.google.com>
Date:   Fri, 16 Oct 2020 09:48:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.201-19-g7d10bbd1a872
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 169 runs,
 3 regressions (v4.14.201-19-g7d10bbd1a872)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 169 runs, 3 regressions (v4.14.201-19-g7d1=
0bbd1a872)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
   | results
----------------------+-------+---------------+----------+-----------------=
---+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
   | 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
   | 0/1    =

panda                 | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.201-19-g7d10bbd1a872/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.201-19-g7d10bbd1a872
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d10bbd1a87237a93f881d8cd84dc686b9212378 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
   | results
----------------------+-------+---------------+----------+-----------------=
---+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8993285159a7b4984ff3e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01-19-g7d10bbd1a872/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01-19-g7d10bbd1a872/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8993285159a7b4984ff=
3e7
      failing since 84 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab           | compiler | defconfig       =
   | results
----------------------+-------+---------------+----------+-----------------=
---+--------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8994039a32453aaa4ff3e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01-19-g7d10bbd1a872/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01-19-g7d10bbd1a872/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8994039a32453aaa4ff=
3e5
      failing since 199 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =



platform              | arch  | lab           | compiler | defconfig       =
   | results
----------------------+-------+---------------+----------+-----------------=
---+--------
panda                 | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8996547b9ca9c36d4ff3f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01-19-g7d10bbd1a872/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
01-19-g7d10bbd1a872/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8996547b9ca9c36d4ff=
3f8
      new failure (last pass: v4.14.201)  =20
