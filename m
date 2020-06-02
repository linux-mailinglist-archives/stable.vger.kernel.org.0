Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1401EC442
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 23:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBVUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 17:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFBVUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 17:20:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78940C08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 14:20:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o6so183900pgh.2
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 14:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j4TSP1iA6sWhkhbrd3pE1hGz1gZ46t9B0rI04JOiI80=;
        b=whjn3FZw6aukawQAyY7kwS60QuLMrdqMh4uifGvO3GFTiKRuvX/N6NHRsyntUF4PJI
         e819XWCbwDrrOtTftYgWJCbeJhUILLtDeAnNfFgIe6ptOgoW5MZ1LIazIVVdNe/TG7Yb
         kODmDFI41qSzJcvDedFjHzPOpi4h2Y59wiM1PSXhermH68QYHP4mDZ3/TddelnydXd83
         sPtrLKT0U8wbqBYefHjWsASmijBC5m0nM2jSxiVxHR3H5tJu9VvgVnl74fXjdJdVZGj+
         eyNkuIcFwrUHq+aIqGKkooV5TsCi+K/GxzbAvN2iAqzavqEK3HVmOFZoPY42DT1lLXLl
         2ZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j4TSP1iA6sWhkhbrd3pE1hGz1gZ46t9B0rI04JOiI80=;
        b=Tsr7akIKFV9+DiccBOSYEeQrgqxQDHpN9S/UM+BE0c/xCACg4oJNdEVsxXA1xBAZYr
         jW4vfWaAi0dfBs7+hJq+JpE62ncrP9pmHM5obGYd3vUIsMJtz210YI1TWLlAQl/JEpom
         VRGz4SfUBdCXvEie1YmP5xCGvNx58EB6PxgQ1ou89huPX+zMW275T6/knb/XCCnuDe7C
         a2OzxQDMeLt0Rjc4BxnTzoR/LSrw4ErDUUdG9qTL/UtB3qUhAw8g67cILsk8XIr5jASR
         /M5xNXoNsqZWrU2Uq6848pK+EMosyQvOrxVmaqbI+GQiVOlLf2JLEYA4EqDb96B2XnfM
         6EOA==
X-Gm-Message-State: AOAM530y4MwyYilwbnheVDjCliVQ0ImlUxfoMwwCxjhOrmDfPnRK2cmA
        BoAPRKtli9Pfl0Hio5dPKSFW/exTzEM=
X-Google-Smtp-Source: ABdhPJzG8jn6UBCbDkjjPEBOEJt5RXaNfdi1BW/e7WXb1fEaSDZUwdw5fkRZgjsCBjaSWyZc89LJtg==
X-Received: by 2002:a62:8f45:: with SMTP id n66mr18959904pfd.236.1591132816643;
        Tue, 02 Jun 2020 14:20:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k92sm3319300pjh.2.2020.06.02.14.20.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 14:20:15 -0700 (PDT)
Message-ID: <5ed6c28f.1c69fb81.5c91b.1244@mx.google.com>
Date:   Tue, 02 Jun 2020 14:20:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.15-175-g4ceaad0d95e7
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.6.y boot: 93 boots: 2 failed,
 83 passed with 2 offline, 5 untried/unknown,
 1 conflict (v5.6.15-175-g4ceaad0d95e7)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.15-1=
75-g4ceaad0d95e7/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 93 boots: 2 failed, 83 passed with 2 offline, 5=
 untried/unknown, 1 conflict (v5.6.15-175-g4ceaad0d95e7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.15-175-g4ceaad0d95e7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.15-175-g4ceaad0d95e7/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.15-175-g4ceaad0d95e7
Git Commit: 4ceaad0d95e7a56ea839541b0e825af93e4817d9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 16 SoC families, 16 builds out of 161

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v5.6.15-178-gc72fcbc7d2=
24)

Boot Failures Detected:

arm:
    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
