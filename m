Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2965345F5F9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 21:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhKZUoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 15:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhKZUmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 15:42:16 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FB2C061759
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:34:34 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 137so2062307pgg.3
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z57+Ea/3QYe18km60cLhxCzegPd1bUGSY4tyRriJodw=;
        b=2rVrzwOsUIDss5qSZL0eHJzGx7FMP0mplpnokyxz0iP8VX+s32UegtPBQXROuyRGS0
         +x7F94mYMCaL9blMKu39029yUAIPzP9Wf1FJY0RAwd8Fwxl7XBAoxknGpiDGGG64mQSe
         QOBc9x1y3JW8djDaQqCwvi7NdEkxBLpIigRiJKJg2W/yAKk3vyf2+j+ifxMuiy0tmrNB
         t3aqLM/0LdlCa2Z9IChPZpp5zfzRFWlOnEtDZSHMcmt6JqtDRD2FvaawvaVE7xOEntT/
         CBWqmJNLDD8YqBxOMhEpRGFlEx2+3ctkfi7ndGbx6V9M5HKLYJ3sQfalB3wY9DDxJ3up
         vXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z57+Ea/3QYe18km60cLhxCzegPd1bUGSY4tyRriJodw=;
        b=3UVW27lyX8LE/RQkeIX/UQWRXJJgRJ3u/84XeNuKOOtCCD2UlG/dCxcFRGVlTCcW7o
         +UzRJB7GpmqL29YYqJzm8SFqslLDWqy0eC0xyds6sRUiZv+XmqUjLHC2+KeKYRNOVJ/J
         9DL3kn5nmU51jbscSck1HnKUQnGLMZLAwSvcOPiMKThhLYs9Vhe2kzd91/Fgv9KiZHs5
         zGn7BPW64JxiHQ7f5BfLw2lLg514nPs4xpFG2LS0UkS5Nb0nmZpb+pPDENXhiH37shuX
         a1SwRad98NWM0qHz/xx2XIVJrgJq5jGXajz5uR8s5khgvCCGlS9sbyqyyxEmFMHcG1Nm
         TYuA==
X-Gm-Message-State: AOAM532laxuzvR3HvRWi2DKugFfBmLoNNgS5/Cj/lNbSqeA35w+HIZKp
        fuVcpbWpO6sBgt186HS78Y+Sm7yQHheURmug
X-Google-Smtp-Source: ABdhPJz+Hm61EdE+hfv7uD4OC2tecBzEHFUpQ79DsSvsY7v3abeXk0u3y2pFIjm4aW2ZEZERpRUZVw==
X-Received: by 2002:a63:68c7:: with SMTP id d190mr23127618pgc.341.1637958873331;
        Fri, 26 Nov 2021 12:34:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm9021000pfu.183.2021.11.26.12.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:34:33 -0800 (PST)
Message-ID: <61a144d9.1c69fb81.549e6.7c7f@mx.google.com>
Date:   Fri, 26 Nov 2021 12:34:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-204-gda1217dd458b
Subject: stable-rc/queue/4.9 baseline: 72 runs,
 1 regressions (v4.9.290-204-gda1217dd458b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 72 runs, 1 regressions (v4.9.290-204-gda1217d=
d458b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-204-gda1217dd458b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-204-gda1217dd458b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da1217dd458bd7b2ce92c919bd3fe33f6605b07f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a10f5ccfff4ca48518f6d6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-gda1217dd458b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-gda1217dd458b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a10f5ccfff4ca=
48518f6dc
        failing since 1 day (last pass: v4.9.290-204-g18a1d655aad4b, first =
fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-26T16:46:03.250402  [   20.436645] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T16:46:03.303079  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-26T16:46:03.312359  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-26T16:46:03.330118  [   20.517913] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
