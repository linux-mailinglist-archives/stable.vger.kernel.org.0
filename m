Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4D1C774F
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgEFRAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 13:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727984AbgEFRAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 13:00:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012ADC061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 10:00:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x2so1301553pfx.7
        for <stable@vger.kernel.org>; Wed, 06 May 2020 10:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M01nXDsb36LbBKmmN5J7/lkSHJecjz8/EA5wbHrXKcA=;
        b=GIIPiXGkmKTrS9PrtCidqjDNB6WNLCvAvLYo9XJo4I7HqjCoAjxXYaHNjGgQJAmuzC
         sPCH3JQX37UxDC5MwT5DWgO1btGZxm3ThuuZzkXbJBYMEVq4aS41I/4UufCI67YxBuUQ
         AuKjWbRxbXE7Qay6HK1YhdzwHX+i6zPuU7h6vKzKu2AQghlKEIu76C+nzPM5mC3HaKPv
         0CT0BPGqcck8QBMobXTKfM2vhddLxaAxtAq2sWqEHlRqlw16/yV6bvAGSUJs2YPoTVRA
         iFXSf+nnSZLBpaf7/s061fdsy8MEtEcD8I9sybH/0FrCkRvr4xxLgwzc0U1dQrxqjcQ2
         sMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M01nXDsb36LbBKmmN5J7/lkSHJecjz8/EA5wbHrXKcA=;
        b=fFb8hrsABLXZdqlg/DquvyvGKy5DhU8bevccWpjDPEnTod61yspnTU4rUSkQh3avsC
         tJm/QvYHQTK4D72eWpm2Mw2sAfWLPjKPlBaW+iZbyLzorMhyCLmopOgljxp35KKTjyEn
         F0Mr+va4F8xyEb+4kXrT8ij4LpuGq+otd1M4U6Um8LPyn6HwH0vIciXaAMmQTiGNhL0N
         jg1p4Ol8xgp6EBv50EQiyeVx1bOAdjgNl0voHuMm8fl9NMUlA56LIrg+3n2eU6DofJJQ
         +65BH0so0DALMtBzcgzpLCogrJrRyizQj2SamRg9k9A2fjdAIG1PQJjhB6xjEQztvhAt
         j7zw==
X-Gm-Message-State: AGi0PuazqrsHLI7QVtAOf7r4IW/d213PhFeA62iL84a1AABKRg+7VBqJ
        zwo0vogf5oIteOAEkV9WDTorl+kJetbpgQ==
X-Google-Smtp-Source: APiQypLeCpWd0uIqas3FGLWGmALIUg9TzHUuLPSH+WMXNxo/wCNI+r6v+encrcF7VE1Qb2lVFP8R4Q==
X-Received: by 2002:a63:742:: with SMTP id 63mr7899927pgh.33.1588784419127;
        Wed, 06 May 2020 10:00:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f76sm2278760pfa.167.2020.05.06.10.00.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 10:00:18 -0700 (PDT)
Message-ID: <5eb2ed22.1c69fb81.41bc0.70ca@mx.google.com>
Date:   Wed, 06 May 2020 10:00:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.222
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 74 boots: 3 failed,
 65 passed with 4 offline, 2 untried/unknown (v4.4.222)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 74 boots: 3 failed, 65 passed with 4 offline, 2=
 untried/unknown (v4.4.222)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.222/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.222/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.222
Git Commit: b63f449e18b130fdc372b9717e72c19b83fc4876
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 88 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 41 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
