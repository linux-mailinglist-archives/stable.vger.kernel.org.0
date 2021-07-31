Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD3A3DC649
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 16:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhGaOYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 10:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbhGaOXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 10:23:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C54C06179E
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 07:23:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so7871778pjb.2
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 07:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=We2ZqHXkznEM/wSkxHwuWgu91mDeMnseOQBitt+fUCg=;
        b=UWlxMGDUdsRXpXMuqY2q6Mc548+iSAFA36QyjX+LW/WlMi8Pp5Y9LzZZ9XdSdjg403
         aF/dhiV3HvxCwD8JHc8f9+TMKzx8isQBrUzXJZuQzysOTAwgO1R+KbjA4FvzFj1Ezs2H
         m7MwSW57/i/FOjBbOUOEEiI9buhjaRn/CRklqUJvKPbGbHgTNxCjvyWK7URcX/Xkox/3
         spEmqEE/RYphBfvg8SQHEJNMoBWL76HW2rIYHC62KKZpgeHldA5mE+p6WWJLY1b0FdRP
         Kg/VYZ3SueCEtQxVNYQFO3ZDXTh/keeHu1I+HVYbSl4/wmqXpbZl7RBs3mv/VT0H33IN
         zKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=We2ZqHXkznEM/wSkxHwuWgu91mDeMnseOQBitt+fUCg=;
        b=DccgEs3xIycc+6Wgnpsx8k3EcuTlBzCrPDTAKG44MbXj5noJkeqeXhWmptgagVWOx2
         MR6gJNCFpq97sAPxUrBlvIXkPJ7s8HpRb0HozAWiZkk0vpj9iDmcHCOzEGe9BKSaxS2c
         BXyOaa/hwpQjNBZ+GN23hNqj5JUUtu9hpsGl9lUQo/RFrFCzl9SjAq7VXoX0g7KCdMWB
         TKOISIyGwf2dsvXs13zOPIml7nZzwbQMRG6l9oSc4Jgce+HlS/kFHqLi0eJqFWad8u4D
         GHTOJFpSEeL8j76sMhogykS5mv9fqDaIGBTG0p2E7tzeyKDnVihQTAm63DGIJWYHc/Yo
         22lg==
X-Gm-Message-State: AOAM531XoU/1f8MmoG7zQgFTgcHmWHfAIwLost2rn32UV1yxmhpXAkgT
        jI3B7Yvr7bYQnzkZoKd9wQ7ZumUOj8AYRvJ3
X-Google-Smtp-Source: ABdhPJwcqc4Ky6wk9F8+G499jtUQacXTRMotX2m51C5iyqNZfaQdfGLg7AJCPPLCYzTZBKPCL3Inpw==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr8558620pjr.6.1627741400630;
        Sat, 31 Jul 2021 07:23:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5sm6240604pfq.130.2021.07.31.07.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 07:23:20 -0700 (PDT)
Message-ID: <61055cd8.1c69fb81.49639.05bb@mx.google.com>
Date:   Sat, 31 Jul 2021 07:23:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.13.y baseline: 141 runs, 2 regressions (v5.13.7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 141 runs, 2 regressions (v5.13.7)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.7/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f17352f54186bbf084d147e15efb5340430aacae =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6105232423377d3b3985f493

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.7/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.7/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105232423377d3b3985f=
494
        new failure (last pass: v5.13.6) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61052830c2b61f4fa485f4a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.7/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.7/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61052830c2b61f4fa485f=
4a4
        new failure (last pass: v5.13.6) =

 =20
