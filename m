Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63752456806
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 03:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhKSCYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 21:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhKSCYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 21:24:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214AEC061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:21:33 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k4so6927382plx.8
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CcIt4jNySk/lwVVlFk42omq/HfUb+zSpfpZT+wchOrA=;
        b=IFokZG6fSmc3fRKjSoYQWx2aPTI39DjItIlb0DC1v6IMxg7Fdp/AIlCZLbXyNzJUuT
         fU1Xlxw/ipxzW+ao7nvO+Chi5Eu4ZYmLHkuYZ++1iBTVj98h9sed/oYzLBvDK4Lj70+0
         bgv/so68NoG6Zbu3i51ZDLYGM+MCbZiyBscYfCziw7YU2hqVtDqUARu5jH8+qffGumic
         jJb06t6RPu8imf8MmcUvzOzzb6Svb/KvpJbsT7wQAzMfcI/Y6VgDRRmCv2SVlpdCFaVG
         cpDrW1bMIqvrIJ9Flcym1RZR0IiQdSjGoyPWB5TaqzgQelTytYANpnlAvDFWdEqnAFFl
         6vSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CcIt4jNySk/lwVVlFk42omq/HfUb+zSpfpZT+wchOrA=;
        b=vSPqjnhMSAoLDg5TNgsR7ODI0H5t58UQ90a/NLU0VFC0cTDqe7KueRGNtdZgfLsx1q
         0cjz0c2HXv0wikU8ufat0U44v65FYR7WcPamDA5I3/v1goy/mc/AMJbETXaTC1COhyA4
         ATjbGKiHxs/LqWjOXuM2SuAvgeiXrozYlPpyOF3hSTlirgYOi9I6llT2fn6EXLDpxSQU
         qAPUaxB8nylVswXEt0GylDD/wKFmcP1DwlJ60RB71qDB3OAt1eEoNkfiirA+1ML6Nb3u
         KYpNtz4wdl7SA+kMSSLgGETLnJVgP9J7C9Cs3Eyt6hRywOagY/HXdvcPsmEZSEOPWBZq
         JGeg==
X-Gm-Message-State: AOAM533eF5InQjHQCIsp4EwAR1b3QndsRLjvGh5v4JDWN47VFtGv+Gxo
        4zxOINzQYKTxP/ncKWHM0B/0Zu+SisfJHqPp
X-Google-Smtp-Source: ABdhPJxK/BcGNJQ8jgyvjscquHszx1cAL46zZ2ZSFORul+PPKqUDU9WhnDX5UeGuRTgLCPKHa9S2Kg==
X-Received: by 2002:a17:902:b097:b0:141:ec7d:a055 with SMTP id p23-20020a170902b09700b00141ec7da055mr71876845plr.3.1637288492541;
        Thu, 18 Nov 2021 18:21:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa2sm10133647pjb.53.2021.11.18.18.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:21:32 -0800 (PST)
Message-ID: <61970a2c.1c69fb81.6bb64.d34a@mx.google.com>
Date:   Thu, 18 Nov 2021 18:21:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217-251-g52142ecdba80
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 131 runs,
 1 regressions (v4.19.217-251-g52142ecdba80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 131 runs, 1 regressions (v4.19.217-251-g5214=
2ecdba80)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-251-g52142ecdba80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-251-g52142ecdba80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52142ecdba8002e888412acb06148338155bf2e4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6196d1a6d41842ebe0e551ee

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-g52142ecdba80/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-g52142ecdba80/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6196d1a6d41842e=
be0e551f4
        failing since 0 day (last pass: v4.19.217-251-gdb8a90cbc48f, first =
fail: v4.19.217-251-gd104c0a7fd2c)
        2 lines

    2021-11-18T22:20:10.135958  <8>[   21.008117] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T22:20:10.181556  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-11-18T22:20:10.191171  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-18T22:20:10.210572  <8>[   21.083526] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
