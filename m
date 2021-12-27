Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F674804C3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 22:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhL0VNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 16:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhL0VNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 16:13:25 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C179C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:13:25 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id b22so14508765pfb.5
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AoMpSk26cEbNW5SBEePKzWNr/Rmm/DywZbNP4yLrnEY=;
        b=8FPGWm79qGav7aeYAyyb3ZtpRJVYVW3FS65WCOoot+sxcVxSw1FmHMuLDMxrv/G9Cc
         ngvbkw/gzQRKQLok5qPmBZ0F063TSx0FReJUdL8nmVKn76J9uN4PWXMOegLNI5ezS5xd
         kSQ1rQtRCFk+91NFu/SyajQlJdJOe/Jt7TLj7oyFriF7etPzt03zQb/ndmZS8lmD8vNT
         LyL2p1qobL4HYu5aloNImU5mioZT5zN27Lv1s+jBHWQ7/Xf0WMyZJt4f182dEPp550W+
         usuG3sdzZEKohMcmeL6RTbNDJW3ZEFHemcFUMpiizRYdrrYGcCGFyEKq53GwLGeNFDbN
         LyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AoMpSk26cEbNW5SBEePKzWNr/Rmm/DywZbNP4yLrnEY=;
        b=UTkNDIzieOw1/Eo0NaprBTllqJDaEIxBPahb3BOX+i45rV7kRRmh4pmlY7SKeTZppN
         exfEp1K4LeGDyndjcs6hlSYtm/b3EcxrqC2c/ZsuyzKadWbIua9U9rF7rpJw2Anmqz/n
         jdJzHPIC3M4SYEmUhesZQDKXqAEWVPm9xi4nFPUVsp1g1sMJcYcrlROdhrlVn5q7dpJ5
         B/BViSSKVheOWRY4ooo3T7c/RZiaL+e8Yv1m+PY88RDkd6anTzkGCo1VZBnm7SuzcE4F
         J8ye6L++CbdXqr7ugTPlnh+YCt6dL2moYxSAJl3XjMqOM/gZddRXVtCf2fUUBkZxnj09
         w/tg==
X-Gm-Message-State: AOAM531DGkfq9QzaYrjCgzABzvlU9aDv/29tdhRVN4EpG5VlWQI+/Q5K
        DQqayUFsbNAcdDu/YWqpvUzP0Ge0y8h3B6WP
X-Google-Smtp-Source: ABdhPJwcd991NOrpIjAlZKvwgi9NO/7zkfqQRlX+wTZEJsoruSo8v7GJj1sPH6GcvtFGip2BqIPloQ==
X-Received: by 2002:a05:6a00:2484:b0:4bb:2a57:3ce2 with SMTP id c4-20020a056a00248400b004bb2a573ce2mr19429422pfv.27.1640639604578;
        Mon, 27 Dec 2021 13:13:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u33sm19867256pfg.4.2021.12.27.13.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 13:13:24 -0800 (PST)
Message-ID: <61ca2c74.1c69fb81.54077.736c@mx.google.com>
Date:   Mon, 27 Dec 2021 13:13:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.259-28-g9d071a90d124
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 1 regressions (v4.14.259-28-g9d071a90d124)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 1 regressions (v4.14.259-28-g9d071=
a90d124)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.259-28-g9d071a90d124/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.259-28-g9d071a90d124
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d071a90d12408bbc5d718f1d5210ef53939df38 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c9f29ef81d137452397161

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-28-g9d071a90d124/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-28-g9d071a90d124/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c9f29ef81d137=
452397164
        failing since 5 days (last pass: v4.14.258-44-ge424e12a40b3, first =
fail: v4.14.259-3-g939915040d24)
        2 lines

    2021-12-27T17:06:20.623924  [   19.944610] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-27T17:06:20.668072  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2021-12-27T17:06:20.677417  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
