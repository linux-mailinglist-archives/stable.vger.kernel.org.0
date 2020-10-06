Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9906E2854B6
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 00:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgJFWpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 18:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgJFWpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 18:45:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64701C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 15:45:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c6so3815plr.9
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 15:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OJ8cNntps0Kd6nCboixhK+E4D3Nk8A/3wsWG8zKoLbA=;
        b=139Kh3Of2tAvIkgbz3+f9hXX1zf5SedznFCuGLI8CWgfjNc2Q7yUyDZBXCBf3uTE5g
         6geR78Sp42RYBL2QRqXhJoABiuO5qnOhc592H9QFWmH/OeNcZ+7fPSWgAh4xe9tKXea0
         SUlgKDT/r1813B/GHkJZO40kXHqJWywVPjYl/lkWa5OD7N3kpXGjT6q6VaB7PRlqlxJP
         H7+KVU6VWltv7mSezOw9l77s4+irROtHIgWA30jMpmp/XQNjGOouYN8twz/jIRZZ0LKg
         HHn19IbAtzgPe0ehA/wtl/T/11F6IXAqcTvBREa2ShCgPpX4Ih+oXFhLBJKZwytBbo11
         0Y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OJ8cNntps0Kd6nCboixhK+E4D3Nk8A/3wsWG8zKoLbA=;
        b=qyhpTDsv7PxpMyUXRFMu1BY2A9KaXyzeZVJFeE12qRjWerD7d0XHoItK6qquFeEOeA
         Ays7qPevIIpoTmnSbWuQ4NreguHfxEeb0nKqxIJ68sC9gTCZCZxriftvoag2xg0LwWvB
         SHyzHp7ypQUZqMltIZ5DGMvrc+v3ToV68DSzLMmm/uQQjWq9WbwJj9yxneB4ecju6N/l
         p2yA2qjOFwNQgTl1gikARrAuSjMuHlNt/z9+GS8QtxbXSOI9PqGsp1NZAHuigZk9T9mI
         n+aldxONiCw6kM/PPWeW1+FY8MHouIKAQZRKiA/QVPn2dVFU74XNQw8yw1kPnzOUbQ+j
         hTAA==
X-Gm-Message-State: AOAM531YUOl0ZHpYNxlUOdz5QFGfMle8/WGtn4Ta1IVu5xwG7JXsQHzU
        MRkZ/1HzmHaGvS/TlQhuaK6SeODc1Fbxnw==
X-Google-Smtp-Source: ABdhPJzJIvmJCC2u6i++aHMaTS6M6TNEMh1U8OHQfzuxMSAsLDiupVwIiD0T6bKAceruRsW/V6Rl0Q==
X-Received: by 2002:a17:90a:5901:: with SMTP id k1mr272440pji.33.1602024310505;
        Tue, 06 Oct 2020 15:45:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g126sm251193pfb.32.2020.10.06.15.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 15:45:09 -0700 (PDT)
Message-ID: <5f7cf375.1c69fb81.ad93.0ba4@mx.google.com>
Date:   Tue, 06 Oct 2020 15:45:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-38-ga522b131350d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 119 runs,
 1 regressions (v4.19.149-38-ga522b131350d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 119 runs, 1 regressions (v4.19.149-38-ga522b=
131350d)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-38-ga522b131350d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-38-ga522b131350d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a522b131350d3390a42fb6fa7fb03dca7f840f11 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7cb0830ebb2e7f5f4ff44e

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-38-ga522b131350d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-38-ga522b131350d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7cb0830ebb2e7f=
5f4ff452
      failing since 3 days (last pass: v4.19.149-4-gb110045ffdd5, first fai=
l: v4.19.149-4-g55b73b3448d7)
      2 lines

    2020-10-06 17:57:30.275000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-06 17:57:30.275000  (user:khilman) is already connected
    2020-10-06 17:57:46.576000  =00
    2020-10-06 17:57:46.576000  =

    2020-10-06 17:57:46.576000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-06 17:57:46.576000  =

    2020-10-06 17:57:46.577000  DRAM:  948 MiB
    2020-10-06 17:57:46.592000  RPI 3 Model B (0xa02082)
    2020-10-06 17:57:46.679000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-06 17:57:46.711000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (373 line(s) more)
      =20
