Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8425346861E
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355152AbhLDQNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 11:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244750AbhLDQNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 11:13:35 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFBAC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 08:10:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id o14so4205542plg.5
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 08:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z7IdAjC67mMdxxnFhz2KbYZXoqeJh4lGQuzh3EN64kk=;
        b=X2/yEMu0XWBHP7a2raRIVGeEPh7vQ+vqv1vsB05+l6yTqU0nRsXjsIk0tqANRQYr3e
         zuTzOBY2ztWM7/ImB6qOMnkUzPumsjqINFOPCOjKcn2nDGr4IlDQTjtWFLk2XmN38JtP
         yYFbcGsigzYHD6WktB5KVLTirC/0V/aQo5YWBARtvZbdClCFT1g3TMH1sJFDT5iC5oXn
         7YWHHojawwUnTZkvDC4PGyzMxHPzJ6EtMY7L9AMvLX8dGlfKdG6I0xoj5NV4yho/q35y
         dX/5sZmxXQSg2g+RDYPuP/ntHRFvKkR3gJauXLWCkvJbNHLWDOV6dUUSuFK/XD8f4uXL
         D4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z7IdAjC67mMdxxnFhz2KbYZXoqeJh4lGQuzh3EN64kk=;
        b=2DWKfRYcbOpl+92vpCsyKSID6ZEeCjbh1tnfbAoo6s9BD5o4746YwUNiykPHYNNQYD
         +xbXTZDytLWlk2E4jcwBjdF2732dVDlmp4NhSn5jr7FgBf1CVOJMqvJsUYhd3G4EiOrE
         guWsvXCaZgw9L1AIIwnXRO3CiWp5gHha0Wn7yu+KEMIBr/TESHQDkMn6b56zxhbVXaPS
         b7CCNy3un8zhaAYRCaBzbGlC5fekN8bPvnpyTVLw9A7nnCmrj1hdMTB3o5cUh9Bg6DCy
         V0abMjsojUnC8XriMMc3n0JhRPd5a8D6s49WBcWsV0omSdwTNaQYAOSEzzJ/Ua8wJszV
         A/Sg==
X-Gm-Message-State: AOAM530Hu7+YS5E49chSmJ3beFztdOeOo73EWf3mojxgVA8tW5ycGRu0
        Z7wnnLaOdy3Ocsccssu4V1dcQhxwy9q+cc1d
X-Google-Smtp-Source: ABdhPJwlmgEe7GvQ0/AXIBF70SPBFqcOv79VkZ0eCDhFb/X5uXw1fHEDoFNvDimOLLW74aMjz0x5ZQ==
X-Received: by 2002:a17:902:9692:b0:143:d9ad:d151 with SMTP id n18-20020a170902969200b00143d9add151mr30410580plp.40.1638634208823;
        Sat, 04 Dec 2021 08:10:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z93sm5392444pjj.7.2021.12.04.08.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 08:10:08 -0800 (PST)
Message-ID: <61ab92e0.1c69fb81.b064.fa3a@mx.google.com>
Date:   Sat, 04 Dec 2021 08:10:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-86-g7f4c00642655
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 123 runs,
 1 regressions (v4.14.256-86-g7f4c00642655)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 123 runs, 1 regressions (v4.14.256-86-g7f4c0=
0642655)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-86-g7f4c00642655/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-86-g7f4c00642655
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f4c006426550940b5fb629178d697c1d978225a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ab5c61065ff7fe591a94be

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-86-g7f4c00642655/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-86-g7f4c00642655/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab5c61065ff7f=
e591a94c1
        failing since 0 day (last pass: v4.14.256-72-g83c23c6a513a4, first =
fail: v4.14.256-83-ga02dd07707e4d)
        2 lines

    2021-12-04T12:17:17.528692  [   20.023315] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T12:17:17.578952  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-04T12:17:17.588326  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
