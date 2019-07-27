Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46563775DF
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 04:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfG0CO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 22:14:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33230 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbfG0COZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 22:14:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so56258893wru.0
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 19:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=ywTssN1OaLJLOAgn1zE68C9sTfGOc1ktG4PsTxTsZPs=;
        b=lXzOfCi0u3mN4TS9wa2D0/nH0DPx6Aa2UxIhNZ3NClO6JbIOwsyj3VRqMnuM7SUu5S
         WL9gXwZy/xsr7GahuFrMqdn0u3Hk/rgB4syfWcboWhpoH508BmfTxOVSKgdi7U74fxsV
         8t9iUKgL6Z7yaR9r+e9pZkXU0SP3FZ87ZqZ3TElhxr8DBA/l+aH7k3MDnqrb2m7CcabI
         gIyThnFkIWelV/xXAQOSYRQjJuhw2st8wnpCSnRceaVDnkYf+9ubA9Com94k4E6OkP22
         hk32gUcBEd+OrlV5fIgXylLRLZOMp+/Al3aSZdSCAPM1/ZNlhjqLi0e0aebo1c8VFhio
         b6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=ywTssN1OaLJLOAgn1zE68C9sTfGOc1ktG4PsTxTsZPs=;
        b=YtFdvRLpkMb1+PAL1gLOny6iIFaj+XqBdCkG6V8SmfzH1Kx+2zZi8+KkAvqc5mLV1+
         oV+xFIzUN8AZ2HDUUaE4pOt451gj0B6iczKOLrBq9LphFl4f6N9/sK/ctZfUdJ6wu7tB
         s35+43T6xgFnhc+iMnGLMHy3UfpUa9Uh3lDnDgsdOIpkIUhkUsH1D6d08NBaoaTIvjT7
         hltZdtM/OcSe3NyTbeqACBqX4FAgokjd05cJVtWXm28e9A8AfS6oZysTTIn2hr1C5fRa
         hkHpvGBNi1khTrHGZaASzS/Oa+vO4T+1A08iqOLhDxq1aKY21HC9R54BYPxvEdOpQ5nB
         m7gQ==
X-Gm-Message-State: APjAAAW3p1BoXKtF6liKAK4Q6Pwu/baNpffSeOcPvQ3UxXdsXZbYGqul
        Q6P+DeEI5HSMTD/3c0qu6Tk=
X-Google-Smtp-Source: APXvYqxuN2FulUnMBRL2t02jka9myeFHxk+NWkBFgvJeEHhWXyKC4SjiPBIqRRej8shcyOfkGQhqyQ==
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr32743388wro.190.1564193663311;
        Fri, 26 Jul 2019 19:14:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i6sm47716070wrv.47.2019.07.26.19.14.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 19:14:22 -0700 (PDT)
Message-ID: <5d3bb37e.1c69fb81.18a4f.4a5c@mx.google.com>
Date:   Fri, 26 Jul 2019 19:14:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.61-51-g213a5f3ac1f5
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/50] 4.19.62-stable review
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

stable-rc/linux-4.19.y boot: 118 boots: 1 failed, 77 passed with 40 offline=
 (v4.19.61-51-g213a5f3ac1f5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.61-51-g213a5f3ac1f5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.61-51-g213a5f3ac1f5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.61-51-g213a5f3ac1f5
Git Commit: 213a5f3ac1f5e2af0e25fd4b26497590ec290be0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 27 SoC families, 17 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
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
