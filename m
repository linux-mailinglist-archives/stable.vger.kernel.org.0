Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D723048E211
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 02:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiANBQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 20:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiANBQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 20:16:00 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352DDC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 17:16:00 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o3so12086372pjs.1
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 17:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0alLbFEoGjw9tJtxOhvE2AI3s31uAuIl3q3ROcIj3xQ=;
        b=2/bvrZstw5A9wx7OtT2TooWdCVFQfL33DX+qLeMkiq6lfsrPGJM0npA3i9D8vBatR1
         5yXxNRdmoDcYSuB6CNADxUQSZmebFQcn7vg6BSH1FzKTeDOadlfNKu3qTu680rIpeU+1
         miNWAvgUMkw+c4JkYmgzsQNEObnmpo5ekiUZMrMtmOQrBSgieYBFviT3pzOcc9wW+45i
         orpMV6v+SsClyd0qwmEf6Im7AoIS6stnDWsiDZGCG2O3ncb6MB5TKhmsji8aqC68775I
         e3rpTrTvbx5MXxd018PgJE6XEHVb73cgVGNHzdpel9tgUM1sMdhCGe7yvQJLxoMOVxKe
         UWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0alLbFEoGjw9tJtxOhvE2AI3s31uAuIl3q3ROcIj3xQ=;
        b=LldZxHWrB6xGDSLZl2cBkhsEubTGI1TXYxIHWcg4W1Aj5xn+maoJGHFUMILCwaimz4
         AG0tIPIOyC0x1vxru30O8wAv95UZaqjjE3BJpV4bYGuW5ySw/vZPIahZViamzrDE2u+l
         1bJ++5hkvgbDsUcwRi7DVh8zTmUSaWrnyEUla5nTC7JxaXZPsqo0pMYh3CODy818OUM1
         ou59Bj9UFk2wxDchrEnl6FbmFP0gfIq45a/4D+sO0tAC0YO4xELe0x3Jhbw5ZXj04ose
         PyAu/uhF45ZKg4TNC/GMpHtOuBdUJMNqKnFGN5VcLGY3/ImWyKGpfWuGsgMTpUtVmbAt
         1bcw==
X-Gm-Message-State: AOAM532BiyyMTMhzUdTaSffy6z6D80xpBgwNa5PNfRSZqR80LFf+ggSG
        xbyVz6AMjwUUnqAeKWLQXukr0Gvhm+PWbaL3mnY=
X-Google-Smtp-Source: ABdhPJwFHaFJKMSNawlan71Zh5WKCDOIGNXC1aYb6c3Jt8igxwHdqtCmNcCoGS18zP0X2L8HHw94cw==
X-Received: by 2002:a17:903:2352:b0:14a:b4a:4629 with SMTP id c18-20020a170903235200b0014a0b4a4629mr7151928plh.45.1642122959091;
        Thu, 13 Jan 2022 17:15:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ne14sm9043331pjb.19.2022.01.13.17.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 17:15:58 -0800 (PST)
Message-ID: <61e0cece.1c69fb81.87803.82b4@mx.google.com>
Date:   Thu, 13 Jan 2022 17:15:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-8-gf00efb3d95ae
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 1 regressions (v4.9.297-8-gf00efb3d95ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 1 regressions (v4.9.297-8-gf00efb3d=
95ae)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-8-gf00efb3d95ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-8-gf00efb3d95ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f00efb3d95ae25468c92925994874a10260c170a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e09e00448091212bef676f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-8=
-gf00efb3d95ae/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-8=
-gf00efb3d95ae/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e09e004480912=
12bef6772
        failing since 2 days (last pass: v4.9.296-21-ga5ed12cbefc0, first f=
ail: v4.9.296-21-gd19aa36b7387)
        2 lines

    2022-01-13T21:47:26.341690  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-13T21:47:26.351091  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-13T21:47:26.366332  [   20.202972] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
