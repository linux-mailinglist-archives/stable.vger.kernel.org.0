Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1C64443DB
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhKCOvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 10:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhKCOvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 10:51:50 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACB7C061203
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 07:49:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s136so2594529pgs.4
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 07:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W4E29PkZhfVTaDBuJl2AqgE6UARnoZR27X599e6Hj2A=;
        b=0KC6mcJcmgqflnSiEyMzRUZIG4mcBujEHc47CtUfZkzIMKCAS9eD1DDV2L7hRdcDgo
         Pz3srcr9HEzFdpY6I0+LQQ8hEVsczx75ZMMkncocHb3agNt99nRvUyMV3+5Jxu2NEu3R
         2i69vpBONeL/dCLubVneVEj6OOfGRXiiaZTWMWSuo2pNYpf5I+69/8PyW+t0Zvos7Fdj
         iQzHbM+EcfSnnX0Ys6Jr3vujsRZHX9LAfrBJiwzBdXmnB5nHu39zt6hwUc9mnujLcKkv
         ucv45NM9t4HkeO6/fljeo2t0ILJk+klcBtShWNgkPZV5Hu1Nn4zGYLY9AQuhUdxoXXkM
         x7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W4E29PkZhfVTaDBuJl2AqgE6UARnoZR27X599e6Hj2A=;
        b=AhTZ+7v5R2WtoUcRuYnieRzhVhQfYI8Poctl3s0VIB0+Lown1qp7rQbSHaCtunuArn
         G54D5D7lioOF/BS6Ndmjkbe4FMado9fynHJtAL5KSRmhwoRKuQFeAfdJFPA1nyaDQY1Q
         0aaJJ4bWUjdOD3ZoryTuvm2BX4Er8uO6sGoaZIV2avpw3ROcpQMwpI+F9MLaw3P4ekPl
         Ns40vG8LXlkaxriYSyawd8CyL7y4WpbTxuJfMGEXa0rnXqKudeco95E5DSaI05mjk3VS
         cWhfNPyrV4WNFMZhJr6wnzCqkrzWecR724iRylZ9y2av9mxRIvZ8LRClWDF+wilivqhe
         ZkCA==
X-Gm-Message-State: AOAM530RltlbjyK501f7q2sp/Qgc1OEBjM/STp7WCQESBVcDVQoBIhk2
        vZiwAZLam6LBWqVGBJM9TPEv2Tq+tQb1/pQN
X-Google-Smtp-Source: ABdhPJx4tx1O0kMMNJPFFrT/K0d5GqSrp2r3qhgGU6t+czQvXlQghRwtSglBhKSOMNZQNE4zbAlv8g==
X-Received: by 2002:a63:8ac3:: with SMTP id y186mr21457945pgd.444.1635950953103;
        Wed, 03 Nov 2021 07:49:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm2025911pgc.53.2021.11.03.07.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 07:49:12 -0700 (PDT)
Message-ID: <6182a168.1c69fb81.d77ca.607c@mx.google.com>
Date:   Wed, 03 Nov 2021 07:49:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-1-g2a132ad10a51
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 1 regressions (v4.9.289-1-g2a132ad10a51)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 1 regressions (v4.9.289-1-g2a132ad10=
a51)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-1-g2a132ad10a51/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-1-g2a132ad10a51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a132ad10a512f453b2af37a06e396a5375a876f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61826f43edcbf78fb43358ed

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
-g2a132ad10a51/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
-g2a132ad10a51/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61826f43edcbf78=
fb43358f0
        failing since 2 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-03T11:14:56.138280  [   20.456359] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-03T11:14:56.189126  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-03T11:14:56.198446  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
