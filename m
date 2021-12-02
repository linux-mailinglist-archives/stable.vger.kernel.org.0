Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC616465B9B
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 02:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344451AbhLBBa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 20:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344232AbhLBBav (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 20:30:51 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2D6C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 17:27:28 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np3so19350391pjb.4
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 17:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2J05PPmr4pbkh/uia0kSf2cz90bY0f2UWl9ewCdg/Xs=;
        b=4kblhoMX5snKf0vCzjiIe44WjE2qkHlg1tF3v92Q2XNMJrXeTHY3Li6y7CraNRQx44
         DjPBZMZ8xCkHgSZ8nMj9R5WJEPalV0TDSKfIFyCOlRAmsg7EzCHQBZkht+nMB0vZMOfJ
         0ZIKdURsi7UYTDbXh0ATW2MesMSBZPWgRpSACrB034T74BryIhXpbN1GbaUk0CVoPoij
         xJc6Qxo/Q/xJmMiUHGxXEXgEBt6WdtjSy8hl+C/a3d9hEMWywUIIoLl5f29tIjb8AG7n
         Hbhjje0FJgn2dzH7Li2b6LuUfa+5XxIRo5pfJmJuboshMGi4phWtHieYIFie7mWVSegI
         WOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2J05PPmr4pbkh/uia0kSf2cz90bY0f2UWl9ewCdg/Xs=;
        b=q04ufCQ8+zdSkiKzF5gPTXRRuut8qH4ELCr95z/7+sNPAbuGjfaes/zJQmXx/cDwFc
         Mhi85LEYiwu8c+lZTp09C3QmKiKyFAYDi518MmD4U+yvch8JFH2sm/2jLCBuPtBqOMeR
         vxUEfOa8+JrpqU4CKeezzB6ubXOaTANj4FwxR+0H8zcRCNqufuSjvunWGxsIAUPtlAhc
         c4/MkJmJ6lVq7guV577g0CjBLcSVfrCpYzxVnXf0vwzK5UA49nVEd5xvnu94MkeNmhTM
         pjv+gzUi9Dbz6t8CUB9AxgeRlt35PM6uAYXoiGX77248kMjK6h69bCX+Qum9pbdYlNnd
         KrQw==
X-Gm-Message-State: AOAM5320Jb62mmVKSlVu3ukINoNAxpf8y6SuOMpUGQ6cYduWFD2JurMn
        vo9NJpKGxMJT4WfXVk83GppdfpmoQPMGMwsa
X-Google-Smtp-Source: ABdhPJzRMD4GHMIrBsYQq/BJ2V3WeuMu1+HSs1KOQueDi9/en6pJvQSPKgY4QBlYVEIrwm80V3sFuA==
X-Received: by 2002:a17:902:a717:b0:142:76bc:da69 with SMTP id w23-20020a170902a71700b0014276bcda69mr11919349plq.12.1638408447895;
        Wed, 01 Dec 2021 17:27:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ls14sm488326pjb.49.2021.12.01.17.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 17:27:27 -0800 (PST)
Message-ID: <61a820ff.1c69fb81.3bbff.2854@mx.google.com>
Date:   Wed, 01 Dec 2021 17:27:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-71-g856af8529b65b
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 83 runs,
 1 regressions (v4.14.256-71-g856af8529b65b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 83 runs, 1 regressions (v4.14.256-71-g856af8=
529b65b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-71-g856af8529b65b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-71-g856af8529b65b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      856af8529b65b9b08cb83096a05c043d90a662d4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a7e979f13a7db3e81a94aa

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-71-g856af8529b65b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-71-g856af8529b65b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a7e979f13a7db=
3e81a94ad
        failing since 2 days (last pass: v4.14.256-28-g54e5647834e42, first=
 fail: v4.14.256-28-gb75fc63979563)
        2 lines

    2021-12-01T21:30:14.143923  [   19.853149] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T21:30:14.184454  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-12-01T21:30:14.193770  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
