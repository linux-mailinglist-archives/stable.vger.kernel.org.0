Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A990F48E293
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 03:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiANClC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 21:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbiANClB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 21:41:01 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10CBC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 18:41:01 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i8so1578366pgt.13
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 18:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o7RoJFXtNJVKm78LI1wawJLIgifQ1D4MgMUCc6EfZfM=;
        b=G9/AhpZ3H2Ud6rPP3pXa87HlLFF1X1bqBt++mSZKrVPnPERXzf6Ka3LgXGZBcDypDD
         +DbfiHm0tWbyQqWjWuXmedooQZCqfBkD2GHXIc7LA2CDLX7la2OA/lQrkaolcwvuWu3t
         JpcmCtYG//dWSqHQnCbSfLsIMZZHUGc2nNh30w80gzqxKVRuM5em6DJxWZtDDfPwLp31
         rSw8HLdOZ9vHlG/0WIOmICq6dOU02x5kg7YZXn1rhI3dE1OC5GLsSIkqWmb8q0t6qggP
         VJz4j4e8J+vm4H/4usHdgr8LvBm1iYA3FhATned+XQFlgS5LnwY2r8dT8thN4QP10Kcs
         Kfeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o7RoJFXtNJVKm78LI1wawJLIgifQ1D4MgMUCc6EfZfM=;
        b=HgA8gpV3qNYMoMUrPa6EveKahY5wtyrI0R/tNUC6383j9+lYHHMvMdrNHfewUrVyhu
         au/Jzw0sNAIZHyad7wA2KyQTOIBhVR9h2WEmspdU48s8On6hVt54BErH7bMVzz40AsHd
         8RjP1qyOIkdEeUP0yfXtP/yn22NkLrQUJyy/z1cYHWTG5jonMp4NLE1rMRhv6+Ky6Q96
         HbR0MJmpwsueX9gLv29RNH2gHxazc3TA+CwCOgrms2OIZFeUo3+yIBkAIyJTe5X81VHz
         YmJFj8z7P17XNAZVQkj8iNXkXKXCTTnGvVRZC6pfhvLjFPoaVA+ZnIBnND1A7S4InPKm
         kzhQ==
X-Gm-Message-State: AOAM530mHjEuuZW/aN6Axlzl1LSlUvD4JO6tgH8cVGOh5/JyD8n82vwu
        SaFz8SxK/iMIiENZ4bPN2mcmdxRMVvunyI3iszA=
X-Google-Smtp-Source: ABdhPJxF1Po2Op8pPVcbIfU9SRGzBIkveg9oPgmZ/vjxtXKZEa54umEuvAlR+dIHtGixwmmVIPMUSA==
X-Received: by 2002:a63:4e58:: with SMTP id o24mr182326pgl.525.1642128061007;
        Thu, 13 Jan 2022 18:41:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p50sm3689994pfw.51.2022.01.13.18.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 18:41:00 -0800 (PST)
Message-ID: <61e0e2bc.1c69fb81.c4dbb.bb2b@mx.google.com>
Date:   Thu, 13 Jan 2022 18:41:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-10-g46678d8a3ee9
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 147 runs,
 1 regressions (v4.19.225-10-g46678d8a3ee9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 147 runs, 1 regressions (v4.19.225-10-g46678=
d8a3ee9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-10-g46678d8a3ee9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-10-g46678d8a3ee9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46678d8a3ee9b264bfa9c0a9fae94b1a498740cc =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e0af84a19ec02f08ef676a

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-10-g46678d8a3ee9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-10-g46678d8a3ee9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e0af84a19ec02=
f08ef676d
        failing since 1 day (last pass: v4.19.224-21-gaa8492ba4fad, first f=
ail: v4.19.225)
        2 lines

    2022-01-13T23:02:08.545414  <8>[   21.281249] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T23:02:08.594361  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-13T23:02:08.603721  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
