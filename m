Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6313844FBD9
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 22:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhKNVku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 16:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbhKNVkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 16:40:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787A9C061746
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 13:37:54 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so2116672pjb.2
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 13:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ZNc9JOY6zrycSkDhIzHtIMwJXV6D5PhdcQ/f0Dn/9c=;
        b=txolKfmzguw/88OWbXDqm9nCggGxrrqtB3so5cNex7RvZCVaffMVnpbeoZLBxy2Sy6
         laiVXeTiR658Y1rjsjZPyKlyWURGYXQytdiBvnPe/9zvDkGG8raRGHCCBBzCg5HVNzAl
         a9pB4qDZkI1RgSyRPmYUs+x6mkIPB8EV2QqlxqMuHsq6T7oyO6+uCYV3cwkrW9FmszwN
         EQp4vVTfJyyaKo0FGzAYEpZ6HQxynQna87Sww1R4eb5VeVk9lKRzSTSuSMz9xSbHcuKP
         RQGjBOH57eC6zyj5MQdKxsF7CYL5vzc+II69eXkEz6UPamHjfHLDmxLFbb9nE4sdA7nT
         YmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ZNc9JOY6zrycSkDhIzHtIMwJXV6D5PhdcQ/f0Dn/9c=;
        b=52n5u3pQKa/hOVlzH5J2wij8Xgcv5Qup7YIcjXR6fGRDbVxDmIjqJIcBwEn12jczuL
         zjrmka/H4Tt2YhnDxTfeMwr2PDc4XvraEphTx0OFSfDpxTvSd3osJr7Ohb/nicP761/d
         zHdRNRWB1PY5466reO8r5CJJuGN2eex8doQcSP9oMZ3CcHtyTfv3vkCVi4PmHmiCCOB8
         rGCrCdMPgWREPMqrOf6JDnFBhfIzCOHuoZJv8BRToF2BTV3IzJCOzMnAgEulhle45qQm
         k/6yY21KwV+etqDDhVVHS2TqetawXtZ8n7Zknklx0mzTc+12njmtWPv8QHSkg6Fr+Hb7
         rn6A==
X-Gm-Message-State: AOAM5311Zbw6diXin7cqXECphi2QemEL05cSmpwmL3XvxuBXSYvkNwSx
        YmlGLTdcWmkW+yB2liezhs/F6aXL20iehAMU
X-Google-Smtp-Source: ABdhPJwBSLMgD+/DaV+Qm5eHrDYAZFhrNaJCg0wAIRsq169f/Mf+laVz2gvCR+ajbUBUIMhHr4pGMg==
X-Received: by 2002:a17:90a:db81:: with SMTP id h1mr60254269pjv.46.1636925872384;
        Sun, 14 Nov 2021 13:37:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm22sm10456015pjb.28.2021.11.14.13.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 13:37:52 -0800 (PST)
Message-ID: <619181b0.1c69fb81.84653.ec5a@mx.google.com>
Date:   Sun, 14 Nov 2021 13:37:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-41-gd3b587b083d1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 131 runs,
 1 regressions (v4.4.292-41-gd3b587b083d1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 131 runs, 1 regressions (v4.4.292-41-gd3b587b=
083d1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-41-gd3b587b083d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-41-gd3b587b083d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3b587b083d1b963b923e312bd353c74d3ec5fe7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6191481f6bd3544bb93358f2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-4=
1-gd3b587b083d1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-4=
1-gd3b587b083d1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6191481f6bd3544=
bb93358f5
        failing since 0 day (last pass: v4.4.292-35-g08732977a551, first fa=
il: v4.4.292-35-gf481b21305a4)
        2 lines

    2021-11-14T17:31:54.404742  [   19.301208] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-14T17:31:54.453214  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-14T17:31:54.462137  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-14T17:31:54.479072  [   19.376678] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
