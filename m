Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C94327A5A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhCAJFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbhCAJCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:02:18 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994DBC06178B
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 01:00:05 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id o188so4369242pfg.2
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 01:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LhoaeTXtnyomokPUA9DbWF5d+eOhrMjgV+pLuUH4rJg=;
        b=Hbk6Fr/lcafYkFG8LFHC19G6yY/6GFnt7EpqToA9naPjn6fYudCS966Yp9+HPpqmms
         6bvVd+mnU9NxGrscnonwOi4D0BD8T8VphtbsMbD+0XAQcRWHTLrt2Ui/e2Cdq2VJDmpq
         EHMOwz+gP0dZti6Yi/wHDZC8UBGpgWzZE2FLiOeLjcOiwCF0UA2yJcHCHZZ+1r4ZyupC
         y2p5KQNKcmNVZMBlz5boJ4utypP9GCQGj6aaZs1CftlsC4F2CYQSoS5c6fAvKNwfSESw
         flZGPvAWTALhJX69IbHoDVlx9NXOhI+tymyqT6RjVrlFZiqN1vXE4yXE3Oc7M1JCmEVi
         j4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LhoaeTXtnyomokPUA9DbWF5d+eOhrMjgV+pLuUH4rJg=;
        b=JEP02ZeKLkLCUT5Nog4fx4wC5eCQD8pFOIalzg+OIUXEDm0+kkROZ3xxi8+swwZFnV
         Dt0X8NZHJxL/+oSSOSW7IhH6YjFu2gINfxWZLtJ3YTcbZG5YT7bH72EqhW3D9eAru5Ys
         YDSJj4OZ/+9V8HcByKx9ur47VSOMGReD2bMisOlaznCS09RIwQcQMvcwmV7EQgFXNUHC
         quelaOR8MjanOe5ZPVxJlo1C5Zmb3bFkAHt+EF8aotT3j1t/SngUGTq8VQzNGAj480Fa
         50JORc0rWsaW/dE/bDk3EVEpUFCaYhO+Z5qkkkbS/FnNOVpMgDtoPZbMCwH347aH26ac
         8dfg==
X-Gm-Message-State: AOAM5308GKY8eZHBLrKd8GwAwoFiRaYqPSz/eKm5asu8PG1GtF/AgyIb
        +Vtqh3xLRDO72qi8qgNtOSBZY/QqdwedRQ==
X-Google-Smtp-Source: ABdhPJzclGDmtG+JMt9+d8Vd9jbsSmoPpRJeA3bgh/Y4Ep2sTKF8Y3vaGieny1uWV5Aois8yUUGc4Q==
X-Received: by 2002:a63:e42:: with SMTP id 2mr12954179pgo.100.1614589205052;
        Mon, 01 Mar 2021 01:00:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q91sm7967836pjk.37.2021.03.01.01.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 01:00:04 -0800 (PST)
Message-ID: <603cad14.1c69fb81.24d13.37de@mx.google.com>
Date:   Mon, 01 Mar 2021 01:00:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.258-61-g381f23792ef7b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 35 runs,
 1 regressions (v4.4.258-61-g381f23792ef7b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 35 runs, 1 regressions (v4.4.258-61-g381f2379=
2ef7b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.258-61-g381f23792ef7b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.258-61-g381f23792ef7b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      381f23792ef7bedbffadcd5b6d45e1559c9ad5ff =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603c7ada50ed8f3d3baddcc1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-6=
1-g381f23792ef7b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-6=
1-g381f23792ef7b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603c7ada50ed8f3=
d3baddcc6
        new failure (last pass: v4.4.258-8-gd58c8b6f6cef)
        2 lines

    2021-03-01 05:25:42.517000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
