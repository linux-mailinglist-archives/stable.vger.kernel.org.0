Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC2282C27
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgJDSD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgJDSD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:03:27 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F28EC0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 11:03:27 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x22so4974826pfo.12
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 11:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TVTof+A+yoSDiofoQCd5VaYN7QgapE8M33EnshgsdsE=;
        b=HRWuPCvs7biTypf07gAcDKbbWme/voNsziB++zfcr+uLWm+qFoZChHrNmhpwGxDdyl
         eS4n847Efnq1w2y3NVmqeJLyI0b+8Ko15Tkp0jI/vVjgvlN5yFrfnB4SbF32xneugQKK
         MMscFsBqFhRjOwWz8LnQlULl/bIvN52FdV493I3JxZX6Kb9DPO7TFraiVBb1fXb2DIVj
         T1vBPhLTN3NNmAxP5ZcY3M/l0wf4ghYXfWBsmAapSYD9V4HDdIzSJUBwxj50ySqH2Ynz
         cGmZAzOwf4tqTNAi7VqQ5jXwgwq3UW8pgKc1N0YW7BRdY0xA+uf7cPA4CJglgXNOAvV1
         0B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TVTof+A+yoSDiofoQCd5VaYN7QgapE8M33EnshgsdsE=;
        b=pYW/VafLPcSEz6REurNxbyJ8J3gqFjw15gx5Bbx9Bcbm/aZL00rjUQHGi0YYeO6JpS
         OOpWa1s57fcabteEg+kmN9/0NEQtnqazOdnhX0xUtNfJDVUy1o2/3gWL1/ZxmCbm0De2
         zdIZ2DzSk/NLUr4SkGslTLNgmpDrBRK6bi45LdDq5nsf5rS76qjLGVQbm0UAKQhgQMRn
         OEIC8d98US7WN0BOnQocVZJsuRt73cVXbyHJ2AyqvT/dh0lR+rKe3l7Ry31z9Q2HBOzD
         JAL4b2WWKb5PifTIWI58rBDJypdLTOMGg5b6TpdJmr5u039oWUUTgBKttxYhMmAhZ0Vt
         bH9w==
X-Gm-Message-State: AOAM5318mtCCWt00V9WmTpMsmKBQnlITnjXIXvzS4NwLZlBTysai4EcK
        SkLE+WUIy27AqirulKx2ZzapTe/UbzceQg==
X-Google-Smtp-Source: ABdhPJxmlW8jRc5XfblAuIojhv317R0FoPiKO9b+hk2wn+bfEQ6J5EnIg+GHnY7vpv/q5JH++TYRBA==
X-Received: by 2002:a63:d245:: with SMTP id t5mr10256932pgi.283.1601834606493;
        Sun, 04 Oct 2020 11:03:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u18sm8514612pgk.18.2020.10.04.11.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 11:03:25 -0700 (PDT)
Message-ID: <5f7a0e6d.1c69fb81.f48d2.0896@mx.google.com>
Date:   Sun, 04 Oct 2020 11:03:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-23-g930d8bc68b5a
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 101 runs,
 1 regressions (v5.8.13-23-g930d8bc68b5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 101 runs, 1 regressions (v5.8.13-23-g930d8bc6=
8b5a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.13-23-g930d8bc68b5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.13-23-g930d8bc68b5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      930d8bc68b5af1572517260adc8bd29d2a8f0efa =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f79d5cd466c2348ff4ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-23=
-g930d8bc68b5a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-23=
-g930d8bc68b5a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f79d5cd466c2348=
ff4ff3e4
      failing since 0 day (last pass: v5.8.12-99-g7910fecf197e, first fail:=
 v5.8.13-3-g58c57ca2b2dd)
      2 lines

    2020-10-04 13:59:33.783000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-04 13:59:33.783000  (user:khilman) is already connected
    2020-10-04 13:59:48.958000  =00
    2020-10-04 13:59:48.958000  =

    2020-10-04 13:59:48.958000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-04 13:59:48.958000  =

    2020-10-04 13:59:48.958000  DRAM:  948 MiB
    2020-10-04 13:59:48.974000  RPI 3 Model B (0xa02082)
    2020-10-04 13:59:49.060000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-04 13:59:49.092000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (387 line(s) more)
      =20
