Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E678077724
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 08:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfG0GEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 02:04:15 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:40921 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG0GEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 02:04:14 -0400
Received: by mail-wr1-f45.google.com with SMTP id r1so56435440wrl.7
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 23:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4pcK1FpOl5u0q7a9+8BkJQE4YMgAYbItUXYB+d0D5B4=;
        b=UC4CjdC6l6/EOpjrJwqzx4xWwDlyXQ7VS8g2gJl0OjbnS1yaWoLDKPnAG7apAnUqZE
         Bch8AYjVs3jt3uSN1olX4E0a88/ZBz5a4mUzAG3pBvIPWDy+VRSUPN3VVLLG8BWBlgVw
         3W62YVEFBtK8k51Z3vEf5meNjo63UJP1kVdUGzreo2rt2h833rgi1y+ECsRFoHaNx6qd
         tNkuhXLFSdzpCp3wceqqd2hyd+PpaTxAK7xS709FPvFz2F71ncUTIsVHF/MvZdMVa0NV
         3zEWRmbK78oUZWVagYicAxar8XOwAio041uyRkFZeftYtrVEAPqbteutBCFkskfZXyln
         y6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4pcK1FpOl5u0q7a9+8BkJQE4YMgAYbItUXYB+d0D5B4=;
        b=goo3bp79P7RBqGLMPzer6YBqv9n58Q9k1/m+PiyENy/vj40oI9VBZY+W2+uzJtRGUM
         pPSznNFqAIrlwSYp1iYejDM4pPBQ/6cS9JhvnPzvBSd4ruhOsLDE3jKgF7CNp5qP22Lk
         tlenbmEF1cmLFfBL3x6lpIeMHBCUcArs0xGID4Wkj2+gJnEKh9ewfpQIlgIdJ9VbqSzr
         QTvL3aTYH82Z8AIR3rTpQnjMCmQTMRnX4RYCeITEG4KRBf4r/A4HAY1r/1ifNvTOAT0B
         zyrqaTqDAKHeC8iFBv8/g1H+UOdlzAhXlzy3oPkud35QFNAf8xZieSuHhq+yRUUHIzKY
         owYw==
X-Gm-Message-State: APjAAAXZyEkdPfU6iTd62IcY9w6tR6U5+P6rMKG9YAs8xfkG7ggIRvRH
        FBN8WEq7LSIP8Ss352iGvurcMXikVLk=
X-Google-Smtp-Source: APXvYqy7UMHqxlljgPHui4t1buIqhfiw66Y2GduNJ2HElHEuR5UjTBmvNJEWmUCFpmsuA+B9Pod2GQ==
X-Received: by 2002:a5d:4ec1:: with SMTP id s1mr99100681wrv.19.1564207452695;
        Fri, 26 Jul 2019 23:04:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u1sm49415605wml.14.2019.07.26.23.04.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 23:04:11 -0700 (PDT)
Message-ID: <5d3be95b.1c69fb81.da5b6.281d@mx.google.com>
Date:   Fri, 26 Jul 2019 23:04:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.186-129-g19a0dec2ed3d
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 58 passed with 35 offline (v4.9.186-129-g19a0dec2ed3d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 58 passed with 35 offline (=
v4.9.186-129-g19a0dec2ed3d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-129-g19a0dec2ed3d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-129-g19a0dec2ed3d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-129-g19a0dec2ed3d
Git Commit: 19a0dec2ed3dce9c2641ca80839e01b93da09a75
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
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
