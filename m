Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403102A3712
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 00:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgKBXUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 18:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgKBXUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 18:20:03 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FB4C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 15:20:03 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id a200so12521156pfa.10
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 15:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EWQ+zKe6GAwBQyCdgX4DE+eKl3qddRYBrU6uhPhFdOw=;
        b=GQqEZW4yYshegZWv2YW1ndWRU9vSLf9hTRst4IwItDGs8QWYDY62SjdG3cTzJu5JZd
         5ui5t1S1Wm2wmrIpWBUzEVD842759Z3aPUITThCPGk1PkleDaW9/b3+II//ohU3zr5ia
         Zb904pjitvXyVaE4Aqa90FBWOarXU0fRRZIIX+CF5pqRArpGi4X76JbryAUGLJoGDujX
         p4PhVVYv6FzVKrGeRe6szvVKAD3MNrp/vBFMrAKZ4DB6xQRZ+prW/LYc2XUshoPIYaLR
         +xYbHTsJkC4wm/qLS2pUoop4vigI9poumCe2QotAbNOmIcCeh9OiupEemj3GSkzZaMs/
         fR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EWQ+zKe6GAwBQyCdgX4DE+eKl3qddRYBrU6uhPhFdOw=;
        b=OEZSmlA8BkzJ6IEJSuaqxE1pcSdIxm4lKl3oLs7OB3d7nvcxrV95QoPq2NbPJIXVmB
         cMpX+BYhhEWGPRhTGVNB80+3nry20Z+/hNav93ImG3X4yp9j3yjKqC16Xz/hmvWO6qx5
         Y1DBLi58Bnnag0fBKj+/9RxeDZifgW+m3X7vf6JbGT5eRymX8TCaqJvOmOTTJwH/e0LI
         OT+e7PquAmf9sLkU0PddHrmsKncdHnW/91cZ9apQfg+s8+GMKe3qqRoICe7lUe/KCUoH
         gckg7i6sTYTsGQ4qRS1LSmGDx2P/gbDsiOrHr7sJk7QH/jL59fE7zjDSHKPri3y3TNtx
         vZsg==
X-Gm-Message-State: AOAM532KTdl/fhzHZK/u9NZ/tub9Vaf+M3jpBFU50CtbLvU/mdU7EwHP
        fxiGfxZB8CW6TECfvTM+S6DADX2hqfkyLQ==
X-Google-Smtp-Source: ABdhPJzI6BFvBizitOWxjzBKoctFJHXDz7NdML4JvS6lbPokV4APcd6fylJk1GuZAO0sxlyWAIjX7A==
X-Received: by 2002:a63:2f41:: with SMTP id v62mr14813121pgv.10.1604359202125;
        Mon, 02 Nov 2020 15:20:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u11sm14041437pfk.164.2020.11.02.15.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 15:20:01 -0800 (PST)
Message-ID: <5fa09421.1c69fb81.cb5af.7a52@mx.google.com>
Date:   Mon, 02 Nov 2020 15:20:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-34-g4300be89420d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 130 runs,
 3 regressions (v4.4.241-34-g4300be89420d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 130 runs, 3 regressions (v4.4.241-34-g4300be8=
9420d)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-34-g4300be89420d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-34-g4300be89420d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4300be89420de13ea983245d746b38d0a1d9c6e0 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa06369d0a29d874f3fe7d5

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-g4300be89420d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-g4300be89420d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa06369d0a29d87=
4f3fe7da
        new failure (last pass: v4.4.241-34-gaf6f85ddc502)
        1 lines

    2020-11-02 19:50:18.620000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-02 19:50:18.620000+00:00  (user:khilman) is already connected
    2020-11-02 19:50:30.703000+00:00  =00
    2020-11-02 19:50:30.709000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-02 19:50:30.713000+00:00  Trying to boot from MMC1
    2020-11-02 19:50:30.903000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-02 19:50:31.143000+00:00  =

    2020-11-02 19:50:31.144000+00:00  =

    2020-11-02 19:50:31.150000+00:00  U-Boot 2018.09-rc2-00001-ge6aa9785acb=
2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-02 19:50:31.150000+00:00   =

    ... (448 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa06369d0a29d8=
74f3fe7dc
        new failure (last pass: v4.4.241-34-gaf6f85ddc502)
        28 lines

    2020-11-02 19:52:04.479000+00:00  kern  :emerg : Stack: (0xcb94dd10 to =
0xcb94e000)
    2020-11-02 19:52:04.487000+00:00  kern  :emerg : dd00:                 =
                    bf02b8fc bf010b84 cba5de10 bf02b988
    2020-11-02 19:52:04.490000+00:00  kern  :emerg : dd20: cba5de10 bf2460a=
8 00000002 cb8ca010 cba5de10 bf280b54 cbc4b3f0 cbc4b3f0
    2020-11-02 19:52:04.497000+00:00  kern  :emerg : dd40: 00000000 0000000=
0 ce226930 c01fb3d8 ce226930 ce226930 c0857e88 00000001
    2020-11-02 19:52:04.507000+00:00  kern  :emerg : dd60: ce226930 cbc4b3f=
0 cbc4b4b0 00000000 ce226930 c0857e88 00000001 c09612c0
    2020-11-02 19:52:04.523000+00:00  kern  :emerg : dd80: ffffffed bf284ff=
4 fffffdfb 00000020 00000001 c00ce2f4 bf285188 c04070e8
    2020-11-02 19:52:04.535000+00:00  kern  :emerg : dda0: c09612c0 c120da3=
0 bf284ff4 00000000 00000020 c04055bc c09612c0 c09612f4
    2020-11-02 19:52:04.536000+00:00  kern  :emerg : ddc0: bf284ff4 0000000=
0 00000000 c0405764 00000000 bf284ff4 c04056d8 c0403a88
    2020-11-02 19:52:04.547000+00:00  kern  :emerg : dde0: ce0c38a4 ce22091=
0 bf284ff4 cbc4aac0 c09dd3a8 c0404bd4 bf283b6c c095e460
    2020-11-02 19:52:04.555000+00:00  kern  :emerg : de00: cbcab800 bf284ff=
4 c095e460 cbcab800 bf288000 c040619c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa0633cb876fbb74e3fe7d8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-g4300be89420d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-g4300be89420d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa0633cb876fbb=
74e3fe7df
        failing since 1 day (last pass: v4.4.241-8-gd71fd6297abd, first fai=
l: v4.4.241-10-g5dfc3f093ca4)
        2 lines =

 =20
