Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED548FE7B
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 19:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbiAPSfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 13:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiAPSfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 13:35:41 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199A9C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:35:41 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so19211425pjp.0
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 10:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LYdNZ0YiIfd/qsGswjY6iynXLAoUneJj1cdqrwOXZ+c=;
        b=F91tOkOzJ9Kl7gkuJAJGsgDgnOc4BvyeIfzkLTbWrFG7DkCVkYVEIa0RFLgB5pm65c
         FMbHQS3w0RqHK4NziZoAowCR8ixNLupkr/s8QkLgsyG8O0SWjiMquDgi2RZN5Pi44vaZ
         S08pOUt48KumQyqGxMQtmklWBQYQHmbWcGnSliTjnNWXafmokddSYrUEdjCFbhoIl4Go
         R01N3qgui+6uONQ+iPVRgNkYzWHNB7YSL+gjkKMyLeprOx4bZJ6u1ynWVneGLkOrbsMI
         m0EyFgnBbzf6shLF9BOuybeY/kSCGRt0yhwVsQ2iCmfjDlbeo1qxhG+FoMSVXQB02eCu
         fP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LYdNZ0YiIfd/qsGswjY6iynXLAoUneJj1cdqrwOXZ+c=;
        b=WM/S9VXnEWetHKtMjOTxbQjB27MGHOrAIZJsBTimq6jhuLNGa2frkoqk5LYFW2CRjy
         XsL9r16UpfwOtIv7aLd7zsL/5LJZNFvsRSTbXFE/mHK2f6Q96XqYhpLunvOwh5O88J01
         7m3X5oH6O3vdFl4GKKeRCViQ1t2C0ALaB3T6P4Zv+hd3zL5d72z90425+wT5Rty3EqUP
         tmoTHi7Fn3z0YGRIgvmj6fBKc02JseS7M4ZQpB+gnWUOwk6SzpRSP7m/Igk2zKBM+/YV
         6Zax7g8cB+6NNP64trz+YX9uzGGn6g58XuOceN2eeGNsLG1aiYNOcKq9jmGXDY7nswrQ
         9BRA==
X-Gm-Message-State: AOAM532tDnoX6pS+thIWqbqyx7yWrbO4JJg+3+FbKQ9g/ge2E4fvFOMN
        qxo6jTXFRF1wposdYl+7kHji7OaH1dmTBt5w
X-Google-Smtp-Source: ABdhPJwbo5adl/gKt0zTJqj3u9o7DOKAoWcFEDvSczksGu9v0MR0mnWaq7knH/e12G2e+KYSVhCuEQ==
X-Received: by 2002:a17:90b:4a92:: with SMTP id lp18mr3101666pjb.152.1642358140522;
        Sun, 16 Jan 2022 10:35:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm11879015pfo.21.2022.01.16.10.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 10:35:40 -0800 (PST)
Message-ID: <61e4657c.1c69fb81.f9012.0d72@mx.google.com>
Date:   Sun, 16 Jan 2022 10:35:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-7-g85a86ca49dcd
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 121 runs,
 1 regressions (v4.4.299-7-g85a86ca49dcd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 121 runs, 1 regressions (v4.4.299-7-g85a86ca4=
9dcd)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-7-g85a86ca49dcd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-7-g85a86ca49dcd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85a86ca49dcd2020afbcab10b9ec7ffca7270d1f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e432e9f668c7ca0cef6740

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-g85a86ca49dcd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-g85a86ca49dcd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e432e9f668c7c=
a0cef6743
        failing since 26 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-16T14:59:26.857747  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2022-01-16T14:59:26.866726  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
