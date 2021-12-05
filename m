Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA3C468D5E
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 21:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhLEU4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 15:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbhLEU4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 15:56:11 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28213C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:52:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so8082669pjb.1
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 12:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8fIXEKhvdDPfCKxK1DgQvIHSjPrKfHQtPZEFMSpF014=;
        b=dTiY71QIy7VP/7RjEmTn8pc9rhnRTAaWKJsohqjUB2tMreL59fIL0qvsA4REvewqUs
         HCAnhoy6OesWuJ4zvVTtHmRgbST/45VS0QW0OWI5NtBxRyEoARNiHb24XWH5V6GX8GM6
         LzQpGsRnphQXsN9Ied47dXuvEouehJzfCi9cVmUSb3q25eliEz+KgpVNC8rZl7d6L/lY
         LAhkpf0UdiNjrGm2En7O7/qC7EEDvigznjqrBdjz12QU8j39IjFDcpiqqOVj4yyUUliR
         ovfqdV2D1NA7lYsBzta4h6pblMmq495K5sWG/dq99pG5fs+HClL3jvJKf1y+VHhiDmq/
         xCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8fIXEKhvdDPfCKxK1DgQvIHSjPrKfHQtPZEFMSpF014=;
        b=UWj6nIr/AiLhwbW2m6UbBc+QLGrpJkgd0cNlsM7ipniLJGNWgJkylvt44Z7YKaGfSE
         QsIgcyv/Kj+rEso1NvlCE1hsx9x4Ih6dYjlSpDoQ/tkXfj0eKy1+QBCrqamy35vFEQBt
         A8KpeV/wwCv1qcP/+E5Ntw1Tvi/n1SBT3pBe6lMM0vqh2+rNST56LbR6102RhesOQSwE
         FjyRz0hZJ6nHsK7ey1DDeDQBfGNgpFMdZt6CyQ178NoCSkurPX+79l7GJvkiszZxD+13
         m7SB9hl45UcIKw9Nyaoji7Plkm6sldqWI0vjz0/+Ez9tagUBTnPcCsPBCpvrUsZ8Nfwn
         4pfg==
X-Gm-Message-State: AOAM533ZL4ajuTYJXskzjy15Py8xdYk1kMcm4MjspZGpU4WVBEpTgdg9
        +O6Rt0L2bp3lHDrLej3DR8WcibQdlFa2ySA7
X-Google-Smtp-Source: ABdhPJzDD6w9VVRDiUMpxjFhMiRU0z0kbkPVtWhIre+u4cdHIIHJHMHyBt7BWDRXvqmEXvpBTPSn5g==
X-Received: by 2002:a17:90a:f292:: with SMTP id fs18mr32251838pjb.188.1638737562492;
        Sun, 05 Dec 2021 12:52:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm7863458pgp.30.2021.12.05.12.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 12:52:42 -0800 (PST)
Message-ID: <61ad269a.1c69fb81.aa45b.73b5@mx.google.com>
Date:   Sun, 05 Dec 2021 12:52:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-57-g86c90b21b24d
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 1 regressions (v4.9.291-57-g86c90b21b24d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 1 regressions (v4.9.291-57-g86c90b21=
b24d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-57-g86c90b21b24d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-57-g86c90b21b24d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86c90b21b24d932b63f8a8451138b4d51f95169f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61acec2e4efcf19df51a948e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-g86c90b21b24d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-g86c90b21b24d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61acec2e4efcf19=
df51a9491
        failing since 1 day (last pass: v4.9.291-47-g43f5262d9792, first fa=
il: v4.9.291-51-g9e9032945598a)
        2 lines

    2021-12-05T16:43:00.824556  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2021-12-05T16:43:00.833711  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-05T16:43:00.854062  [   20.434936] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
