Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F416E440AE8
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 20:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJ3SM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 14:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhJ3SM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 14:12:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC09AC061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 11:09:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 187so12368550pfc.10
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CAx3cg2BtxO0f/AvJF1lZNsyKkBITodTXf42RJBkIWU=;
        b=ekOZ8Ma+a5q7AxfYM7gtDsi7w6+TTYzk/9AEszKojIhTidSUYnV6L5qv10ANQrlv1C
         Twm67gDxuhIuh5ppNF63NfgbZfoi1pRvMwSZ7jmvOSodExEcQZKeGJSWDr0MVKZXYsbR
         FedBj4bbEL8QgwZxUtbBe2pm13uq7XokKzx2XzZN6bHi6n3t+o+bt01I2zIPR2f+lOg7
         uavbKX4Sp7qPjkS6doG5Hp2LJ4T3VmsnnPnkCT6oudCpsEl7iWpNr+7o939Fk3XdsOD/
         w8LVzidEYemgJpZz5Lcz5kMcz8xGqKANhvqoY3sqPKk3vhs2X8yNsoAROTa8RK03zhQG
         JmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CAx3cg2BtxO0f/AvJF1lZNsyKkBITodTXf42RJBkIWU=;
        b=DOy0ZT7XXyCGDrUFYx/c8Jg6N1yzgaUKhrjndpetLnhqzHu/u39+jnHFknXnY+3KmI
         TwpYJwG2+0u0rWI34xYmJAkIMkpaZUu0xgYOAwM6mQ2TVZJ6a2Jxy6U1Rqea6miVluSo
         5g5yUyDSI99KtSY9zu8gKNZcOvCf/jk7+txw/d/wuUbSIbg1CuruHRMwMJFO12bHe0T0
         B+NTbTk3d5GTEogavtO9IEgehhFvSFqC5tKL38lUfxybD5lLvlVC6xW18M3nsW/TddCA
         hH2PHsVLfvRncQ5QMHGDM0p8T8WC7TZM0qeMKYMBJ+ScHZ9TvTP0Q4YgTMUZ5KnWDERQ
         CmJQ==
X-Gm-Message-State: AOAM530mE4pbRyZEsYpPPuE5Iat4EVMdBITDzHuwGCn8V437ylBZ/OvB
        DK+5yq85azhZjk2l6wAAqTpzJSJhpjmbcf6r
X-Google-Smtp-Source: ABdhPJyhwq8qB9EtOo2RYiawsHB8/JdD4oMecoQ+aY7TIX66caFAHUdyr/o47Ot5IC6VnaabldpBSQ==
X-Received: by 2002:a05:6a00:1489:b0:47c:29db:a199 with SMTP id v9-20020a056a00148900b0047c29dba199mr18374222pfu.33.1635617396017;
        Sat, 30 Oct 2021 11:09:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n29sm6135276pfv.29.2021.10.30.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 11:09:55 -0700 (PDT)
Message-ID: <617d8a73.1c69fb81.af520.faef@mx.google.com>
Date:   Sat, 30 Oct 2021 11:09:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.253-20-g8332949c1b31
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 89 runs,
 1 regressions (v4.14.253-20-g8332949c1b31)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 89 runs, 1 regressions (v4.14.253-20-g833294=
9c1b31)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.253-20-g8332949c1b31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.253-20-g8332949c1b31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8332949c1b316816f001eb781576ce091f9bf863 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617d535e53eeb29f523358e5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-20-g8332949c1b31/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-20-g8332949c1b31/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617d535e53eeb29=
f523358e8
        new failure (last pass: v4.14.253-10-g2d214026445d)
        2 lines

    2021-10-30T14:14:41.361207  [   20.286346] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-30T14:14:41.402042  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-10-30T14:14:41.411530  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-10-30T14:14:41.427105  [   20.354248] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
