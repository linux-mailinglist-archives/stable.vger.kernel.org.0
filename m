Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF4482E30
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 06:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiACFbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 00:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiACFbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 00:31:13 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE757C061761
        for <stable@vger.kernel.org>; Sun,  2 Jan 2022 21:31:13 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i8so20793247pgt.13
        for <stable@vger.kernel.org>; Sun, 02 Jan 2022 21:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lOHVYg9V7M8nh7gC5NPZYnsknIjurPO7C/vZ7BvVWrs=;
        b=T7MJNODiMpCN5a44PgXmexy0KP9/uLyG71La8EENuutqvW8ZbrImwudC8P6u9npnZ2
         ruyAKJ+HWZqEVoCiZBMBPG/31+hocLD8nTOa4OGC7ojl9jenAq4Y661Xv2Ei+8cAAhYM
         FmcEtzFArmfN4TnjotNk5PKLVTIuOwPZXchOawiG5ZzLRt/xJhksQdObmTAztVsFTfCk
         7psdS+/tiP2Q7RlAKp0A6g+6W2eGih2+bg2SMxwEmZtQflzXiQ5zmeYJHpm5q3qXcV+t
         CFn9ZZv3jb4WSQE3Tve3KfjrnG2Mk4wBG9qkWFBuVojBhCZ2GcTmU8lrPfuapOdmVMQH
         7Nyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lOHVYg9V7M8nh7gC5NPZYnsknIjurPO7C/vZ7BvVWrs=;
        b=mC8x87ECNwawaxvFvA2YTTk76e7sl5TTfyN2rf7Kx/9nP52jYqDC8/nRYA4dcVxt6k
         XYXqT2RHh//ZDHLrZmUopYYMVl7gd1vCmLaZfaqIDZV9BNP8J6lts1mj7aa+TPKjs91d
         UZoHOKsEjczuMgVq9cVbSKJrJEx7vanF1vmY7OnGm7QdET2TsGEoPigp8DRuKga6MUvK
         Zg9IWLv7Y1slk0FmAAlRc09OoXvU0ge6KodkSFjLA95aD/ot3u2DydrTVBOPueLOLKlO
         nvepcZedeLSHPgEs7NSTSzk4R08aK73YoN2vIjErC/v+KkewMTQy0/oGmYbhvWtRxyaU
         o2ww==
X-Gm-Message-State: AOAM53316/hgRpMBXnGO9I5NU0plyRwRSVQMyA3LifYFdXbEGGxDpNAX
        ktflqx9Kf5bab2mQCM1wsyOGXTjWXx0TU58j
X-Google-Smtp-Source: ABdhPJzIV3Ko4DV2Biw9KHkDBKTMBR/kZrJaPdcExVemZRTpVTxGzRHiz2KKJbDdcTnfE6osaQZzYA==
X-Received: by 2002:a63:90c1:: with SMTP id a184mr38996531pge.44.1641187872716;
        Sun, 02 Jan 2022 21:31:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12sm40423625pfo.95.2022.01.02.21.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 21:31:12 -0800 (PST)
Message-ID: <61d28a20.1c69fb81.752a2.c242@mx.google.com>
Date:   Sun, 02 Jan 2022 21:31:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.12-50-g3e6a8a34a042
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 146 runs,
 1 regressions (v5.15.12-50-g3e6a8a34a042)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 146 runs, 1 regressions (v5.15.12-50-g3e6a8a=
34a042)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.12-50-g3e6a8a34a042/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.12-50-g3e6a8a34a042
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e6a8a34a042ce3395cac255cf206b38247a21e6 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d25a0aab168886baef6750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.12-=
50-g3e6a8a34a042/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.12-=
50-g3e6a8a34a042/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d25a0aab168886baef6=
751
        new failure (last pass: v5.15.11-10-gdd26a1c213b5) =

 =20
