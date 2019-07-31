Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25D77CAC8
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfGaRn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:43:27 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38119 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbfGaRn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 13:43:26 -0400
Received: by mail-wr1-f52.google.com with SMTP id g17so70621843wrr.5
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 10:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cu4vg7JQ2MMf3zX4T/8TGzKsbfNFoKFrB540X0BOFeM=;
        b=xzpYbX0o7YkWqvs72EbypZSeHQacR+kFlB6tyqashUe0GunuN53ZtiE3SLoTNc8Lgg
         Oka6fDNzB11MTXtaW/Mpfp88KhBEwb1aJac2yuPbBLKOncdYDeRmuD0vkKFjSGq4fdlT
         O83PO21s+O93XIAI72FQ85i7in92jlsUlDA9N2eUu8c2Xfhe2uqVh0k5J4RWXR8ibcrA
         XfnChOeALqsZ8WeXfT0AIwUxmbzpnmooWSMIG15fXED0FLeVqiY9+cPhEu87UXEWPWZ3
         iAkQ3QFIhJ2Ua+IqBEJ9A8NJPdcv1O3zFoqRYHKwXuPn5ZP5XYmjhdMEKvhGO2PGyj+b
         qn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cu4vg7JQ2MMf3zX4T/8TGzKsbfNFoKFrB540X0BOFeM=;
        b=kjO3cgLpy3ZrTywOKi21UQrjEEDYm0Sbi07HQrrRnY4rBMI1OZXjvxTU/QU7GNAkvj
         1Hw1KPM82Py0DATaZYHkGITqFLldLqbDxMSCmmoYyDugBL2Nr4th8chwtX9iupQe0iKv
         5cifbbvDDm5yjP7WPL+DdQdOLWfLPwWe2Zjpc7Bgd9e6pH2Oy0kWfPZ6lczYG7Yds2q0
         31YboALQv8PRZqAMoRyRkc+NIqjWgtcI1bQNuRdECGu+VcWPAuf6F4qT8K3hIJtV0+eS
         mY+DeKHWxP8AtU4EOj8TJjS6E2WEO6cNT3TnhPTRFW9iIG7kSvr9rAsA5IARcbY2cS2f
         SDBA==
X-Gm-Message-State: APjAAAUqhCXhbG+v9vL2Hx8Wxmdg1+FUkoEUGcN9k0hJwMQ0EFYkBrRx
        B5wW+BNPz2K4KP87C1+LLSRGaOv1M+E=
X-Google-Smtp-Source: APXvYqyAxXb2Q4yaIBXKcPuDvhAFeJ5bJsryY8q0eoRkP/S/8NTBgOzua8I6vbOg5OmiLoSrdYYLVg==
X-Received: by 2002:adf:eb0f:: with SMTP id s15mr58934375wrn.324.1564595004677;
        Wed, 31 Jul 2019 10:43:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u18sm55268360wmd.19.2019.07.31.10.43.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 10:43:24 -0700 (PDT)
Message-ID: <5d41d33c.1c69fb81.ae4ad.d6bc@mx.google.com>
Date:   Wed, 31 Jul 2019 10:43:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-303-g55685a28b143
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 120 boots: 1 failed,
 78 passed with 41 offline (v4.14.134-303-g55685a28b143)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 1 failed, 78 passed with 41 offline=
 (v4.14.134-303-g55685a28b143)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-303-g55685a28b143/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-303-g55685a28b143/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-303-g55685a28b143
Git Commit: 55685a28b1431ae3c9f6041e5e20693369feb8d5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

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
