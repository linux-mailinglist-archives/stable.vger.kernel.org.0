Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E431D25A
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 22:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBPVtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 16:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBPVtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 16:49:51 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93763C061574
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 13:49:11 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so7051946pfk.1
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 13:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0D7LSRc37RLXqYdrh4ro6vmhnKXmjwvXix9caYj7PQ8=;
        b=F61FuQsy61ajX1az4Yk53h+q5hB9p+O2cjIoZIbCtzXGdiJ3HpgmM1IrtkjJfZCdm/
         NA48FbzRDN27sGKaSEv4WOktO4ADyvUjC7R33LFjP5WUAriRUJxKrdjq5XMtVxpCdun1
         f8cH8nCHaWe58oGjH1Er32fBw7jJXARkGfRm2qrC/9/xUgItY2nRrBVOisD7hzNcwjwM
         C/wXH2vnOwon9HtTTbwO6+HHVq2DNaCz2WVui7axheyLmL9Jjqxaf99UhRc0vU5sS3+U
         dvg5Mr7/yqS5j6ALgMgMeESsRhK2WqoikKRQeKfaIY80v+pn2H2rrj4HUpz0ZexA/85V
         3QAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0D7LSRc37RLXqYdrh4ro6vmhnKXmjwvXix9caYj7PQ8=;
        b=nRiWf3pUW+vbgzMvo2IxP6asGrI2F8Jmntl4OC4ut6gMU9eBRF8eby7yBflCLQs/KG
         p7pQ15DIYaJGyYNxkoiM+bHXGoo81QSAMxoECxyQ8o2mORtp4zl1dN/TfmxL/4Uiq212
         TetBFya0iReHXyjewZ7q+Fxvz3eUi58adDFD8QQvWD5AqhQOeAS+YgOriW2w9gsmnFs0
         CVG33g9zv+nXnW93N8CrS/OY1drj2//N154hqOeUOR7kILSALHguUYFN7RonJ1vSq6QC
         up2wmw9YihNJM2rdH42zJAkGqTemwdCIVFvIJ5zni4QODTISu3A0IC6Wn/HgJVAjddtq
         OXFw==
X-Gm-Message-State: AOAM530b5ef622gVLzK2zCi9CruclPW0IXqF7ziQq5unz7YxEjCdVdGi
        nRaXVcarveCOsRXGTL68KtJhnJH4axsB1w==
X-Google-Smtp-Source: ABdhPJwiSBxHQu4s6GS7x1m2cc2uC+rqhK1SPLa031FzsNro72lRol6ztiyH/LRcOmASAXfAwlrMoQ==
X-Received: by 2002:a05:6a00:1582:b029:1bc:fb40:4bd7 with SMTP id u2-20020a056a001582b02901bcfb404bd7mr22142536pfk.41.1613512150796;
        Tue, 16 Feb 2021 13:49:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm3533491pjj.35.2021.02.16.13.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 13:49:10 -0800 (PST)
Message-ID: <602c3dd6.1c69fb81.231e1.851b@mx.google.com>
Date:   Tue, 16 Feb 2021 13:49:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.16-104-g1cbf162ff83d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 108 runs,
 1 regressions (v5.10.16-104-g1cbf162ff83d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 108 runs, 1 regressions (v5.10.16-104-g1cbf1=
62ff83d)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.16-104-g1cbf162ff83d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.16-104-g1cbf162ff83d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cbf162ff83da1f3c47917485cdf392fd5ac3060 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602c0d27596b611dd9addcc4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
104-g1cbf162ff83d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
104-g1cbf162ff83d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602c0d27596b611d=
d9addcc7
        new failure (last pass: v5.10.16-104-g43b9ec198577)
        1 lines

    2021-02-16 18:19:18.226000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-16 18:19:18.226000+00:00  (user:khilman) is already connected
    2021-02-16 18:19:34.376000+00:00  =00
    2021-02-16 18:19:34.376000+00:00  =

    2021-02-16 18:19:34.377000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-16 18:19:34.377000+00:00  =

    2021-02-16 18:19:34.377000+00:00  DRAM:  948 MiB
    2021-02-16 18:19:34.392000+00:00  RPI 3 Model B (0xa02082)
    2021-02-16 18:19:34.483000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-16 18:19:34.527000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (388 line(s) more)  =

 =20
