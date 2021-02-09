Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCB6314928
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 07:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBIG4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 01:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBIG4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 01:56:42 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AD1C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 22:56:02 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y10so9212228plk.7
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 22:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4XL4D8wFteXOSsD2TECXOEsyw8u6QN5owWiVHggaTCk=;
        b=uiDVY3OP7ZX4eOd/putskG6YhYu7HvUIlVBE+yKMNO+HD+MKCyhb2nnKxAVvSHAx+c
         vGp49WkW0orJQChBjLG94fgPeOXPSWpid5519fya0JMXe2GaaYZrOqJiLTKR/PQ7qQQ7
         h64XxMBBu6FhKorUsmZSNUJ57SKjwOJRubMF4UJfzyGqzSXKjr7fuRRY1kWnbyywCQM+
         d+9Kh31dZMDdzx3RJW6uh4g1E+v0u7VsXGuTYhHZUKyq2sIqIeO6ANWfhf/+6FYeJCPQ
         Wy/DAUtfvh5QvVUI8ENChQIkFPQiti+W77ZycC7okG/Clba7cUznG5GOeKDd+mv87Qwx
         VHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4XL4D8wFteXOSsD2TECXOEsyw8u6QN5owWiVHggaTCk=;
        b=DX6RtfOqGB9jo5Cy2jGSHfOi/vG/Vj1oT4zTnZvG9RU8xi6tDjMrtRK/Q62Oi9vGVN
         etLtI98+M9f5j40trHjGd6y/baTRd0XcOywt/XDhoRxATEYCOIWKfkKdW0zQgNmV45fU
         JXoc0c+GumtASbuUow8LmoLg+75DvrQiSI8XUfwRi0kClDuDjhcm6xYPAKmRA43WzDuf
         BP7kbgzF+talZUAUFyMTAaGfXT3WdOluVLYbhqNkswrdTs4KPKnU1R7QeMPwvaxpx0Ie
         FnW3VcWzB+okXQAa15LHZ5v+HqKWW3YeLRBPAQGAECk81ASMW5imXBujM1E9oj83A93E
         D3CA==
X-Gm-Message-State: AOAM530co/fQ2HVI7PELpSfvjzEIkGOcwewX1Dw/IC34wzPVaM1zD3XG
        G47vvdd4M7QN2E3FAB7A3LFkmwULEhlDlg==
X-Google-Smtp-Source: ABdhPJxx9lg3vhx6aqtH+ydA7MThgowtZotF8PbC9KsshhU6hhb2kx8B80I0zzrHbrV/PUOJh3tFSQ==
X-Received: by 2002:a17:90a:e646:: with SMTP id ep6mr2663219pjb.218.1612853761212;
        Mon, 08 Feb 2021 22:56:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm18960514pfu.215.2021.02.08.22.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 22:56:00 -0800 (PST)
Message-ID: <60223200.1c69fb81.6fe90.b865@mx.google.com>
Date:   Mon, 08 Feb 2021 22:56:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.174-38-g601019cf8e3a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 84 runs,
 1 regressions (v4.19.174-38-g601019cf8e3a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 84 runs, 1 regressions (v4.19.174-38-g601019=
cf8e3a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.174-38-g601019cf8e3a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.174-38-g601019cf8e3a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      601019cf8e3ade680cd4110809ff7b19f3b98cb1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6021ff6465faede5cc3abe77

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.174=
-38-g601019cf8e3a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.174=
-38-g601019cf8e3a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6021ff6465faede=
5cc3abe7e
        failing since 0 day (last pass: v4.19.174-3-g9df30fc2980a, first fa=
il: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-09 03:19:59.778000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/107
    2021-02-09 03:19:59.788000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-09 03:19:59.801000+00:00  <8>[   22.881835] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
