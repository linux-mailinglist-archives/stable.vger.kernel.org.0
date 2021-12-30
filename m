Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF71481AAC
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 09:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbhL3ILA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 03:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhL3ILA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 03:11:00 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69533C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 00:11:00 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t187so7261924pfb.11
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 00:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wYEjxKNK2JKs3T9zDAUKNUfnAHBlDeNDoOEfWENeTS0=;
        b=qhk1VyW1yW6nxb56ZsJrCEatbOf343cFOD4eUZKzAEyPSBe5PboiehzNzxQRi/eS+8
         EQMCoOLBXEsrWp591d0CSje/CcZyHUQjz3HtiPN+4uLuFk1WyhCeeGs7AvY/C2GNGhxS
         4CoAjpH1YSNcg2h7vNvk8NWfhwuEjl+eJTat0HIXrfTDOLEPUPnQo4CJwUJw9TJ+PV/V
         86Bh0lBPguUJrrBu+HEhByfAxIAcXE1yey2t2680TDHLmJ99S0ha6cHsb3YGMPH82MRT
         OjLFr7fUCqWt3nacbncY+O4p4VU7giXGDQd2c7bZJ/kOVKZoOAmAQfvEvmHpKhFLaSYD
         GYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wYEjxKNK2JKs3T9zDAUKNUfnAHBlDeNDoOEfWENeTS0=;
        b=6yeu5iK3NTrtwpmSMffYt9VGKm44gEhwBQzN+BG+gVJwr73t6UK05qjiZnCPlJ3J/v
         wD8uIUPUPWDJE10hPvTgPdP/iMHGdf5W7fxoUvU7HowQuKzwl/gIpqiDWKUWkGUfaFXp
         KnjbyQrnTjvmcRxH1LJmoOB+nnpETNb2iaiunskCdEKmXtqMsEFYxcC3OwjYp05Ml3nc
         2CsCsbNIBZBUdmSzoZ5gsebMkXWRXdFDJVhA9L0HZ5xD1bz3IvwzpWl7HTpqN6RTzFbY
         EMNwCUVlaBV0J2A/sN0qJj+yD/U3X2yJOpczBd/lPr34v4eNzqP59Wlh1yZH/Czd7tEa
         Qjcw==
X-Gm-Message-State: AOAM533OyzYpVObhT9jwFfaKlIxz+7SSvcZwS2Aqe/7lgxFKttv9hiEL
        LLl4Pjp4FEoRiTKQ30kL9Gu5yAt7VNZnYX77
X-Google-Smtp-Source: ABdhPJxlvlmiWuZisMWMkdPnkA+RqInMkgzOQ2KTJ5XPOXdUTuGar2UEpXx7bVdybFLlTvhBpMa2gQ==
X-Received: by 2002:aa7:928e:0:b0:4ba:fa67:d87 with SMTP id j14-20020aa7928e000000b004bafa670d87mr30355612pfa.41.1640851859823;
        Thu, 30 Dec 2021 00:10:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16sm26804885pfu.131.2021.12.30.00.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 00:10:59 -0800 (PST)
Message-ID: <61cd6993.1c69fb81.f32f0.a837@mx.google.com>
Date:   Thu, 30 Dec 2021 00:10:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.259-32-g0a7337090d93
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 131 runs,
 1 regressions (v4.14.259-32-g0a7337090d93)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 131 runs, 1 regressions (v4.14.259-32-g0a733=
7090d93)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.259-32-g0a7337090d93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.259-32-g0a7337090d93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a7337090d93c3401b82492cf0f855b6583b68c2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cd310b0f65e4c779ef676e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-32-g0a7337090d93/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.259=
-32-g0a7337090d93/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd310b0f65e4c=
779ef6771
        failing since 7 days (last pass: v4.14.258-44-ge424e12a40b3, first =
fail: v4.14.259-3-g939915040d24)
        2 lines

    2021-12-30T04:09:29.518958  [   19.837554] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T04:09:29.562280  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-12-30T04:09:29.571835  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
