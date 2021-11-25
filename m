Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47C45DF7E
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242450AbhKYRWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbhKYRUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:20:10 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C1AC06137C
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:04:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso6212240pjb.2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nctp/Vz+ULjlfW9hDzlg5T5IzTSaXpgnE/kTqs1v8Gs=;
        b=OmX14wb+6eR2zbwL4QFMiqLtKAnRMopXPDVM6jqzk41kq7R5NWJ67VjMHWF1J49Wxv
         STot2K6OC4eqdYaWHuFT7oPejP/1X7EUkMkF2ixCfJKonYenYlOu5cCOaXvvRq4369hf
         LzQ3seimDchkctZ54u0c0cllricGsGtjLmaDOIwwjwZ49WOLsfSRIHMQ/IoMDUaofOt1
         y+SDe7rwLzdEnieEJYxmpHDeZ63Mj4r1YLuJp9/TKApUqlEhrLsDLdKV6I8kbe701Uf3
         0P5DZpIUl6R/wsYGAXyfDqeCR8/VWE4Gvac+t+0oS55XWvyqS4d6+6N22tSgbP3zS/8q
         HKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nctp/Vz+ULjlfW9hDzlg5T5IzTSaXpgnE/kTqs1v8Gs=;
        b=0/jPnVyr1HnrfNSDwX0QUHgKwzMozB3Qp0utIANTxBInOMsuRwvoGgN8OkCZzmjYS/
         UO4TL0B/7OF1XbC6Z1qe/2PJkdHyrtBz3cXc9yB3hyBjKrd4ZV0GYoET/tnvMaqW87Ro
         RBPn5eGTA/3z8BNSR4bqsjN45ZVmmTZCL3zsdIi/Rn29phfW/vDd37Asx23T+/RagX3I
         5TWkxnkB6+iPGDmkTKyOvYQcxWoelGbW0NzfcXhA2F68Jn/5/aqF1F2XPUhsoub/AHDD
         VNdSjknsMiynQCx2iz0RtXiK61K+siUeqtpR9nAp/mLOyab+eHpRZq1yhAsvmlbA0wLz
         xgzQ==
X-Gm-Message-State: AOAM530RjZooslKSMQoC7gZhi/2g5ZZFkHtWfv9lcUuaI2/YGELZbOY3
        ngVxyhOxuXGkjjp5lS+yxKOQxkGXOVaVToP2vyA=
X-Google-Smtp-Source: ABdhPJxwTQvVlItK4B2bnXBRk/x6OYxuQkIObuZo6N3lfNl2zwQK0DWbkOyxo+nWv2C4oRlzlEYcjA==
X-Received: by 2002:a17:90b:30e:: with SMTP id ay14mr8722970pjb.60.1637859843287;
        Thu, 25 Nov 2021 09:04:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm4372962pfv.65.2021.11.25.09.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 09:04:03 -0800 (PST)
Message-ID: <619fc203.1c69fb81.e8999.b369@mx.google.com>
Date:   Thu, 25 Nov 2021 09:04:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-321-g71126e61451e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 146 runs,
 1 regressions (v4.19.217-321-g71126e61451e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 146 runs, 1 regressions (v4.19.217-321-g7112=
6e61451e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-321-g71126e61451e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-321-g71126e61451e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71126e61451eda8e83171be4a86c19b8cf0009e0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619f88a20294572ec5f2efaf

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-321-g71126e61451e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-321-g71126e61451e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f88a20294572=
ec5f2efb2
        failing since 0 day (last pass: v4.19.217-320-gdc7db2be81d5, first =
fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-25T12:58:56.239925  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-25T12:58:56.248746  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
