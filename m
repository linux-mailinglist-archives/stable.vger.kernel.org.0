Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8EA481AB9
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 09:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbhL3IWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 03:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhL3IWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 03:22:12 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC67C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 00:22:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z3so17756497plg.8
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 00:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GJ3OQ9DgHOHihhnbmho5ZYAbN5OI5StqZGZ9OghLGuo=;
        b=s6J+pwuCHJplL5I5bdOy3zFlNB4tlxYL1nv78mwZaB1Ij9YAjGLV/kaPoCEGr9iToW
         caxcmVhilFTRdZ/l+7lYsvv8QXJTx23KmW968t2zWyUw6ml8OqzmUcayg2COXxJ9DjAT
         JeldEmbR7JhB98+BUW/Fdt+iwCC20mXDfZqss5ZVZg4XybOknGTfgo39OXARFj04H81g
         dfZSSew/vMBHWrVjYJ8K+xAHRBpv7+xQTHIgmINwQed6ojq6I8VtVsbavI2HMx/XhjO+
         /lVJag96/tLNtOAbAZKqc8umGORjgRrXuTbc6K7o6gIQF9H8iETNpvzd/j1Ne9eWgtTY
         EqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GJ3OQ9DgHOHihhnbmho5ZYAbN5OI5StqZGZ9OghLGuo=;
        b=gw6T72llakLXVjCNsfpo6JLkF3rwDD/3UqHmX5tZ1bbAgLFp8LGJUUF3NgiVznyttL
         2/A+xS6bsBceQhmLCFJQ4oy2U2GyyIvIRXAEB/zH/KkL1TjdQA3++pehryg+BviWiBCQ
         BhUSW+EPaRU5l5ys526LKWZwcNkFj1bTf7Yp6He2G9XTgBMUwgkp0YexFjpqyTqhOsXX
         ymTxu+zFOlxsn21ZB7yf/VaYNZ563ZaTR3d5ChDIF1+AsR1ypk8I72xKMVD0kJTHmU4Q
         jchPIXCCcyrynStVqXFKFI0NszBtQvSwdCgttm7sFO1vdu/FCnj7GTuDE7QlHHRwQM8c
         kQHA==
X-Gm-Message-State: AOAM533IX7ng8Klnl9qJc1d+RlWESZ9ktPkXfzEfu47gFXdnvLBQpach
        DYnUdT5rpT3YB88b51uxUFoTNhlJKjy4SsAY
X-Google-Smtp-Source: ABdhPJwyOGEIskmp1MMLBm6nBjg9Wjr8ffK+Ogb5ELYNDKVahMKm/fXrJf+S7d60o8TxNQU0uc1L5Q==
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id m3-20020a170902c44300b00148f689d924mr30096132plm.78.1640852531570;
        Thu, 30 Dec 2021 00:22:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm20266379pfl.18.2021.12.30.00.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 00:22:11 -0800 (PST)
Message-ID: <61cd6c33.1c69fb81.1283b.87f7@mx.google.com>
Date:   Thu, 30 Dec 2021 00:22:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.296-18-g954deba47211
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 93 runs,
 1 regressions (v4.4.296-18-g954deba47211)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 93 runs, 1 regressions (v4.4.296-18-g954deba4=
7211)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.296-18-g954deba47211/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.296-18-g954deba47211
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      954deba4721157cb622c84639dc5af67139aad5c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cd32ebb895ec41b0ef6762

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-1=
8-g954deba47211/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-1=
8-g954deba47211/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd32ebb895ec4=
1b0ef6765
        failing since 9 days (last pass: v4.4.295-12-gd8298cd08f0d, first f=
ail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2021-12-30T04:17:28.194370  [   19.304138] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T04:17:28.240904  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-12-30T04:17:28.250174  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
