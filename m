Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FFE460AF6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 00:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359545AbhK1XDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 18:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344946AbhK1XBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 18:01:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036FDC061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:58:25 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b68so14743638pfg.11
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=frHo1JM8hhm1jncPlQzgIHbivIpFT7jCVSY9Pmka0VQ=;
        b=e6ey4BKMBPcmo2qg3vfoHZa3TsTH6T/vHGEhhSdo3UqkaEKkysQvDph7vbPmI8ykyq
         xRL6yarJCCJ6d7QGnnd+U/hvLQMgM5Fy6WPYVVsUtvdR5hIgEYvDxKCyizkQVdPfWmow
         eKyZBE7DHQZs5W0ZWYviFkQRp0ncMI3m+kiOy6WpxumoyZ9fWRQwxZL/+RKsgByZhpu8
         RJNx6Cc+VkSqcOlQVUhtyS92R7VpXGWtrxB0RUMJwu44kc6I4Hj6ADFe3GWtv1zlks8A
         /tqrKWEUY9OnNIqPUk5V4o5LRmTfn5D9bLo49U57btFTM3jZuGA73LtjY6kznfH01lYH
         g5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=frHo1JM8hhm1jncPlQzgIHbivIpFT7jCVSY9Pmka0VQ=;
        b=CEeaH1I9/CNJFvH5PQLuoF05CL5xAiCpqbuxB5313355QUHaCN1YyXtPDD1b5SvwAh
         wtfWuPVtnhcxrNcdPB0+1IZfCsUirlmygRranztHTj8uFH+dLuJGrep//hiHVx9RqMHs
         9hR7s9xZUJJTUYF0BXSvju6pD5tKC3nxKLXtdHX93D4ZgXJXEse9WdtTYuYSlvc3di5s
         MeUWadDdTLxHSiOZ5CR8ElYvOc8SB2uVhyo+TwSiP4+MyiRMJ6C440pvtdPi6YsrdFmg
         2zLKN4kN9srxDYLLbMzhzzv+gOxWtZk4MuaeniW0YQICY6QxKkG9sZP4ptsbkKoVqgIz
         UOrw==
X-Gm-Message-State: AOAM530IzSqO6Qfto3JbjRbvIfnj/aQir/z1ln8fbKtn4JX2Z5dPWgMS
        eXhVbhGSwUEH3MmNkqjOT+00PXAydAqT+9aF
X-Google-Smtp-Source: ABdhPJyuOzprnm2kc6uM1IzCrXMyt21rVfA8LxKyGyh0bbQJzZu7QsFLXd1bmmx+/GJElCf2F1e4ng==
X-Received: by 2002:a63:e216:: with SMTP id q22mr33025618pgh.3.1638140304430;
        Sun, 28 Nov 2021 14:58:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f19sm14838725pfv.76.2021.11.28.14.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 14:58:24 -0800 (PST)
Message-ID: <61a40990.1c69fb81.86479.8a26@mx.google.com>
Date:   Sun, 28 Nov 2021 14:58:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-10-gb13cd9ca3553e
Subject: stable-rc/queue/4.4 baseline: 107 runs,
 1 regressions (v4.4.293-10-gb13cd9ca3553e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 107 runs, 1 regressions (v4.4.293-10-gb13cd9c=
a3553e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-10-gb13cd9ca3553e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-10-gb13cd9ca3553e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b13cd9ca3553e9a1c427d44697c16345d4fcfad5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a3cf6833f1b6224618f6df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
0-gb13cd9ca3553e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
0-gb13cd9ca3553e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3cf6833f1b62=
24618f6e5
        failing since 3 days (last pass: v4.4.292-160-geb7fba21283a, first =
fail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-28T18:49:58.999022  [   19.044311] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-28T18:49:59.039055  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-11-28T18:49:59.047595  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-28T18:49:59.062947  [   19.111541] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
