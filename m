Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398BC46B01C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 02:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhLGB6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 20:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhLGB6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 20:58:21 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE32AC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 17:54:51 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so716911pju.3
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 17:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cMR7p4BAMIq8fCtyJj1Su4ONCIW3e6Mkuhl1/ohsiAk=;
        b=XUQSgdMvHx+pOaE8VWuDgI03QJyxIC/GZQKmTO1rfYyvbRtL1ULp81PncsvyUUwocL
         FnHWLaQ999NN3vwZp4LFJx23ahLFoK7WMV/wxH6GM65p0TOJFVP2hx6QHRvhJ/C5sskJ
         Sv+JvvfyM3xuozOAtO8i1M69ZJi/iYJVS+806dgwKnDLEXRjZxnHe5+5+MrjSgLzf0Am
         9FGu6YyNhXTBHflVlkD+lOBP9jrnR2RqDFDEkz6FJO14vxt92WjWmpYDEr6ngeuYaAm5
         PFWF4rKZCDn8sCgU61xyZ4NjXPM08IqHw6SeJiw++uEQdGMVxS71Dd0HX9IesFo2ATKU
         qVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cMR7p4BAMIq8fCtyJj1Su4ONCIW3e6Mkuhl1/ohsiAk=;
        b=6t8B2Px9+8qo/LBqEFKyi/J48NYFilZ1h0pa7v0p/OwOx94QeZvFXpTE+3b8AOi+E8
         /6YbGHvCT9/fYohcZF12RJXyyynzO+klkFBQSxFUnBHxNS/E8jeok0w5AGG/gEWqyd5q
         vugKa3z6CaN+LyyRkghYZNlYZtZkVglMafOw+igz9ayj1mM3hKn+nDfuikeWvKVD/DBI
         AuX3CMwp2Vca0Y/XHZb11xy7OUSc5drygxCbQZFY+mOWi+K3omfKEzzZlC+NeMkN72FK
         bwhs85slVqlrUlTmnzKnSMSFR6qCflUxCtKyVGxwlWMZ2HP02WnIpJZbGGYt79mFtsgk
         WfUg==
X-Gm-Message-State: AOAM533/hNELitfEOS52J8VFm0ChwJuxwFX/5wUdfuFwPbOZr4/a45MW
        lRTAm1KBwABfTTZIpXIQciVfWd1ccKfQNw8/
X-Google-Smtp-Source: ABdhPJwNPD6E/R2S3pcgyUMU1tuTzzcAJBNi65Eeo4IfPcAbKrd9TMRKEHrvXRNDtjbP719K7GvzGg==
X-Received: by 2002:a17:90b:3e8b:: with SMTP id rj11mr2909230pjb.63.1638842091074;
        Mon, 06 Dec 2021 17:54:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm14330558pfk.68.2021.12.06.17.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:54:50 -0800 (PST)
Message-ID: <61aebeea.1c69fb81.9c593.8c1b@mx.google.com>
Date:   Mon, 06 Dec 2021 17:54:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-62-g6bbeba4a98d4
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 1 regressions (v4.9.291-62-g6bbeba4a98d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 1 regressions (v4.9.291-62-g6bbeba4=
a98d4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-62-g6bbeba4a98d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-62-g6bbeba4a98d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6bbeba4a98d4eb3f2538a23da87fff07110ba569 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ae852396ef0e78fb1a94ac

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-6=
2-g6bbeba4a98d4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-6=
2-g6bbeba4a98d4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae852396ef0e7=
8fb1a94af
        failing since 2 days (last pass: v4.9.291-47-g43f5262d9792, first f=
ail: v4.9.291-51-g9e9032945598a)
        2 lines

    2021-12-06T21:48:01.716716  [   20.186828] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-06T21:48:01.766431  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-12-06T21:48:01.776442  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
