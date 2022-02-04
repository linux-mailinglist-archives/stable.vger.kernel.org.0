Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC624A9EB7
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 19:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbiBDSMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 13:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349855AbiBDSMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 13:12:17 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58A5C06173D
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 10:12:17 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h125so5670067pgc.3
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 10:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k+dGImG2FS9UekD8XFGr0L/9hgmvIc6uuJWBsJ9Tw7o=;
        b=b17DkfQvhIYQW9VqmO5n2BfvzPb7+N+xHFiXYF4zy5jFM4HJewhZvPNhRCnPVDYWaZ
         U3hXtgCMK6klEiptTqXxaVU/eQ+f1hqgKp3bgxF0EC6FNt4Rd913EMKYbJvyjwy96Jmn
         cAZvZZl0oNQAgtlIJXmRiSxazSlrbhW+STy/IS5ZprHDg90To0QhPXdT32/EF/w2mWGC
         szVsQyEnVTCY1QUbLRuuR5BpnuLecLYrIBrHgXh4gnlVf/Tcirww7JecgDKelsshJBlA
         MFTZHH62ZMRBsbRnZi2fGvChG44EYpdrieJSfdzBTcNLSr4u+d+9wfZzo1uikUwb5IiM
         i0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k+dGImG2FS9UekD8XFGr0L/9hgmvIc6uuJWBsJ9Tw7o=;
        b=lHyx49E/rNjQBbxi8kD2cLgBHj75TV/k3C5VmVUuVkBUdlm0j9dhMGdYRrki+nL2R3
         BWHRtB+xZKZjjzj8rui9nnTf0NruhPo4v9KtfpBwzyRz11/1Ja1jR5uBOi2yUOCXJPF5
         GHhHBPjAP/5heVTpv1csHulpqAoBg7oJEUzh+14n2ROytJKmNNIm5bPkFFs/FpVoiccB
         Ke2ncm64yypFSICjMCfL6vIdYR80xLGIS455D5x/ACGVGT7f8ZD/WB374MAwTpECCIdy
         gs8wBfxwCQYJlJsgtINqcrOYk+vqO8WEULcXiEGsKsXFRXEU1YmZbdQbQH9J/6k1nuxk
         d66w==
X-Gm-Message-State: AOAM533wSqQzABLkOCUuFeNyM0/bgjTgkCFbI/QS7vPeME15SbwnBB8a
        zaCbEsm3+/z1Vhulq2GZR8gDhrjn/T+i0tRe
X-Google-Smtp-Source: ABdhPJy/UQmX9QxT5mwSTuNpm8zvbdF3REXFXzaB8rnCXUhcMK/wnhE9FCUcfhW0oW54HrDfMovXAQ==
X-Received: by 2002:a63:c6:: with SMTP id 189mr183565pga.482.1643998337074;
        Fri, 04 Feb 2022 10:12:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id my18sm2955208pjb.0.2022.02.04.10.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:12:16 -0800 (PST)
Message-ID: <61fd6c80.1c69fb81.980b0.734c@mx.google.com>
Date:   Fri, 04 Feb 2022 10:12:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-32-gd7365d857865
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 1 regressions (v4.9.299-32-gd7365d857865)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 87 runs, 1 regressions (v4.9.299-32-gd7365d85=
7865)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-32-gd7365d857865/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-32-gd7365d857865
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7365d85786503014dd1c0fb13092979cfffdc60 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fd338f0d52563ab45d6f12

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-3=
2-gd7365d857865/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-3=
2-gd7365d857865/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fd338f0d52563=
ab45d6f18
        failing since 2 days (last pass: v4.9.299-13-g3de150ae8483, first f=
ail: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-04T14:09:02.289029  [   20.128570] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-04T14:09:02.331049  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-02-04T14:09:02.340201  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
