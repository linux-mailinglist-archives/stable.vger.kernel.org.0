Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E967C683
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfGaP0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 11:26:39 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51416 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbfGaP0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 11:26:39 -0400
Received: by mail-wm1-f44.google.com with SMTP id 207so61285638wma.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 08:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KvQaWkZEuVHhYkOsUE1i52IZydsRDscbxK0oGMI9LxA=;
        b=qT+0KhurHO0x3FcQDusn/5Yor8yFmoIMjvZzMutuor1Qv9byWBttBU79dlBzsnz1Px
         we9Hb9DocJxMJE1wrfSpCtoe72bDT9G3yQm9aVewaM4YXoJqMOmB5fZLGTps0mTEQxTn
         uab8ezBOvSlYVe713WHYW4U2L5KraBva/Xw57D+mlO10wJCHy69KzIlX2Xl8bwyTgLD7
         YFPeyPl2VgCDL1gbhhtXMdoLRVx+T9MP9kqztQeq6jphRMpBJ3aWqOmQHL/YTCHiQMiF
         /lOlJvXEqsBB2PXF8gMeFZAmvUQ2C6PV97cKIWHD85GJJeiy3AyuNNk+hiNW2f4ADWnx
         q51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KvQaWkZEuVHhYkOsUE1i52IZydsRDscbxK0oGMI9LxA=;
        b=Tg6I4RkXYO+Y3TUBONQNtltkq+l+nKMLckKwsQ6LQ+nVVwJiF/1gdANkzRvuMfQ3oL
         IM4yQQ7TtLUA+EvYflVVjnuhy92bMeCcmnb+dtV5hOPexWYJROwkeoiM+Bh6veSAqoRE
         fbfIrq/InZTPwseyVO2pmDOcugXvVk2JktahDPvk5dFGFXxVIG4+X5Xn3UrcmEXakn4n
         xNaThYkevMeyQtpALv5nJ5qJv/VKx3eUv9h0P1Qlqklaq1UpXj4wwXp1Ol53ukRVlUvx
         Wfg3OjH9sLFmL4LR6wvRiwcW5nwE0bQPwn1W5z9Oi4z+fAZkawwn/cXKgBPRj6jUXz4W
         BHoQ==
X-Gm-Message-State: APjAAAUtu2NuDZlMjVX3BxwjOvnFhj22eGYFZGwyYgHjutLEPcdZA3kv
        dcj1dfOMlSLjJbzpU/CVUWwTbqLVuK8=
X-Google-Smtp-Source: APXvYqwtDfUhDul3eTy6Z1fezlIvrJ0MnzT6TKpkc2heUHtp3ZopDfqbfk9vr48MIXXWoIb44tS3uw==
X-Received: by 2002:a1c:1f4e:: with SMTP id f75mr108710782wmf.137.1564586796625;
        Wed, 31 Jul 2019 08:26:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm78423813wmf.8.2019.07.31.08.26.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:26:35 -0700 (PDT)
Message-ID: <5d41b32b.1c69fb81.85fd7.4ea9@mx.google.com>
Date:   Wed, 31 Jul 2019 08:26:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-217-g6aaac92a7ecc
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 136 boots: 0 failed,
 90 passed with 45 offline, 1 untried/unknown (v5.2.4-217-g6aaac92a7ecc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 136 boots: 0 failed, 90 passed with 45 offline,=
 1 untried/unknown (v5.2.4-217-g6aaac92a7ecc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-217-g6aaac92a7ecc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-217-g6aaac92a7ecc/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-217-g6aaac92a7ecc
Git Commit: 6aaac92a7ecc330b95d4184c29c3f49e0c6c3de9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 28 SoC families, 17 builds out of 209

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
