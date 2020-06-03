Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49B1EC79C
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 04:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgFCCt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 22:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgFCCt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 22:49:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76608C08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 19:49:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o6so736667pgh.2
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 19:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UZfXuo2yyBJrbaWSk79ISaU5xV/TuxdIQ9e2ZEp+3rY=;
        b=WVfshSLEhf8trokGhgonEhjIx0Lzpj9WedOlZNT5c31ttinIo4JhIOamsuReoYFma7
         M0rLDaj/wYkprtf1pNRamZNrVVbFEIlkW4/cV3MnLSkxR/2G9qolHsubcS+1DFbAArRA
         +cDW2LerP0KsF74SSb43B7EX5+AtaqcAWZKJJKs/DGBEWQZj6I1M8GmFxxqNoNab2rya
         qsjn9KUIQeSaTp2vw2wQilydIGg8HQuNS24m8rQlaHA/E+Cu6FO7+zYgsNQR9WIPQz9F
         RQwmJxNV0mXV78mhd0SIK/LBeTiGg9i2kaNGh6yKoVH5hDYtAWm2kEZ6EmTv5UgG5NKN
         NwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UZfXuo2yyBJrbaWSk79ISaU5xV/TuxdIQ9e2ZEp+3rY=;
        b=YQYz5NdGz4hI/nserh3L8z/DwTwRar4WZ3B6XYAJNbd672hdclntkn4ksj/yMLIdDp
         h3RY9+MR1sXsCPJlH9DL0f54GxEqxU8b1lxzzduXR1l0wa4QGxpAlMWh84m5jZjvyPxQ
         lSaCfSKhwXATPpj3vUuGe4NbqGPCsxSH7mVHLQpthRej+K87No5HRvl9Uuki6t1fdfwO
         4aVBiqExxnY+6+i2W0b4MKPhOquc+MjkgVGn1VU4g1QupcigASNniucU7tJmL1FepArT
         Zv9ubC++k/ipZyYACnV/itlyRVQ3TskGlvURrAqGouSO1FhWmOXg311Aqiu7hJIiz879
         Pwtw==
X-Gm-Message-State: AOAM530RgTW2FGUlmp0YwRED7Cdr9imeF2lZmccjnAdvmX4r7tJgQRtJ
        uD/4H/dxJ1OU8W8KCf2DmQlpgASYyaQ=
X-Google-Smtp-Source: ABdhPJy6JVNVlViW6NxqdPx6WMPoFXFuhFlGzhcurGupAcfu2bfwM24FghsyKBhT4K3IT3J1fJWFnA==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr2795555pjh.10.1591152565559;
        Tue, 02 Jun 2020 19:49:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm403802pjk.10.2020.06.02.19.49.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 19:49:24 -0700 (PDT)
Message-ID: <5ed70fb4.1c69fb81.2c55d.1fc9@mx.google.com>
Date:   Tue, 02 Jun 2020 19:49:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.225-56-ga836fd8c024d
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 86 boots: 2 failed,
 78 passed with 4 offline, 2 untried/unknown (v4.9.225-56-ga836fd8c024d)
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
56-ga836fd8c024d/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 86 boots: 2 failed, 78 passed with 4 offline, 2=
 untried/unknown (v4.9.225-56-ga836fd8c024d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.225-56-ga836fd8c024d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-56-ga836fd8c024d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-56-ga836fd8c024d
Git Commit: a836fd8c024d14989c7cbfb91040e805b093f1d7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 18 SoC families, 15 builds out of 157

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.9.225-60-g6915714f12=
d0)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

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

---
For more info write to <info@kernelci.org>
