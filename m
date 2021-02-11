Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CA53183E4
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 04:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhBKDTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 22:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhBKDTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 22:19:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23485C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:18:27 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gx20so2560569pjb.1
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3l+mZMig6k3jWz8IGFKfdatMfxFyqz/AbwrPUIfGg3o=;
        b=dSAqWBQVVwZUIYey7dYFdfIwCu4FUqbymgCNxUShIsciPs6BQeIrvYG+lILlLgVpII
         X5e9jWQb20kkrkHxa07u1hwiqR06Jwv4PUEF1Qe/AFz4l8KHxtPD1F99bMnNnYKTxff9
         H5Qlorc1an9BzYdv3aXk12blnDjtCQBGMR6wxAbKUQooBz9xgIyTaybpyjy1TH1m11pv
         FUznSD68xpLufT+vZlW6Ws69oguUBKDgBTtLvq+evfu/wSAMkgQdpWvbNL/rrJHwVZlW
         gvNfVs5PMsM+5kzNkmFkA1HRQOHF2hjEVk5zGAcJcumOYfu/OEHrMxd/B/VE/Y3MycTv
         1nWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3l+mZMig6k3jWz8IGFKfdatMfxFyqz/AbwrPUIfGg3o=;
        b=JsodMEQZQ3c3q3rJLk0aaXgSqPn2t8y4ksNYQLHU61mYU2lH21G7KBGHY/w4U4PPwq
         BHnn5ZJuM6UGWaeE2n5aLTKxEnFmYMKlPYcwk9haCYx2lpPhC4Gn6JzkaSeaqCd6BQQG
         grXH2o1iqSLh8WfIEXuF786fYt0L+15WIBTkfsevkbHKYGE2DTyuGqGeNCK4CkXTM6uj
         Bv1hqYbPT1PQUjeO//vC/vsoVCXdwD8juGWmE3Ct/rR0ny0LMoPoLrG7tIqobJ/5+Wrj
         iaAFQoSUL6VdCk0hLUpieBuxsZeHN5TRmnb+GagkDd0BwIKt8unYQDSpcM1AhqCzChh1
         uxTg==
X-Gm-Message-State: AOAM533ovY5+3sc2LiO8Z6nOpdlvBevEIWJoThPMIrpUrzQEI86NnMhz
        FCuCNxmv3jUZjwqgUvnfRx2Um1LrKphtkw==
X-Google-Smtp-Source: ABdhPJw9lPybflbhiWiQK0MD+2cZRsw5SqOeE6Uig+Tm+X4O2IwHscuVLbtJz1irkeDHpXa2pbJoRA==
X-Received: by 2002:a17:902:c981:b029:e2:c149:cbea with SMTP id g1-20020a170902c981b02900e2c149cbeamr3151107plc.56.1613013506293;
        Wed, 10 Feb 2021 19:18:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9sm3770537pgb.47.2021.02.10.19.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 19:18:25 -0800 (PST)
Message-ID: <6024a201.1c69fb81.59cb0.98c7@mx.google.com>
Date:   Wed, 10 Feb 2021 19:18:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 31 runs, 1 regressions (v4.4.257)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 31 runs, 1 regressions (v4.4.257)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.257/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      788437ba4c80d0d5e32ceaa28f872343e87236f5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60246fad1d10b2895f3abe70

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.257=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.257=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60246fad1d10b28=
95f3abe77
        failing since 1 day (last pass: v4.4.256, first fail: v4.4.256-39-g=
1a954f75c0ee3)
        2 lines

    2021-02-10 23:43:37.449000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-10 23:43:37.467000+00:00  [   19.084136] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
