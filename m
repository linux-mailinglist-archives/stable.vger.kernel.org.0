Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5093412730F
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 02:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLTByo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 20:54:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38972 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLTByo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 20:54:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so7869813wrt.6
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 17:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bSlB1HtH3yXfivTokddyXbGFcxd7exyD04wMu8+2Pck=;
        b=CrltI+w7pQfIvRlWy/oneWrEPmHfMZUMMUVu4OFPlzM7u2GOYJeAvy/MB4BT6cnSsr
         m8BvCk8sEPGdI+gYfR5ZcZ7MdmrlKYO9RBeytCpDuwVtSZKxL9I/IHXu9p+xRTzRKQKf
         Gm7rbtIXK3b6/5nfYwSWv8mMHhTXMq8O/d2kA35et6x+vA7tIL1w+K262HVl3zFEH31Q
         VxRiV4O0k0pMkAggCWW08eSj5jXwkhnpSJWEgXR0oNCT+QuJO3al8RycJz1BfLf3DCb3
         gAKL47/LsZPJoDxB8YVgogFcd8P3U6Fm4V8sEtQVE6vANIcYLMxgeQQBYeO3xP1LZp3V
         2cfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bSlB1HtH3yXfivTokddyXbGFcxd7exyD04wMu8+2Pck=;
        b=cmwi4WYqW+fOmGOuYAp36ZkSFfYaF2m8/e725WM484Yl5kiu+ma0V5kt/7Ftkakc0x
         2pBg4gwZDiOblwHt3lJ9C8e42I4uOpcOfz7y3hZSnVjZUlmm9ELqX7YWaaVtdk94vcn3
         Mp3ZT+R7j7WTHXgU1Ec0WWr4VYSaiqRLSNz1ULeskQef2S4LV8gbvJXjp3xXbaik2Ff+
         l1h9GRHpvb/vQF6AQJkf1WSJU2U/DnqlPQtDKMIaLQfvSN3RWfA1HtXN+6wsRoDsB0tp
         py5v/PmwxCh94L1G1HnHv2I1K0PrFhLreKdhv1dhNe/RWvcxaBcnmlPR3EDah/uJKwae
         tIWg==
X-Gm-Message-State: APjAAAVDQJQT1l4685MyMNxhGimzaI7bDxx4nTtwzeuFnCf1SVDWtCyW
        9P0rrlmIh6bOF1TCunzGbnEmaOn4sP0YYg==
X-Google-Smtp-Source: APXvYqzDZ5aPVs/TxgC2qSaLQ/Hrffrqm8Pn5NFoe4o6cPocX/2zjZ7/SUC1AX1pnsQkj6YuYCDl4g==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr12672188wrx.178.1576806881760;
        Thu, 19 Dec 2019 17:54:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x7sm8219948wrq.41.2019.12.19.17.54.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 17:54:40 -0800 (PST)
Message-ID: <5dfc29e0.1c69fb81.247bc.9e50@mx.google.com>
Date:   Thu, 19 Dec 2019 17:54:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.90-48-g631e9861976d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 122 boots: 2 failed,
 113 passed with 5 offline, 2 untried/unknown (v4.19.90-48-g631e9861976d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 2 failed, 113 passed with 5 offline=
, 2 untried/unknown (v4.19.90-48-g631e9861976d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.90-48-g631e9861976d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.90-48-g631e9861976d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.90-48-g631e9861976d
Git Commit: 631e9861976dab68c01c22dcd7d1a07ea91d4462
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 22 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.90-48-gb3=
300fab1bdd)

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.19.90-48-gb3300fab1bdd)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
