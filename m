Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6804B468CF5
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 20:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbhLET0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 14:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbhLET0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 14:26:05 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1726CC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 11:22:38 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id r130so8191180pfc.1
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 11:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uTPcGk+dFI+5QyhEcA7wHcXIxsebZqwbhrGN34P6wTc=;
        b=Kd2dZkUOmG55cRd4MbznUIj1hMKVeuTaln37qEWdMtNlLE6xNqpfaXJMRY5WW0Kryq
         OY1vbbF9uhKi6VFjkLR+Fs3vdryJuamPpgRDKDkRCpwLzW9MozI2W4qSazUxoghYnU06
         xQ6RSezYC84xs1Beqqzvr0QY4/Zu/JfORrHJKrjaQXGCuyLI7BMokBPB8B4nMsBIFtIa
         ORe+Eo2zx2UnGsu/hVw8iRO8XlemOjmL9bAa8eg0vuuOztxYT6d14eCgD2ph8prIqoab
         PypeExQc2zz5eQlsKYqs6OMpn2awqsUDpuJRwLKi6rM9eExFTOqM5vdTsdiboFysn200
         12AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uTPcGk+dFI+5QyhEcA7wHcXIxsebZqwbhrGN34P6wTc=;
        b=WNY88iYGk1bSqyQGNCCw84UdOxeUIzGJYqha2ife9jZQIbqAjqY5Fm4Ieo40kvNFGD
         a/ESy3hrXTJdJcULihfUh4YZW5reXyzkRSfoz4ZMSOCUZKBbmgMUIgju2Xpm7VHAMJ3k
         iU5R+N+naDnnVn4RelFKcW52RvrobLS9XrlwLwKS/eA+VB7HN1n0Em46FvIVzMTUUu6H
         Fuq1kZQiMrnaB3Rbr11LJ/0Uf5OruVFaExQTr+aLUODEOHlvMscCd6eS5Ff/8IzxXsVc
         OwtyhxslM/X2XQJ/EtaOCxChmq11d2Yud67nxwA2WS9pebIObY3qO4SvOFNA/aUJfaLe
         Kk5A==
X-Gm-Message-State: AOAM531bfdJ4faHXoTf7qQw4SiNt2Ztk4he1/jMvGbHTh9acQgSjS/rk
        6T2rJv2D48KmaBOSBWNQqG67Pl7C4IHAns8x
X-Google-Smtp-Source: ABdhPJx/Ie6QBS4SF1R27H+RXB0yy74ZkrYaYwVp/PXqlnxYzH6TyX6O0+LCdkKnB4iGeOhobtpElw==
X-Received: by 2002:aa7:979a:0:b0:4a7:e510:ac1c with SMTP id o26-20020aa7979a000000b004a7e510ac1cmr32361468pfp.71.1638732157247;
        Sun, 05 Dec 2021 11:22:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g189sm7680205pgc.3.2021.12.05.11.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 11:22:37 -0800 (PST)
Message-ID: <61ad117d.1c69fb81.fe397.637c@mx.google.com>
Date:   Sun, 05 Dec 2021 11:22:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-48-g52d38a062535
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 84 runs,
 1 regressions (v4.4.293-48-g52d38a062535)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 84 runs, 1 regressions (v4.4.293-48-g52d38a06=
2535)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-48-g52d38a062535/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-48-g52d38a062535
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52d38a06253586a77601907ff89f2dc88b674f4a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61acd94c12b1adbe191a9494

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
8-g52d38a062535/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
8-g52d38a062535/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61acd94c12b1adb=
e191a9497
        failing since 4 days (last pass: v4.4.293-33-g845bf34b777ca, first =
fail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-05T15:22:17.852653  [   19.243469] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-05T15:22:17.901819  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-05T15:22:17.910585  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
