Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296E379EC5
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 04:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbfG3Cem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 22:34:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36606 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731340AbfG3Cem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 22:34:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so51074128wme.1
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 19:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=KXaoPbrQR8cOY5xonhHKs7ogV9g+KKiBGCtdfBnXIps=;
        b=xR1buKxFHC0Ubt/ueUgau0i3OVjchdiaRtL/HXgzdhTf3GxYPAuByUABbqIUdX9CHO
         WlxxxdvqpyPWTiTttbdGIHYR2dYcnnenzozkng6PJ2U6FIW7+ZZURcSyAVkM/6t8dFWf
         8PTTJ3yzVfNEgxhTtA4Mp/MF5Z4b1tZAfAuhtuETVUNcPAtBg7mYyvFlZ3+p8+UoKo0Y
         REt/MGwcGK2tc2mQM1FOYiROMEdfPQQVaFWlZ5T7b+pPmQZLSxCQoUf0dkO3yjveozJa
         QIGIRGQ66OLYTsblwdav/XiDj+vz2nj9R8T8sIsK4b/zNx7dr6tP/J6yS5jnoaIpzmNS
         j7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=KXaoPbrQR8cOY5xonhHKs7ogV9g+KKiBGCtdfBnXIps=;
        b=WD09uMtPhnMLVFLRgNuEPtQLFKrmkVk61qWv+gjIApfd7logVWqyxnK2S21r/SYfTq
         F7q6Nbywc512RJCOVc6mLFSOhahS39pipnhBp4mtF6avI/GJLWrUVu/+Bb5HodB1UpF8
         K1pU3kuswBh6Ffzg7TdyTDztNwQ7CWZFJD7xY33x2agVNGHKBD9rny1WKnUgVXvO1i9p
         Y8OnNeUkq+zpH84in592f5T2hBbuXHlNDylZz6iqpXxMEXcK84iZ3VD5OZAiZ6059Si0
         HOupzspyOqsh/Ds4wRXllOROP+KvOjXMt9sg1MF2yRr+MEObGr2XmbJpKvd+qs99uRdm
         uX4w==
X-Gm-Message-State: APjAAAV03mygy7ljFxcXb60oZ8ctiMyKjSs9nTDU7vkWOTY6Z4ViKwIy
        5Kewhqdxx3t0GtIx511ZeLI=
X-Google-Smtp-Source: APXvYqypftDUNx8st82aK4dw1bMbg4A99G1C5vmNK3sMd9EDAfkwgxv9Spu5UTrgFmr5v0FOmsvmSQ==
X-Received: by 2002:a7b:c4c1:: with SMTP id g1mr6832114wmk.14.1564454080143;
        Mon, 29 Jul 2019 19:34:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c1sm145051435wrh.1.2019.07.29.19.34.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 19:34:39 -0700 (PDT)
Message-ID: <5d3facbf.1c69fb81.f6d50.d89a@mx.google.com>
Date:   Mon, 29 Jul 2019 19:34:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-114-g0c75526c53c7
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/113] 4.19.63-stable review
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

stable-rc/linux-4.19.y boot: 111 boots: 1 failed, 70 passed with 40 offline=
 (v4.19.62-114-g0c75526c53c7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-114-g0c75526c53c7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-114-g0c75526c53c7/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-114-g0c75526c53c7
Git Commit: 0c75526c53c7c911b415119a86ace13c9d3e1724
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 26 SoC families, 17 builds out of 206

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
