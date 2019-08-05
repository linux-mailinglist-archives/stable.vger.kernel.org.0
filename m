Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADEA8240E
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfHERfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:35:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55098 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbfHERfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 13:35:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so75518777wme.4
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 10:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=RzHMiOnu0E/vzeqnz6OQSYCDgnQPYk0slkQPna4Gc9I=;
        b=dcRXeC4P4bg4MZ6xn2ewYUn+G+pK61xfRimdyccb7cXr+icAUCd9xS7C8atFXiS95z
         WDfqMRFa3tmEqPSjGSK5mya4DRHH3k6n0cU88P9TNKqC4JKBaFW3s2h5/tVrxMOhWRZJ
         hlx3/nwHqJUqOk4rGtz+plboLvnKMvSyckbCf0+W5D/pIxTIe/5XM0yVdVuOQDYlmcLV
         2jjzO9XzmQnmS6DNkfl6+OkxhfBrOwkkPII+vlsG6VxuESvPYEfsHRgHcCMzG2IkTWpX
         GsKIs17AMkJvicDFs8WBB6yxq0bcXKW4I2XIc5GKldjuujm1dxPvJybJ2uWkkdHbsLSs
         kdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=RzHMiOnu0E/vzeqnz6OQSYCDgnQPYk0slkQPna4Gc9I=;
        b=ExLJyVyWS0SHQMi2WRWpaM9vn6Lq0V1blK3oQZ+mBbK9lTauYNvYnVqDoQiWoKv5RE
         5olEHACvszQ9+AqVQsF2gP3T8dXD1hLWyF08hraaX4JOHgu1jGKL2ekLZzkmclP9AKaT
         IShJFW7BZdBwyr93FgDI4MkvartHiUwfa9utFx3/q0fT/wejKUTWU08LjAHZp5XjE4Zj
         tKZLZXuACNMYo1jah0zWyoN3nMnGXrkaP2W3GLOloSAvbRPcl1F1P+ipn+IeTxsTRI44
         SMkns1VqIuRo/xQ4U5019aZs3nwacOoVdI30xrOgkLViAKkRaKsLvKvPHlVesLltk8vl
         jMAw==
X-Gm-Message-State: APjAAAVqC7uSWdGTXZRyypiYiKnF5nm60PlpooAYhchd42Xn3f+v8bdY
        vVRneMpw8rYkVo41a1N51BRypw==
X-Google-Smtp-Source: APXvYqzX8VV4h2PU6dSAOR8cpdLWYsk0rioH6pr8LO8E1BgH4ZY4/Oh0bFQbJYHxOX/ftnExuhdDjA==
X-Received: by 2002:a1c:d107:: with SMTP id i7mr20798548wmg.92.1565026519241;
        Mon, 05 Aug 2019 10:35:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k124sm146235069wmk.47.2019.08.05.10.35.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:35:18 -0700 (PDT)
Message-ID: <5d4868d6.1c69fb81.9f97b.d309@mx.google.com>
Date:   Mon, 05 Aug 2019 10:35:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.187-43-g78dd396df223
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
References: <20190805124924.788666484@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 101 boots: 0 failed, 60 passed with 41 offline =
(v4.9.187-43-g78dd396df223)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.187-43-g78dd396df223/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.187-43-g78dd396df223/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.187-43-g78dd396df223
Git Commit: 78dd396df223345521dd977f3974e6418c078296
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
6-224-g5380ded2525d - first fail: v4.9.187)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
6-224-g5380ded2525d - first fail: v4.9.187)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
6-224-g5380ded2525d - first fail: v4.9.187)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            bcm72521-bcm97252sffe: 1 offline lab
            bcm7445-bcm97445c: 1 offline lab
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
