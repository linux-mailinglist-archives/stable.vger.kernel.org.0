Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCFC31B7F3
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 12:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhBOLYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 06:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhBOLYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 06:24:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B43C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 03:24:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nm1so3549649pjb.3
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 03:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fEcSY6uCWNH5yxBDB9eLykf9bVXZ8mdX5luUzCUaUEY=;
        b=Pv1NsKvLPztHudApcBh5FNln1uCcylKPbNQlq4COj5HNxYI3pIj+/TKz+ZIccCquz2
         cCCjXt8LtHuaFE8Q5x5UmHZ3lJ+5cax6Crtae6qf2ttJNBEd9RaE3RP9XARenHqclqXS
         W9rbLXzskYiwolLyyP6vAg0dUv3uYRqDtT1x/funB5jqCVjwrCjJj3TifVqwshH8M2Fq
         xIOx76Pbd/SEF9gOHDW5bJB+sDcTrPSbcX3ziOK62/wlkBetokonINB6KnPnUDGAgsNl
         uMyAD0OidQ0PQZC0i0u+qPM8xxh8+yFd5X55IpB8SPI6iMooY8E9/ipgtZglqvd3RFx8
         z01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fEcSY6uCWNH5yxBDB9eLykf9bVXZ8mdX5luUzCUaUEY=;
        b=GS1sYGz1sPLZj4J/UATnUQO4r/Dpvbscy6lnlLQvEj0ShwMrxPfs+nL2TusluCnaLj
         CEyuRyjqGrKGSgGExPuMKcSTCaetM8VQRM0HIH/YQnwg9bCGUbVr5KpOMwiP6MsnLbID
         KJnXuu8gv7HjAuZWT/SN5HPeSrji+MVfnKQjUObDMO+7t/tcUfXdTJ8Tzfa+xebsWEtg
         FBegk8tZn7RkuSsMmYrNz5hg6OL91NLOu8LlhOeiIG1DeS5McXl0QC1cikmC/IauFbUq
         u+kqlPKt74BDoD6uhLW/l4KuXpaPyeuUNS69ZdNKV1Q58XJkid68hcszDO+6vKglR9LD
         9jEw==
X-Gm-Message-State: AOAM5323uJHcXu5evl0vMUpYzvLVPKGhm9DpEQ0T393S1mGjLCwJ8Njh
        p+78qY+Ta9mKEQNnEJqExv9qDW62Oe1b3A==
X-Google-Smtp-Source: ABdhPJw3+inr+7fgZrQRdAu2UDaeHe0n9+2BrrkiMmjGYjW3iFjOCSoE/rSeXuV3BzDeQSPfgtsLdA==
X-Received: by 2002:a17:902:20e:b029:e1:916c:a4d6 with SMTP id 14-20020a170902020eb02900e1916ca4d6mr5707112plc.57.1613388247073;
        Mon, 15 Feb 2021 03:24:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 14sm660606pfo.141.2021.02.15.03.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 03:24:06 -0800 (PST)
Message-ID: <602a59d6.1c69fb81.c47f6.0da3@mx.google.com>
Date:   Mon, 15 Feb 2021 03:24:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-28-g66e05e4dc150
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 43 runs,
 1 regressions (v4.9.257-28-g66e05e4dc150)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 43 runs, 1 regressions (v4.9.257-28-g66e05e4d=
c150)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-28-g66e05e4dc150/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-28-g66e05e4dc150
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66e05e4dc15035bfbb7d711a97dfa9dd3be4748b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602a2805e5601da3c13abe7b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-2=
8-g66e05e4dc150/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-2=
8-g66e05e4dc150/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602a2805e5601da=
3c13abe82
        new failure (last pass: v4.9.257-23-g21ae91a9e581)
        2 lines

    2021-02-15 07:51:30.226000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-15 07:51:30.241000+00:00  [   20.600006] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
