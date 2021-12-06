Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E53E469335
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 11:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhLFKPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 05:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhLFKPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 05:15:33 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA1DC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 02:12:04 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id np3so7320138pjb.4
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 02:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9gtoGkPDZPlu9Bukya7uD5fsEI93kL16ig/IVV8VWH8=;
        b=N73Eul2ajasS2Q1y0+bFcgk+Au+PcdJSwA8NsZpSc1RCfmZLiVUyu0xBOVKbwFPPfW
         fH9G8hxojFyglf+1asPMYIEDWKKche1y+E9R+FaaAX+7IlRmn0Xoba1wsUvPWgPfxZ92
         l01jMRWePjkz1/xU3W7t8YGL1Jrw4lYyio9TByv+X9HRIPWy0oVMBr3JkAno4NLFBVAF
         2TgGief6uhc5LO6KicBF/RnW/gv29iLqcUvKRqGiGtPnoNklShZnyqFCDF1WPtHc1Yvj
         g575OxABr1zZSCRLlMDcH4Y5opOE1ghEv5cNUOhayW9WOptqYTmaXRtccASmHNTEa9Ub
         ITDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9gtoGkPDZPlu9Bukya7uD5fsEI93kL16ig/IVV8VWH8=;
        b=RjqvUm5N0CGhCBBT8Bt5XkwVoHHN+98nGaVlV6vJOzZTT/6dqePL1Uvz9iKJ+nujEP
         S/he+7VAcyyKe/EROiAgliuyG3YR3N2gBji7jtqFhX1jnAZI8okOLoeLfOuqL1bgHQsg
         3YB6PocrIUvzAovSSQ9AGKsz4sg3QbUjN9dRrTxQDr9rdP3EgGFidHXudaq6Wj4VYHmy
         AO+4bixsR+SJuf+bVRH3giB/qGCfOzhiDVW4qqSpFmn85E6heI9NLBdw/nr41bT9CP3J
         dzaH5rFIbNNx51rE3EbDvbcIKDp5S8bvdMOD7oRQay0S/gRqM8fWcrPBazXBCisL/XMm
         Qqcg==
X-Gm-Message-State: AOAM531lUhUKsvu16YqEkALpqnX9aQtoOrEgGOTdxSzcJDRP8vwMZclL
        NWDGBcIZc5EAV7lKCrej0TLbAWut1vfuA7EF
X-Google-Smtp-Source: ABdhPJwZZW4Cvn9QTDduZWHKnLDOeWMxFV9x4+slLwZhRgZjNTaXpMzjcw0bhq8BKRTRsZxQs/qBmA==
X-Received: by 2002:a17:90a:bf0b:: with SMTP id c11mr35749394pjs.208.1638785524212;
        Mon, 06 Dec 2021 02:12:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm11842375pfm.170.2021.12.06.02.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 02:12:03 -0800 (PST)
Message-ID: <61ade1f3.1c69fb81.2cbdd.2523@mx.google.com>
Date:   Mon, 06 Dec 2021 02:12:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-57-gb208f4ab2d641
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 3 regressions (v4.9.291-57-gb208f4ab2d641)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 3 regressions (v4.9.291-57-gb208f4ab=
2d641)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
i945gsex-qs     | i386  | lab-clabbe    | gcc-10   | i386_defconfig      | =
1          =

meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-57-gb208f4ab2d641/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-57-gb208f4ab2d641
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b208f4ab2d6418b1ac2821460ee5e5c6571435c0 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
i945gsex-qs     | i386  | lab-clabbe    | gcc-10   | i386_defconfig      | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ada73bc6851b74a21a94b4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-gb208f4ab2d641/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-gb208f4ab2d641/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ada73bc6851b7=
4a21a94b9
        new failure (last pass: v4.9.291-57-g86c90b21b24d)
        1 lines

    2021-12-06T06:01:10.438899  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-12-06T06:01:10.447921  [   12.003657] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ada8b86f3aecc35c1a9482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-gb208f4ab2d641/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-gb208f4ab2d641/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ada8b86f3aecc35c1a9=
483
        new failure (last pass: v4.9.291-57-g86c90b21b24d) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ada83e98939b91b01a948e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-gb208f4ab2d641/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
7-gb208f4ab2d641/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ada83e98939b9=
1b01a9491
        failing since 1 day (last pass: v4.9.291-47-g43f5262d9792, first fa=
il: v4.9.291-51-g9e9032945598a)
        2 lines

    2021-12-06T06:05:23.797304  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-12-06T06:05:23.806597  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
