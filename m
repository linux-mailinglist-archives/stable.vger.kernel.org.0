Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6FD4A6847
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 23:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242477AbiBAW5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 17:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242426AbiBAW5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 17:57:04 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA185C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 14:57:04 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso4139495pjt.3
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 14:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6rHw1hzRk9dGTJm7jPXIZ46ZHiHqd2FKg1PqHITwnKY=;
        b=Kmlwoq3i68ZWCKzzg1142kpM9Ioru3V1QK8w+AWxip0EStRAgMdv5gAlRah8T25NrX
         MHECxmvEbfeABFKYwbsHtz4rkFJ0FWIkjCiiaF8uOkL12p7Mf9K2xiLy/wWVf8PamRbf
         ek4VLV7j2xLwQjENlDr3cJwrcSNVebKLexNonLjfIDtq5BfVOwSaDpzQMZFow49rxuTm
         3Dd4YJ0Zl26O727LoiQMBqfTGGpmcw2oYot9PAcZVojwln0GPDaeTkkL5SpGPcoAE8GY
         nCW98mkpX4u1xZTi1EYQHYdbEBmGfiVQ4E/Dxhgbuo0QiqrZobTjLal4ZM2oNrMXBH/d
         lgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6rHw1hzRk9dGTJm7jPXIZ46ZHiHqd2FKg1PqHITwnKY=;
        b=OytbPd4w+cMMHCpA7WDNOf5UUgFVocz/reCo0odXIq5LJenumAxwK//OPp77BzUYUO
         LYjfy4Sg7YY3ZinmmEvmkL5KtizKAAp7TQ17zX5tjmbjci3nNDtfnreX+FNRrUTulMy9
         KL6qCFqaDt/km91CF1mmdVckpB2q4oMLoTG8jpmjW2dm1/quEqsp203NNbn+xtVVnrzK
         g2W9B78f72QH1K0kTpfeRjDkptRueLuLnkX1Ix0VEaRY86GdScDWixdNn4tv+jKihTJQ
         LGSlg+84jGhY4ur6MxOEMEBi49o2wwH0H2pE3HL2wnVV6pxTo/D7I0OhOR/B9FkGgD8X
         p7dg==
X-Gm-Message-State: AOAM533RXSxRousv5AYqE4DdotY3GtK2UNpEk9F+r8vbt0zXoSdS4sIx
        Gy9kgdRyLU/yqlJjKwiHcL06XmVno+pWJde0
X-Google-Smtp-Source: ABdhPJzMSLQV6ZPCuOUrgVJxErdo2JbcS0XxTBVftHIyIE2dbLCfbp84IS3vMOKeQvtd8t2THHwEiA==
X-Received: by 2002:a17:902:7109:: with SMTP id a9mr28441419pll.170.1643756224316;
        Tue, 01 Feb 2022 14:57:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1sm31920428pgg.18.2022.02.01.14.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 14:57:04 -0800 (PST)
Message-ID: <61f9bac0.1c69fb81.c1a90.6d70@mx.google.com>
Date:   Tue, 01 Feb 2022 14:57:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-25-g8ae76dc07a67
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 136 runs,
 1 regressions (v4.9.299-25-g8ae76dc07a67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 136 runs, 1 regressions (v4.9.299-25-g8ae76dc=
07a67)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-25-g8ae76dc07a67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-25-g8ae76dc07a67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ae76dc07a678edb91ac420cc85c4da4befc5a95 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f97f5e66cfe71ae05d7029

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-g8ae76dc07a67/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-g8ae76dc07a67/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f97f5e66cfe71=
ae05d702f
        new failure (last pass: v4.9.299-13-g3de150ae8483)
        2 lines

    2022-02-01T18:43:24.475234  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-02-01T18:43:24.483938  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
