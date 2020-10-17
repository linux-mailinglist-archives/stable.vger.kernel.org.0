Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1862912C0
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437374AbgJQPrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437369AbgJQPrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 11:47:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B154CC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 08:47:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v12so2787862ply.12
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 08:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=77tBuMbzQ88BfO+4ECVLTdtIGtyFBc81hm/KlEeuktc=;
        b=uN3B8poll7SyqoyPs9McS7gHsHE0doaSJ8r20mjbgbO5p4Rd32qLqOD6o4Yzxo3qg7
         kywAt0gUCwLsm/pJ3SwiG0Mue5w9DHAN5xRhfdVEkLHeriz2Q0MqXx4ZV3lWZxxT1Sic
         3pOcG1p6wzSWEQ2BJN29ubBveqSyeZu/iSvhFPj5w+e4BtrvK/qA4ru0R17ZIBfvpIhA
         qzmHWtvXMN2vsGZuLWXW5WrFZS41EJaaMgaOskC2s9NlEsz23zSojpaAAJaUpX3Ubt6G
         2Bwz/H91FKObFeJTwu3BKwj/qlVoHyLPti3TUZoCqo69sBzLfue1kkNYJaL/SqihGtBu
         f2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=77tBuMbzQ88BfO+4ECVLTdtIGtyFBc81hm/KlEeuktc=;
        b=ovcYo/yW3BwWfr7hJNdrKU1+CSDLFnLMUtVA6LVhYRDHMBlQ/jVVfCrcyquGvDEHo4
         MTwBk2TFIYvMGc3mcs65jIhHxGYbK/UG2C+wemc1s9HPduir99+7kyiN/r0/YOcNTUjb
         TL0jgC6GcdSHgqqntcG5zXBzYzkqzekCwz8kpW1m3mPJbLOz8E+PTUoxvIdufHVR9XVx
         TO1xPYnU1L+qzUVsf0mB0+yCGboGW1nKmz4b8MZTI7mGdzv9yQuq6AZszlrNGo4OL13Q
         trPiLnoN8FyoKxf8McpgSgiCJxRfYEycK3/wrrWSxu4pr25GKK00yTqaOGp0R118MAXY
         FTZA==
X-Gm-Message-State: AOAM533ExwV0I957qK57rDN0EYjdeAlk37Zta++d2hNMeAXhl6Ua9vgz
        stThZZAkwKK2hL0OCf572QfWFAG1WQnlbA==
X-Google-Smtp-Source: ABdhPJx2580edtjfzB5j2c23HwqC8BPCiz6n/hM7i/F3Tbc2poNRt+92aa05tooByCyf7SXXGKam7w==
X-Received: by 2002:a17:902:b7c3:b029:d4:bc6e:8aae with SMTP id v3-20020a170902b7c3b02900d4bc6e8aaemr9533565plz.12.1602949659863;
        Sat, 17 Oct 2020 08:47:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm5892190pgl.67.2020.10.17.08.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 08:47:39 -0700 (PDT)
Message-ID: <5f8b121b.1c69fb81.aa571.c6a9@mx.google.com>
Date:   Sat, 17 Oct 2020 08:47:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.152-13-g2b9cb7715a7b
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 184 runs,
 1 regressions (v4.19.152-13-g2b9cb7715a7b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 184 runs, 1 regressions (v4.19.152-13-g2b9cb=
7715a7b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-13-g2b9cb7715a7b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-13-g2b9cb7715a7b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b9cb7715a7b947a4197f0506a4784e2a75295b4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8ad553e14129ae914ff438

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-13-g2b9cb7715a7b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-13-g2b9cb7715a7b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8ad553e14129ae=
914ff43c
      new failure (last pass: v4.19.151-21-g3d5eaa44a9e0)
      1 lines

    2020-10-17 11:26:29.790000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-17 11:26:29.791000  (user:khilman) is already connected
    2020-10-17 11:26:46.531000  =00
    2020-10-17 11:26:46.531000  =

    2020-10-17 11:26:46.531000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-17 11:26:46.531000  =

    2020-10-17 11:26:46.532000  DRAM:  948 MiB
    2020-10-17 11:26:46.546000  RPI 3 Model B (0xa02082)
    2020-10-17 11:26:46.633000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-17 11:26:46.665000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =20
