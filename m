Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975CF191A56
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 20:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgCXTuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 15:50:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40320 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCXTue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 15:50:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id l184so9852627pfl.7
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 12:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mjaIfGzoqDijTRFNDLQJQTSCwYwEtvgN4s0ThjEcWE4=;
        b=XrOrhWkRAkWAbeu9QRs5O8/OMyOHlXZwamvJ7mF0FPJEMh05gjKt5BO2fzX4vJAT7O
         6XoyYJSk+5S2xh2rVvdv032NCpFm0IUdf4klUgJ34B2eaknML+5q0JxPZIhEgUOFFMZD
         VNuzAAhdJdE6nh4k6Ux/gOH3y/Z8OuGv/tAwMUE45dZhaHq881Hpz289BSVW2qAnwQIj
         a+jab1tnfSQNrbr6xJlGvUNlDGyzxsjYbptYpch6AOrXFI9x2vSSWIiW0hxjS3TUdBjA
         n+UHM9A8Pd/SDI3mzAoMTVDXWjkryZI9xcaokQP5zVvH8HtJdrcB0CbTdaRJS0IeOTYe
         POFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mjaIfGzoqDijTRFNDLQJQTSCwYwEtvgN4s0ThjEcWE4=;
        b=UEMUH1Tolo12Kp3Euv3KS8wJFCn2OZoXWZ3NW0AclYTDcluexECVRmE2cL6Lvb5fgn
         RTS2w5Gr3vBJi5jpIb4e08iNs5XL/BI1rrM6JoDIq2xB5jLFevZm99OsejmAE1gCho3O
         5Mn/jcq4p2Kc08qRxp6CeISHVkzt+lE+UPHse3ShObTmPPfNLkSi42E1edkT/Nz2oUei
         wuPQlwbJMBb3kST8cQtbBW0iVPioWyXLlLN0QhhB/TERPvtnYFfiI29Y2RvIEr9iCqKI
         iJV471IHiCoiErVbw/Qze2Z5LnZFr7XQgvIThwXlio1ijxpOEHPCmYQjVAfBwFTa9mT6
         wFGg==
X-Gm-Message-State: ANhLgQ0ZLHwudS/Qr5FKpJ/HuhwCHscLYBawoxPrIqWpkovPDH4joJHQ
        9QxZTv1XgwRTXGG4V4GdxkGAZpXcihw=
X-Google-Smtp-Source: ADFU+vscAp/S5NYh3pmYqf1drpdGy/D50lOtIxPW5ryARq57Uz+6+dXwxqwUTyt/D2nL2ah+OkzogQ==
X-Received: by 2002:a65:4d48:: with SMTP id j8mr21641969pgt.144.1585079432043;
        Tue, 24 Mar 2020 12:50:32 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m28sm3944224pgn.7.2020.03.24.12.50.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 12:50:30 -0700 (PDT)
Message-ID: <5e7a6486.1c69fb81.9ef53.f9a4@mx.google.com>
Date:   Tue, 24 Mar 2020 12:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-127-g955137020949
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 95 boots: 2 failed,
 85 passed with 4 offline, 4 untried/unknown (v4.4.216-127-g955137020949)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 2 failed, 85 passed with 4 offline, 4=
 untried/unknown (v4.4.216-127-g955137020949)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-127-g955137020949/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-127-g955137020949/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-127-g955137020949
Git Commit: 9551370209495433397e2cace91fae9cb8e798d1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-123-ga=
b9a373d5af1)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 45 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-123-ga=
b9a373d5af1)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
