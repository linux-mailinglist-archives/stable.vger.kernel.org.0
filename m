Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538C71B86E1
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 15:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDYN6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 09:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYN57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 09:57:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5E2C09B04B
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 06:57:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e6so5089483pjt.4
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 06:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vzDgnjhVgoQRUIps73FuB92bNJ5nZe6Zdc6xiMsGo1k=;
        b=Bis1EvwIeac0EBHNDMAMRnsL9801smMZgeUoRNUSq4v32TSDhMvFJ06NzpOMSOotZl
         0Tl5baA7Ejgfv5laYxyD/okFnPb2Q7GBieTi5juO4Ct9J21mP7mszcGxVO7h+xYA897k
         oOBwQCdUDeCZAcZcJLBkLTN4+CqD+8nMyQd4e3QHVOKYBaswAdwl6vOcdnSZDQ5MkWCD
         mEey3GuZFULWgaIcTlYG65PqdmWfIFaW1gwgbFHa4pV2mYwAazlxbHbLSfgs0nOL08JA
         DGamXCiHxtZ7OtW/jZNjZdooFm/274qUd5kHpMKhZYs0LNifBUp9ZEoyRDGNsfEysTbE
         cBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vzDgnjhVgoQRUIps73FuB92bNJ5nZe6Zdc6xiMsGo1k=;
        b=i0JdDV8oRKeAZa81Sf/JKASjDAxRt+Istl2qdFSlRzSIh2Sr8AvlrJ4QXZoE5sQEnx
         2locsZ/s/afeQSq352LoEP9+BsLoEEgfq38EKRVV7EbLiqJgFwDD16DDzJhrgWKtOcTL
         5FcfzR6ggRSNxpz6a8EI1vCdEWyZDFMv5MW32LpenRx0qpvWhOLWm+ARqtItKu2ZWQYX
         a9LxBLf5937+V7vwKFC1K7Nkic16kKXLoSJNBJbneitJpiWDRWQntI5FNh9sPzONxZq7
         u0aGyW9p9jpDoQtSugtvZslOnV6bb46Tez/FJxLvpv3HfQ3ALPMlzoy/EBX965+9lBnw
         Q5tQ==
X-Gm-Message-State: AGi0PuZmPFa+qqedjWn0B5DnZxxRYrAhd+gzsJQkmRNBT/uN0SxbiEiJ
        iSFPL52nZtqRLuJmNV5ntASwIDXolMU=
X-Google-Smtp-Source: APiQypLo/TtpgytpNuBCVWfy3TlYAWMGltLZHUKrH+64l4SvecXnc3Abw0xMmzN29XLhl6dmrzKV0w==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr15273701pls.194.1587823078601;
        Sat, 25 Apr 2020 06:57:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y186sm7202760pgb.69.2020.04.25.06.57.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 06:57:57 -0700 (PDT)
Message-ID: <5ea441e5.1c69fb81.78469.6691@mx.google.com>
Date:   Sat, 25 Apr 2020 06:57:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.220
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 103 passed with 5 offline, 6 untried/unknown (v4.9.220)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 103 passed with 5 offline,=
 6 untried/unknown (v4.9.220)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.220/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.220/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.220
Git Commit: 0661b3d6cfd774e28a2e2ba90a3d87479e5c399b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-125-g0=
1b8cf611034)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-125-g0=
1b8cf611034)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.219-84-gd7b7a33b06=
09)

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
