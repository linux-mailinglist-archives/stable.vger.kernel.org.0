Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E036495505
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 20:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiATTmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 14:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiATTms (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 14:42:48 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BCBC061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 11:42:48 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q75so6171093pgq.5
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 11:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/y8EhWh+uqKRXB3jxXNx1S2blx3mCKiPkbaveMa+Uhk=;
        b=dmd1WZAYmJxoruE8TprA6wXhHLtYQRmSA4JaaUwE2DK3WHfPDx6SO1435UJF74H+HS
         nE33LjIg6KrPmfv352Lo2TDZ5FvqHcvZbGbgoYiFOoLnYNIY+C0aMfF46qXp8Fm4QVXr
         Az0GtqQwXSv8yLhdDaFeAyejMpPQHuxrJkaGF/quEiqFS3xHDQgRtdO0PEmh24LGKYnP
         Stjvx7JCZeqTHfyqjdWHiOC+uO3thWUfoWjuckoMkUQdDci19cOAmo2Cbm4agFgjrttM
         3JcHisjdcvIYbcqvdX6nUGE70o3NM34vNlE9QBmMQb7zzE18PnbjSEQGk280Ex12bUlU
         FhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/y8EhWh+uqKRXB3jxXNx1S2blx3mCKiPkbaveMa+Uhk=;
        b=S6Vaqh4A7tjw/ReVy/uRJ0YCzMavgZqaCVT44FwsBCkKw3xnj05Mou2DLd43WBjli8
         SKLW0hBmA5oowT7LnOg0Hxk7mBm2qv23bk/YJJgXWSZm8Q0nmFlWqBpMEY90wI261yQj
         NWkMx6Yavlozrw+KFty92MTIeV7H2z0na9w/EyuZQATjYOQFJAMLXOBoTPaFZrLZjiUh
         tKHC1QHwMuhc0gc2PC/XUni1TiV2FCT38mKyRQE4Mnlvc1Nx9FaDMvThnD4HuocZUE7O
         Rt2h+8CLFHCu/uJ8G6pWVzf5eckmNJB9weq4+Thxoemy6sQAIYWcH7eTkvB5fpMBmWG/
         JZMQ==
X-Gm-Message-State: AOAM5306OSzlmwrMm3wW1yqrBEjIvR1MmUn7rZTWkI7weDJRuncVDdGB
        RKJvQ9bv5dPXh7mk/Hl3fYSo0uSBKhaeZYe0
X-Google-Smtp-Source: ABdhPJwj/qjlxFHb1o5hTw64fUbEk2UtXdBlb+uIFLzeIEIUutTSj/6PM0aFgmMDJri2DDyrwfPC/g==
X-Received: by 2002:a05:6a00:2444:b0:4a3:239f:d58a with SMTP id d4-20020a056a00244400b004a3239fd58amr435664pfj.85.1642707767457;
        Thu, 20 Jan 2022 11:42:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 66sm3808862pfz.217.2022.01.20.11.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 11:42:46 -0800 (PST)
Message-ID: <61e9bb37.1c69fb81.35dde.af80@mx.google.com>
Date:   Thu, 20 Jan 2022 11:42:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-21-gf2a5382f8a38
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 149 runs,
 1 regressions (v4.19.225-21-gf2a5382f8a38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 149 runs, 1 regressions (v4.19.225-21-gf2a53=
82f8a38)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-21-gf2a5382f8a38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-21-gf2a5382f8a38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2a5382f8a38bdba79d2a15bc33a8fdedb291fd1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e987358890cc68f0abbd11

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-gf2a5382f8a38/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-gf2a5382f8a38/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e987358890cc6=
8f0abbd17
        failing since 8 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-20T16:00:38.251235  <8>[   21.338378] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-20T16:00:38.296014  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-01-20T16:00:38.304982  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
