Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3577FDC8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbfHBPpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:45:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41121 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfHBPpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:45:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so74437080wrm.8
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 08:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CvbJ4Mb0OTfzM5X20ka9OD1aKfYxVMxvP5FPJbxqTMs=;
        b=1N2wDRSG/ikLYsApbrOCDGT50tvJkNyo77sFigL2sKox4TyyOpao/jCFCh79tXoMjo
         fvx4J6F/4GMCx0f0yd2CVHuHm5TE2wvc0CdHpJYBs1QKBWOdv8Nj25phtzadwVI/OkRa
         sho0VMBK1YpW8CtOMmSuh39EK7Zg0E+JKXIW1bRhSR2OjwQvK3Xk+Zwqnzo9v9av8ME0
         u5IyEFlDmAYCBLwLgxkNExiNi3FO/KAMAZ+3C6p94hCEy0i+xjlcf//cNXSOVl9w0+f4
         x+4hmHfMQomGtqKRC9twbsaSCbYKesTx9SP3cn3TcB7HUbs6VIU8A2PGGIo+vFmT21Gu
         X9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CvbJ4Mb0OTfzM5X20ka9OD1aKfYxVMxvP5FPJbxqTMs=;
        b=QCbaPRt6Lj8yzNe8pe8t7PElKPlMoMBjBXl3p1q1SAjSEs/Zu6Sr707NYIoMxfpQp4
         EbSR8IMEzT8FKABC8H5xBz2pKqsQWFB2lLNj7sr5WVCMDv9FuZmLqsKv88ly5t/B6J6c
         eSVlq7bQm3v9kWYciNz3edMPv2oWK1lZ9m3tJNRfj40mvBrITXL4JlCLeKtK1L5DW9P2
         QKkTvmdqYDSSwvJLxAX+LngCBgWZARO0jMKrlo+/IRW6Amhd1ogQEdAijJZ49mUg+uM3
         VHwwr5SCDNsyjTYINOOUZGciXeQpk8J5qGPTp2bvPCu54xZf0+LsvRj4xhK6CIvJYn4S
         6Dmg==
X-Gm-Message-State: APjAAAXlJ6mMgurPpn+tDW8SlG0hJyhYJ3kQL+hQwTXFgo+V1pccRCty
        CHudIsu5CKEn2w2LNRdgiI5sCZ3xXm0=
X-Google-Smtp-Source: APXvYqwXY0llRwqyyyBF67x059YULeSYRFliPW06NRm/1XPF/ZFAgVDjRLAABSbAGDMKh/PCZyNorQ==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr70621738wrw.8.1564760738732;
        Fri, 02 Aug 2019 08:45:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h14sm74940188wrs.66.2019.08.02.08.45.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:45:38 -0700 (PDT)
Message-ID: <5d445aa2.1c69fb81.831de.76fb@mx.google.com>
Date:   Fri, 02 Aug 2019 08:45:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-318-g8834696721a3
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 120 boots: 1 failed,
 77 passed with 41 offline, 1 untried/unknown (v4.14.134-318-g8834696721a3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 1 failed, 77 passed with 41 offline=
, 1 untried/unknown (v4.14.134-318-g8834696721a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-318-g8834696721a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-318-g8834696721a3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-318-g8834696721a3
Git Commit: 8834696721a3cabb1dc560fa6b03096d4f8ad525
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 26 SoC families, 16 builds out of 201

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
