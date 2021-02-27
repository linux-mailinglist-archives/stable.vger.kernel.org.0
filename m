Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3D326B0E
	for <lists+stable@lfdr.de>; Sat, 27 Feb 2021 02:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhB0Bev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 20:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhB0Bev (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 20:34:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53EDC06174A
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 17:34:10 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id 17so6204561pli.10
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 17:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8DyxH+yOYSAftf7gyo/Ke0rI+jgl8BqvAgpASxJkePg=;
        b=NSb8ydxD9Kjtd98th1KztB4q3BnB5VqvHxTkpyymrB6ZLKR9Er8XlrrNuWUF4h9H4Z
         0a2Hu8q7dmxp5MSWKWOw0+DjZWit4G+IRKW447Dlqpe7REtdT63LT7Gbew6MWQemARVJ
         1Jrx8wgbDz53TaV2gmtqa07HDB4+OngSUYjZMkC1cfBGDWwh5zIcT65uLdiGqtmxFa3D
         cNU6xC1IQz1btaJp/3Snj5AbgZBzajhwqtPwcxjKo5IVlBiVX0ZKxbmpvNHZXfpFBk81
         sNJRQXO907Yqx9MfDgZcSNkyLFjlxGw91tBrfwvyZjAvAgclm7x2UhpZyJ3q6nhcAslm
         ptew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8DyxH+yOYSAftf7gyo/Ke0rI+jgl8BqvAgpASxJkePg=;
        b=bhegKISSrjYaOEct4Txgus+RXSZ4B5BTmz/TanQ9sKhwlbPAiVmSqXPeyrtI9CEXPc
         IThCkXf3v0+YGIPUc7xlJY+MV26pHjj3II3CKxSskBR5S97FHp7ZC+SwushYsciI/5Me
         eZTvQKUPzEHDqi+FgDoMgJ4FVRc+TixxvdxPZ6tdEcqtGDK5vDV5hUIbDSffO9wsZN+y
         2zlfUpfqQc1pLa9fyc+h6214MVv3i5p78JmbY6WYES0N69c87+azLjg35wD4DpHGex0v
         QxrlupXeYUkHnrml66nCZczQM8QCZCqD0iIoIeh1mnKzVrzwqSFGA5WbZx4pFW/QHCex
         Vngg==
X-Gm-Message-State: AOAM531YkzGbldTjqTcAyGZtSUMQUm0qIbRqK5TVVUH0D6okEtyxVWjl
        VlYhqz88ai2L3kvzLHyuQibibXIXVi/vFg==
X-Google-Smtp-Source: ABdhPJyQ00r8ZzsJqTWAx38FB2ufIT5CXYsto6eh0zyy45S79zTti/WwxktFNkDDyjvhp7E5f2Ap6g==
X-Received: by 2002:a17:90a:7c48:: with SMTP id e8mr160138pjl.89.1614389650226;
        Fri, 26 Feb 2021 17:34:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm10176865pfh.150.2021.02.26.17.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 17:34:09 -0800 (PST)
Message-ID: <6039a191.1c69fb81.68ad2.82cd@mx.google.com>
Date:   Fri, 26 Feb 2021 17:34:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.258-6-g5bc2e9b304c2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 34 runs,
 1 regressions (v4.4.258-6-g5bc2e9b304c2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 34 runs, 1 regressions (v4.4.258-6-g5bc2e9b30=
4c2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.258-6-g5bc2e9b304c2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.258-6-g5bc2e9b304c2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bc2e9b304c240bfaa5524200ffb33d3416c78d6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60396680e54398d908addccb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-6=
-g5bc2e9b304c2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-6=
-g5bc2e9b304c2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60396680e54398d=
908addcd0
        new failure (last pass: v4.4.258-6-ge6404c3da628e)
        2 lines

    2021-02-26 21:22:05.106000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/120
    2021-02-26 21:22:05.115000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
