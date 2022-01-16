Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523DC48FD35
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiAPNgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 08:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiAPNgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 08:36:48 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BF1C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 05:36:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l16so8137873pjl.4
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 05:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RiO+KJ7isDVtpS86F4+4eusKydDq0dX7CBOplShXrMw=;
        b=R0wT5g4JbZyBFrfi3UiVTshv/31I7+AYpEVkfuYdSRvIlpPyqTKt10yNmhmYcGUCqb
         qquB4pGajB17/5lEzuMXpddKbm1EVCq2V7pb7vaEuFoW7BL0hiJkinOBzaYoqtbRk9DB
         iLt1ceEruZoF1YBzWIMj/sIpe/bGFiokmOkDSVN/s25HJXg1hP1SMKNIeqBrmZ4yL1+0
         qaxwZHzqz1zQsH18BXSdWEv1hIMTwOldfaBXn6WRv9PAr9nqPl+v5qrrNyaK4/edntpL
         ZS5hlJ1n6wnXqXXBhCei0OVk6/u7/X6cZichE6r2P0aQf4ugwKaIb1PwtKaujyVVS2/b
         +WOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RiO+KJ7isDVtpS86F4+4eusKydDq0dX7CBOplShXrMw=;
        b=3NR49sjXegWnDWbpqSSvaYHM/hwA8RbZ+/kNjUUWmuNsvE6AwLugru9n75IdPe9yt8
         DtCJ4JLfat0Bx/Vwg7dpACXVplKe4qOL2MRPkKpdgDmD1V9Tbm2jvgixQXHGKvlvnhZr
         eANXq2+xILiboNo3VXn3hhYsKs0KLiCxgt+T0DcVX73jTNMwQuQH8gb/+UrJfe5yVuVr
         27zfY6MRfq+Ff6NHNMGxwoJDW9rsMDZ91DiEApDpFfcQWTiOtDW7mHZjyAAB/+XrlSWs
         AApJFWH1npuSvYcCzy+w154kUL4kSfAACQfZA2zbcmRevQCa0Sd57aCoKEWqTFthIH1R
         2dkg==
X-Gm-Message-State: AOAM530ig/+LZf7ef2GOCKRK/8fRCNlgt/i+8Eh8xl2JmncpECAvpQQ+
        f731hXaCzQ1xqXPBM1Qqh+4ZYAArYmKSWtRD
X-Google-Smtp-Source: ABdhPJzZqP3OktIWBQ2d0EIrFIgxgZQPTlBL0MHN2Dr/cVdpYr9x+eqCf6W+wcTqVf0VFdaOHdo7CQ==
X-Received: by 2002:a17:903:1110:b0:149:a428:19f1 with SMTP id n16-20020a170903111000b00149a42819f1mr18434792plh.120.1642340207337;
        Sun, 16 Jan 2022 05:36:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm10382651pfo.38.2022.01.16.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 05:36:47 -0800 (PST)
Message-ID: <61e41f6f.1c69fb81.c0115.dd3b@mx.google.com>
Date:   Sun, 16 Jan 2022 05:36:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 157 runs, 1 regressions (v4.4.299)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 157 runs, 1 regressions (v4.4.299)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0ee52316847cf279a1028334117985a5d633c0c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e3ec69b3b9c29e62ef6743

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e3ec69b3b9c29=
e62ef6746
        failing since 17 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-16T09:58:49.344939  [   19.041595] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-16T09:58:49.388470  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-01-16T09:58:49.397841  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
