Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CBC4588AD
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 06:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhKVFFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 00:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhKVFFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 00:05:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C5FC061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 21:02:41 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso14205352pjo.3
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 21:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=msSJ2hN3XOYDilVJKAzC1M+8Iq2CGIp4hYm8nQUQjuY=;
        b=XAeWxXAQHWLf3sOMlnNeP1T6iRIWyB9u+p35GjkD4ppG5GEVXqjA0idZ3W/NhmLLAy
         J9hMH/K56maX6VXkE6AnksHM/x83H9EUoZVN+J6/PfX1yff6Aeq5L/+LpwtJRAvSuAjm
         iuBfi6DHXfjpH7RW4Cv4PtUu7HInvWm7yTaN2zYQq0bXyho/F4wSNAYxMFiidGVhS3ql
         1GQ3jPBGsVZgPm8JCMy2xvWPxGMUITY75RUsHM5i+Zqk4DMnvusEI5bz22v4I5fN4I6b
         Nr51zvR6/HWJ0Ps98FpmojYKqqz3qWM9LGZ+WJt0XnzW1G8PzlTACWs318ttWqmOTwD5
         LLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=msSJ2hN3XOYDilVJKAzC1M+8Iq2CGIp4hYm8nQUQjuY=;
        b=eDWj0a+nUkWdOqElm3b27vvq1GiSCaht6juVX9RnEDEzlRXK+i43VA6dSY3s/VrdA/
         pF2qb21lYpXybtzsI4E7LCxX+3GZcAzHGPVSk6vc+xJyLK4afUPBoJlWWiWNddKzHQmX
         EKlTQ+d/+l7lza+giH4y26NKfEvi8KBXp1P8f6PwJ0+U/v4hXJWV5pSKf2+L5z2wNEpu
         UtmM3gGELxTCPx+jNJ/3tO8p4k734VruXcx1LFabLCkhqYKvlp9yh9sqCphYVaS//UC0
         U8l7VrixSmHi3jknJhfcFBSuaMiz/S3hrITKZcIgxM5p15e0e84MGYddZlYyriaU5pY2
         NZpg==
X-Gm-Message-State: AOAM530WfBXCbY9KX6WDgbdoEMnvKzXO82IOtk7sEp27qbqZ8j67W+4f
        7vyaiZRz4IbdFSuJkn9wHRnNZ6N1h+poEfio
X-Google-Smtp-Source: ABdhPJwSGWLm23jMQBmoxiXSnTDQJOzYsoK0MYGWWKxyT3XPp33lrJxIAR7fJ4C+74sGTVmiaNcsKA==
X-Received: by 2002:a17:90b:1bcb:: with SMTP id oa11mr27362536pjb.140.1637557360757;
        Sun, 21 Nov 2021 21:02:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm4856206pgo.88.2021.11.21.21.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 21:02:40 -0800 (PST)
Message-ID: <619b2470.1c69fb81.429d4.efbb@mx.google.com>
Date:   Sun, 21 Nov 2021 21:02:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-231-g73f81038f9b80
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 145 runs,
 1 regressions (v4.14.255-231-g73f81038f9b80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 145 runs, 1 regressions (v4.14.255-231-g73f8=
1038f9b80)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-231-g73f81038f9b80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-231-g73f81038f9b80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73f81038f9b80a437cf32dd3e1e98a9854936e8b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619aee00481db55f8de551d2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-231-g73f81038f9b80/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-231-g73f81038f9b80/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619aee00481db55=
f8de551d8
        failing since 3 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-22T01:10:09.836819  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2021-11-22T01:10:09.846535  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
