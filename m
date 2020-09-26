Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D927970B
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 07:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgIZFBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 01:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIZFBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 01:01:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D3BC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 22:01:30 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m15so366724pls.8
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 22:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ysxi7RHfy/d038+YwV+O2buH5A18GK6O4x4pjdhTblI=;
        b=jIEbcKfP3yablqEmrd8XWu05yBzFs9D+W0aGYD7EbsNsVEC2MTnL6xvrIscwFNLqR5
         YRPMyINuq9RL/5LrGLi/dwMAkS8Oo1Sk8nU9cqFXJKYO3j9oDJCcx/ea6idOE5Yhsz0C
         +SUW7TkP2nRhAHmX8kXHC1p6JCvo2i255RgPeV9ic7B+/As+Twgg/8R26uy9piFNH5eA
         Q79DAP4gHUFKmqMs/l0rOo3eD6pQjHt+jZNvFIsCnVmilmAJLu7r86UzTcJ67EZxYePE
         qV/B2EXP0BDcCYZCW0/8eYDmYIxdE7yDeVtkYCOsIbl7GWa3EbhunrHFRHxWkXMuWmGh
         64WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ysxi7RHfy/d038+YwV+O2buH5A18GK6O4x4pjdhTblI=;
        b=LN78z7m/7+GNhUtYHnS8Eai4B1IuUI2u5U72ioKlmNZ6igd4AZmc9REJOfXrZgBHrx
         0PdM0DjvE0L3BR25hpQXRKLQadYc1NoYezWxUdurDyg4H+8AJLlyU1+v394mP+luizg3
         X0PeS0JOuVQD8Z+WGDk4LWDSQqyLhqatnjQ5Wv2bGre8sFt5XaFbTMFY4xT7r7FgmuZ3
         /d8lX6G+3CjuWe+QhV9RJklvee05lkPtFbvZaPpAO2XbnpFjbUIrijeHDMXAEH25cDHL
         /kTGF9VJ+2JBZm8mmvPDjZ5UGhA8KXECNvfLGiAV84zE3dEask2bq/na15FTZhkJEsHk
         /79A==
X-Gm-Message-State: AOAM530UW6ji9ravBMwA3apgAYpYjW5fhHWvoH6GISFyM50IgcKWO5aR
        9polIZj3k6stpUOR8MI7Vx6HchGH58PcMA==
X-Google-Smtp-Source: ABdhPJzSJHiJ0Fub3Ow3VCK+ER1vxdpZH72aL7R3Zg5wmsenUTaKtVNtVnqfOLZXvaLKZCCW9fYX2g==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr757368pjy.79.1601096488520;
        Fri, 25 Sep 2020 22:01:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1sm3527560pgr.3.2020.09.25.22.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 22:01:27 -0700 (PDT)
Message-ID: <5f6ecb27.1c69fb81.e6e76.a5c4@mx.google.com>
Date:   Fri, 25 Sep 2020 22:01:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.11-56-g6771838a1891
Subject: stable-rc/queue/5.8 baseline: 169 runs,
 1 regressions (v5.8.11-56-g6771838a1891)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 169 runs, 1 regressions (v5.8.11-56-g6771838a=
1891)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 3=
/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.11-56-g6771838a1891/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.11-56-g6771838a1891
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6771838a18918adcc30440999b07b8454363c20c =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 3=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f6e989852a46e60b6bf9db3

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.11-56=
-g6771838a1891/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.11-56=
-g6771838a1891/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f6e989852a46e6=
0b6bf9db8
      new failure (last pass: v5.8.11-56-g8375d24eb6f6)
      1 lines  =20
