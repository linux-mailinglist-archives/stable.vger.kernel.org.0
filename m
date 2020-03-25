Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80308191FA8
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 04:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCYDVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 23:21:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45594 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYDVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 23:21:25 -0400
Received: by mail-pl1-f196.google.com with SMTP id b9so251757pls.12
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 20:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7tZ6//gCFKaGgmQjwwY1C5tTuOpkZCtGYkq2IqI2FKo=;
        b=TJuCdQFKyf+hI+mUcta3DvoPFbMdP8YBnIHFqF6ULNogiO2rJXq9xel1o834apZGry
         mWP8S4FTAPbs4tWgJWLZyV5m7z1sEeLbwadUX3M7xQNisogB4sKBapIB+jFAUAX/o72o
         IsEATDFheGiU16Ms7GfOPtDQ8sWnK5r51uHU68Nj+T1SVukajbYu1GnDfpjqI7MO7jEt
         wElkVeAS5ItnbqgbTMnEUENON1KEHbzeFH7dozEFaWS4Jv1PGrFymHf/fy/71mOyL/uH
         XUSkON9P+eGewaPsqWONnyMiFQW+YtEktlIzL3cQ4Wn/oSKu0CkMSW2OPUZzlYPeKEho
         gDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7tZ6//gCFKaGgmQjwwY1C5tTuOpkZCtGYkq2IqI2FKo=;
        b=RIpbzPyGXefUuhM7rTQE8wT7SxW8PkXR0tM9wYnsResoeL9eejMz3b29FxfTakaxef
         eXPH1XMO2y7YZjO2hfhg9Z2WSr5ivytcaMD4CpkHqhBlQNq7lp9v4+TIOsHOvvaHwwUG
         blh69Iiu8dloL1oi1O8J9NnTY6xTK4GcrglBlDJvJNUcK2pIkP6dqbmMkJrgOopwLkgL
         rUFyjyGdrsC1BCrAftCrHu75m96EaXQDizhjzIWw65HTgTfuW2hDxRhDombf+nITIfRU
         TCL6+xVUZVkQm3UY8Mxkk9/wu8o4eskl/a4xEHhSPTv+MlVkCfIxEcnwTUo5mi5jl3m/
         dYfw==
X-Gm-Message-State: ANhLgQ2tP+E11HuBC+1gCotu2W9Wvn2Pl3fyKTMidXFzRrVGpIcTabs3
        pPpRJSPF9owXdgiZwJrS97Yc382/CeI=
X-Google-Smtp-Source: ADFU+vsxRQAtJ7jMymPmhjzSebCUQYKPrd4rCsVvHcvtguDA3k1p1pPNaDm8oqyV48ga4yAOxQz9+Q==
X-Received: by 2002:a17:90b:430f:: with SMTP id ih15mr1250903pjb.56.1585106483772;
        Tue, 24 Mar 2020 20:21:23 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c1sm3480956pje.24.2020.03.24.20.21.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 20:21:22 -0700 (PDT)
Message-ID: <5e7ace32.1c69fb81.682fb.f2dc@mx.google.com>
Date:   Tue, 24 Mar 2020 20:21:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216-128-geb874cb221b9
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 111 boots: 1 failed,
 100 passed with 4 offline, 6 untried/unknown (v4.9.216-128-geb874cb221b9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 1 failed, 100 passed with 4 offline,=
 6 untried/unknown (v4.9.216-128-geb874cb221b9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216-128-geb874cb221b9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216-128-geb874cb221b9/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216-128-geb874cb221b9
Git Commit: eb874cb221b92fb416c4ac5ec93bc929027d677f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-122-g1=
fabd1dda010)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.9.216-122-g1fabd1dda=
010)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 45 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-122-g1=
fabd1dda010)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.216-122-g1fabd1dd=
a010)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
