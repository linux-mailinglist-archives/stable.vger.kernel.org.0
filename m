Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307731EC353
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 22:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgFBUB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 16:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 16:01:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5BBC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 13:01:56 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so57265pgm.0
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 13:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h1hIwGXD7X8v7wYYk9rkp8kVpGA0a/zd5+DnEahiwv4=;
        b=KTmwAOm/3ffsGZUu3ras4plS3XYvSHp0xVebhkOCMaQKyGPh6IUD7Mks4rs+IuEH3x
         75dnQM5pupvr0KfKTqf2RRLuLVnEV9SJIVfKg6fLRDEDWaWAdakd5ly+DMMJUFIw5wXP
         PDS7r47EU755XaBKsaj8KW8DudQAzGMQhXifkIa6F5zx7Xwe/1OiqGnY0MsG6Qp5Dgsp
         kD1kAX+vcGVIw5WhQZcJ63QKtHMm43Gl2dCCbT24FdUISfn6Wfyy+LYX75Q7Tt99K/UW
         m+h3/CV6HAJVUgn4RAv+1siQN68te8LJV5x1Tju/1cL2hz96kKA5OipFGx5ZDdzli3yk
         i5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h1hIwGXD7X8v7wYYk9rkp8kVpGA0a/zd5+DnEahiwv4=;
        b=OnVJmdPRO73+CAKCV4+lINEV9vCXn2qD5CShIefBtoGBcNnMugllWwmgjMpEHHuTaH
         r488Z/1B88L8I+C7bZxkKRNduHJjzjqf9w1sjiy7ZhaAlWXODPWNNa9ww43kEfE0Gaqe
         OSFotM6WP0XdAScySu9qiOHpSOYLNCbT5dboB5FxtNWp4vxzFk/r6bWoSIQYKXQOhhEF
         duCiigBWmU05gnEaCok9pMwbAEmPHuVscu1/g2eKzOr8wSc/17kRf9uBUNXcir5K8dJE
         518dgHEeZ5lv7nKxUqREreKDHH7WCBnhYJpkHuUO2lZ6xnwXOaUlcEPixrLZgpx/2Apc
         2mSw==
X-Gm-Message-State: AOAM530AagKfyQPbl8M0OiQtgVc7Wg/3JWLC614wq/kIT7BCJ3f0z5NI
        W00e+pbEtu/59TU4WtUg8m5H6mLgnq0=
X-Google-Smtp-Source: ABdhPJx1EVQn1GRGaW3c7QWBib+a4/8jkboORiH9oyHjds+H2As61Xk0gapj7/futRBLRfF7dyctgA==
X-Received: by 2002:a17:90b:3691:: with SMTP id mj17mr848797pjb.152.1591128116071;
        Tue, 02 Jun 2020 13:01:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2sm1532346pgv.65.2020.06.02.13.01.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:01:55 -0700 (PDT)
Message-ID: <5ed6b033.1c69fb81.3af13.810f@mx.google.com>
Date:   Tue, 02 Jun 2020 13:01:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.125-93-g80718197a8a3
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 133 boots: 1 failed,
 121 passed with 4 offline, 5 untried/unknown,
 2 conflicts (v4.19.125-93-g80718197a8a3)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/kernel/v4.19.12=
5-93-g80718197a8a3/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 133 boots: 1 failed, 121 passed with 4 offline=
, 5 untried/unknown, 2 conflicts (v4.19.125-93-g80718197a8a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.125-93-g80718197a8a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.125-93-g80718197a8a3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.125-93-g80718197a8a3
Git Commit: 80718197a8a3f9c3b222375e5d1de8adf5422000
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 21 SoC families, 17 builds out of 164

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.124)

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 81 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
