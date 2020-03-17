Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528BB188D82
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgCQS5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 14:57:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34577 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQS5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 14:57:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so12230463pgn.1
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 11:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+ZVarU3pPx5vmdRMR9a6L56fiuXEuW6kWEmNePPg7kA=;
        b=Iy4+cbCh56wvpQ1C1+20fCij3D5j7quaJzNRYbn7ofpgCofLt6khu6vtUXMPBVg6ao
         mJ1Oq5EPlIdHoHfBJfPjW0VdPJ/nVLXRo93OXVHMakfzK7IybNCf89UiTmjlsac5OZIR
         C735KzSD8idro0MCKSrKiBuKja989nREypr2Qng+5eb4B+/vv9getjJWVt41gQO+nELJ
         eD0S3Vy70jVvuWthVFEMYJ5sgctHaCaptPnsMEFzGXeZDzqcCRnm6hqvXAMb2zMnkI/g
         B6Mf+V/IkETZfB+ox7zVHjDZ7O4ffdkPpqItmPN0OQClXTPHovVn5P67uNU5McAuVTBZ
         2GpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+ZVarU3pPx5vmdRMR9a6L56fiuXEuW6kWEmNePPg7kA=;
        b=CDzqz7c8dWm00t+jb2ZQkgBbx0xfdSDki+aDPQ4oVltJMGfYO8GOq0zz/z3X3S82CY
         BCJdCfLtP9DpVcudFlJ7sKFodI15ferZyyZzHeU0Ssn4xTjl25h3vWIH6/MWw2SnDtcP
         XHD1Tx8NRlL7zCpVamoY67kMd3Hju8cSlBLlZqYaydi1FmZ3hZGDKAAmb2fYS0onWt2b
         6270rL1WqLAafbMbyk4GUyJAsFYDsKsZZZsKEItTNNLLAZzEpkYh8X6lrS9Ifwt1ds43
         /Jh2mGVNFcQrDrdBJxfls1ZH67oDhUGplZMtin5geOT0DaMC7NtHVI0QUKtZ7TWBb78W
         qC7Q==
X-Gm-Message-State: ANhLgQ1h1UC5TXesLBZuruRdIfTGv5pocV5vmVYw8BjuvJtAk9CKiaem
        BYPMHokxUSz4s15myEjMUbWJkSV+DUs=
X-Google-Smtp-Source: ADFU+vsjYVtTIUioFiMYJPx4bF+ejGYh9O7svkNjWWqz44cXuwM13Trx/2b+2Wrd/4tTIuFjPsOl9Q==
X-Received: by 2002:a63:b21b:: with SMTP id x27mr654383pge.310.1584471450095;
        Tue, 17 Mar 2020 11:57:30 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11sm3739681pfa.149.2020.03.17.11.57.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 11:57:29 -0700 (PDT)
Message-ID: <5e711d99.1c69fb81.22a5e.ded6@mx.google.com>
Date:   Tue, 17 Mar 2020 11:57:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-124-gbd9158ff941e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 163 boots: 2 failed,
 150 passed with 4 offline, 7 untried/unknown (v5.4.25-124-gbd9158ff941e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 163 boots: 2 failed, 150 passed with 4 offline,=
 7 untried/unknown (v5.4.25-124-gbd9158ff941e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-124-gbd9158ff941e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-124-gbd9158ff941e/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-124-gbd9158ff941e
Git Commit: bd9158ff941e0efcea216f7311abc7fe13e8ae39
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 98 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v5.4.25-124-gf8af896ae6=
72)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.25-124-gf8af896ae6=
72)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 38 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 1 day (last pass: v5.4.25 - first=
 fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.25-124-gf8af896ae=
672)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
