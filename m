Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410A031B462
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 04:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBODZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 22:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhBODZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 22:25:12 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FE3C061756
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 19:24:57 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b145so3369609pfb.4
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 19:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nx+ubKVST/K7g0OoIBWqR/Ywr0WGMtyVSfzSwUWnUWU=;
        b=NXpssm0+ymFyTYdXd3EerAj9fwn5V9WZmr4p4T2UIRlacvwrSE/jWlHm+i1cOLKIKY
         JQysT2EoJihbn7+4FWpvd9bsBqtyGtLlsxNl8OLtwpZV8DLC2HTvrMx1hVZYurukkpJs
         Ebs+0+NOIAT8tWdjrVstcLw2zBswPgwothu9YLc8W6w/pQXiHsMxpbeP7d24tXgC7THx
         +3nqZ30uqDagZQY5Ukl3vf6xuAcZV+R+14/P081F89hZRtaECrxe1jocbD7jZR2fFRpg
         Q0z1CCuHr/nKeit6nj12Qqw/7c7ytVbmEQmFtQmipdAClC3G4NPlAIbMwNtCkBSmSbMq
         xzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nx+ubKVST/K7g0OoIBWqR/Ywr0WGMtyVSfzSwUWnUWU=;
        b=UrBux1aatR4wdfKYj5MLjESx4pkDUbuCOSqmyvTCjlN2QtbAbY8Ku0zq7u8NbmLaJQ
         BzJU9uyis/ApQhsXTnmufomJwH0uEHuNE95jWrM0zL7UemT770C36O8+bviCpPoPYXa9
         moxl2UQIbmhV+aI3M7sGMI8IwPCHkaon1i6T5crT+X+HNDsPvsmVncunjf2jdoXFEqap
         rlhVnvU7J1pXr+X/1qRNaqEO/BzzHbL/DPYNqUyq+HnYqOYuXVhEhtA9DBrV8QHMFNKh
         2sRCPvbIkTD7wkUHof4SfUhudlgo2aq7mQ7/QQrQZSUx1iM+skyOY7Bja9n974on5NXG
         7n1w==
X-Gm-Message-State: AOAM532mJxzhFSrtL2/6C9Ombkv066Plklpv9EDNQoyNlv5ElHg6D9De
        mtDRpR/g8apti8+KhA4tUgZNWC/R4jXsPw==
X-Google-Smtp-Source: ABdhPJxq/Um5UCMgZmZDfXgmgcb9E1IyHA6z1GespvXHK+oSmNSs2Q8Fz3rCJzMvEBePia1UC1ioQg==
X-Received: by 2002:a62:1ac9:0:b029:1ec:48b2:811c with SMTP id a192-20020a621ac90000b02901ec48b2811cmr3675904pfa.18.1613359496967;
        Sun, 14 Feb 2021 19:24:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm14748793pjr.44.2021.02.14.19.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 19:24:56 -0800 (PST)
Message-ID: <6029e988.1c69fb81.fa044.0205@mx.google.com>
Date:   Sun, 14 Feb 2021 19:24:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257-14-g867b525bd0be
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 31 runs,
 1 regressions (v4.4.257-14-g867b525bd0be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 31 runs, 1 regressions (v4.4.257-14-g867b525b=
d0be)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-14-g867b525bd0be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-14-g867b525bd0be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      867b525bd0be01313b34a31c8f94c480c1719383 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6029b69dc0c620f6c73abe8b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
4-g867b525bd0be/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
4-g867b525bd0be/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6029b69dc0c620f=
6c73abe92
        failing since 9 days (last pass: v4.4.255-14-ge5269953cc26, first f=
ail: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-14 23:47:37.759000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/120
    2021-02-14 23:47:37.769000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-14 23:47:37.789000+00:00  [   19.346405] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
