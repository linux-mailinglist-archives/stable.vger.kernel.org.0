Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25D32AE4E4
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 01:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgKKA1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 19:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKA1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 19:27:45 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FC0C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 16:27:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i7so197869pgh.6
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 16:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DkWIx11NkXlR+7rmxebrEDvzxpPBnNcVjPf3A1qcQjk=;
        b=0ccAGMKQCjtOkk0rflvv6Jp9Uqc8DpTSwndN0O9fGw5qlaSXSozA7fYYk2lxnqWnYW
         Ou7UQycnz5nXZyJUFP6tC172tByumPpoqSQvIWMXMx/f3q8dpiIDT7zVciARTCwsQc7i
         WEv0vrDg3YPkWBxiVMVnqSvDgJuibqo1cJnwy3yTUBWwerjzxetY5Vulz3MarQFKO8KS
         KUVWxrF+PeErNOlMgvdaLKyDv/Cv0dJWj82lQeXvv+vvvSLrw3VosjZbDQau1qBhDJ6K
         hqd2jGdpusx/Dp7UydWEKk5e3kiDa/Ossc7SVkHVsa/ZFg3vaTo1R1ZfozPeydVNVtN9
         hR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DkWIx11NkXlR+7rmxebrEDvzxpPBnNcVjPf3A1qcQjk=;
        b=EwJfJWOXExd4kHSK14JFy9zkFTmbeJ1YsMdO7p1NC0iN3DR2Hma9yPuuM6JDn/7CQq
         TlNt9Fa3oUJTHU6uUZV2kR1bR0/OGlaLF9+Csrnn0xPkjv5plKcf7sCHp9wP3ETGIuJn
         7NFf0GyW3gWjfiaZql+h12ZLx2KSD7DtqXSW659AnAiV7ZozaHHHLvtSBucKig9Mk1cS
         /+mx0qH2PZLO7aCuF5+j9Xn5GR5nPqGu74lgMNeJoqEN6KBrocUqKrudrdZmVnpP9x/O
         Hyp5QMV+RRGOpVzxhWv905W1EWKpHmhRhaES/KexldBoBaT7nCr5WkBrCm0jrVroYSNu
         0Vtw==
X-Gm-Message-State: AOAM5302n5d3eyzG+0YWVtZmPB0ujnyNYxeRrtR7+v2xedh3HhlF5D2E
        bBI9eiUlErT5R8+1LPC/jP2xWa8RhSl+Fg==
X-Google-Smtp-Source: ABdhPJxjWR/KOZoJzgV/hEcOZ3KeX7bUt/mYt+jwcC4bmGlzHVx8q+BMelCf3ZXrx4Yu8VcSoIucPg==
X-Received: by 2002:a17:90b:3252:: with SMTP id jy18mr867601pjb.191.1605054464553;
        Tue, 10 Nov 2020 16:27:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w10sm133756pgj.91.2020.11.10.16.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 16:27:43 -0800 (PST)
Message-ID: <5fab2fff.1c69fb81.67cc3.092d@mx.google.com>
Date:   Tue, 10 Nov 2020 16:27:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.242-1-g113d25b242da
Subject: stable-rc/queue/4.9 baseline: 119 runs,
 1 regressions (v4.9.242-1-g113d25b242da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 119 runs, 1 regressions (v4.9.242-1-g113d25b2=
42da)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.242-1-g113d25b242da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.242-1-g113d25b242da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      113d25b242da11225c40f6c18760a98ac6da787c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5faaff2b3bd4b82fb1db8861

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.242-1=
-g113d25b242da/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.242-1=
-g113d25b242da/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faaff2b3bd4b82=
fb1db8866
        new failure (last pass: v4.9.242-17-g4a0d38d66d3e)
        2 lines

    2020-11-10 20:59:20.142000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
