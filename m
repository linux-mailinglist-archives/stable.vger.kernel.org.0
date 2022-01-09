Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94CB488B4F
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 18:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiAIRfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 12:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiAIRed (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 12:34:33 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC1AC06175E
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 09:34:30 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id j27so758549pgj.3
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 09:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=My8+95eucP1qjlIzfd45p9FWan6vdplsUtZ4q6jFQeU=;
        b=wMRpkQ8vc2GqqFA4ypmxR0zGU4BlDAHSAIwZXtRzeMTPjN2aXrT0eSLoqT2Xn8sqWc
         oQfvPfKS3q0Jhfn2ioiLErDIZyykVoC3Up7j+YCJWXKgSnBQHqCuHECljHUihyIAvD6K
         HmrFnbyfvDaBcHACCdXhC5YzPzBLUwWoYBS93152xvA2a7ijmnu8zbr6TLM6i73mU6YX
         vveq8pYMMmc8JfFXwnvbfnegDBAXjwD3yKruIKZfRlRa398sNsyKRdIvvHe2KdKBMX3E
         r68P/fIGFSbo6l12rziQWrSskCEuzHd1pc3gCDMJuYJ2ztkpWxwQLXo+4jeGRst7AohA
         inAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=My8+95eucP1qjlIzfd45p9FWan6vdplsUtZ4q6jFQeU=;
        b=wXS3NkdQ05IWLRk4HbWGTwOtaKQ5tpxHN3BSn+dpbuXALha+N94IxprIVObbYEZ0mV
         59wuBk1+/r1Wp2mTHOPBFg2hmbbrENFtlpyWAe+Nr0RtZ/1DuNFxts4rnLWm9DJ3StDY
         x4BGbSZe8DY21tOaZ+y0zu09RQRkzRuudZwY2RuwHLlrO+TiuG0FTrEclzsfoRvJdv4t
         /yUCWBSGtnG0J6TQUwOdzOo4TNshig9bHBfzKnVyW73mEKgSaUjvmCuKT2DS6s9HAfWh
         VGZpaJIBFcP0NJfLV/m3rtp7pBUEXNAcYb+AvGZ1Eropo5lcVgQ/DneuahXdcJPoqRpT
         Saag==
X-Gm-Message-State: AOAM532wcAl1ncVRZpPsaXLAdZVchjEmJgW+k2aU8rJfmSKnAtj+gcXL
        9sAxmRSbLusfHWmPQPyvciW82ol4uAb1iG23
X-Google-Smtp-Source: ABdhPJyNbDMrfjR9lPTHQb5qawR4JN66r7Y0LLv/3y6X3XEcwx7JRzcYf4JZDdbJPe+KNM462rVC9Q==
X-Received: by 2002:a63:9550:: with SMTP id t16mr5237079pgn.184.1641749670004;
        Sun, 09 Jan 2022 09:34:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng7sm6516812pjb.41.2022.01.09.09.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 09:34:29 -0800 (PST)
Message-ID: <61db1ca5.1c69fb81.3a5c7.0d1d@mx.google.com>
Date:   Sun, 09 Jan 2022 09:34:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-9-g11fce4ed659a
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 116 runs,
 1 regressions (v4.4.298-9-g11fce4ed659a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 116 runs, 1 regressions (v4.4.298-9-g11fce4ed=
659a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-9-g11fce4ed659a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-9-g11fce4ed659a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11fce4ed659a83bf08f00bf3d26fb9f84870a819 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61daeab33227751597ef6774

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-9=
-g11fce4ed659a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-9=
-g11fce4ed659a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61daeab33227751=
597ef6777
        failing since 19 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-09T14:01:09.177298  [   18.982940] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-09T14:01:09.227648  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-01-09T14:01:09.236896  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
