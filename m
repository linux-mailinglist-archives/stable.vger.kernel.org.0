Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226244893F3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 09:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbiAJIpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 03:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbiAJIo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 03:44:57 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCF7C06175B
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 00:44:57 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id i6so11276789pla.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 00:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C0N4aR0khE8TXhoq33jTYRsGjtHa7R0eSsWb0Qbc/p0=;
        b=1M4ggQc9se+93Lt+VZkDCch7HY/zh+ALQ7KqjTINrem5eGiOfRBrvspnewJ8DLZHQ8
         AbGTCkUrr3c4nujnzAyLqGdhM2aGke6scT0Vi4JznLQHaPxYciHdAu7VklfVdzoISYDw
         zGfGWdtUzb9BKpkAHJepSdYRMouFaihDjjOclTUDghz/hzcHJhCB233INtH5Ueoq6uMo
         qmyunz3/Z7Ggo5Wt23qVQqrXpEBfm7zrOnLiC+GCbBZ46XomarIEpZCr53wmhj4Za8v7
         WZt3mnlgSkpIMNdyNmBH/1+NMjNnbumGZpbSUzBoD9LcA9iBPbe6UHoOKLroZDWn+mUM
         cO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C0N4aR0khE8TXhoq33jTYRsGjtHa7R0eSsWb0Qbc/p0=;
        b=PCpT+0TAHpcRiropollqqPSmA1eZQxigH3cEFNYfrS3QcI7tBY1118vp7dSLwMp8YJ
         vVwDJ4fata6w3+oU+TnlQiORgAxncyxYR+5dwzgFdSIXXVKxrp7x6KcI+QHJwwgBSsab
         xkneDo4bu+NAh7C1LL78oATNDmfM+JSWQY3unhg/OgKGA6HTAgv8F7tMiD+JtqdH3MUf
         f7o2QMCZuAWGLGq+hk+QjZ+pkG7+pjabeH9Shyvj0LHTqXRoYFWXqTmfSqKVPrQP6LPL
         Toa4MQ/19wCuNf1vV/OAxgc/N7TbI2lieYKhnKS9eUiecIstsL4ydbWMFjC4jHgJChBX
         3LFQ==
X-Gm-Message-State: AOAM532W/Ik5symBzQKOKPhF1oqHVvQSRFUAXfPCMAQvcM9nvhZx9nmp
        peaAIJjScHxU6Zm32YaRa0HNMwTRqGfs0Ap1
X-Google-Smtp-Source: ABdhPJyD60Gqnm2ZM7zjlCu4vgh7ppAzI62e2ijq9avmOg0ohUkirnznen9QP1qe8t3o/aWY37Q1MQ==
X-Received: by 2002:a17:90b:4d91:: with SMTP id oj17mr28813983pjb.224.1641804296599;
        Mon, 10 Jan 2022 00:44:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6sm2538167pjo.39.2022.01.10.00.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 00:44:56 -0800 (PST)
Message-ID: <61dbf208.1c69fb81.45993.640e@mx.google.com>
Date:   Mon, 10 Jan 2022 00:44:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-22-g0d85bbd52179
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 140 runs,
 1 regressions (v4.14.261-22-g0d85bbd52179)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 140 runs, 1 regressions (v4.14.261-22-g0d85b=
bd52179)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-22-g0d85bbd52179/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-22-g0d85bbd52179
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d85bbd52179081dbe9cdcaa2c27db95ff753dd8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dbbe63ae698c2e1eef677f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g0d85bbd52179/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g0d85bbd52179/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dbbe63ae698c2=
e1eef6782
        failing since 7 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-10T05:04:20.728915  [   20.403503] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T05:04:20.770160  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-01-10T05:04:20.779083  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
