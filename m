Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CAF3216C7
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhBVMeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhBVMdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 07:33:32 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7D9C061786
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 04:32:52 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m6so6523400pfk.1
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 04:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=weudKI7W0S9y63SBbknp3Gpji+fj7VJcVTGyMdZ3ae0=;
        b=hmtmrCQrAuJfsGnPHrDwPSB5RiCUIcj0zexY7VZBLXLomgwrbTxYZMDYyVayiQ9RFw
         kjIb9vrT8hXRIXPpqLPQj7l/5rsRAtFGoun/jfPCy8dniSf+kQJ8fXO6S49J49U/gE+r
         jfCGsrbGMo92oC5652OTvghK9enXx6PJM0sWUQ59o3goYz7kbv0H3YOOMKQIfx0iJjPd
         umT7kb6DpkCrhBkopomoCz5zau6myUhH+02es1Q3SWkjXqg7Eayeu5bxnxfbfCRQJgCz
         QKUAe7sX6UdLD/cJtc8JEnJFWTzbnzL56WoavSmRVJlJYBW9lfC8EZqa+GLaoiIWD6xh
         r6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=weudKI7W0S9y63SBbknp3Gpji+fj7VJcVTGyMdZ3ae0=;
        b=O9DipwDbOJIeqirvcrClgG4lTEyHF4Tmq3wAL+/h8VO8Lmc6QBf4/GtbHAmAkCBWdf
         1OL3kTCCcyuFqt/u8U7NWKZ5+Ru1OgG8sll82q9C70UCE9laCBSW/WvJmSK3dp56GmA/
         pwlmXS660NBY55d+0C2a+bwxRJL5NfFctSEOYgF+X/wZeV0j1rN15JEJF3iP/cXnoMFD
         RCGOZbX2zQp8T2K+poZu4teyj9NBGUj86K3LagKQgUih91KISwLeQH/PLrQN2/BVqj7l
         Zj2NeGULGJxac068WBvISxfyqpKT2JVfQxm03IIMdnf96KbLD1UQn4kF2IzDguaPHOXB
         05pg==
X-Gm-Message-State: AOAM531LGO7kbkaGHB+I4iQwExEWdWDUl+wjs/zgINhBtCGWKJn8/aX+
        L5C9AIXy8FLZl/kax8RAK6+oj6Lz1QE9xQ==
X-Google-Smtp-Source: ABdhPJxSh993L5ksVVHSx3JYIIlgYUBW/8ZNDXGgA6CKLuN7A7acFVBYPr/oxVQQMLbLlKCBBvdBfA==
X-Received: by 2002:a62:cf06:0:b029:1ed:c016:1e7f with SMTP id b6-20020a62cf060000b02901edc0161e7fmr1036636pfg.78.1613997171875;
        Mon, 22 Feb 2021 04:32:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1sm17939352pgn.94.2021.02.22.04.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:32:51 -0800 (PST)
Message-ID: <6033a473.1c69fb81.47cd2.6a87@mx.google.com>
Date:   Mon, 22 Feb 2021 04:32:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-39-g9ec85b6c46de
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 95 runs,
 1 regressions (v4.19.176-39-g9ec85b6c46de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 95 runs, 1 regressions (v4.19.176-39-g9ec85b=
6c46de)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-39-g9ec85b6c46de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-39-g9ec85b6c46de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ec85b6c46de11bb8244475c741bebe4dbe705c1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60336a2fbeed041eabaddcb1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-39-g9ec85b6c46de/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-39-g9ec85b6c46de/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60336a2fbeed041=
eabaddcb6
        new failure (last pass: v4.19.176-38-ge34222cb6df4)
        2 lines

    2021-02-22 08:24:10.422000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
