Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330E5297DB9
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762422AbgJXRYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 13:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761912AbgJXRYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 13:24:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE9AC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 10:24:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x13so3666434pfa.9
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 10:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fa+ZyrZCHUSQKjgNQ/1Z7GGmtjpPxln6Nu+aFr860zE=;
        b=n9gfQP5E2NKVC0+OJWaetQ8HYakgMhkqLDX9yWn5J2Dij1JUHSPryILCqw7vNbNsO1
         21DoZFuorPi5QyByyW6kpKCq8VuAv3qWCrYudWrCDeR5gfhVXAUSOrOwKqJavj9vMRra
         8O2wcbq3j4/51RCA59AiyFpmLmrXTMP5tjaus2h0ywy/X6K047Zqcb+fOKo+56QFnIHV
         1OO4jmFFV//V2K0XRYiKWOIlEAP9UlE0HZQIDExJEVHGwtnQFff79HPttA2QpWFOevaS
         OkzCJ+xM2F/R3ALUSZyOg1bmR0RtLlPa9MZQfZm3lmRyoWi9RJ7K5XRTRuO5Fyt057M9
         K1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fa+ZyrZCHUSQKjgNQ/1Z7GGmtjpPxln6Nu+aFr860zE=;
        b=OiLUd+W8MOII4bQgiLvAAgBzkaR7aB8kR1fEksoEzKV8mm1BnyZOr8Vs/1VMl3zjmX
         SjJcnPS/5o0TrahLFtjMf37C+z39lsqXISXwECsqp5ivBboC1VdBBQ2ne7NhjIEXPHTI
         nWCbj1rhjOkxJCsS3ajHas2uuCTGwKx4h+udujtaJZvhFPk6/QheyDMEw+YJi96cSgdb
         IFILqemmNWO87Z7A+/sEkepZKQ1OR26m1rth8enrf6c5YYugxlPbszO4HZmNMj47wdxN
         4HR5HnDTSq+kQKbXPDfF/tCQ3a3Is6DseLWqvxGntP32UnNdFD/uciDHPOQfYboQR/3L
         zctQ==
X-Gm-Message-State: AOAM533BALxJzidHmPSLCOenjhjcK4rmi5+o4xacVdiS1EcqOy0qBaaj
        ly4f1Z66lM3g629Bq8uK5E92fvcqK9unLw==
X-Google-Smtp-Source: ABdhPJxqQg7AB2zZ+N8+PtB2aT6mdiDEk+cBU29sl1SCQHk7y1RIZ/7rd+Rah07C2OEJyxHqG/5HEA==
X-Received: by 2002:a63:e703:: with SMTP id b3mr6594272pgi.265.1603560274146;
        Sat, 24 Oct 2020 10:24:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm6636294pfh.45.2020.10.24.10.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 10:24:33 -0700 (PDT)
Message-ID: <5f946351.1c69fb81.6458b.c2d6@mx.google.com>
Date:   Sat, 24 Oct 2020 10:24:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-14-g52afac38fdf8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 134 runs,
 1 regressions (v4.9.240-14-g52afac38fdf8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 134 runs, 1 regressions (v4.9.240-14-g52afac3=
8fdf8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-14-g52afac38fdf8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-14-g52afac38fdf8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52afac38fdf89a9dd2d65e7bb238c877199b7ba3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f94327e47be510026381033

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
4-g52afac38fdf8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
4-g52afac38fdf8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f94327e47be510=
02638103a
        failing since 0 day (last pass: v4.9.240-5-g556e4f1b1550, first fai=
l: v4.9.240-12-g493707a5601a)
        2 lines

    2020-10-24 13:56:05.571000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/124
    2020-10-24 13:56:05.581000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff234 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
