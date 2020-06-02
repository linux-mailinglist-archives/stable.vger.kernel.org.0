Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591E21EC3B0
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 22:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFBU3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 16:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgFBU3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 16:29:48 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9066C08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 13:29:47 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id o8so54503pgm.7
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 13:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2y1O9fNRd6TunpLhiMBwJcnqLO1Pv9ggwi0BgYvDus0=;
        b=Ynk+M6g4+lfsesQAKPMSIK/3Bn9f2bS/6KXysda+MWPCAYKpYd71MLzyoLPLmB6N6K
         rRq8gtUvyS8rgMsvh3R4DnTn7lSHKkcRC2sUBV8FbWHHu1cbo/SS/MBa3pUcO98gE0Cy
         W1Ioknm6v5hMPPvhp2w/KdiiKZUPqVen8gOPmul1CM0XAjnWYr9wkRy2AFHnRNghto1O
         jXc/AUlDNCR/9TIgGzUbrvTKKTVbHLNLiykHaBEv8gAkeu55TJwlbpAAQICpowMWbbzD
         kdfuCRCANP6haSKVtoc9vTwa3FDFEZWzG9xODqPtcSWzE3+ehhrg9ncU+q3+4jUFD8rc
         7kEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2y1O9fNRd6TunpLhiMBwJcnqLO1Pv9ggwi0BgYvDus0=;
        b=RL7vXEZYQxTX6nI2Kp2siPJF+xZddnGrqdl8A0SA4Eu6ev0C9A4DGBqWCwI5sUdk0u
         MvsDKWDbQ4vXAYMXyPjQ7vd14DZ+rAvpKxO+qrXMCFz0PkkCO/9Izt0biOZcQmU6SmwT
         /thV9cyGcxGz9xC8dqUbo4b7B17KPP+q2t38MaQbryzlCtYghFlQ0FGJLTrkYDY/1IDe
         FRhrZLJPRYj6uyqAvfE8W3pJKXH5hXJrmhMmXNjLVLsDTpadyTg1l6m0cPgF7BJRhhU1
         K/U/dNdcjUomsDPECNjbIpZJjy7fxbRpDnT9VwJzcb+ZXYgXqJTMHqQatghADxvdDPHc
         mtrw==
X-Gm-Message-State: AOAM532vWD2kAiwgQFKLtsedZ1FIB238ApcxbHsFF9hsgK+WXQ6duC3A
        9ex+AK6020AWSaLPAqcOuV/m/WIrY+M=
X-Google-Smtp-Source: ABdhPJwZgy3RQpT5xI9Xm434uY7KUns2t3jbMZ/mqPiXjFNb1PsNd85/eaWhLMCrFo6EPIt8/2opyA==
X-Received: by 2002:a17:90a:a107:: with SMTP id s7mr1048932pjp.199.1591129786828;
        Tue, 02 Jun 2020 13:29:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w6sm3078908pjy.15.2020.06.02.13.29.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:29:45 -0700 (PDT)
Message-ID: <5ed6b6b9.1c69fb81.3bbbe.f829@mx.google.com>
Date:   Tue, 02 Jun 2020 13:29:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.225-60-g6915714f12d0
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 10 boots: 0 failed,
 10 passed (v4.9.225-60-g6915714f12d0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.225-=
60-g6915714f12d0/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 10 boots: 0 failed, 10 passed (v4.9.225-60-g691=
5714f12d0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.225-60-g6915714f12d0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-60-g6915714f12d0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-60-g6915714f12d0
Git Commit: 6915714f12d07947cc3e82cf34852597ff239b17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 6 unique boards, 3 SoC families, 3 builds out of 168

---
For more info write to <info@kernelci.org>
