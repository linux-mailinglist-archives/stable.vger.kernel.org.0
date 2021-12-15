Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4014747643D
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 22:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhLOVHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 16:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhLOVHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 16:07:46 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B49C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:07:46 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id p13so21798677pfw.2
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L9OKJkqKhufmMuB1Vl3Qa1hod0ydeZ/vf7o3OfQ/BsA=;
        b=EjIcFc0ZtIokAY/2cdFfYkr/urdxEtP11juxxRoXRcomi45eX5qGhXlVTs3+NZxNIO
         AC6WUixAtRy9brwct5fUs2+NwN61YetxnWeSRCRnlPQ4NUmajsZDODVaIHUi2SfTKKQT
         07QNSrGOBO10OecKJX2RRz18ZhPWPcSy4/vsb/s/lYPP+b7fbKFX19w+0ZDUj03dQzNV
         yNqjbuvkNiCoWvJxQC6kufrndYIsZ9wSpyV2RIA/2O32uET5na1YDPKMoXrm+MXQvHS2
         WO0NdtKZ2CSxrRDHKnBdmD0JNWqQz4FvWSVEs00PBhMtoN9/fKAUoG9ULe0044FF5ZKZ
         t4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L9OKJkqKhufmMuB1Vl3Qa1hod0ydeZ/vf7o3OfQ/BsA=;
        b=WE3Gmsy4ipMlgQZGB9ScMc+n7XYQIylmrJHWf3I3f7p3qzuKeAXJ0Q/3vwf56qqmAS
         RcSNE4dDKUyPPBQAS7f5BhJpm78h62bklJpjYur61vuPLQgPLFaTweXUVWdb4waMKQue
         AoxRaOfqtWqMm5IZpyzCB7o43PTW6JHZDXtj5IyThXoRHtjVm1O7BjXFT7EQU0limGHv
         W2l1MxoyXGeIpKmFWXEb3bIcNe6C1odCKMcngTpLWrKcdKA3LNYt+At5UosmFO3fNN2v
         SZBgus7PQDTIShWJohLKsgrycVMMqkKLVvtiy8myR5J2XjHHzGpNRRHMzzcncJFKHnp5
         jB3Q==
X-Gm-Message-State: AOAM531BrAv9hvVjQvThpcwYBmQdAME/N80fX/XVZvyFZWQWkiTdEY9q
        3QY5WeKmpotEP1FOmp4s7zMci5FN8ns/Gjh4
X-Google-Smtp-Source: ABdhPJzhtd1fJnPRNMVlduoNbTKQpMfTfjVb2425O/uBFJyUvOmID9Ujb6p8f5sc6H+GFeqBYCIzSQ==
X-Received: by 2002:a63:5752:: with SMTP id h18mr1119326pgm.520.1639602466041;
        Wed, 15 Dec 2021 13:07:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k19sm3556785pff.20.2021.12.15.13.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 13:07:45 -0800 (PST)
Message-ID: <61ba5921.1c69fb81.834e7.9aab@mx.google.com>
Date:   Wed, 15 Dec 2021 13:07:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-7-g3a18355545cb
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 1 regressions (v4.9.293-7-g3a18355545cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 1 regressions (v4.9.293-7-g3a1835554=
5cb)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-7-g3a18355545cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-7-g3a18355545cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a18355545cb476de4d5bbc5d754b42271d6cd94 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ba21dc97c50be03f39713b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g3a18355545cb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g3a18355545cb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ba21dc97c50be=
03f39713e
        new failure (last pass: v4.9.293-6-g9a8ba0208160)
        2 lines

    2021-12-15T17:11:39.157944  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-12-15T17:11:39.166982  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-15T17:11:39.182235  [   20.778564] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
