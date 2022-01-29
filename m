Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871CA4A307B
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 17:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243432AbiA2QSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 11:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242424AbiA2QSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 11:18:41 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7EBC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:18:41 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q63so9448713pja.1
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ghqgOJDnBSs/LB/tg5G1m4OFkVMPjO9S0trGHmI+or4=;
        b=fy9b21fQHIyoi1ZIpBzL6r6FZl8wnjERcX5ty4jDIyZi1Qjs197orXP+OkRupFwEnA
         z45ktGevXQaxEmdoiLcUPohBPmRC49U0JB3+xsh78IZqFqkg6jtajC3EVX5BYFEAJ/gS
         cPvtIQEzlSlD7DWHK1yjN31NuJS17hz/YIKcWAwYLeOmp0yT/w8k/BMfUQI10SeMz2W0
         A1Xl6BaMLQ06cq03ybcRHcINEMYvRx5/OLQAo4hWaRc6O3STQaBYOO3d4QKMWTGaPHJI
         b3ycAPb/wD07g7B//kwAlkCqZPsJ3S5BbPI1FH2n0+dk/DmWgoZS6kyhRSMjC0NXysVl
         gCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ghqgOJDnBSs/LB/tg5G1m4OFkVMPjO9S0trGHmI+or4=;
        b=YQO0PJdiwZle43gddUgWzFjdRU0c7Mp4AwVaUTuxH+bYURnTuI2iXcbHwWuSmIgWTz
         7PzifYvIS/mU8+5bwu75nQMSLaicWVJoCqUALpN1T+xtGG0EBVjHfra6hH6hXMVT+g4z
         Yqg5Yw6jWfDjhpk3eKUagGpcfoaff4GmfYJxq1ad0tU39zBjqg0Pt1wjvatPUikRbYDw
         HBa2NH8p2JZxV79z3baMm5hHpT6fSkDgMjNtfY7Y6Vztp/r6uqM7uBHOI17M8tTMrbH1
         P1qM+8X7qlN1my0iPlCPN2HIyZYstsxJjOPISuRmW6gvxP9LG7V4w7xOum1WmdmIfNFO
         051g==
X-Gm-Message-State: AOAM532Tegq5dCQwGFd4FyJItag2M9IKmwfnS2HyTZch7V5XdCY7sWLo
        TiB1x7p/dm8yKi+qprkIyo/QZ+usQUmE97sg
X-Google-Smtp-Source: ABdhPJwOq66SokyoF93pj1hqZx7n4k+IhmJ0c232Mike+5Ng6sMNcxVOEpBnFEieDHeuevDE/ywPBg==
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr15477837pjb.93.1643473120446;
        Sat, 29 Jan 2022 08:18:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s4sm14819896pgg.80.2022.01.29.08.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 08:18:40 -0800 (PST)
Message-ID: <61f568e0.1c69fb81.bb643.6c48@mx.google.com>
Date:   Sat, 29 Jan 2022 08:18:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.226-4-g23c81f83e59b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 127 runs,
 1 regressions (v4.19.226-4-g23c81f83e59b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 127 runs, 1 regressions (v4.19.226-4-g23c81f=
83e59b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.226-4-g23c81f83e59b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.226-4-g23c81f83e59b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23c81f83e59b37480961582e774edf4bd4773733 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f52edcaa6720c8b4abbd1b

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.226=
-4-g23c81f83e59b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.226=
-4-g23c81f83e59b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f52edcaa6720c=
8b4abbd21
        new failure (last pass: v4.19.226-4-g38be3b9e94a4)
        2 lines

    2022-01-29T12:10:53.220027  <8>[   21.174682] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T12:10:53.270802  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-01-29T12:10:53.279156  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
