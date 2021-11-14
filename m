Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5151744FA0E
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhKNTId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 14:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbhKNTIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 14:08:32 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FC4C061746
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 11:05:37 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id m15so8785482pgu.11
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 11:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NPOzBqrQVprJN8y/NcxN4wr12j8ea2wPCUCkuhTZ2Z0=;
        b=7D8a2tT7FgYNoM9a3k27l3CJJJQGFtdiEWQ0e+82DkxQyntSEA93D4x4bQ3kFlvWb8
         Xum0Rp862tdZDADohMRJuXDzbkHpTmC+BqszGq2+fDRBckF3OjPLC6546EYkgwu/T58C
         R9XPHNbr6ZUYP6omTqGsDmJ6G6s8j3oC8HZO3jZdja/h8OaqOi40uxhquc/UPuYSePe3
         AUFVO4FS6OyFkSwa8uNAVk6s3+Ig9nprEGkNRBfL+4S0JB3nFI+/zNb0RriuYDRToVSX
         ZaiS7t2aVFs4t+oXDmAlE5QB0qrrOipIYRo8Ft8AaOwync8Nm01bwoRmBKM6Qra1EA7v
         NeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NPOzBqrQVprJN8y/NcxN4wr12j8ea2wPCUCkuhTZ2Z0=;
        b=coGAU0tB7QsH1s36nTSmbqBOE3QWgxWm5JdTOEiy/jYzb4psKZDZxzzJiy1xN10ZWO
         X6Ot5HxPFxjwmcH65HbyTPZzXWT6BhIg+8Fl35GMyXqQ1pAk9L/edW8nCgHMo6Q/VaU/
         fsF+Tmp/RW/ph+Kb7PLAe5YapGCQyMsM+VhnpId6Nj7n4V37di9OAfGqIgR5ef9HzISH
         EtMClK96ZGssvAC5qTHHQ168pTdXpYZ37jIkWza9x1NqyliHmE/GutiUBeRz9OAnwzq3
         lCpSogIX3CeT0Y1SqT4jlSzMhfTIwu6hMjdCixat0rAdq8PVqtrhQRrC6K8IGXijpHkI
         CoeQ==
X-Gm-Message-State: AOAM530mAxHYWBODaoTT/gnQIh7+ApcTn/CQV75FfYEJfCc5hQcb8XqM
        BDHvytwQ28d+q5tvL+ExdBpSaRrUnK3OwQv9
X-Google-Smtp-Source: ABdhPJxBYgWVFVPK1Ej1Zjjp145/eVPOTMNYvn4FasPpQihqW8GwROLESv4kpCG1gingIiqompXs1g==
X-Received: by 2002:a63:7882:: with SMTP id t124mr1573102pgc.149.1636916736872;
        Sun, 14 Nov 2021 11:05:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id md6sm10299437pjb.22.2021.11.14.11.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 11:05:36 -0800 (PST)
Message-ID: <61915e00.1c69fb81.3056f.e3a3@mx.google.com>
Date:   Sun, 14 Nov 2021 11:05:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-38-g5a3e2c9212ff
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 131 runs,
 1 regressions (v4.4.292-38-g5a3e2c9212ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 131 runs, 1 regressions (v4.4.292-38-g5a3e2c9=
212ff)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-38-g5a3e2c9212ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-38-g5a3e2c9212ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a3e2c9212fff27dc5f44abec21b0cdcb00c14a7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6191256889044397dd3358e3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-3=
8-g5a3e2c9212ff/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-3=
8-g5a3e2c9212ff/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619125688904439=
7dd3358e6
        failing since 0 day (last pass: v4.4.292-35-g08732977a551, first fa=
il: v4.4.292-35-gf481b21305a4)
        2 lines

    2021-11-14T15:03:42.256615  [   19.634521] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-14T15:03:42.299521  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-11-14T15:03:42.308765  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
