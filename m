Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF37C1E2055
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 13:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388704AbgEZLCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 07:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388801AbgEZLCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 07:02:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966F9C03E97E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 04:02:31 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id cx22so1294673pjb.1
        for <stable@vger.kernel.org>; Tue, 26 May 2020 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PvMWh3RRnIM7ZI00bZNxFM2atmPi35YqsKKqZANzKcg=;
        b=oO7vxUmCph1+MJBSgWRnZR+D7WFbrfTR2493ZK/wxThKHCo6qnRfkD5cTUYBG1VX3w
         tQot/6hH7SQ8yTSeqkLp4b8rIhB15iAbVKeOBEV3xVKa2RVo1aTDByMOetJ0vPiMpHK/
         MPDc3eVBJpZYluAZqj4JUZp5Ce9Y10VWiW1TVTpZZyRbrk1LSNkzcijL/kiM4rbw019T
         JMqjnzYxJu/Lr36/XfQ+aWGPXIEyojeZ2XF5xFipfxJ3SO4HzV9VydD7dmXXw/o1k7gB
         jhAfl06yzkfueUJmqzBKkYihJ6veI3cinAJwXvZt36I4/WO2TSOOvaR/a4wU4dVo/Nks
         uuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PvMWh3RRnIM7ZI00bZNxFM2atmPi35YqsKKqZANzKcg=;
        b=EvjqKfF7jPPH9on9fl2dR2TniElInVwylrA0AUTDBMwhQCGypTKgGYSkRdfzFCKAOY
         KOF8dB9SlV9k1gYTfm41vOW9nCzvyPI076YgQUgTl/GAW9Vn2ER1yRfSHRU/JWRqBYC7
         2DtaCa7gTSqsvjW1e4KO/6cwqGqQJSYKBfJS3xB95eNDVz9OVjqWTY6DuSD0mpUat+ZS
         wVFgCODXtTnholnhVJSMaMHK5AdZHFZHrW8R+AsM9fwyBNkbUquriLcDKM5G4qEd7kpb
         bialRpTjKpU3pesmo719SIiTIAiQ21fHP2MAOVAzav4x9gPDMGMKJb47WwY8wTr29yl0
         syRA==
X-Gm-Message-State: AOAM531yKwJ+rpn3z3MzEDMiNDKet1W932s1e2hBCIHuTIzjdY5dr2x5
        wkCyxStEVtrRzWbMgfMWuPeu+OE2Q4I=
X-Google-Smtp-Source: ABdhPJzV5HO99uQ0onJ2D2ekonvt3e4T3VBGOm7OUQXHA33qEXMrFn2DReGLDeAwDcG6w+jRqFoCbQ==
X-Received: by 2002:a17:90a:ad86:: with SMTP id s6mr25383157pjq.193.1590490950590;
        Tue, 26 May 2020 04:02:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j24sm13897722pga.51.2020.05.26.04.02.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 04:02:29 -0700 (PDT)
Message-ID: <5eccf745.1c69fb81.4bfe6.915b@mx.google.com>
Date:   Tue, 26 May 2020 04:02:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.224-38-g1f47601a4296
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 92 boots: 3 failed,
 78 passed with 6 offline, 4 untried/unknown,
 1 conflict (v4.4.224-38-g1f47601a4296)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.224-=
38-g1f47601a4296/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 92 boots: 3 failed, 78 passed with 6 offline, 4=
 untried/unknown, 1 conflict (v4.4.224-38-g1f47601a4296)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.224-38-g1f47601a4296/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.224-38-g1f47601a4296/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.224-38-g1f47601a4296
Git Commit: 1f47601a4296940bac6cba8c55ab73ca2453f284
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.224)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.224)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 12 days (last pass: v4.4.=
223 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 61 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.224)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
