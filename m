Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE09484906
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 20:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiADTzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 14:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiADTzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 14:55:49 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E052C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 11:55:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x15so27778095plg.1
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 11:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AVSNdF6Ez/Unf0d6utl4MFZiUSjP4D469125QeVPcmg=;
        b=zmuD8QOa2LBPciChjvFEASNwvCypJr22vEZzv/RnLlId7qXNMu3FZ9uHvhdkDuT+AC
         WIRAt+akgIvDmQ54xgMQ/RFiut+RJud65eiUam3xhVi0MlFP9aHyJizuChU7VbkJcUjE
         MenaOirXspoKja0KPoLTByVOHvL9kqS3uiqmhgwqNDFmqdX1C7EUTrhcRoX3leBwXAEg
         9+7/x5TqK7pnrG3UFkhDw6eOiYsFAUr5qHbWqD9yFk4m5SKMZ2U/C8qIWShabtK98x/j
         2iWz+3fLTLE/sHumWrNpzscmjfjwZ/ndIZOqVgygku8w7DCEp6PXSoJDyph4wgH3kqsa
         9wZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AVSNdF6Ez/Unf0d6utl4MFZiUSjP4D469125QeVPcmg=;
        b=Ltv0oG3GERZ8yH5KqOErraMhHHD/jPYKigSyb1hFIVsW2SovAsBe45G3kjpVeHxYFI
         4HxO3jz4BzBQTQ69zcQEDRZ2djVd8weqMrAshSzokpqvFmwR9pp1M/6hL2T0pMIb8bP/
         +U1OEC11sRxz5OZeyY/wY/QptMYhzthL6oBTlomAqHgEh8nRwqHNiE3QvF+t4JxrhQ8j
         x82umuwiLoRf1MVsX2uaBk236F4cdZPBMtwHp195fYsdjhjjAdO/7SDznOJjAVTKdyw2
         gVe4X+YGfonFw+16KUP5N0punGi3xoQsHOLjhes+DJ3BmCq/g8/0k5yrfXUE1lGVN9Ui
         Y85Q==
X-Gm-Message-State: AOAM532/rYUCkueq7MM7aLilj8jG1cCSePkNKA956qLaIfjSDq46Iun/
        sPOdfujPq3zCe/xPDkB4vfyLQGC7OOlqS9xE
X-Google-Smtp-Source: ABdhPJwwfLQ10Sojb/IH8d0MAsvJ9Z47n6gtNxkqh4mRfTjD7HdGX1m5Uc98Rg5WROsz3kZZ/44TPQ==
X-Received: by 2002:a17:90b:3b46:: with SMTP id ot6mr61438382pjb.62.1641326148468;
        Tue, 04 Jan 2022 11:55:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm40187021pfl.125.2022.01.04.11.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 11:55:48 -0800 (PST)
Message-ID: <61d4a644.1c69fb81.1cf08.c40e@mx.google.com>
Date:   Tue, 04 Jan 2022 11:55:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-20-g8c1980a86d05
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 118 runs,
 1 regressions (v4.14.260-20-g8c1980a86d05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 118 runs, 1 regressions (v4.14.260-20-g8c1=
980a86d05)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.260-20-g8c1980a86d05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.260-20-g8c1980a86d05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c1980a86d05eff3ce26e569d604e0da042a41fd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d4738d576ce6feddef678c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60-20-g8c1980a86d05/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60-20-g8c1980a86d05/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d4738d576ce6f=
eddef678f
        failing since 12 days (last pass: v4.14.258-46-g5b3e273408e5, first=
 fail: v4.14.259)
        2 lines

    2022-01-04T16:19:06.491218  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-04T16:19:06.501001  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-04T16:19:06.514459  [   20.058746] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
