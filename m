Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ADA48E27C
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 03:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiANCVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 21:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiANCVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 21:21:47 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61F3C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 18:21:46 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c6so3600320plh.6
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 18:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uaQAogPMCMONtu34hXxvgeHSc3E94IkRM7RGvT5vYfI=;
        b=HDHyELgoaq2PlsBqM110ZEl5MpQ7BtteT0inHl0a1dcRGF7pEJq6uxf9qt9cA6ZHX/
         ZcnpaNpW2rFECyqKARRAVnnUl2HTIQAiuDWnIgiy59pARaPlfYDmBgy/mbTzlx2CyF36
         EN7GKycuFi5FyWrkcPnKKAD6jfzm/w4LGsHYpNZZFS2A+GCeM51VGjrp/S6bV4NPhiSW
         uzVV1DSH5YhPIJKtnKQorP0ja5Z3iJ6pu/Y/1Xok7Hx+SIFR66jr1IDlAo3F9IBxRrKR
         OPc3Ij2di4S49LAm2d2laaEA1npd+u5HCFu/0eV9scfiSsf4YlphAiJh6263sVUfuTp3
         i+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uaQAogPMCMONtu34hXxvgeHSc3E94IkRM7RGvT5vYfI=;
        b=UouDJ1Gq9mlIj8MzHIZ4B7xCKWvHfBczkpzoqmBhBYwrWHqermIgr4VMHUxVtNMJJI
         vPTNp3uolWMWSN7NIf0P72m3OSPRIl9093sMDFozON12X/4SGhfKr5RndrYY/0QDfOba
         xK+4qb34alAYFWDCYS0Yu5vreKXHNBGGnHqlpRIfzNz3X+NCvtQk/ngE+uYf8fT8BOQv
         vOBW+uA+5oUSy3FdIi/XwqNlmYku3gKPuNBULwPcLg902OM6UV98UWskNBfIkz0FXEg7
         tGOAxl+5HSWC7BEwftP2tgTJrVGWStxhU0hamoeShUdnhORcsa6jEj4ya2/EHmHhAL6g
         PRWQ==
X-Gm-Message-State: AOAM532r/pOKo6U8nXQI9ih8rdXp86G+wLL2NGntXdusA0+QkTsT3wKy
        0EslXekuNqjC4QrP++3Ft8e7ztaGDWhQvfuX22Y=
X-Google-Smtp-Source: ABdhPJwR5mdn3XXPg4tw3dHP4IDOgU2D4wFjBT1OvUnKkMxf2Ve4pR6OFpoPWHd66GRVtvABBfiQWQ==
X-Received: by 2002:a17:90a:628a:: with SMTP id d10mr17801155pjj.139.1642126906244;
        Thu, 13 Jan 2022 18:21:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2sm4015717pfl.138.2022.01.13.18.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 18:21:45 -0800 (PST)
Message-ID: <61e0de39.1c69fb81.bdf7f.bde2@mx.google.com>
Date:   Thu, 13 Jan 2022 18:21:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-8-g3740dc6026a2
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 1 regressions (v4.14.262-8-g3740dc6026a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 1 regressions (v4.14.262-8-g3740dc=
6026a2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-8-g3740dc6026a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-8-g3740dc6026a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3740dc6026a22721dd62a2df07f9c8ba153fd61d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e0abd8f183338d4eef675a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-8-g3740dc6026a2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-8-g3740dc6026a2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e0abd8f183338=
d4eef675d
        failing since 10 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first =
fail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-13T22:46:31.852024  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2022-01-13T22:46:31.862662  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-13T22:46:31.876687  [   20.162384] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
