Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1A24A9218
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 02:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353672AbiBDBmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 20:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353649AbiBDBmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 20:42:53 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE0FC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 17:42:53 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k17so3878565plk.0
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 17:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Le1JC5A1PpXY+3PidMSHMpjEWFywaUoBupsGr/bLANU=;
        b=rQ0733DIUYV7Q5S8xOCsLb28sq8z6mpH4NDjJAGnNRRWtC5Nhu3uAoD38sPyZkj3ME
         KDc9ChCl+WBUt8We+ZaL4KJc376bElYYTeuVeGa6XDNGKfaDV+OUKtRTS6UyVbhRrGvc
         owKQ2KBzQKoBhnES7avh8NWfk19HR7fGfEEGdXHxWKJ64vrWWM6YqTQjrFjp2WFjUJdI
         QkH2b2DYweIhKfdT99Uujgkh7HBGizv9IV73fQmZWH2BAglDICzW9hVrGfEboH8+mKwY
         kAKa+bdP4B7F4nM4hNT1S4iNQbjvRvVJQar1S7Cb04/+gOHF7ztmTi1XlgjwlvuMevZJ
         xqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Le1JC5A1PpXY+3PidMSHMpjEWFywaUoBupsGr/bLANU=;
        b=KbydbLueA+JiINB1MGilHSd3uxyrjA28Aq62vYiKFAksdkopeKhmO66un7lDmsDzCX
         wpO3D3IebzeBy6EjGUaUpJ8PB34DF802evPofZCyJipVTsP68apX6hl45lE5zyAMTUfw
         CDWY6enbTTjmTt9qzITGqlI821acVaWtQLC0A5tqzKZoxIYNtVGUKYs0wiZ7+0ZED+vY
         T8SMB5V1puHddQmJtcbnZBm040vy6p7XWYfNmNKonttK9lus+R/NMKwPzw65LurMLwL4
         XWiFvegp1xvZFgA0rJjWarSy62odgrHzem84M67rLCWnL9Z4srv6+t4d0CiAZrrO4JdC
         y2Yg==
X-Gm-Message-State: AOAM531UaSIDiSTrOJ2LMSyxDgFLO3eb8M4Gvaxl662YISJ7uabr+Cka
        FMSJ+BAgTdwKxeDg7gVvG5DNTf/t91fBF2zU
X-Google-Smtp-Source: ABdhPJy7vEhEG7RvrmGEhjqfJc0SMVvtbBEPTu0co0Famf2bXyq/yMWQ5NeX3sfsaopXAWkc1/qK9A==
X-Received: by 2002:a17:90b:1d88:: with SMTP id pf8mr561086pjb.162.1643938973343;
        Thu, 03 Feb 2022 17:42:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14sm261054pfv.212.2022.02.03.17.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 17:42:53 -0800 (PST)
Message-ID: <61fc849d.1c69fb81.c2796.13ca@mx.google.com>
Date:   Thu, 03 Feb 2022 17:42:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-27-gf7aacca58285
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 1 regressions (v4.9.299-27-gf7aacca58285)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 1 regressions (v4.9.299-27-gf7aacca5=
8285)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-27-gf7aacca58285/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-27-gf7aacca58285
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7aacca58285e541f58c782d5f896eb5daf6bada =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fc4da58e4a807d195d6f0f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
7-gf7aacca58285/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
7-gf7aacca58285/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fc4da58e4a807=
d195d6f15
        failing since 2 days (last pass: v4.9.299-13-g3de150ae8483, first f=
ail: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-03T21:47:59.300741  [   20.429046] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T21:47:59.342469  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2022-02-03T21:47:59.351864  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
