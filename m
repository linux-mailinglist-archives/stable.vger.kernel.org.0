Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A22A1886
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 16:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgJaPYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 11:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgJaPYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 11:24:30 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64758C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 08:24:30 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r10so7381429pgb.10
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 08:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PsLLljs0yooJa1H/ZZk1gVQ9TrPokPCxCVsjVZjVTNA=;
        b=ER8gEjjZCHzkf3X2tZ34tOvtVoghH6sFTZY7CpwJ9FwpOVb1CdZ4dZRzEha0Fu9Ax1
         LsMJYmlKhbIlmPNtwBKLil49H6LoL/iFIkhP6H/WIlIZ9zZI3ob9xfMU9y/QWB4iocGz
         MdKeYw5uPdIapGwp2FVtAQhalbBh/oqvhJit5QPChyB9EIIRdqUS5/zMUlf1cGuX8rNu
         5DXsBW2L+D2RZHKt853qe2Sa5LiaA4SR10maEmHlhmcSj08+hoo23iqSg0naJe0P7/rt
         0sF7659jODZ5pw/ysFp38nvukV5sdv7EOFDJMAordAChTn3MKWb2+drmiedcU6NiOyUf
         aQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PsLLljs0yooJa1H/ZZk1gVQ9TrPokPCxCVsjVZjVTNA=;
        b=dGf8Ewrrm+WTn1QmspfEQV2kzT31NWWxTc4L/xY1BLp0iibsDwE1DSMaOjYS6GoVlY
         5CYhh93fUB6FqMotSiYDwm3ipfXPsawz/ENAmMoU2uTjV7TKJuqayNmvzExdN7taa1jM
         plOrMhaC45DQU2WZVZIrHiR52tjuqX35lYitEIA0kB46y0EXtcYm4WpfN0zLwnP8vvl3
         op4uQQd1cmJ/LShOSGTA57mwiBuD2f8jJWQj6bqY1TfDKijtlTtzuiPX92V7Mtkw/X/X
         VY/4TXe4fSRks6ScBxZPEYx0oqU51oCGSXxwXIuglKUxv4/DHV2CK+ke4/MAIhZsBzo6
         Ia3w==
X-Gm-Message-State: AOAM531SWwgh9nbbiaCGT+AVfYOgW7zF+njFPn+hzAWtCUy7QXc4teRr
        vqI76K83EHH3RvX+UEGdOHXXU894Ms9pIA==
X-Google-Smtp-Source: ABdhPJzadbGxLKAQjPgze/9ulQENRZBO0eyt3/tCH022+sJ0sfAdK3iyn6Pes1e7p/L9QEL5FR/P6Q==
X-Received: by 2002:aa7:96b9:0:b029:155:6332:e1c7 with SMTP id g25-20020aa796b90000b02901556332e1c7mr14479615pfk.35.1604157869594;
        Sat, 31 Oct 2020 08:24:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v3sm6640104pju.38.2020.10.31.08.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 08:24:29 -0700 (PDT)
Message-ID: <5f9d81ad.1c69fb81.92d7b.0480@mx.google.com>
Date:   Sat, 31 Oct 2020 08:24:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-11-gffd730fbbbb4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 122 runs,
 1 regressions (v4.9.241-11-gffd730fbbbb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 122 runs, 1 regressions (v4.9.241-11-gffd730f=
bbbb4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-11-gffd730fbbbb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-11-gffd730fbbbb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ffd730fbbbb426909e3de2e19e408da1580939e1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d4d30c8423871223fe7fa

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
1-gffd730fbbbb4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
1-gffd730fbbbb4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d4d30c842387=
1223fe801
        failing since 0 day (last pass: v4.9.241-4-g8d9cc85ab09b, first fai=
l: v4.9.241-4-g40bcb1fe569e)
        2 lines =

 =20
