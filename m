Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BDF446A7F
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 22:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhKEVYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 17:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhKEVYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 17:24:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6699C061570
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 14:21:57 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id p17so9365386pgj.2
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 14:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j4tD6ukmz9xW/8iOF+zXaSYzfC+3vK7tuiN7pPXc7jE=;
        b=zJGDN1CZOGomJ5JGOejsau1cJE2rGuchG38Q3GKEMcdngNu9//h6j4OzhvJ7Bl2zT1
         JQTtKpz4oiWcFERHhn7QQQ6sgsxc9xoUzuBY2nI6GLjR/2Xwd+m7JdmuB17jXit6k8z8
         RIEYQtHMhvc/OG+j4eBFVNqjRp8SzBXE/1GJucFFUARf5gEFIISpl2+qo5NriDIrKusJ
         sUbs3KnlJaSzgAdbSlDJ6tJBXh8IA8yQV7Wf17VOwLcpL0Bf4CVEY1en9AMhoia6FkKX
         9Hl2rYFGcjPPli1k8LWv3FD1BMnTAmlbDMrOfQwcyxZw2WYMCRPDT86EgGM160fYHzib
         F4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j4tD6ukmz9xW/8iOF+zXaSYzfC+3vK7tuiN7pPXc7jE=;
        b=rgkRWudXep93EzbxiYrDS3WQGlYCTc1dj14Nx+E2YxdsDEov7vcyyqkZjwNfcNdrAj
         3weGVF0Lc9nrDZ88xo4mYeGb8kQC6KsYBZbkVf0TtvqYoxa93cLeyb4OO6DPd4WLiIem
         V9kJFAtrtTxJGDgM93ElPEV0bFCRAwmNcOWHB6htfGWx2MpZRgCmUyXmAMd6h1HSX/L8
         aYMYSTB/UUQH0pm6P5Mr0ZukjagwiePCmataalMC+QdmM5fTPo7D1dGy3cUDPZ+Oh09S
         Rq2TAXPlNt8kbWvxR3cXddqampM4YWPXF0etA+AsZB2Jcc7IDbM9w6r6eOE1h8D+zVXx
         MoSw==
X-Gm-Message-State: AOAM530S2PPc+yWfrOYStmua/RjUUlbFj83dMIjugj08CFNgP1U1fLiM
        5rTeS1O9MiDkV5BzbkXoQwxoBmnjCnkafIpE
X-Google-Smtp-Source: ABdhPJx9DU9Q1e6jFuf+5+3oZeE0KdIs/UmYqgc0XmM1rUVuoy0+Ltun/qPUwQbUY55YMrLBtt9vOg==
X-Received: by 2002:a05:6a00:1309:b0:44d:4d1e:c930 with SMTP id j9-20020a056a00130900b0044d4d1ec930mr61583580pfu.65.1636147316987;
        Fri, 05 Nov 2021 14:21:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d7sm8902030pfj.91.2021.11.05.14.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 14:21:56 -0700 (PDT)
Message-ID: <6185a074.1c69fb81.c4ea.d791@mx.google.com>
Date:   Fri, 05 Nov 2021 14:21:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-5-gd40c0701ae4c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 138 runs,
 1 regressions (v4.9.289-5-gd40c0701ae4c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 138 runs, 1 regressions (v4.9.289-5-gd40c0701=
ae4c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-5-gd40c0701ae4c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-5-gd40c0701ae4c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d40c0701ae4cb5ab84408e8938750ffd652a9821 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61856cedb86e88935f3358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-5=
-gd40c0701ae4c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-5=
-gd40c0701ae4c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61856cedb86e889=
35f3358df
        failing since 4 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-05T17:41:52.536916  [   20.591583] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-05T17:41:52.587750  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-05T17:41:52.597955  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-05T17:41:52.617698  [   20.675109] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
