Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215DA4815EF
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 18:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbhL2Rw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 12:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241179AbhL2Rw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 12:52:56 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E3FC06173E
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 09:52:55 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t123so19242966pfc.13
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 09:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=esVS8xzXosTEhCxZ8jnwSMnSm3V7967HwADgFo++UOE=;
        b=aYsDR6Yt+CsjywzrVm3+pBbVN/pwN6WpiCzE+wUKy5ESdwb0iuC/3d7ncD+NGmI87C
         dwbISa3//t6vFxcAIq+SCtVKqNOa+vger3ec/gdVHq0OkDOEexYduJHpi5Dp6RPn/eCh
         WiNDSiML5hz6fIOaphBWPT7+VZOka7b+dpwFILS2DC84LZljXcF2DyzAsaZT5JQmYscE
         101sXNHMauqBD2f5P2g2GpWcc/SA/zzazLVmYu2YewN4EJitsfTMv1xdk38+sB66Gf9J
         gP15sutlKcgX/s5urSEfParWlnfdBC1okSPa2LBjSQ9aSSu1NUYXPJ/T3Rwxnc2yYCrP
         jO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=esVS8xzXosTEhCxZ8jnwSMnSm3V7967HwADgFo++UOE=;
        b=vQqEoIKF6jTYv18qkvK8M5YK8AOcy86nkqTXTiRIiUDqdnhVPLi7qk7GnQi3irCZhK
         Oac62Q6LTJ5RXycMjZpY2QGeYrrjsQQDKsX4aBLM4O+nymF3iWf/MxNLPjRH630wdPja
         CVry2t+e0NXkjSaALTx+2W7GwnRLBVdw3NHODt0GplHHAJ2RZVnoJQdeooGIDRNCDoqu
         VnvYPib/cAFFdqfy1nkjmJEeiVTgw5Pfawk9r4BhaPpX5fiFTPERcUBU/N5coilX6jB/
         QVWoVhB1ORpzIF4+4GHkkk97eB3gGz4J99xy1mQxcqRatQa81ZbUpyx7UeS8kxaRO47L
         cJzg==
X-Gm-Message-State: AOAM532De6AE5xiZGMzTijR2A4yP3wShSLw7duDhJJywH5UVTRPGTw+Y
        MQww7lEAzeGJEpKk7jXMuRmIGeSk3XJVw/pO
X-Google-Smtp-Source: ABdhPJyPJHB0JWVOs87x+YkscKlSIddfedPUmO5Rly3LnCfoJE2zvlfaD/C1gxkz2a1Yd6F28onoeA==
X-Received: by 2002:a05:6a00:b49:b0:4bb:5708:ea12 with SMTP id p9-20020a056a000b4900b004bb5708ea12mr28018308pfo.57.1640800375333;
        Wed, 29 Dec 2021 09:52:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t27sm6528476pgm.52.2021.12.29.09.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 09:52:55 -0800 (PST)
Message-ID: <61cca077.1c69fb81.4f85d.1545@mx.google.com>
Date:   Wed, 29 Dec 2021 09:52:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.295
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 120 runs, 1 regressions (v4.9.295)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 120 runs, 1 regressions (v4.9.295)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.295/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.295
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8f660a868284e61dadf747da85bf2bcd9826d9a7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cc661cc4f61a1bd2ef674b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.295/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.295/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cc661cc4f61a1=
bd2ef674e
        failing since 15 days (last pass: v4.9.292, first fail: v4.9.293)
        2 lines

    2021-12-29T13:43:38.444495  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-12-29T13:43:38.453341  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-29T13:43:38.469667  [   20.415985] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
