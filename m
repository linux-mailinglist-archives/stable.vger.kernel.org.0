Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56CB1E0F9A
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403856AbgEYNf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403855AbgEYNf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 09:35:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DA3C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 06:35:55 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so8700825pgn.5
        for <stable@vger.kernel.org>; Mon, 25 May 2020 06:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=koi3goIslcHVnM5wiFZYUR6u05saUiVdLz+rMXL5wiY=;
        b=CUF4PuBi5nEFv1qKRMEWhbKTJBT03jIYDWJXEnf1h7+cf7oX0NxHN3olHSNIusnj+H
         xbZ2VGXEHj0Dg6gYvgLjEXOf+8ffae9ws4ODIC0zVPvwZCmM96pLvQxR+bCPz1fh0F+M
         G0rwhh3lDZk5DwQQlwLVhW1ekEXuAYW8IBKBAfpdbmd/8JuhDgeBbTffoTce9xjj/oSE
         d1vTHtR1n9S44JUPBzgBI/uhnGGZFFHfziVQjyldwi4CFAVplE71J9K7KkYkc2eAHUza
         CTnATdPa4utZLpJQU+Q2j6S1dfLxAfyJObkHECMaf1gu4ZqhuuBbyUDRFn/oulWxalfH
         uSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=koi3goIslcHVnM5wiFZYUR6u05saUiVdLz+rMXL5wiY=;
        b=RZHwGFCaxs1WZwyww1i6QpPk/vHI+Osi5ZcnocuJWOU8pDG37MO1nD8fMx3YSvwwUL
         5pf8L8BB+Tcslo3SuJkOfop0DnbZ/dB5R/aI3D3T9elZs7RbB2nUj/ojylaSnMncbJZT
         pVNUoPYseaYhe2AsW64zVCf2sv3WZvQfNd6dgSucInT58yDwn9dLcCjJTOvQPSv1pC0r
         bW/ZJAV+0gVtYXD1DGGSUzsS2/DGWFfqcEGuQ0gVmk+5qliGXCQMf2s8vrXZ5FEa9w6U
         5Uf5rirPfRLO13YkaqDJVMEy6cyZj1X7irq7jmRTaHymq1SUWTT1r3PcyOuK0oqH1VNB
         UuqA==
X-Gm-Message-State: AOAM5318yYTlHP8bwue3/IbK//9PEjp/JEP4vxwIi3jNOvgPdN4glfQ2
        6gg+5UaqcADoOxq5kp6otrtHriI+D7E=
X-Google-Smtp-Source: ABdhPJzxsU1SMAFLigvRS5NkH0Ga6TjhMhaQMlX6x+u+Gi+Tnw5rkk5EeNmeXfy4mff4nK751niLWg==
X-Received: by 2002:a63:3546:: with SMTP id c67mr25630032pga.379.1590413755145;
        Mon, 25 May 2020 06:35:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1sm11990738pgl.11.2020.05.25.06.35.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 06:35:54 -0700 (PDT)
Message-ID: <5ecbc9ba.1c69fb81.46ecb.cc71@mx.google.com>
Date:   Mon, 25 May 2020 06:35:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.224
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 97 boots: 1 failed,
 88 passed with 5 offline, 3 untried/unknown (v4.9.224)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.224/=
plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 97 boots: 1 failed, 88 passed with 5 offline, 3=
 untried/unknown (v4.9.224)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.224/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.224/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.224
Git Commit: e4ebe4fae299b559e683eb31a2dc950507842bf7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 19 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 12 days (last pass: v4.9.=
223 - first fail: v4.9.223-25-g6dfb25040a46)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.223-91-g7cb03e23d=
3f5)

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
