Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56C34500EA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 10:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhKOJQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 04:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhKOJQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 04:16:09 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BA0C061746
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 01:13:08 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n85so14453820pfd.10
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 01:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PA+MeCpzT3mZ+hoLKXbZjMcc6caueOexzw7Js4KbNd0=;
        b=xXgh5IEcbWiSjS5C462LSpoSeLCe8tgZXFsqGFJoIEhtJCJcy3vwO6EIYyOSY6yfZj
         vdfZq1/W28J0HZ5INYOzxMQkJgM7w5jHM1c9uZjGfY+dv0u7jaFD1KjsmGW8keki6kzP
         iL77tQIGZR4ShmoOgZYlDRgI8A6JETZkf94SIVayp+78lEgnJyjIIl58JNICyhPjhhbq
         UX1oBafAnDVIkZZBjN6FNmO01XjSHmfVL0tFZyE1OJxZCQftv+q5kBQshMIF+HmBu+U1
         2DhPE4dX2pz05m8mSZMNaGx6B/W4HqIPd8KHKPgMY3pw8DbYAy7UiMtNSW9S4YnbBhDH
         5ZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PA+MeCpzT3mZ+hoLKXbZjMcc6caueOexzw7Js4KbNd0=;
        b=0umurrvgQN0yy5veKJfb1rCeSm3mHgcSRxOYTOo0WwzS/75Nao2jdO3kT7cCCz5W9q
         5Z5eCiL7CRvUhCDxKLJxWE9ZKIPyyO+lFf2cL2DGGWM2rz5eLvzV8vcC99kChtwkH7aV
         DwqlTbDX6oS0N5qUgbh2iwSbrUxHaMDidtkRwI7z2qaEmxALOdDaYNh1+Nhz7Kv1qh2l
         nE4ZTcJZoihUj0O8BqT4ndhg1J+zuCkw9/sAi4UHMcLAByECLoJv/cNDaKP+p93bRiQ/
         s4EBhZ28okl4TIdIXYuskoYfXTLqfKt562vKYc2MZRYvtK7xZvAVN3bW5XMG2litORxe
         hzMQ==
X-Gm-Message-State: AOAM530P/aM7ED5OevYUu8B9eKW1dAFS68Y6FHhyVM0iW25XZpgLdxoa
        rPHXiFW6WrvTOuRSel4yQU8mTiPvJRtdyvzT
X-Google-Smtp-Source: ABdhPJyugn9Ur0oBXlF7YIcEsfbM4XhDSJCDh/i6rq8WfFl6m1Blwps6l8g+iameJ8AakCJ22m8D4w==
X-Received: by 2002:a63:491:: with SMTP id 139mr23708241pge.285.1636967587369;
        Mon, 15 Nov 2021 01:13:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h23sm14092536pfn.109.2021.11.15.01.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 01:13:07 -0800 (PST)
Message-ID: <619224a3.1c69fb81.80a64.9070@mx.google.com>
Date:   Mon, 15 Nov 2021 01:13:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-191-g525eee50f7f8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 160 runs,
 1 regressions (v4.14.255-191-g525eee50f7f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 160 runs, 1 regressions (v4.14.255-191-g525e=
ee50f7f8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-191-g525eee50f7f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-191-g525eee50f7f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      525eee50f7f80cf1a0bbfd39b673fab7096b4537 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6191eaa85402d0d05b3358ec

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-191-g525eee50f7f8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-191-g525eee50f7f8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6191eaa85402d0d=
05b3358ef
        new failure (last pass: v4.14.255-69-g8d7a2e8287ccf)
        2 lines

    2021-11-15T05:05:25.474263  [   20.284332] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-15T05:05:25.521794  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-15T05:05:25.531550  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
