Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02C43182E8
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 02:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBKBJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 20:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhBKBJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 20:09:24 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BAFC061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 17:08:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id e9so2319917pjj.0
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 17:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gNbpPXGc9HQCxazZ1sX2/+kVZ8qRb4DUa7MApb/AfiE=;
        b=tbWTClQyxjkwrl1SaOOzUjy0EWJzAmfSHpns4BKvvYK+gJz+sus9Wz8vx5APXBxyWg
         FNjEx+fcqQWfDko5da9ZBtfdiYDBV3kgsGZcurMOR626kR2iNd2MSMubxzn9ln0u67b+
         I2YU4P6Ru7ImYI3nl787A4AtzosxyrZ6/kYGtQtVUzSBNhsTy78negDOYavOQXQ/MRQm
         XrVZgzQ5bJjXvDk0eHVubf0ohuBjAfBR2uUPDn2ju/DHULr22ruxgeNVm4+NKbLvHLUQ
         V+kzQ0leENuzCgxievKHHaQXlr7LzUTemHKSZ0UvIE/IypNHmDb9kSJi9aykodNt+DRe
         Fy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gNbpPXGc9HQCxazZ1sX2/+kVZ8qRb4DUa7MApb/AfiE=;
        b=sY1VJtwhpgOYia7gTI4uOT/8hJ7W/vRSpdD6Esd5RgTzIlK7PX967bXvaAq+XhBHrS
         07Hh7206b0W+F3AZQG1CbbgBXjday0hhJ6JqD6yl8l6UOqIUhVXtlbvTtNwxVeIeMVVw
         bbnSmjGVkvWKO7DOTB4X+B5IBmzQyEo4BmVDG0XIK+XBUNGBuYmvLOJ20WZXIFQ4yI2S
         TvvP/LUJpaVWBuE3HeuUZlad5IRk6YaEpOgiuWtdQf91z12zmKIxo7o+hY3EoglP+bZ/
         Jr+0DJy+cXJgw87Ah+cmhSjJUBtK3nQjE2OniC7Ay+sdm5XPbp4NHiKIoy09wBXWKB9k
         Bsgg==
X-Gm-Message-State: AOAM533A0lN1HszVwtfXlUAgEXuHMJ2UdRaYsEJJqrvAa0XNLUjLBtf2
        l2ahznpyB1ztwMn7AamXzF8eWtHKRLt/Dg==
X-Google-Smtp-Source: ABdhPJyUED6dZRByDszVWhlOxGfVZ5R2yss0QKm9mYi0xLXd3Ux9Amm2VUTCGj4JuapL6AHJ4SeFEA==
X-Received: by 2002:a17:90b:33c4:: with SMTP id lk4mr1616251pjb.157.1613005723296;
        Wed, 10 Feb 2021 17:08:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15sm3154591pjc.46.2021.02.10.17.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 17:08:42 -0800 (PST)
Message-ID: <6024839a.1c69fb81.e4abf.7c5a@mx.google.com>
Date:   Wed, 10 Feb 2021 17:08:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.97-19-g43dff312b4de
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 93 runs,
 1 regressions (v5.4.97-19-g43dff312b4de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 93 runs, 1 regressions (v5.4.97-19-g43dff312b=
4de)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.97-19-g43dff312b4de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.97-19-g43dff312b4de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43dff312b4decea24bf33b1b21651642d753c349 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602453005c82bcf8c73abe68

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.97-19=
-g43dff312b4de/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.97-19=
-g43dff312b4de/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602453005c82bcf8=
c73abe6d
        new failure (last pass: v5.4.96-67-g5c086907ef220)
        1 lines

    2021-02-10 21:39:07.274000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-10 21:39:07.274000+00:00  (user:khilman) is already connected
    2021-02-10 21:39:23.021000+00:00  =00
    2021-02-10 21:39:23.022000+00:00  =

    2021-02-10 21:39:23.038000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-10 21:39:23.038000+00:00  =

    2021-02-10 21:39:23.038000+00:00  DRAM:  948 MiB
    2021-02-10 21:39:23.053000+00:00  RPI 3 Model B (0xa02082)
    2021-02-10 21:39:23.144000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-10 21:39:23.176000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (384 line(s) more)  =

 =20
