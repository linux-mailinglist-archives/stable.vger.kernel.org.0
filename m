Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250A61E376C
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 06:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgE0Egj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 00:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE0Egj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 00:36:39 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18635C061A0F
        for <stable@vger.kernel.org>; Tue, 26 May 2020 21:36:39 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l73so713414pjb.1
        for <stable@vger.kernel.org>; Tue, 26 May 2020 21:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3IcUM6l8+5yCQn1az4Su+dCn9uvuvzMP1EjZOM/taEQ=;
        b=m9+pp1TPNZwSrLit2/4nuMtNbexSQUhmDTHGF81X7A0d3tX300ZUnU0VotVjvWGFIc
         75QfNUu5hbszOH7k3Lm2JmZhuJaWZfsWcb+NbTO2q8FnbJS6LZ5CiF32Z2BQiS4bBIIj
         KtEwuxzruzjyH+cLw2/zgGI3A7cTnaAvHHd+19szVhsplR/HJeHrVYW3lIMZq7sCd9c0
         fqmUZikuospL1TvwRx24WMVHhy+yUKH6gI6SgPH5PZhWQ6iBq4OkNtaUMGiPDOKcFQkB
         Rg1f02QUX8BW3v5khQSlQ8qJfmumxbFX7Mw2IFOE6fikSrVpvClBreEeJ40q5qC+WV+p
         nEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3IcUM6l8+5yCQn1az4Su+dCn9uvuvzMP1EjZOM/taEQ=;
        b=Sl//xV5v4wvZAQUud7NGJtvzM6Y8IU5xAZETjzJEfoJV3kCiRhX9ma6FChB2VNdAE4
         jW157Il2O9sL4M1TagRu5bTugtv1xw9ip9coRma7cFN3n2XYnEfMvX9dZmiqQGZDsBod
         umwtLONAF4Xf9Tbsor7fEkwYWxxfNY6mCuwa3+A7sC4fqkbvv/NZAVcAQceM3hpmZDeA
         +7pUcYFTx6DRn8gRLpi+5SAEnUagctjG9Puu/M8MK55BbmZ6ERfgJf/doiNpCEW8mIzV
         V/XQp+d07rwQDpW3td2V22cx+ZFE4CwPV24/P7HkSLRV+qOPYzJErRVyZlkpB1Ar7Gr3
         fuZQ==
X-Gm-Message-State: AOAM532A5qf9q3ni6lKX+1F5ovtb1dyhB0wjRNn5D5OdXL8hIU1fCoKD
        k21yJbpvyEBFWfCwU8F2xHZmTkk/S7c=
X-Google-Smtp-Source: ABdhPJxblc5NEQd2Yyq0rSduhBrBCA9v3OhWM6i1HGn/DA5DdS8p/rJBjQXozsxeW9nlGy2ZW4eCxg==
X-Received: by 2002:a17:902:d3d4:: with SMTP id w20mr4225035plb.3.1590554198204;
        Tue, 26 May 2020 21:36:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b137sm870387pfb.110.2020.05.26.21.36.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:36:37 -0700 (PDT)
Message-ID: <5ecdee55.1c69fb81.b42f0.6a23@mx.google.com>
Date:   Tue, 26 May 2020 21:36:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.181-60-gce8b534d70e2
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 91 boots: 4 failed,
 81 passed with 5 offline, 1 untried/unknown (v4.14.181-60-gce8b534d70e2)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
1-60-gce8b534d70e2/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 91 boots: 4 failed, 81 passed with 5 offline, =
1 untried/unknown (v4.14.181-60-gce8b534d70e2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.181-60-gce8b534d70e2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.181-60-gce8b534d70e2/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.181-60-gce8b534d70e2
Git Commit: ce8b534d70e21cb589da3731a1f61fabda583756
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 18 SoC families, 13 builds out of 165

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 13 days (last pass: v4.14=
.180 - first fail: v4.14.180-37-gad4fc99d1989)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 96 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.14.181-59-g2c9e54b6a=
d6a)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.14.181-59-g2c9e54b6a=
d6a)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

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
