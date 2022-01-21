Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63687496743
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 22:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiAUVXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 16:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiAUVXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 16:23:36 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA56AC06173B
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 13:23:35 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so14381389pjj.4
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 13:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HqXqcXRTYVJemN1YhRv7zj7BNJrodCKExgO1DSlkp/c=;
        b=C4JEK2PHbNPEcnSbyqfeCm20i1MZbgubzjYQQ/zYdzwy07kxEPZLXdmCSc94J1ja0x
         sE8NdYImrmxF2oDjSp8Bl5VkBpqk6APjTbCGEMkLAqTlyJpQVgf5OpiKEey6LBNKtFzb
         Asnro/g2RMqCJJnXs4EpEyw/6S+5CPzYdbQkuC1PtgwR8B37hIy8Pf8rJy6S2KMUzdaS
         c/ZMRqn3r1m++OXHwe5gqz1PVGp+Bq+WMgX0wtDvo+RKPpUg4ZpvmbmdOWLNI9GzBPuC
         ugfj/pWJP3P9V/bzvFKr5Y8KwIOKdCdMjriqnkppyuUOoj7k3iw2nyMdwIB7DQ8fWqKE
         070A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HqXqcXRTYVJemN1YhRv7zj7BNJrodCKExgO1DSlkp/c=;
        b=GvtZjk8zwwUUrzYtHCiY12NDCBOKCaJCWUb2AQW8dY4MQ6HYwAstQTppY749IXMPzP
         G7fQJ5RzqLgIgQZDfURe+28duHFPK3gpRh76WoMuRBSYU8cOJq1/2Oz0aYw2PuKg+UEb
         2ZB+C2zCaniCtDh/4Yk017jmWcv8BOv5Uzr59mjbEcEBaqZ3FCvI3vBkFyRSwt6xbCuT
         HIJsy5c3FsvF1W6E+3lHA7kLZSV7+7QDFjZWDV/WcljVgMLDl3doI1Pm7eAK5Rxwi3rL
         7Mr7Qh4KV4sMgooMyrPm1UeufJSEAEGvCElQbe8szAyWB1jrq8bIFvyIMWR+w0hjmhTf
         +gXw==
X-Gm-Message-State: AOAM533ayHxImAurssB74YrXXeSB9b6oYSaarhqWBioLCkNtQxkr/c11
        SH3Fr3N6aUl4JjdpQjaRk8a4Heup/1asd/df
X-Google-Smtp-Source: ABdhPJyOnheZlxVDeo3w6CB/OM+4bGCg74KM6BveYMxfkjuTWBx8+M0oIKu9fHNHrIjNt17eKwmfxw==
X-Received: by 2002:a17:902:c40b:b0:14a:e2d5:3b1b with SMTP id k11-20020a170902c40b00b0014ae2d53b1bmr5371671plk.45.1642800215225;
        Fri, 21 Jan 2022 13:23:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm7871064pfl.69.2022.01.21.13.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 13:23:34 -0800 (PST)
Message-ID: <61eb2456.1c69fb81.f0043.67a3@mx.google.com>
Date:   Fri, 21 Jan 2022 13:23:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-9-g2dd38d9f15a4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 1 regressions (v4.4.299-9-g2dd38d9f15a4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 1 regressions (v4.4.299-9-g2dd38d9f=
15a4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-9-g2dd38d9f15a4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-9-g2dd38d9f15a4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2dd38d9f15a45c8efd2bc34ac294ab8b50861794 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eaf140acd28f4f38abbd13

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-g2dd38d9f15a4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-g2dd38d9f15a4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eaf140acd28f4=
f38abbd19
        failing since 0 day (last pass: v4.4.299-9-gf0ed06ea70f9, first fai=
l: v4.4.299-9-g7958be08b7c2)
        2 lines

    2022-01-21T17:45:15.551607  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2022-01-21T17:45:15.560489  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-21T17:45:15.576616  [   19.376495] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
