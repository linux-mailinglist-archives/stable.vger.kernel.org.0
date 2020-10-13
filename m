Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B1F28CBEF
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 12:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgJMKrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 06:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729751AbgJMKrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 06:47:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0BFC0613D5
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 03:47:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c6so10465799plr.9
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 03:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3ntn9DyzGhS3Z3M/6At8ah3hrJim5BqR8VboOKGYXuk=;
        b=kbKZRb0lBrjXF0JRvIgqzz1CK/uC7OVsZHPL6O59fHj0/lSFGVZe2KKQI7G/w6RPf6
         vROmgjPYyQJyQu+F26D58XDj2jVhEAQQFQy6Wqr72ww2x69wD134o0igXuw+saJjUzrQ
         kyHWk928ARymQyutup6JacQ+1lgyfmsSQ9QWv4qCChuHNMZ+NMTFgfDfAVZjLh29/bdj
         28nm7Hf/00FMMm3ikW8obaSX91W12J52n6xLwAkbR5JriYM3S+V9AwgEueHs4buirLfP
         KyEjmGFE17Gi9+0SSeRiatndtnUlI3l1pydRwfjKeXyYFNSYQ5m6jR9zXVrniX2hALCw
         5okA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3ntn9DyzGhS3Z3M/6At8ah3hrJim5BqR8VboOKGYXuk=;
        b=JxMgWJfb7YY0YBHE4Z2BFHla6AFkdoO8pdwGY0S+8cnBPHpPnIt3u2pePrLlT5OqoY
         tuZN6QX8S2ZmatEBam9AvxouGuBhQfU3zthXXxzQxHTruZkkUS5YfH7fTQx3upCBHoGf
         a0Jfk3sjQGHkwABEkuTojmDG2rraC9jZVaBEH/4SLy9gbNVRU237wnKl3MUuM+ihG+9i
         Zbw+ysHJaq7AZ5+fBAhwyWIWlAMYwmKOfrvgKu4PRvFkWT4k1W7EqVriZW7aRq21CgEE
         spopLJUxNmUHW5V6kEnChfl6bZnKm2DmTXiDnPFJsLIEG3tVqw1zbFYHHrQBtgv7UpoV
         jSdQ==
X-Gm-Message-State: AOAM532XqXzhVebu+fQUTuGHbJO0DhUk3vftl0QFwBdwKvigV81WD3Jz
        r8aDwTTWWHUwtQCJ6gChpVhiXLxcWKjq4g==
X-Google-Smtp-Source: ABdhPJw+8+1bwSo09gOqqXEU8moZlqzw24zKWdkyC9JWlNb5+dSXLb4O+rcjMxksMd/ApEo6xfTeHA==
X-Received: by 2002:a17:90a:5885:: with SMTP id j5mr23627253pji.117.1602586042614;
        Tue, 13 Oct 2020 03:47:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 32sm22410613pgu.17.2020.10.13.03.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 03:47:21 -0700 (PDT)
Message-ID: <5f8585b9.1c69fb81.52540.b2ef@mx.google.com>
Date:   Tue, 13 Oct 2020 03:47:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-49-g269cfef6b429
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 179 runs,
 1 regressions (v4.19.150-49-g269cfef6b429)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 179 runs, 1 regressions (v4.19.150-49-g269cf=
ef6b429)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.150-49-g269cfef6b429/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.150-49-g269cfef6b429
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      269cfef6b42978d332ff8f0e889255658f133148 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f85482f835dc098a64ff3ee

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-49-g269cfef6b429/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-49-g269cfef6b429/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f85482f835dc09=
8a64ff3f5
      failing since 1 day (last pass: v4.19.150-28-g0d0080f64605, first fai=
l: v4.19.150-29-gd8f1e7f2dffe)
      2 lines

    2020-10-13 06:24:42.678000  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2020-10-13 06:24:42.687000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
