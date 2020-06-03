Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188481ED818
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 23:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgFCVbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 17:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFCVbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 17:31:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7F2C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 14:31:24 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f3so2351095pfd.11
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 14:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zOwvDZLrXdCJu/nAhAcxhk3+k7M5fpI55v7fAKNHaoo=;
        b=wOMheMqW4xGZ7DBArtb9ZrN4Jdz2idQjLCCQSC2sWnR1J4in0Q5sQB9iOYtmLh84Jk
         CTkXsm9MqGb+hFGs/xXgPQkEqbBq1y87S+QgLNcY+IiirchtOm20RySYRAOqi0DKcw7x
         TE7BZIoUYGHjOR/NCzlQ6mrV2CLLa6ZWFGwY0zNOll3tgPJgBmWgPAYZCUqLfw8Ue+9Z
         ab2a8l6vZk7/LSuddV8N8TvzzXYmkDEUHgbZcIczvfIMaca33VEB2qe5yJ+VNnQdgQKF
         HfkBGhPirudUTxITAeNDJsERW8OG+NJPYsSaA87ihDNMV/oykqMRg0jvSIGHRwJEhDRI
         XdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zOwvDZLrXdCJu/nAhAcxhk3+k7M5fpI55v7fAKNHaoo=;
        b=jpn4NV2JgMpCXt8uUfdf8sSYmtOJEMrvcYwQdfLwEarvR81INPgqflQUSaAEw2qR59
         J5Y7gc+H0Wztu1+gpgTugp6e1uRxeN6rsW4Lv5GfFhINZ4qd0BfzBq6921VQ815ilVvi
         vWBPOE1nfgCxZpMPzuxOv7rnF4ngJDUE7/Gst1geT/peGabgA7V/YjvJOj50KcSSOBXr
         NIL0fLRMO0j8oYPmLAnNp7JKgmuG7xXyEg4AoYRnlh3tb+IS5pJQZFybx/lz649uuxTn
         bBMWyEbcOt64qfRsv/Z+quZLi1uky9RKU6yjd8IhQGIP+5fsCGNzc4x9ah8Bwb/XJcCB
         hSZw==
X-Gm-Message-State: AOAM530a1EvqAQliFjAB7W0a4gtPmH7JemWu3qp4wqJ97gs0PSX1QGxw
        vPt+9g4PQ7FwD+AWkXlqehk143bXKKI=
X-Google-Smtp-Source: ABdhPJwaMUeYoRZgjildoLQNLRyJipiarVNl87Y3TDU+AxXYBALOf01q2nfCqWDkx7+gdMZvaSmwdw==
X-Received: by 2002:a63:7d1d:: with SMTP id y29mr1282025pgc.189.1591219883954;
        Wed, 03 Jun 2020 14:31:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 25sm3276526pjk.50.2020.06.03.14.31.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 14:31:23 -0700 (PDT)
Message-ID: <5ed816ab.1c69fb81.55d35.8a7b@mx.google.com>
Date:   Wed, 03 Jun 2020 14:31:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.126
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 130 boots: 1 failed,
 119 passed with 4 offline, 5 untried/unknown, 1 conflict (v4.19.126)
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
6/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 130 boots: 1 failed, 119 passed with 4 offline=
, 5 untried/unknown, 1 conflict (v4.19.126)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.126/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.126/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.126
Git Commit: 4707d8e5727387e36ea99c74d5ff0ad227700fd0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 21 SoC families, 17 builds out of 169

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 21 days (last pass: v4.19=
.122 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 82 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.125)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.19.125-93-g80718197=
a8a3)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
