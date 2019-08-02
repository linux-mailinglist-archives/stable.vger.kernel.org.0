Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0897FDDB
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbfHBP4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:56:16 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36893 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731112AbfHBP4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:56:15 -0400
Received: by mail-wm1-f50.google.com with SMTP id f17so66784618wme.2
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 08:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BECnQSoSPZEsLWCAx/dZ+dr8be9NxTZu4qHnEkBCl0A=;
        b=U7fdOCtBWwljfZIVlDI2ScogGRqa+BmYc7yH4RVPot0hNyyYqxUHQmZgMsBJFj1AUM
         CGGYFRXuNbjNN0XLno41B1QttqGn7ibRnSz4vcIkZTKoZ2MnVfNJHWiW6X+uP/FUGDFd
         5BcsJ9hKLPMbYF6B0JWeBRmoDm0cWYxsYUlqU/HhzE5Cs6XiAXccdE2TESCX3oFt9mcv
         2H+hpo2DsWQZtjrtN42HBc8u9yAvegkMTNCTbe0qF/40jgepkTU3HilqaQLUPFDJ+sOI
         TbCNVTyFTH0wLJA02+cAfBEsxQ0PK/X3YR/DJM45VHKvvutw0ox8vw+6iKBfcbOBa8OA
         NzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BECnQSoSPZEsLWCAx/dZ+dr8be9NxTZu4qHnEkBCl0A=;
        b=BredLoYtXC3GEVXQXFBIKFzCxrLlEu6FckcoJQiEDKe1J7oS9jkvtEb9eL6qvnSaoJ
         OjsBw4lcKf0ilINy6Q7fx0NKFBW62Ge3W3erdxvR4+qHe9dpNa+zmQN6bBwQkEK7uyDI
         kiPLBug99/kjf82ujQFp9Gijw412l+p/IUJP1wOBTOXKwP5273jt9xWwDCd0ZcE0FSmY
         4BofJxm8HB7tOah94UJjqKlppuB+Dbg0YFQPMkmd1Mdd4wIUNU4/CF6YTNnL6BBhIesp
         RzEMNXU5YhvCRNjZ9VJtSuO6k+8IhqPsyYsnms5V/byKYTI9LfLKdl8ecVMohglTmdUH
         1bTw==
X-Gm-Message-State: APjAAAUoZrllASO5lQ7PqgOZ/NYv3y+Pkkeu5WLixG0EPsgj6jaNSASX
        Dt4hW2ZlTDLreIAc6CUTMXw1V4A/Ifk=
X-Google-Smtp-Source: APXvYqxMB9DGe3w5AtoPzXSlVa+WYfSj1KtOzsgLEN9hwhN6V+tor7A+dRTLsE9O/7IiopEExj22XA==
X-Received: by 2002:a1c:dc07:: with SMTP id t7mr5227326wmg.164.1564761373316;
        Fri, 02 Aug 2019 08:56:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i6sm70297281wrv.47.2019.08.02.08.56.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:56:12 -0700 (PDT)
Message-ID: <5d445d1c.1c69fb81.18a4f.6f36@mx.google.com>
Date:   Fri, 02 Aug 2019 08:56:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-236-gdbc7f5c7df28
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 136 boots: 0 failed,
 91 passed with 45 offline (v5.2.4-236-gdbc7f5c7df28)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 136 boots: 0 failed, 91 passed with 45 offline =
(v5.2.4-236-gdbc7f5c7df28)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-236-gdbc7f5c7df28/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-236-gdbc7f5c7df28/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-236-gdbc7f5c7df28
Git Commit: dbc7f5c7df288a6bc587ae08342450a1e7f5cb7e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 28 SoC families, 17 builds out of 209

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
