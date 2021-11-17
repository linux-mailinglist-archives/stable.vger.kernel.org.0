Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ACD4550DA
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 23:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbhKQW6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 17:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhKQW6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 17:58:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78869C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 14:55:51 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id m24so3489826pls.10
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 14:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7OdExlZH2HoFVaLQ7Aq7IEfVZEUFWj5+4U/DJ72h754=;
        b=CbtiCN5m+ZBnnoz87kGginKzUndrIMbPWHqZ+jBVRp4Gwby9jaw1aRO2zEPbYxU15/
         ec5q0fXa44Efj3BXMrJGgvuhsevRaA2RjCTuIkuBS6NdWb37RxHO3LVihRR8BmBs1S4R
         EDhXR2zSmyupEh2DBSrUfiO8/fB+XIVILBrtx2dfMqZn/X4OzU71GQo0Dv68yFP8Yz8l
         Q7g3OUJ4V68bnyfpAMAM6gO72zGbFP1mMMHwVOqSHyD9wxvdc3MoQk5HK2VvUu2YDNNQ
         idqLeSGK/zxJTBFgrgbdi65wu/79jXNus5c9zEdVG8anwD5zadamjmRbxezutQSt81ev
         sEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7OdExlZH2HoFVaLQ7Aq7IEfVZEUFWj5+4U/DJ72h754=;
        b=MfvqobIqqwctOpjRfldKfEXO8Rl+zwwQBQocZmPOyz9O+sVrPquiJxFcZfbvxTPXos
         mTT4rihG4Lp1bFvo56BwK708j5ppJN1rc1jSYZJNOsho6tXmew+gwvhkFdAxgkHcGTjg
         6ncY7XsSqoax3D5WgIS2YRLoLuYaOTYz9O7dy+bZFHrxklb1FUTj1ikNKNZ4poCzn88h
         Rp4Cm9InJGv/a+FANtMnlekt/xLGtH2GwDKx3i3Sq5Io0vr7S4XKFgO5Ze+8+gv1iHsJ
         dYWjOKKzilIno3h1Ev/8O6JYOIGgfueCgAqXtk9ymurVcShAj2aVvxALPGEcou8N0YQq
         7kOg==
X-Gm-Message-State: AOAM532bcZWd7DmhAnBSmUHrk57FcU0FO0fe7g8imKWGbFJqhAE8LrVm
        C1xPwNVwVsPG/cpkdPf9OzJUY+7rSGRg9eMt
X-Google-Smtp-Source: ABdhPJzcIAz1w2yeL/gcMGXx0Ejf0A/OksMz5JtcaCEyS9uYAOlt46LkLFev0PHt+9vvBnxxlQ23Gw==
X-Received: by 2002:a17:902:e806:b0:141:fd0a:2201 with SMTP id u6-20020a170902e80600b00141fd0a2201mr58885631plg.48.1637189750892;
        Wed, 17 Nov 2021 14:55:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h25sm571916pgm.33.2021.11.17.14.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 14:55:50 -0800 (PST)
Message-ID: <61958876.1c69fb81.70a0e.2dfa@mx.google.com>
Date:   Wed, 17 Nov 2021 14:55:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-158-g1c9ba0d60284
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 1 regressions (v4.9.290-158-g1c9ba0d60284)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 1 regressions (v4.9.290-158-g1c9ba0=
d60284)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-158-g1c9ba0d60284/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-158-g1c9ba0d60284
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c9ba0d602841e7a4afdb2280842823219c4bbe6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61954ee0aaa06b760d3358ec

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
58-g1c9ba0d60284/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
58-g1c9ba0d60284/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61954ee0aaa06b7=
60d3358ef
        failing since 0 day (last pass: v4.9.290-159-g2cf93eac9faed, first =
fail: v4.9.290-159-gb2c6c16b9d4a)
        2 lines

    2021-11-17T18:49:49.876764  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-17T18:49:49.885656  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-17T18:49:49.899616  [   20.026885] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, aa:50=
:bf:36:22:66
    2021-11-17T18:49:49.906058  [   20.039520] usbcore: registered new inte=
rface driver smsc95xx   =

 =20
