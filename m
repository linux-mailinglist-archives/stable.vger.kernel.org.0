Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9B748F0B4
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 20:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbiANT5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 14:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiANT5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 14:57:02 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725A1C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 11:57:02 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i65so3691590pfc.9
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 11:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V2S6f7k4M30JwuUaSSF2c7h/l4IuywnyYe8Su0QALrI=;
        b=pKz+rFJx1pShZZNGAwEPiWXTt+Zd6vK2wjoOtGpDzkoNRbye71ba5z75LNILn3mcp6
         UfBXzo9flu+Jw59Cd+VJgRrlqW86431DmO/NNWx7mngYOYcsyrmJ2DEsoercxmOVrvZX
         Q+r4o91P/UeOaPw771AqwZFvwQZ57OzkHgGNcSMLT88O1Wv4fLY61n8Iy/1/xoIqEYlx
         z/fMfCfpOria6wl0KU35tAm8AHSK/MFpRbh2lU/X/IZA7AgU+oHMaKEi0u7NVwTFwhDL
         H4QONVrxMt3oE2GwDCc7nB4SNHPnWYDPhaimMRQCO5txov8EPWCZ6sWQVNlvDb4ik0WZ
         NYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V2S6f7k4M30JwuUaSSF2c7h/l4IuywnyYe8Su0QALrI=;
        b=aiAcvqcLGxnQFZ/tC5BqA12s/A/KKeL+uoa+BhQFaP8aDt+TNvv1e+7IrT/81whkt8
         jAREKQJVtb2qQZg2/uRpdt5jLk0es/sjUaQX5aSk0ZFZrO45dJqo82MCSeGyRxMhWVIp
         3yd/cpQuo5lrfplluiMCbKMqDqKU1zEC4fc9ZN45aa/UfYxbrLCk1Dj0Rpk20C26Sv+H
         zo5JxLgZC/j7Q2axJImKe3Vhp1yJsYBiX1z0Tz246eubzVGjUrPiZK+/cq3czU0wyaVW
         FxAZuz4HUtPry8gQs7fm0h42l2+2iO92G4vDOQhpPhe/U+F351YZuIUdJhrYKuzBIyuk
         29Yw==
X-Gm-Message-State: AOAM530ShMgSYiFmbKAiG/Iy9Fyxsa+JBuae+J3cy+Tj9rw6R1CrfZfY
        AxqQBbyl0Z+kIirdfBekcuaSzQYwvlrDlCQF
X-Google-Smtp-Source: ABdhPJwd5/zQvBvyMC76SHxXuUC+wAbxWNKpqbtaNxzS8kR5DDuvt7Rja8he4iIoPUMVYS9obSolog==
X-Received: by 2002:a63:7c48:: with SMTP id l8mr9112683pgn.483.1642190221861;
        Fri, 14 Jan 2022 11:57:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o184sm6500186pfb.90.2022.01.14.11.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 11:57:01 -0800 (PST)
Message-ID: <61e1d58d.1c69fb81.65d1d.290b@mx.google.com>
Date:   Fri, 14 Jan 2022 11:57:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-7-gb73cbd6cb212
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 95 runs,
 1 regressions (v4.4.299-7-gb73cbd6cb212)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 95 runs, 1 regressions (v4.4.299-7-gb73cbd6cb=
212)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-7-gb73cbd6cb212/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-7-gb73cbd6cb212
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b73cbd6cb2121629cc6c77b1f673ff0651bf8c40 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e19b22ce435d9a10ef67ad

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-gb73cbd6cb212/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-gb73cbd6cb212/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e19b22ce435d9=
a10ef67b0
        failing since 24 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-14T15:47:22.281533  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-14T15:47:22.291180  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-14T15:47:22.310339  [   19.538909] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
