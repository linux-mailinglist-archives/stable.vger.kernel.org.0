Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE8C3B39E6
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 02:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFYAEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 20:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFYAET (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 20:04:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26713C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 17:02:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e20so6141178pgg.0
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 17:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sNbTNJtYS9nnhN4C4014EFq/ADwCsdJr41Pc/HmHmIg=;
        b=IsO4p3IRxvMfuto3hYB4W8XcTDgTWQj8EWtRhQaVk98VUPTlJUj92yDJUQh8ebqIcV
         tP/RuTZzemcKNwimPW8iR6DjHzaB6ewX8TxTzDNGlq4NSmGdZaQn2w09QaxC6CVPYeky
         gKA0xIVsMyj+/BFERPoADWjqfmjdpZiKPz5B1WnhTLOre2KvolYCAiacDnE8kHucZX83
         fp7jwhj4eT3UrHmFsZrmnuFrhqbRTv3KZ69QHYnyLtScC7tvTonaxISwCoGWj2voLlrg
         O3cIsT+A/tz4/tPbJXY/Wg9IcgJuq97ti4Ef87gXf1RrTLz10ynKZb50rBsgiAAMgG+L
         nL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sNbTNJtYS9nnhN4C4014EFq/ADwCsdJr41Pc/HmHmIg=;
        b=Bar0hZUUsZ0Y4ogibrHehpetZJw7AHOEwMBfzUz2YIGDQ1PYNhWFTFN/QAmW2KVzzV
         R/rCxW+zFuJamSZk6wugo0ACHb69/e6fh1XO3ZXw6l8yUAbEttzoWheVNHLjnPIgdwHQ
         nbouO0ROBFjGxPV4YLErmgFnH6pGrELV3RYn9jp7r3V24YlIWsZ7TXA1wS92yLp8eovU
         XQ9rS4XptED0LatVELePNlgf9pRNqpwm9tfnuzf5yOmqxfAWiV3pk64Lpe1tJ3ewZITL
         /JA8dqDF2dYTQRDLXFogTiRJOvuS/YIubSO7kMgEW/nQHFCXmMwZJXMdGKbuYAWlGRgO
         hbKQ==
X-Gm-Message-State: AOAM5309bxCzK2Gp4Nfr4EQ9kvuGwd77fdPIOhA5hSjixC8CNKmAbKtY
        3yw/psmS7ROMVYYTgKPXTUcfY3oI6SRhyFn9
X-Google-Smtp-Source: ABdhPJzOdURmSMgZOC2YgvUcFvDgM8n/OgKEsQu+SQBwgAMTQR3uNH8cMjB1aYTLzETYwH+ONr+F9A==
X-Received: by 2002:a63:4e4d:: with SMTP id o13mr6887759pgl.361.1624579319482;
        Thu, 24 Jun 2021 17:01:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm3357937pgp.16.2021.06.24.17.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 17:01:59 -0700 (PDT)
Message-ID: <60d51cf7.1c69fb81.8e575.9a9e@mx.google.com>
Date:   Thu, 24 Jun 2021 17:01:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13-1-g71fb3603a537
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 141 runs,
 2 regressions (v5.12.13-1-g71fb3603a537)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 141 runs, 2 regressions (v5.12.13-1-g71fb360=
3a537)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.13-1-g71fb3603a537/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.13-1-g71fb3603a537
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71fb3603a537b9889b8b3bc6a86a1c058f7bba59 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4ea930d9c3f8f64413272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
1-g71fb3603a537/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
1-g71fb3603a537/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4ea930d9c3f8f64413=
273
        new failure (last pass: v5.12.12-176-g9d7145f72380) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4ea7a0d09cefad2413292

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
1-g71fb3603a537/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
1-g71fb3603a537/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4ea7a0d09cefad2413=
293
        new failure (last pass: v5.12.12-176-g9d7145f72380) =

 =20
