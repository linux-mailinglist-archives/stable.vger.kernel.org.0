Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828A845AAC7
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbhKWSJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 13:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhKWSJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 13:09:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E03EC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 10:06:31 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so2642795pjj.0
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 10:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bqo2TAJOXXDhFLXaZWmyJFRRHkvIH188NipFNLUv/us=;
        b=pd6xCVjxGamudkQORXhFAoJLoeI/cCbWBkbR1HQBNk8ywbrUTbxndcVnd4FOiFre+B
         88x8SMB2XyDkJ781IJXSZniG8n3W+AiV2mchcPHa27btdNseaJurOHhiiaeGrHhSHUy5
         8beV1XKiPf2cLfu3kj3KRe2sK0uDMxIstKJnRNkj3G8XiBKjel9OTHJYo0B2JCMcG+jw
         0KQyWlk6qSJog3Pt1J7NNpYJDvhc13C7WJXqIdMivoQdmfP3WXJpzCZphCcLkTVnPDRy
         WQ/dbYCQ1IMQk8vXKzVeEnuw/kkyoLCu64uYJGEGKl5c8dZvXIFslfc9kyjlWMd2BYqj
         +uKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bqo2TAJOXXDhFLXaZWmyJFRRHkvIH188NipFNLUv/us=;
        b=7zoxDPFB3DgMATzobtf2E8XZQ3WyRK5xvv9h2phIuZOTz+LXfVTktC0rMR/MLBuA3Z
         4zmUWtUsZwDNy5Jm0TBAgX54k36yZ2DS0MC8OUScM0O6KbZmrUFWvsvqYjr72qQFgrZo
         BRFhxClULq4gQ7ODr8mPw9qsElzW6uVU+OYBgezYz/NOGoMpfo0L7yhMRC41SBDESFrI
         62PJUAN8zbdAj5Nc+rFq1I5GKEqi00lyBMSQgPIiRMvwuwwM2dAt3kAVxD16FerEoDW0
         7ixipjcjABt452t4VFEOrAQscjC6RWdOwMH35R1jSTH0f4jIw34wpig1A/81NaSu9tj3
         1iFg==
X-Gm-Message-State: AOAM532Cx3OtOz1g4d0bzG8NAHrpQVCqUTZtGwSaxVWpjxD69/WINLJ7
        IOBErHwwmfCWw+dMW0BCAyiTDRxKZrrYG46C
X-Google-Smtp-Source: ABdhPJz61oDFbE073s+NQmUQu5BUhdjaWD116ABcGygZSbe/QJ0T6ixqQWtxhfYx70MwXEiWcuXJpw==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr5442294pjy.68.1637690790796;
        Tue, 23 Nov 2021 10:06:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ot18sm2309241pjb.14.2021.11.23.10.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 10:06:30 -0800 (PST)
Message-ID: <619d2da6.1c69fb81.f1bd2.4ae9@mx.google.com>
Date:   Tue, 23 Nov 2021 10:06:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-248-g403d1dca749d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 138 runs,
 1 regressions (v4.14.255-248-g403d1dca749d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 138 runs, 1 regressions (v4.14.255-248-g40=
3d1dca749d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-248-g403d1dca749d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-248-g403d1dca749d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      403d1dca749d0392ef194d5623bac7bd30c60284 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619cf9dd86a8cbcc98f2efc5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-248-g403d1dca749d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-248-g403d1dca749d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619cf9dd86a8cbc=
c98f2efc8
        failing since 9 days (last pass: v4.14.255, first fail: v4.14.255-5=
4-gb6f4d599e1d3)
        2 lines

    2021-11-23T14:25:14.601490  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-11-23T14:25:14.611089  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
