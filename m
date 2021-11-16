Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92DE453812
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 17:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhKPQwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 11:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbhKPQwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 11:52:07 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F06C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 08:49:10 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so3412949pjb.5
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 08:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wWuQ6DScWzSdZ3RFxIXWkQXNPIJZps0MR1ci62sOESA=;
        b=ASsnXxvvso+D6TCbr6+XqSGRNDc1EE4Gmj0qbJclIqz6HRs5ds5ceUOtKdFu34mo85
         LXMPn/NsJhHbm1QhFjWmWJ25o8j98XZxCsYtRpLr1HoUqJy20hE7SddH/8OWSmIV9AdX
         sYCbhpox/hynWmTxusDWwEcwpNW5lcrXusHlAgXwFAMaFpBAs1DJaQxTLRgbqrE7wItF
         pn9bkTxx85BqoOsdl6Fu62TQQPn6wn3lbVSG3xEm/P4oN/990BH5cG2y7zXqN9z6lvTi
         RvB96MQfTqc2nuu9GIVWdERxbJkzi9wUo5o1Ep9dmTtqdQcv207azKM3p2mE0lVIlJ2A
         I0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wWuQ6DScWzSdZ3RFxIXWkQXNPIJZps0MR1ci62sOESA=;
        b=J/G1+UCP2A09mdNy7+rHQIru/REWx7G6DdoPD/vnW+Rv9a4kMj19P1QS258wwcUhjH
         NguRsMTN67Ijf2QlZQxAPKGMaPeTVke2TKsN7/531ZkuA73O7PLtL6TKn2kAWEKQ0Kef
         cW0/1SZNadB2UkghmEO1pmxBT5OJjcVpUp+URPpo/bx6ABcmxTF2gdPIT6JfmyzBgJDw
         UW9fmDG+zPm5twHgsLna5oVXI/czcrc0wmBMjC6saBwA+PN/FzJp+9Tpl61dQ18O7JW2
         ulsXoFp9joDYUcB3Mb8CzJO0q6/Ua8LCxU2AjxEGkGu0SZ5pF6ZaODDWcLfwW++Xbk9c
         n52Q==
X-Gm-Message-State: AOAM533WExO++9APyne4tAIflC2MikWIhzRoXnO5x4VPwiJXUSgOz06L
        rATbYdxX3yA8r0xJDOImvSM3dkeaIWhZS9JW
X-Google-Smtp-Source: ABdhPJwzShHmuY45IF5VMLaSh43YKmV/uFFwTQA7wbUc21jRVEo3kv8PlfC0Pw6yOY3rrziMP3AcQQ==
X-Received: by 2002:a17:90b:1e4f:: with SMTP id pi15mr584337pjb.181.1637081349916;
        Tue, 16 Nov 2021 08:49:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t80sm14944513pgb.26.2021.11.16.08.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:49:09 -0800 (PST)
Message-ID: <6193e105.1c69fb81.b8396.b734@mx.google.com>
Date:   Tue, 16 Nov 2021 08:49:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-159-g1ae19462fe82
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 91 runs,
 2 regressions (v4.9.290-159-g1ae19462fe82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 91 runs, 2 regressions (v4.9.290-159-g1ae1946=
2fe82)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-broonie   | gcc-10   | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-g1ae19462fe82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-g1ae19462fe82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ae19462fe825324c99a6dd07f578e59464e7dd0 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6193a8a7d2f2d340cc3358f6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-g1ae19462fe82/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-g1ae19462fe82/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193a8a7d2f2d34=
0cc3358f9
        new failure (last pass: v4.9.290-159-g76921fd9d01e)
        2 lines

    2021-11-16T12:48:20.084854  [   20.317291] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T12:48:20.130718  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-16T12:48:20.144770  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-16T12:48:20.157474  [   20.390350] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-broonie   | gcc-10   | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6193a817b76ecafa4a3358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-g1ae19462fe82/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-g1ae19462fe82/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193a817b76ecafa4a335=
8e5
        new failure (last pass: v4.9.290-159-g76921fd9d01e) =

 =20
