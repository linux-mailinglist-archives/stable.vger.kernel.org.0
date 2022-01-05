Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65AD485982
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 20:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243695AbiAETvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 14:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243738AbiAETvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 14:51:16 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B8EC034001
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 11:51:16 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so109409pjw.2
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 11:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YE/fgxly/QxtL5f0POEOeBairt66WAEpGF3k9XOod38=;
        b=g9ajO7+5FPR0mY+oWVKz1BMs9GitGGYIcea+bvRqZ24u57fGCpYqheEIJIi7kqEsif
         650sR74wWIW1RamnBsZ/UOLPCNaiV6J6KRmenCv2je7VbPprMWnKuKM8fo308ipY3wF7
         xd6ClRYbzi5tt2v67OHxOa+hBZw5PbFO/Xw+SwROD7VkEPmSunzS2fH2K69gQGlJeRP2
         VP358JjBCWBbOg1OfSxgzxcPItT+niUp2RqPpmjG31Gq7IELQ73HjXOY3tTkzB7YOJLx
         X9ahcFePBl8AYgrrXTHoxL9sVkRLtLW8aWDcS2ahXB1aifWbJScpoXNMRIAWLiYjHL/E
         qGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YE/fgxly/QxtL5f0POEOeBairt66WAEpGF3k9XOod38=;
        b=BLDqvuf/ichrN1/9uO0vGLggvw+uGT2rH433VxoxRzbmZ1xpLD77IDkcff2VIK14mJ
         8w8B4cukuoyQlT976ORlPx4+cw17Y4OVmwoiHF2jq0zTU/MQbfkK17oTC+jJm/jnJBKZ
         s5vbC/p2D9y/Q6UIGNGUQRT87csGyBw1bfo4B6zxVjZ0f0cO/rjs2lkB7NEwn54rJL0A
         Mba3xZrhavgnA8QZ+AujjSUwJe6gNmDVQWlu+4Qq2B0nYJGiS/eYE2fcZudimPew2+mB
         DtY/df0xEnBzcCThUhp0VN914LVCuW03YEfg2uhFeRvqJRMm8JNZYsF2pK4baDFd0l5R
         B7PQ==
X-Gm-Message-State: AOAM532r+Mue8BMvH17a/Y07ZsG4CpwNZCuRXMDqDDL1Y/ZUJ0MtHUlc
        vcQ9yuWeonDlg75LwqZ26CbrLHxt5Blkps4M
X-Google-Smtp-Source: ABdhPJxU5wE5ub0ZsYBQKEAOHUyzHlvoDnWcG8zr/QchedYO6l9zfSJsfHN5J7L9ijCadHid/v+uug==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr6036445pjb.246.1641412276088;
        Wed, 05 Jan 2022 11:51:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k141sm44663949pfd.144.2022.01.05.11.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:51:15 -0800 (PST)
Message-ID: <61d5f6b3.1c69fb81.ec7ef.9208@mx.google.com>
Date:   Wed, 05 Jan 2022 11:51:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-19-gae196dc2c9ce
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 144 runs,
 1 regressions (v4.14.260-19-gae196dc2c9ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 144 runs, 1 regressions (v4.14.260-19-gae196=
dc2c9ce)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.260-19-gae196dc2c9ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.260-19-gae196dc2c9ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae196dc2c9ce32094877e4d1b8ab1742141a8970 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d5c16349a1626644ef67a1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-19-gae196dc2c9ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-19-gae196dc2c9ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5c16349a1626=
644ef67a4
        failing since 2 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-05T16:03:27.240074  [   19.977935] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-05T16:03:27.284522  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-01-05T16:03:27.293582  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
