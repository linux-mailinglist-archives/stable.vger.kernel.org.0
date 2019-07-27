Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFFE775DC
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 04:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfG0COZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 22:14:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42300 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0COZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 22:14:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id x1so6253227wrr.9
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 19:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=u+EbFX8sFMH8pWi0TV6CAS/I0F4j3WfAGkd0Fx8VVEw=;
        b=zBoL95lCC+VPdvja/4U3V2lbyo+rh1+Ywr6tM8ToiBqfYr50a1L3W0Wmcm8Yf0LJHW
         4BTe5kOSQ8ejvEvR0HRYlApjrwck4XBXt4nZ4VDlbDDoWWIY1MiZA460du9N8iHS/B9Y
         QFzMye2hhlZ/ak0bZ5zb9VnE78TMQZC7WAdxBvV0cdsncpazOsUsxLh1P/ck6fCafYVO
         ZQZNQibz9TH2gfp5FOyiyyIrVozR6V6I58YIyLEHHCqrV396M216kBuHf9faWYEuVVfJ
         Z5pY0MxO0tsijOoLrKlg4lr+NdDbcDNvbp6jlSCgwvviX9yC4Zz0+qCqOdQi0TGCYVvl
         dfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=u+EbFX8sFMH8pWi0TV6CAS/I0F4j3WfAGkd0Fx8VVEw=;
        b=tP9PE6cGHB6j5kTs6UoNrNIK2p1gktN4mMUqU5bviOXXfknQJuVrNQsgZGsU5Zdk4g
         9PshA5LYykEPA0gk0U0S5+4tzajPlUxZzM/tZ9Y17XvwsErumIXn1u8VN0MoVufM8u8z
         15kC00RDCI2fTvY4qrksCENLlHrTmrg1j5jGQ3Si6IMqbfwdj98CnJ2NeDn/b0MQlWTV
         5c95T1Pl6lvyDeS0MXtIW1CMJWXMgNmiWUtLeT9cRDLNREcnOFAMDHo56EHFW9YR6LdL
         iMyOqwSQ2dKhkD52VvGWPgTOEjwNvKnLPRBS4T7rOIqLIIj9+x1/lu89vXvUobKtUQo5
         2EBw==
X-Gm-Message-State: APjAAAUW0wEs2il1D/O7ek89UFtQ36OFRY5fN8rAJ2IaCsmaUlmxs1iE
        XMLhlrf872f9QxlAcXli7Ys=
X-Google-Smtp-Source: APXvYqyaqxBdIkPi7LwPrV8eaLuJGxamLn3RtSnWkdi79t72OjyC4pvuq/SwA80ws8UqaVjoL9fs3w==
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr32743341wro.190.1564193662879;
        Fri, 26 Jul 2019 19:14:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s15sm35146778wrw.21.2019.07.26.19.14.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 19:14:22 -0700 (PDT)
Message-ID: <5d3bb37e.1c69fb81.33e47.f6a6@mx.google.com>
Date:   Fri, 26 Jul 2019 19:14:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.3-67-gd61e440a1852
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
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

stable-rc/linux-5.2.y boot: 129 boots: 1 failed, 83 passed with 45 offline =
(v5.2.3-67-gd61e440a1852)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.3-67-gd61e440a1852/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.3-67-gd61e440a1852/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.3-67-gd61e440a1852
Git Commit: d61e440a1852a64d8a2d0d358b9582b19157e039
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

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
