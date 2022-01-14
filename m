Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF3A48F2D8
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 00:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiANXLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 18:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiANXLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 18:11:04 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D33C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 15:11:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so23633220pjf.3
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 15:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9ZGzjJw/x+4SVCIMZ0Gq4zwev9+os0Kd1/lPpl+v3Q8=;
        b=102O1dKYW+gbXNdwDalGWtbz8hTgqxbhNgn7FX0OKOYc/6eznarLswrllfN3ciMShs
         ETNPKua3C4gTVCbXxl16cZ7qKKeZe2SzDjEzqcCj/8DMpIpTtIrZ5iACmsMFNukM3oPK
         PiA/wRMEsD9sMOCT04QGcDFvN9qIz9pZ0rGw88//ij5/ejCgcLKFcmqP3opqQ513FvFd
         3R03ETXmpJ2zk1XAcBlddrrSb8TC7llslJ+fxVAX4EP3WipzPSdHbfma4m1f8cXDzX3M
         iNdMLiJsiS7LDmFA7CuGBzHpv2I/ibI36KJlOsVwiNxs0HL1rZEeg54x58XW53b9jQzW
         Kw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9ZGzjJw/x+4SVCIMZ0Gq4zwev9+os0Kd1/lPpl+v3Q8=;
        b=7YdIu5RpkaGHGD1fbqu055WnPR9rd6MhkgnlUc5McADDFJ/YmfmIBbFdve+XJB8Edy
         oVo4xxkySpJ6p4fM/ktrrXVmI4OC3XMltk9CDTNjUUI92aA6aAGkA+1Z5wuhrZLrDuES
         cyIrwBbrXZSQ7jLCocPPZs+6KQUCeKWHKkYeZtADzbpUJrM2Rg4X6rHsO8xEC+Nb6nb2
         IiUfmoRmsQe3+gyPU7ZFLnfa8A+GDQVlZYjZdFjKKRNNeU6fAmHizhJDzXw91ZIwTQOo
         8tLhwp2SuYMosJKfPuLwTSeQpW5sFaGhOOPju+4R6Bc5aS84Atuj2G2BrK/e/OGb7+h3
         H07A==
X-Gm-Message-State: AOAM533+rTPzygD20hlbqmPDQI7++ja5UsFasyB/NtTj4p2pn8uZQNqy
        CBxfJotMgJpLi6g5rxBEQlujhZ+5vX4RllmM
X-Google-Smtp-Source: ABdhPJyAXVQoHTZHL+mrB3VeiQaZ0mwXl8Rbr0T4ZLw9jKfd0gu8pDVSOmI/13ZcFI+emYoqDFhScA==
X-Received: by 2002:a17:902:a60e:b0:14a:766:a8a0 with SMTP id u14-20020a170902a60e00b0014a0766a8a0mr11642069plq.60.1642201864152;
        Fri, 14 Jan 2022 15:11:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o15sm3168903pfg.176.2022.01.14.15.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:11:03 -0800 (PST)
Message-ID: <61e20307.1c69fb81.68510.9848@mx.google.com>
Date:   Fri, 14 Jan 2022 15:11:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-10-g2c80b66182ea
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 120 runs,
 1 regressions (v4.14.262-10-g2c80b66182ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 120 runs, 1 regressions (v4.14.262-10-g2c80b=
66182ea)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-10-g2c80b66182ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-10-g2c80b66182ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c80b66182ea2f5db89b3db12808225a84b99979 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e1d243fd6e19c5b1ef6748

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-10-g2c80b66182ea/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-10-g2c80b66182ea/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e1d243fd6e19c=
5b1ef674b
        failing since 11 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first =
fail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-14T19:42:41.049463  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-14T19:42:41.058401  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-14T19:42:41.075479  [   20.177490] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
