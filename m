Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8242B46BDCE
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbhLGOhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237908AbhLGOhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 09:37:42 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87B4C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 06:34:11 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r138so13956489pgr.13
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 06:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jx5mL7GBecw7Qn7p4n6jaNutdyVtJNgufFSljczGVv4=;
        b=b5lrURcrFyoTpMcpqZnQm0WDOiWv0I03IOyQApsgApchd8IU7IvCsOHw+8NzfL6xJR
         LKeu4kYkh1mGvrQai05yo7Pw1tIQJL34/VdYH5XZy/Zo0/jQcUFOo0Vr3lShqc+xKVIH
         tGlzhm5kMeMMuVt3I34KMfapoS/TXwf/bgUnbLWEF9Bo3KJz1yi1LxQVzlbBpwBiPi/B
         Td/PRBPmqaVzeCMbSR+RZvNdAdO1ntx2J3MhKbYPdnfZiUfxR1KVZSVFe+FXmhIMieaF
         LAOWl8yg3s5w5zDB0IORzcH07M/W+7kEi6iK8AqmsHm5RM5lG9TjcS6q8WemtxV+7T9e
         DhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jx5mL7GBecw7Qn7p4n6jaNutdyVtJNgufFSljczGVv4=;
        b=7bbhvQhbPDn/HXg93A3K+V2MO/+QdHBCYBQ6gBctl7rQaJJkhtNCRt8LMk2Jo8rkk6
         YTcNQC8p1sYbAmKCmG55189drMoysKJLyNSymiRa9wQ3HFhNkMTMYMIvi8DtfibghSy4
         JIh72rsgdgD74Fm6UVMeWvvuBosiNr2+Ehdn1uub/GmZZ05NJurtKZiWW1Jbc9Fs/j0P
         4oeD7vhbFv+Y1gXvY0YduetQsQ2pdY7BN0tit1hPGZ4BWMFjkPINQaZu8FrITG8879o/
         Xk7lFAEF/rlPDzgOUB5J63iP/HIExf9OtgPy3Xvo02AnfQEGVvCSf3o/HPNxvFBlu5Le
         ks1w==
X-Gm-Message-State: AOAM531VOmP++6e6E4YZLmDIhTN2AiHJBMszXol/3pjvuoJoOy49sJpP
        5J9McAHm3xUHsU4NypQPNKl/KDq22pawLIgi
X-Google-Smtp-Source: ABdhPJxhN/t65BdUBFVZ2aZ6kRkwRssFU45/aiScg47aRm198uEqQQ/ibOS8iBmo51rddjDHk/DYow==
X-Received: by 2002:aa7:9990:0:b0:4a1:57ff:3369 with SMTP id k16-20020aa79990000000b004a157ff3369mr43508901pfh.31.1638887651257;
        Tue, 07 Dec 2021 06:34:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm16680630pfh.210.2021.12.07.06.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:34:11 -0800 (PST)
Message-ID: <61af70e3.1c69fb81.86f3d.ed0c@mx.google.com>
Date:   Tue, 07 Dec 2021 06:34:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-48-g68edce585def
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 166 runs,
 1 regressions (v4.19.219-48-g68edce585def)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 166 runs, 1 regressions (v4.19.219-48-g68edc=
e585def)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-48-g68edce585def/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-48-g68edce585def
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      68edce585def7ad8f803f1ff6a07b4aff4356ebe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61af3a54ec53b2a4c01a94a7

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-48-g68edce585def/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-48-g68edce585def/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61af3a54ec53b2a=
4c01a94aa
        new failure (last pass: v4.19.219-48-g6cc188def9f7)
        2 lines

    2021-12-07T10:41:10.038494  <8>[   21.331390] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-07T10:41:10.082930  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-12-07T10:41:10.092176  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
