Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C0B4940C0
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 20:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbiASTUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 14:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239680AbiASTUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 14:20:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3E1C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 11:20:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id pf13so3437114pjb.0
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 11:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fwN6cD/QkkPPKjTeWwMRYuILe28YgCjWmvtJMPzopFU=;
        b=dn8VSk7XyrAof4r2ggklqqOjqKzb1SYxGASHso2dDgiMXBUnJg6RtFXgV5d1GNnapZ
         WkwRAHIWdCpj1VK6+1QMV01kOi8tjtU6JYoGzKEE6aRzcwCySbRW5NcFuqx4lJK5Sv5B
         7/s2scudZmIQ21C2/tx6HXAgBYaLhXM3y1xt/n/1FpL0Izj+rmFwmSHla1YiLQ7hjIJG
         A6oiOL8E/55byEJgDu3A1F309mdN6+ZWHNYcA2F8WpsVu8c+COdia0tGhpbwAZsE7Gzr
         G80YiaFBxqgpQiFZNHDzDNwjWtawJ7y7ElMuXGDlfp08p+b4vfG9rsDm0qjYBQA/FIzx
         aVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fwN6cD/QkkPPKjTeWwMRYuILe28YgCjWmvtJMPzopFU=;
        b=F2N+BSuLxS1CkbY8X71OGKVo07n8GhkpwaHqJy430XKAxM0POntBSXOkJ3yMEp8pre
         6m4fZhN8OTppbIxUfUKV6dUxJWNqP1LNdjodqtJhhPtaSVu6/nmEWybLwnF6UHDKo5R6
         TyepwuAOoqUvUMEXvJwG1MWN4efzFQcZcMtXp30BrES4Ow+iMrY8xfZdDSd4tbhydDEX
         vMsT3WTR8Gq10ti1jOP0BvEmIkf6Bl6UpR+tLaz/ZvKScQyE6jwswBC3erFcdFsSI17j
         W+ljhIf8fGVKxhVjHvUEaVzIcFOKTZEjrJBhCqpwrGlPaJ2Vjf7gw4GSpU7iXo4tYpQY
         hEJw==
X-Gm-Message-State: AOAM5319AIcNkdJ8rMPnw8FOywdDIj1xNrfJfxm09hV8VotxQVTJI/n5
        V3IRMisg3jaZDJD/h5j1HsJLgsPS+gb57Uxp
X-Google-Smtp-Source: ABdhPJxUDJ51bULJHuUx+2vIKqtoedqaLBeJZuxWxvFWNGxiv0tK6PKLA11kl5DjuXc7ZG4tLNO/GA==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr3410087pjb.156.1642620044013;
        Wed, 19 Jan 2022 11:20:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18sm478994pfn.46.2022.01.19.11.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 11:20:43 -0800 (PST)
Message-ID: <61e8648b.1c69fb81.18811.1ddd@mx.google.com>
Date:   Wed, 19 Jan 2022 11:20:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-15-gc015d06920ca
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 157 runs,
 1 regressions (v4.14.262-15-gc015d06920ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 157 runs, 1 regressions (v4.14.262-15-gc015d=
06920ca)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-15-gc015d06920ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-15-gc015d06920ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c015d06920ca2b796e3d52ff2b4fe1939c8a99c9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e82e63a289babd61abbd35

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-15-gc015d06920ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-15-gc015d06920ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e82e63a289bab=
d61abbd3b
        failing since 1 day (last pass: v4.14.262-10-g93d10bded874, first f=
ail: v4.14.262-13-g01f6e3343a5a)
        2 lines

    2022-01-19T15:29:21.817275  [   20.132720] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-19T15:29:21.864686  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-01-19T15:29:21.874023  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
