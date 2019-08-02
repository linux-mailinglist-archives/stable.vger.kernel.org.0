Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221F18020B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 22:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbfHBUvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 16:51:53 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41290 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbfHBUvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 16:51:53 -0400
Received: by mail-wr1-f46.google.com with SMTP id c2so75236520wrm.8
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 13:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QaQBEpZu+xXnV1QWoG+KGBNXP3VFQ+2BoepjF8wvvlA=;
        b=JBFmhxUFcL04CNgajuA8/e0FXhPDHzjDxVqcqq2uYyAdqxfXDWmcxgeMieJ7ha77ty
         kRT12MKKpxzaoxoi3nwETcbQH/4tGcyDJtrJY93euQC/ZfQhPy2dis8SNNeaLZAGFA6U
         JomNfA4q3pnddRrHNBBdoGyPNgL1lUZV/n6+5kpXI20aYAsMBFVAdKJmlkg7W79rt17d
         aGqFSy14r7GYYH81DHN0BYEHlGsNx3r+Lg1hjA/K8h8QoFgX/EJEtuaqKEnG7sEEY/S0
         OHZShIK83noHtSSggTcaHVUdMMG1S6K6a5P53x9S+QBzwi0tmQhcxLSlmg64DILPjEel
         0YVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QaQBEpZu+xXnV1QWoG+KGBNXP3VFQ+2BoepjF8wvvlA=;
        b=ALrV4K4rU7ViLihZ+pKrB7Kjz33SWQUmIlwA23tZ1EYf1cmNOZsmHZvRbGewvh6hd3
         Qu9aTqj+bbvS7vtawcuoR/BYE4788/5BfwSt6Ao5tCNDMjAkEgRfxV2elgcKme8VZ84P
         GhsGbmJqX27Kb0utxz+57Dmw8EwaRQS3OuB3CSbSyk/SFKY0mkeyMWezeGu/7Ir096rf
         9upZGSQKJaAseLm13GvSv1v1Xl8nQaQOIAu9KepeTNlMSOYfWufpUFy1NVUfFqkcmJ56
         Uwj96CSHVZqLPqK/6kAsSgfH7l9JiLkMGhqGH0z5QHoTVzYJxqelk7fL5nz2PmJXvyjg
         1B1A==
X-Gm-Message-State: APjAAAW1EmRU3nabqeqTpE+jph9YKABw8Hm/g0f9Frxel0kWin6c2iPu
        NL3ZSFN435RBafxyKst3XtyjSQeFerc=
X-Google-Smtp-Source: APXvYqxZLxJ9N4xH3tfZF6WbSFY5+Yf4/sIXuVoLZCEV7csfXPUwbgfzlJ39YyCNp+C+vH7wYQ5vNw==
X-Received: by 2002:a5d:498a:: with SMTP id r10mr60144992wrq.28.1564779111310;
        Fri, 02 Aug 2019 13:51:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b2sm101674388wrp.72.2019.08.02.13.51.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 13:51:50 -0700 (PDT)
Message-ID: <5d44a266.1c69fb81.589e1.1136@mx.google.com>
Date:   Fri, 02 Aug 2019 13:51:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-235-g44397d30b22d
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 135 boots: 0 failed,
 89 passed with 45 offline, 1 untried/unknown (v5.2.4-235-g44397d30b22d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 135 boots: 0 failed, 89 passed with 45 offline,=
 1 untried/unknown (v5.2.4-235-g44397d30b22d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-235-g44397d30b22d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-235-g44397d30b22d/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-235-g44397d30b22d
Git Commit: 44397d30b22dd93340c705ef34bb61c16f43503b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 28 SoC families, 17 builds out of 209

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
