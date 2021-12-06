Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070904692FC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhLFJzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 04:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241537AbhLFJzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 04:55:36 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61FEC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 01:52:07 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i12so9657153pfd.6
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 01:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZBSuq7fSvT1iiZMJz1W8JdQ6nYi611beDt3ifRvvdMY=;
        b=GPrgs+MPjY1+8v29SbcNwFPezUHHBa2e/0j+cxKhP28chc7gJBzmR7Ksu/VDan/BBW
         MMs+68QWRyxAOb7HjIOnXeF9TpswjsubywRjPuay/54zUJojR+2RQYPJwfxZ41BWN1R0
         WJ8Mz21YtN4T5akHmGX7+zcz2CAN2OB4eHPx7pRJaU0LqUCJf7cq8boDL2ZuHD164uya
         OItnXFeuBGzdS9c0w+t614BEK778LNJa04fjVXN7Ouq1KN+F9/Fc+VWqmAol85arABiW
         l7rchcOFS+I3nJEN+ZFpESfGch+lySeYFT+vMrDB5Vke5fFbMIfluOPL3IrNQ2nccwWE
         Tq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZBSuq7fSvT1iiZMJz1W8JdQ6nYi611beDt3ifRvvdMY=;
        b=demWBD0zR38462FzNRx/KgbMa1a3PTJ35bYKSCblH32QB+0+M6aSIn9LEu4tHqPXT2
         ziZ3u6B/XsNynims9TX4xAz7f+HUTOTobNvJinDNV2IM1rxFZK/JBzhJk3bSbmAwpJY4
         ivB5BP4fKuSmmLsAN5TMBH+dMgwRxmXQNgVqNMzSI9BLqKsitVvHL0xCRQZWHbJpatz3
         CLwstkion/DMFsUttFxe6Gud/h5k/pgOQIZDpyCiDLP3aed+Odll6mrGUSSSjYtwLA0G
         k06ryxJsxJCH96fH/oM8QMzfzs39m6AOxMCJ6rDHUC+UhU6+xPYW2tsZioyHnaH8ZfD+
         VoUg==
X-Gm-Message-State: AOAM533VmPfs9sbg8NazhIYVtI/rgYA2mtaPw2mwo+jOf0NAYppH2ZOA
        aM0ELorHZeyKq4cvYGDFlBVl0GlRR701lUl4
X-Google-Smtp-Source: ABdhPJzGJfc6ZWXMNMdEWIUjhXOgXOTRV2bl0zkXaFlb8fHUH26tbPEihe6oZRer+DbqM9rx3QnDXQ==
X-Received: by 2002:a63:1442:: with SMTP id 2mr17903717pgu.16.1638784327181;
        Mon, 06 Dec 2021 01:52:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22sm11488995pfh.111.2021.12.06.01.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 01:52:06 -0800 (PST)
Message-ID: <61addd46.1c69fb81.ae55e.1966@mx.google.com>
Date:   Mon, 06 Dec 2021 01:52:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-48-g1b8de9fa79c0
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 77 runs,
 3 regressions (v4.4.293-48-g1b8de9fa79c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 77 runs, 3 regressions (v4.4.293-48-g1b8de9fa=
79c0)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-48-g1b8de9fa79c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-48-g1b8de9fa79c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b8de9fa79c044b9833336f32293fedb3ed4b12a =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61ada534f8a92ada2f1a9490

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
8-g1b8de9fa79c0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
8-g1b8de9fa79c0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61ada534f8a92ada=
2f1a9493
        new failure (last pass: v4.4.293-48-g52d38a062535)
        1 lines

    2021-12-06T05:52:40.581147  /
    2021-12-06T05:52:40.684834   # #
    2021-12-06T05:52:40.685454  =

    2021-12-06T05:52:40.786731  / # #export SHELL=3D/bin/sh
    2021-12-06T05:52:40.787086  =

    2021-12-06T05:52:40.888220  / # export SHELL=3D/bin/sh. /lava-1194355/e=
nvironment
    2021-12-06T05:52:40.888560  =

    2021-12-06T05:52:40.989702  / # . /lava-1194355/environment/lava-119435=
5/bin/lava-test-runner /lava-1194355/0
    2021-12-06T05:52:40.990816  =

    2021-12-06T05:52:40.991487  / # /lava-1194355/bin/lava-test-runner /lav=
a-1194355/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ada534f8a92ad=
a2f1a9495
        new failure (last pass: v4.4.293-48-g52d38a062535)
        29 lines

    2021-12-06T05:52:41.419404  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-06T05:52:41.425513  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0xcb9a6218)
    2021-12-06T05:52:41.431970  kern  :emerg : Stack: (0xcb9a7cf8 to 0xcb9a=
8000)
    2021-12-06T05:52:41.437211  kern  :emerg : 7ce0:                       =
                                bf02bdc4 60000013
    2021-12-06T05:52:41.445875  kern  :emerg : 7d00: bf02bdc8 c06a38e4 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ada56615266152191a94ac

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
8-g1b8de9fa79c0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
8-g1b8de9fa79c0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ada5661526615=
2191a94af
        failing since 4 days (last pass: v4.4.293-33-g845bf34b777ca, first =
fail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-06T05:53:14.822718  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-12-06T05:53:14.833717  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
