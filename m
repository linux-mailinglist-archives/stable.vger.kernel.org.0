Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09A9481581
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 18:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbhL2RAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 12:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhL2RAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 12:00:10 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57F4C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 09:00:09 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id l10so19002573pgm.7
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 09:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FibGhSqLdb7Fzegm3TMIXUYeUPeP/MVJTkmpBe5DjFQ=;
        b=e0xmRKcGunflnZKNvzrt6lHRAwSX+uucxoXrc5MfySpEoyUks1zO8Q3Lxr1aLiMv1o
         k4kbEeBNROrGKaAGqOoxAlrbs9uGQsDzurjvCoB8V20lKTZ7g1PDcthD/MW2O5YF0V4f
         9k8JHH/FnnGXEfRbiZmDyDIhi3o6m7wt9hRV/kisnQqIxOEXL+59uJtx2onCgLaO7FOS
         I8aOvxVY6KtQ1d2SeQXZnp8snoixAtrKgKSrGzv5/fm8m80P51CN5F/ksF6n0KzQgDCV
         sYwfNW9lXlZ70fBTH/Nuobk2D4O46HtsdR/XWiW5CCGKgPg02RUbXTqMDoCk16HypuGt
         lg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FibGhSqLdb7Fzegm3TMIXUYeUPeP/MVJTkmpBe5DjFQ=;
        b=BOz2i61peM+aVd1vv8bdUjHfEE+P33vig32FUQ3nB9uTCdPH/q2+0sQ3J9qIwcRo9P
         SkZa+qSSuodSOssb2mwNQixprOH9iPxrPPYbDkI8XtciJCvr4P8iApIjlfXQ+3nuux9S
         LPT7538JIBjJ3UON/qRaDnYZyJ7JkuxGWU+ZDXtMal6/rIpOba8j8pd+Exkm25C/mD3F
         ZcWoQRarNDO3fzL7XyoYwNUPYghvhj411ctrX9lii/EgO1AXXbH/T2+ry8J2G9wqRcEJ
         iH6Kj7tYI2KgBX/pkJhJDgVDkdls30UegxCMnlH8rRoBDVLBsXKn6IwmMCSTQLqXUQDb
         s8GA==
X-Gm-Message-State: AOAM5322UP35adZsNWN61pYuoNkHjQd6tXFmw8VbPUJlU8xp02VLTCcv
        nQ6TR/7JUaL0/9AznnlvhpIdmOveQbCTcNHg
X-Google-Smtp-Source: ABdhPJyd7KU9OUCzY6Ucg31FYocMxpQK+lz9HlGPG6+pW2mHTZDVv20Pfo3UiK3G2NuUoHAUF7i8Nw==
X-Received: by 2002:a65:46c8:: with SMTP id n8mr23815897pgr.265.1640797209122;
        Wed, 29 Dec 2021 09:00:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm2095047pfj.65.2021.12.29.09.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 09:00:08 -0800 (PST)
Message-ID: <61cc9418.1c69fb81.b352a.430b@mx.google.com>
Date:   Wed, 29 Dec 2021 09:00:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.222-37-g891a1f1a0355
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 1 regressions (v4.19.222-37-g891a1f1a0355)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 1 regressions (v4.19.222-37-g891a1=
f1a0355)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.222-37-g891a1f1a0355/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.222-37-g891a1f1a0355
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      891a1f1a0355a0d512de7e0f8ce0e54929f55e10 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cc59c1dbfd4f406fef6749

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.222=
-37-g891a1f1a0355/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.222=
-37-g891a1f1a0355/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cc59c1dbfd4f4=
06fef674c
        failing since 12 days (last pass: v4.19.221-9-ge98226372348, first =
fail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-29T12:51:02.271509  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-12-29T12:51:02.280971  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
