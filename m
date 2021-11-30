Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA316462AEE
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 04:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhK3DQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 22:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhK3DQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 22:16:29 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ACCC061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:13:11 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s137so18200278pgs.5
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dpVfL/xO3PaZto6Frs4kalBvluNEzUwZTkKuabmdYk4=;
        b=2p1siji0i+Wl/BpVi8TfCl7HEo3cNU7ppJ6NCjtSiOqFT9HwGiVMa6uzLVMX+OGL1b
         w/cfBIN4jKg038xmPyM00cFz0et+wwzzM3CotD95hCixvV/Ws2vFTZ8DcfZ9q178igYc
         yr9pgU6EQjRY4jNe0vdlWwDBMxzYSAFxVrZx8zPH2UsoaaOjDpL5W8RHyIKjdRYeGdzs
         QdMgT7yUPLj6mOiJUpLRV7uY8N7ULsd4yI/i9jbB5teWynRugJo/rfXqrgIKycZSX55x
         x1twomQfvtuWIdY1M9jfH62VBO0tO9nzmdtnzel6yOmPCOY4Xpm1756f7Nz94BGXuHti
         hoaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dpVfL/xO3PaZto6Frs4kalBvluNEzUwZTkKuabmdYk4=;
        b=Ad6P4bQJKNKyQppDHij2B2CyL9pFT3AqUh3ltPMfDZLxeQj6C9UQE92Ce4bneItwqZ
         3bMXAIJt76Kv39jXIGc16GELiKHYCO5MJ2PPHm1Gt5HSrg9Ipeht/JYR0Oya5wlHVmg7
         ItCyjzEf1M4UC+rB1/8NofyHd2BbGDXbfi8slnQkTDUosIxVZNQ5+XR5PHN7zGervOsX
         hJWgFxOkKXuWMB6qQTt2EtITp27EyYuOOJZaLz+swcOm92eG0+ugEKi40cqNJTylLB2J
         rVWK2vp4yKU4XgdX73776GNBnhwVSDYbfirvQYfWgCFPHq5szOu5Y55cbN2+Ku+6JwgW
         Rk9Q==
X-Gm-Message-State: AOAM530CwTyjH/vGkGLTCI8VbY3I39HOz/BXRfqtj3zrgqH+1ilC6RaQ
        1Avp1w7kueEU6oeJ0QI5LhYawj1Fk5NHLK4V
X-Google-Smtp-Source: ABdhPJzt4zrOyW0eZzPO5y379ivDu9jD0ie2Y38zDhJYyMoyNZSFvrU3Ldjzf5ISZvtqsNh4DT1AmA==
X-Received: by 2002:a63:d257:: with SMTP id t23mr23900459pgi.533.1638241990777;
        Mon, 29 Nov 2021 19:13:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j38sm13233995pgb.84.2021.11.29.19.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 19:13:10 -0800 (PST)
Message-ID: <61a596c6.1c69fb81.5a81f.44c8@mx.google.com>
Date:   Mon, 29 Nov 2021 19:13:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-37-g45b2659d6eff6
Subject: stable-rc/linux-4.9.y baseline: 84 runs,
 1 regressions (v4.9.291-37-g45b2659d6eff6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 84 runs, 1 regressions (v4.9.291-37-g45b265=
9d6eff6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.291-37-g45b2659d6eff6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.291-37-g45b2659d6eff6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45b2659d6eff6c5964c83b3218aa7b9acc792c63 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a55d18a4b2a9200d18f6d7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-37-g45b2659d6eff6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-37-g45b2659d6eff6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a55d18a4b2a92=
00d18f6dd
        failing since 16 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-29T23:06:47.311263  [   21.302642] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T23:06:47.361702  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-11-29T23:06:47.371174  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
