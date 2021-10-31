Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F64440C95
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 04:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhJaDS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 23:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhJaDS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 23:18:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E540FC061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 20:15:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so6832394pjc.4
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 20:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ksnuVM4eQbmCJciud3cnqbPZQyjMDgfYj9H0IiVugN8=;
        b=ONQdzyFjrxgSToR7Jzoi7BMacH9ZbVpW/Og2rfBpZ99g5RR7aoQ1LbyexrL1NevhwK
         ny92Wx5Q/DmggEvZkFNwZ9gC7SZmF+bht4mQXY1CTeZgehy4Ko4G4GJqq5ujROGa2MGq
         vpizv+oo8XgEyb9E0SY/XRSpB2hIXaMPaVEphu9RjWmBmFPo43hm/w9RlMoVnfJIzXc9
         U08yE4sEmjpnzQ2rHDqVcd2BDaA+VmavV/7dSKmnQkSaZuHe0xUp/dJcyI5S7+blezib
         PW9PZNZiUQeEMaR2+SQH6cbnvrbS+hvJMP7A79MGEOTwunlFuXWzG+aX87zItD/xZ7Hj
         GWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ksnuVM4eQbmCJciud3cnqbPZQyjMDgfYj9H0IiVugN8=;
        b=g4meimCUBE5vbe6eeCEUWGWQ5zSmrAdvRjsXueitHSEV58kRAcZroja4CKPgOER83B
         ukxU0FI93f3Vtt2XMD2/NgVbsCJLodIfHtAJ77vhDMYnSpfkowUUz+/O5aeLSVZpTmoo
         fC7k/ArMzPAvoOvhBsvIrgdaBEcpzSlvH9SoatsALiKuuteojEWq/dUa/NRYwOWksqUb
         D5qc7vHrMM6Nd9FA89byPsmXpSQOc2/+41wZyL7GP6qqGQG6vdk/yjMhVOlIkkCU6xGh
         Y6PbqeaRxFip2R/S1HlOj+NJSit8oc4ouiYiNunhL9xz1vxxA9wirUn3jPR7YRWXETAa
         71mQ==
X-Gm-Message-State: AOAM530IZf5f/C4iX6amDytJqClmYKcEHIOJEOLs4uZq/NyTirjUiZ4s
        yrC21XxavHBdbvhG+eIvr3oDqhg/U8oagMQ8
X-Google-Smtp-Source: ABdhPJyAxSxyULjKEQho6iHdcMmD5bJufc2R3jDIbJYjKeTyCZa7tnqpCylFty9oktmzYyRhIA533w==
X-Received: by 2002:a17:90b:4f90:: with SMTP id qe16mr21869380pjb.137.1635650155254;
        Sat, 30 Oct 2021 20:15:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm9134427pgh.24.2021.10.30.20.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 20:15:54 -0700 (PDT)
Message-ID: <617e0a6a.1c69fb81.8aefd.a596@mx.google.com>
Date:   Sat, 30 Oct 2021 20:15:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.253-25-g5a6b2eea5567
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 89 runs,
 1 regressions (v4.14.253-25-g5a6b2eea5567)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 89 runs, 1 regressions (v4.14.253-25-g5a6b2e=
ea5567)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.253-25-g5a6b2eea5567/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.253-25-g5a6b2eea5567
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a6b2eea55674b21663941897dc119a43c00af72 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617dd0a45bc1377eaa335902

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-25-g5a6b2eea5567/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-25-g5a6b2eea5567/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617dd0a45bc1377=
eaa335905
        failing since 0 day (last pass: v4.14.253-10-g2d214026445d, first f=
ail: v4.14.253-20-g8332949c1b31)
        2 lines

    2021-10-30T23:09:05.760346  [   20.202056] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-30T23:09:05.802460  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-10-30T23:09:05.811838  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-10-30T23:09:05.827104  [   20.271728] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
