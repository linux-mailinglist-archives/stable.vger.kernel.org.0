Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF000776A4
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 06:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfG0Eeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 00:34:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44792 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfG0Eeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 00:34:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so56300641wrf.11
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 21:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=/rCL5mzeUkeM+esQbDrZ/uK0LlKhDHPTally9O0PdPo=;
        b=MIwZu6HkbKMoR0xKaJpX9YrkRinY+iC2t6YMFDgESrtDT5Dd08fuXZDkboEB+8RJ9p
         U6+l9NIZPwyJClgafp5iLNBWMWAFbK3I0bpNYtyYMv/dywtCNcT3Dm1HLRi9v/a/nMx/
         twt62JJV+eM8/qqbrAyx0mHhr+WC4JEGIaVMKq3vkeswdCVjIf2SwOYEihtKRe9MwpAy
         j5YQhotLLI8T0Rz6b03boYJmy1khJvhM5ACx+Doa1MjrJ7F7Q8GiHxm0orUTEcMGnBoc
         HeEGk8A7dn8Cxqisz8iSYmZiZYuzRo5pZMtX4iHFSKiuKBtM3cBvXNurmFXZuIb0DeEp
         GXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=/rCL5mzeUkeM+esQbDrZ/uK0LlKhDHPTally9O0PdPo=;
        b=SlQOk4jjPNokW9mz8hKg6rCDt4OruzHYSYFi32fZzefgtrtyBf/0pQ0nElFWJV864j
         ZmdiCRTBSveG6uNDuMBaBrrFUNNtAOTWKUlO7PX2gYbPdiqZoIujlbPjMSivjUEZpFLY
         tSYxmv6GKQfydTZ4vqwO8vOg8q+3S4zdCG1BK9+fYvJuiXrzgvOovNn8Q2wuY6e0j6aq
         Mh8NeXKRBG8FL+OXTkhZETA9aMuZM/QoiE0uc1aruGync1drpNVavE0QaYm0GXfnP/ne
         xtLzHpmOeYZltaZRn8HSeXtgVvYnv9R9Ub13ckQFxvx52dMowHMlH+WhP2AZYzVqV1Q6
         Lx/A==
X-Gm-Message-State: APjAAAXldHMNmYgVvXNy0ybTfwSKGihf2K0VVeSxlxHQ7ej/p82rJm29
        kSIngS/I4hnwnV9X6JDniHs=
X-Google-Smtp-Source: APXvYqwA6Vjq76w63dQRjztvowWX9+oOyFlXtqd2BisuVQlaTXBbQZrlRLKAniKesJdukpZIC80MUA==
X-Received: by 2002:a5d:470e:: with SMTP id y14mr80412216wrq.308.1564202082047;
        Fri, 26 Jul 2019 21:34:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s15sm35394855wrw.21.2019.07.26.21.34.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 21:34:41 -0700 (PDT)
Message-ID: <5d3bd461.1c69fb81.33e47.079b@mx.google.com>
Date:   Fri, 26 Jul 2019 21:34:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.1.20-63-gf878628d8f1e
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
Subject: Re: [PATCH 5.1 00/62] 5.1.21-stable review
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

stable-rc/linux-5.1.y boot: 127 boots: 2 failed, 81 passed with 44 offline =
(v5.1.20-63-gf878628d8f1e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.20-63-gf878628d8f1e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.20-63-gf878628d8f1e/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.20-63-gf878628d8f1e
Git Commit: f878628d8f1efc883e9bd6f9f81173194b4a01dd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-x96-max: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
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
