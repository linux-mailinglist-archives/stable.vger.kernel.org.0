Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136F27DB0C
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 14:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfHAMMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 08:12:23 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44159 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbfHAMMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 08:12:22 -0400
Received: by mail-wr1-f51.google.com with SMTP id p17so73310384wrf.11
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 05:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IENYmoC95ERRbL9qXnWyGiIPXx5TJJLZrpck1MDP2Lk=;
        b=ra6W/FR4yXgGXMGR8s4f2ma5hsx40LWm0xMUvC3lPOncQx8P20GasRo/ywgeFo7LpH
         k8hGI3IbxAYVOJNivMPwBZ5WyxMlEKFFEF5l6L+tF1IItLH9cVEHCpQvwAlClGw6js3c
         OGM6oaRDuzsPoET45YHziG9JLd+HHSRXirWuBuOf8pyywS6CboU0DzU8m0xZZCbeYQSo
         aYGqIWRAgvpY2iSMCx9CpOo0Dm/TVXBt2oxh7qzUgTbPgBJ2H3UOJ2C2sopK86x9BX9y
         cGpq/vceBbQF0nGkJZdVPO54ZUnV+xpaCUyEIZheXGy+xqR5nqPfJ5Qmue5YSHZJQV3l
         6qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IENYmoC95ERRbL9qXnWyGiIPXx5TJJLZrpck1MDP2Lk=;
        b=XNtBussUeLtNg/JpEDOaEFWXhfzs6l6525WbBrLYGu/21G0zyDFxHPRYb0PwfeMf+v
         FwuMMKaXOhrgffBws6j9Rh0ZwY06wcN2o+i/jSLRFaIV6n5b6moSt3JJMzcgB29EVjBs
         rllCRycECfBX91AyayrHa2ANj8oWEQyCPnGfgFBKJ4JTqXHez0WXHu0wlHdJHHl7x9sm
         VDTdCQG/K4tDb3ecZFZjMMhkrpm1qnRX1YMvKkw499kSwjzjIlR5fR8fwW4o9WESEbqI
         8ePW7qtlQgEYDO119tqsZfchaOhlTzyRcl10ON0YC0WnkAapzXsUbBKYE8xb08spBiCH
         fTVw==
X-Gm-Message-State: APjAAAWtmirYF6s/n8Tk/kWWYtEpsaQGETssx1DgJhUfWZ1Pv+lF5qK+
        JSaW4s4vnxIck4J+/Lzh0+6QSDVizAg=
X-Google-Smtp-Source: APXvYqy3S0ZIfex9gtkTjmopRwjLVGQXZMp+f6BvNoIvCYgP0l/MOYwZRUEuvUUn+pZUAdKlG3zCvg==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr132569842wrq.319.1564661540498;
        Thu, 01 Aug 2019 05:12:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g8sm72733930wmf.17.2019.08.01.05.12.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 05:12:19 -0700 (PDT)
Message-ID: <5d42d723.1c69fb81.5c064.1cf9@mx.google.com>
Date:   Thu, 01 Aug 2019 05:12:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-227-g8b9088d37d9e
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 134 boots: 0 failed,
 86 passed with 45 offline, 3 untried/unknown (v5.2.4-227-g8b9088d37d9e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 134 boots: 0 failed, 86 passed with 45 offline,=
 3 untried/unknown (v5.2.4-227-g8b9088d37d9e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-227-g8b9088d37d9e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-227-g8b9088d37d9e/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-227-g8b9088d37d9e
Git Commit: 8b9088d37d9ebee58a6d6bff5f428099bf0e8232
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
