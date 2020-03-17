Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7B418894C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCQPkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 11:40:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38450 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgCQPkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 11:40:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id z5so12165699pfn.5
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 08:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VInE4Bb09FVIHPAK1WuQNF/5fOVt+QwLzeNgiP1ZNno=;
        b=0GWQlmeixmHHBQMl5chaK64OnT4esQYj8Kyy+QQrU3+lexqT1Pv8yHapSKmINzVG+N
         TSm/XGvplVI0nRw6m0V8jwQxFYAjCKOuhqXllGDBsU69bMgbv7fAiLS+9pkJq9+7UBzv
         Ce4vOslNS3yUL6PTtyw6N9HnyRsfCQkOxAHGGuBMAn+x2eAe0MLLh8U8Fx+5TRIj/96d
         Je4LNd4YN+c18nwLGyVsR9hlzQftsEzq2g3jnl+v+tNKL7mHyJhyGqt8wVZP+xVvrGz4
         +HbRR3vE0nLFMcXUy+a3tJ7Vg1YQkIyph4wWanNPbLJ3aExipPzv7uzu/aR0SV/8jNzw
         WjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VInE4Bb09FVIHPAK1WuQNF/5fOVt+QwLzeNgiP1ZNno=;
        b=pRq4FCwJzWVZIvj6WY6UwlFgbyB6hQE25o29k5OVGFC54ydRY9+86TJnNQzHBDwUTw
         M13Shvxl98fGr+oBoBNWUN7UyJlkO5VGKJaqWepiTEpzKACI7xyiEWmugfHNvgIyNV5S
         SYKrusERJgRWBjYtEbQ8dYxpw0WaTpbBBDqe9XNWSatMXVrUM0t0N3BwJYUQWmiVBAvy
         6eY3RqUOFilGQu0TU67f++ADDXaqNRSiZKZkpXAJ2+Wb0Z0G4d1wxBewNgrSq+qYPOWV
         jblscXog/b9zzTWSIhg9l3zU0LXOGe3Ix8hbx7HDg0PRQecWuQv1k/HpexrGAjkgYWAr
         KgAA==
X-Gm-Message-State: ANhLgQ3RREsg3u91XEf0hNisPi3rcl0+1Rk6R6+0ZN1vb50yDlsqx1Ly
        TjBuEgTvA+3u7lGaW4hy15sz8gjRyW8=
X-Google-Smtp-Source: ADFU+vvuIcsX2hYJr+VfbSDzXacUSpCJZ4jjmGv8P94JxpBiDPcQFyr9ZYa5GXd6l8gDyLxSyhVABw==
X-Received: by 2002:aa7:8745:: with SMTP id g5mr5556741pfo.306.1584459610320;
        Tue, 17 Mar 2020 08:40:10 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm3597029pfz.91.2020.03.17.08.40.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 08:40:09 -0700 (PDT)
Message-ID: <5e70ef59.1c69fb81.1a702.cfee@mx.google.com>
Date:   Tue, 17 Mar 2020 08:40:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-38-g4173a298f52f
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 84 passed with 4 offline, 5 untried/unknown (v4.4.216-38-g4173a298f52f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 84 passed with 4 offline, 5=
 untried/unknown (v4.4.216-38-g4173a298f52f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-38-g4173a298f52f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-38-g4173a298f52f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-38-g4173a298f52f
Git Commit: 4173a298f52fab4a3487a42d1fa378ccefc8cbf0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 38 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.216-38-gde8c7dfeb8=
4e)

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
