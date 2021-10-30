Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FE2440B7B
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 21:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhJ3T34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 15:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhJ3T3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 15:29:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662D7C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 12:27:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so6424117pjc.4
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 12:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b4PAYOIPnA65ArM7R6VMH77YHRECG5+VmvdPXyhtWc4=;
        b=oaH2FFy3g7wzBnCOyY+VxCaY8+25clRWtJr9pz2hIF6JiLITfMg6xCl4Y3a9lWYLdl
         fc8mE1Jb77jPhUlO3kuoNEPaX2lepoS/FSH4TcKssTzYut7m5r25QJdIk6SatRE7N1G0
         0G7iS8O3+fCh+J0IVkwF6q5PS+S4af6CyNsZOvVFLY0jydeZP4MCM4me3AmvJSmH0Tba
         gxBRNRyYJ7taGl+88rUxTnQ4sBlNOexGqFb+Y3Uvsmf41oK1D3ApHWoYEujhF/avAb0Z
         ssDZghPuF82Oroxq71vzadfsyCRnPCKrU3aKcam34+n7ZOV57e7V3XIzEUvPBjy9iGU+
         3hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b4PAYOIPnA65ArM7R6VMH77YHRECG5+VmvdPXyhtWc4=;
        b=6ox9dTI2B+/afCtnu1c1w6fL+23l8AIUSkR3B6uKTvoHJKCM1cQpEBD+bacxsQ1/xy
         5r4tZSn0Hu668bmWhwhZnLzhidUwIj+t9wqyyzyXCxmW5b9pg1EBeomtn//fZDYrO3+2
         lr/gff7XH7TrRFuo0/S2RhO30ltzVJMobA+pvgrE18jzNBDacmIa67wn2/x2N311Z2vG
         YTAkKlmv6P1fXZmCN+0c+d10nRcxpkxSF3zdefDixnsuCdndeHjr3jt3c6+0HTAKefEz
         h1I3TfxPK0+3n2SQ5Ww29CaEhozeLJZ8hajePhflCiXpfmSDe518OrlwX7V/vPt212XR
         uI0g==
X-Gm-Message-State: AOAM533G9A82pxQmlDOouucfMuHKjKHn6NnK1OkF88KNtiqhcqTY+QK0
        v9y3HwGjjFDNScBIHlfEXYwcwxYSRkvfHDZw
X-Google-Smtp-Source: ABdhPJwQIAbGDBn9srYjtjFRtt7V6aCsGwfGgD/BqX14ACJAWSrQvhK0qyDmRaltfTWqggvzEmXrJg==
X-Received: by 2002:a17:90b:50c:: with SMTP id r12mr19284928pjz.71.1635622044720;
        Sat, 30 Oct 2021 12:27:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bf19sm1210277pjb.6.2021.10.30.12.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 12:27:24 -0700 (PDT)
Message-ID: <617d9c9c.1c69fb81.b1e3.2d1b@mx.google.com>
Date:   Sat, 30 Oct 2021 12:27:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.288-18-g37ad6744e03a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 106 runs,
 1 regressions (v4.9.288-18-g37ad6744e03a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 106 runs, 1 regressions (v4.9.288-18-g37ad674=
4e03a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.288-18-g37ad6744e03a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.288-18-g37ad6744e03a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37ad6744e03a3c16b63f3bd78c583a52bfcbf450 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617d629e4d700f17833358f3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
8-g37ad6744e03a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
8-g37ad6744e03a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617d629e4d700f1=
7833358f6
        new failure (last pass: v4.9.288-10-g8bcb3b51bfa1)
        2 lines

    2021-10-30T15:19:42.617341  [   20.002990] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-30T15:19:42.658842  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-10-30T15:19:42.667727  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
