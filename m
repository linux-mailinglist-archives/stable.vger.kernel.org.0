Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDF1E11F9
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404076AbgEYPmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404002AbgEYPmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:42:47 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115C1C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:42:47 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 23so8949811pfy.8
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hzEFY387OfpumVkRD4NehcA8w/3o+vXVgYtzr+VKInc=;
        b=tXa7/MX3DL5ecTm305HvZnvW6dafc6+RxrTJaBh9miTsqbUG56oB1cNP388IRWovat
         5ZVAnptOt8rQKIm7jI/liM0ZZfzWVr31V18x1lpOVmKPXsLYxjKhwJsJjB5DMUHWvQGc
         r5JkU+fTpUN0pqPz3yqnOzgbP/aaerGNSyFliw0Ek86v6WYuF6bbCXF8gMrPkedrl6+e
         K9BGOgrBveEdp4SzAkqZwHCp2kwYVOVceU1ga+4yv7qF1Ca1xcoJ/qPOXsDHjIGd6TcN
         hyHVdpRCgqoXDOdXNki4pEr2TNok2WTVEVMcpWdmTGrOqm61Nr6qc+3t16M24f442160
         0bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hzEFY387OfpumVkRD4NehcA8w/3o+vXVgYtzr+VKInc=;
        b=n7Sx8iAOE1YCGRyJe2/Z5Dcvs2oOFnROW0GVj5oVeYFE3EjsWIWAlWkdgD7HOZtHNB
         SUr+o+fwkMKeV94IWL/Y49187CssAbp/259657eVwOLW1k66r+lcmd9nxazHXfzvkoPW
         fyhu2GTxeTv91yfGZigXdRI7YgYiMobHwzMMUVxlb24ngHosNknXbi6XgSkLiJ11IYVJ
         Tu9p8HEG59rpT5u4/N8D8l1MuS5CMjvygefdETbuOuhT1nZishbDQmIH0dTZDcC2dZIA
         Fzf0ZoQltKJuJJdOy3xEVscG7/auqsuHdNiEmsgZuTa87X27DXw/Ye5GWhlZPRAdjGg/
         D8pA==
X-Gm-Message-State: AOAM530VdV2YE4p21xEMlY30ZywvuTCx9ARk6GFmNTCgbSatd8Bkb272
        Zgg5NzkspiUO2bjOiDkjDRvd5pc3bI8=
X-Google-Smtp-Source: ABdhPJxVduq+yaqcNXiJVQ/PfOrm2ZLicAslnAKW/x9ZgC1GI4kx/YZ93jqhjQq5TqT2bX/KeXYluQ==
X-Received: by 2002:a63:a55c:: with SMTP id r28mr26576706pgu.108.1590421366314;
        Mon, 25 May 2020 08:42:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l67sm2702254pfl.81.2020.05.25.08.42.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:42:45 -0700 (PDT)
Message-ID: <5ecbe775.1c69fb81.4c484.039f@mx.google.com>
Date:   Mon, 25 May 2020 08:42:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.124
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 1 failed,
 117 passed with 7 offline, 4 untried/unknown (v4.19.124)
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
4/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 129 boots: 1 failed, 117 passed with 7 offline=
, 4 untried/unknown (v4.19.124)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.124/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.124/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.124
Git Commit: 1bab61d3e8cd96f2badf515dcb06e4e1029bc017
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 23 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.123-81-gf=
f1170bc0ae9)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.123-81-gf=
f1170bc0ae9)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 12 days (last pass: v4.19=
.122 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 73 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.123-81-gff1170bc0=
ae9)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.123-81-gff1170bc=
0ae9)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.19.123-81-gff1170bc0=
ae9)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

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

---
For more info write to <info@kernelci.org>
