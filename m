Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7845443877
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 23:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhKBWbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 18:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhKBWbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 18:31:32 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B0C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 15:28:57 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id j9so658107pgh.1
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 15:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XGhnozjlp8xFd3AK3LYkSIsHulDv+Sl1RZhPuPYESUM=;
        b=RuLPuvicY7t8Rttdmv6cEYkQBJlGFlS0wHWNnLogXmzxZ8WYG2E+8bbLYPLaPisQWZ
         RT3fxX+tKpoFznZhA+a7ceY58gf1z9OEXC/xmCtHBOqTJ4bXaIzbF7XJDRu/U38hF6Xb
         VaI9/CdARHXoj6KDokrwTrq+fDrxswZJ/x+mhlrUJApRHQ2s17affUJDVKPXNd1V4hMx
         Kxv1zd00LASB4Hc/HQK4HIk6s1XK9hYiU66Y35qLoakeQfEWebEV0M0725qd6W1iMHa/
         PG6lbfZ7jfUTeu4AH1smWzu7lswcDZgPBg5g5q13Vg23TDk2RKpBwowW/7saFW9hP8tR
         /LKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XGhnozjlp8xFd3AK3LYkSIsHulDv+Sl1RZhPuPYESUM=;
        b=YGS3j18FW9OclrDp9OHdpTEuDzL4RMY3qDb8Nhfi3XqK7XsTVB5pnXLMe8cR2tw8kr
         zdFVbvyx2irAv+O227HCCm86dH8QwRG5VsX/tqRzoxeRHxR57mDcZ8fhan+osvBJ/4CL
         VYF+Il6oAfAJe792eqP2xOKbVrlnkXIy++GdB4VOPnAUOAe+9Bhb5uvxr7u3AnjEbadZ
         jGvHCNAc5/qVqC1mUiY4Mh84VuHbexTV9NgE2x+KevVqgSTpAcQoXZNfQwIAgGa1QvYQ
         sSVvYflXTPZesdkmxFX55TCVL2JgoNT/74gTjKFlbHssg2d3LKL7ZDWsiuLFVFWbH/LY
         KrSQ==
X-Gm-Message-State: AOAM530YKBcRjkfekaql9yBBPvEF6iQbhSQbM3kWarzL8TJmq+Wc2jTE
        E2fp/2vHuUogFPaj+M7HvbymcIZRbXs22kbY
X-Google-Smtp-Source: ABdhPJxbzwjGQz0LThZCnwwLZv8qAVJg00u0d1PwwYOKbmcwvQyA49JgpJjwVQtJpq1n0zpabcyAgQ==
X-Received: by 2002:a63:2aca:: with SMTP id q193mr30260704pgq.211.1635892136825;
        Tue, 02 Nov 2021 15:28:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm165849pfl.173.2021.11.02.15.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 15:28:56 -0700 (PDT)
Message-ID: <6181bba8.1c69fb81.d6bf6.0e0f@mx.google.com>
Date:   Tue, 02 Nov 2021 15:28:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.288-20-g6fc9d83c1a50
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 107 runs,
 1 regressions (v4.9.288-20-g6fc9d83c1a50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 107 runs, 1 regressions (v4.9.288-20-g6fc9d83=
c1a50)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.288-20-g6fc9d83c1a50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.288-20-g6fc9d83c1a50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fc9d83c1a50ea24cada0ed01f289ce9544efc86 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618188c3ded7305fce335912

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-2=
0-g6fc9d83c1a50/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-2=
0-g6fc9d83c1a50/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618188c3ded7305=
fce335915
        failing since 1 day (last pass: v4.9.288-20-g1a0db32ed119, first fa=
il: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-02T18:51:25.922540  [   20.366455] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-02T18:51:25.974076  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2021-11-02T18:51:25.984089  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
