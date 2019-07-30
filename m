Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DA979F8A
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 05:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfG3Dex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 23:34:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44103 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfG3Deu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 23:34:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so64026300wrf.11
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 20:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=3H8HzMsuloNzCatYKYD2aCuZ4wdUjxBb7w2vguXBYNI=;
        b=sJFSAdWaTTM8mnhej8+UbIZFyZd1Yuw2wR5qXpqXCgEwq8pi6eFX2uoWjew63Eaxs0
         SiqAS8M7Hiqk7+/RrmCILMzS8s3Q6AQ2Q38eIQWtk6bXZOgqDy6i7t+fqsrcPDvpaWu8
         blY8629kH3qiVlb4CE1QZHP1AvJ9P3tfPeidLUjRg3TYCspFNt3ivmeQNhytW6B45aZj
         oxYceDdQZew4Q2Zdj40tc1xepoiaT3TtPGO4rxIT2SuYtboTyqi46EE4JPTJe8tAkH8Q
         zU1ny9XCr9gytS40UE5N6X81n9/sBrNGLGZnaSZd/PPIYjytYCsXFa86famWo2S2SWr3
         XZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=3H8HzMsuloNzCatYKYD2aCuZ4wdUjxBb7w2vguXBYNI=;
        b=ceBXO29f6h6r4mpyqiWIyBfZWcakTbGSBext3UAEfq985C7+NROaeD7r2SphZMIjyz
         yXh/3g5tIEwkQnnyPdkE9isBcjUoQWlniNViQwgOFm4tBSob2K1Wxi27lG7d3PseYvFl
         fAXW1V5rIlKZ6i/4TqOJfoV4k2aU4+kgGaoJlGGh7w6495cph4jjlo1mI90YQqu1hNqz
         ShDNPm8GCmj0mXE2XTt2v8xyl5vIiN7aZtV13WcgkUrvqERQpmTWT+FCwj9+5TB5Lu5b
         t7iEJnoct2qnTXNpkqomYDFe+/h8ubg4bk067JWUysqF+DJQL16/75dQqPmgg/cVhsMp
         sTfg==
X-Gm-Message-State: APjAAAWvmG5HoRZVQYXuD0ipAcKkRR8/mtbjc4P99e5AxCp0AK0kraE3
        mmwXKH4CqZnDv6C4YYZm+OI=
X-Google-Smtp-Source: APXvYqwkFBwCAF6njBkjdYcr/wmNKupVcX30EILoQC/j7SuXfRrm3XoAxvKv75OkB0FVjpj2NjwgLg==
X-Received: by 2002:a5d:56cb:: with SMTP id m11mr1634121wrw.255.1564457688218;
        Mon, 29 Jul 2019 20:34:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p7sm39473699wrs.6.2019.07.29.20.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 20:34:47 -0700 (PDT)
Message-ID: <5d3fbad7.1c69fb81.d66f7.548d@mx.google.com>
Date:   Mon, 29 Jul 2019 20:34:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-294-gf6ba73a2e356
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
Subject: Re: [PATCH 4.14 000/293] 4.14.135-stable review
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

stable-rc/linux-4.14.y boot: 106 boots: 1 failed, 64 passed with 41 offline=
 (v4.14.134-294-gf6ba73a2e356)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-294-gf6ba73a2e356/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-294-gf6ba73a2e356/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-294-gf6ba73a2e356
Git Commit: f6ba73a2e356d3f40ed298dbf4097561f2cd9973
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 25 SoC families, 16 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab
            meson-gxl-s905d-p230: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            meson-gxl-s905x-p212: 1 offline lab
            meson-gxm-nexbox-a1: 1 offline lab
            rk3399-firefly: 1 offline lab
            sun50i-a64-pine64-plus: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

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
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
