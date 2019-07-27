Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBAD7766C
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 06:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfG0ERo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 00:17:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36987 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfG0ERo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 00:17:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so49140137wme.2
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 21:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/rCL5mzeUkeM+esQbDrZ/uK0LlKhDHPTally9O0PdPo=;
        b=WhuVcm0VSKAp3r5iiI6JNyavaVvBG06kp5rJHVU6oKbKejcgf2DZ+GmqSljLke8gri
         wGKNKt/sUd4Ee/URlUhnW8kZYnLlmhlSTX5lNZh7gTKIeVsJ1pgw4x5NdtL7NjeN9RTz
         0TSDb058ZAbUFeZ2f1MB7Gx3VA9Ki23z+AxIbh4R3pwsJSUkJpJLyVwV8SxZuBxdlBIJ
         6NrtzxjDuCzM+5Pdsh1uoqr1KjewUbizPJftX6jklvwS1IWOD0WZGjFEF/Gw3a3ikhw3
         m+ld4PRLZ/ZcYKWluOo0e2mNIRbqC4+yluET2U3qDZx95DVfHfBZ+c/ZyuD9x/rSh0RF
         g1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/rCL5mzeUkeM+esQbDrZ/uK0LlKhDHPTally9O0PdPo=;
        b=m1CzXztCRGQQLfss3C0o+MMapfLjTOANBvQ6WyUVJGjHPLqUCFCoslX8wD4YcStjAe
         1k417lpqGzAn2OJYncVqjbeNQmaKcdp0lyJLtLAAnrYxaq2siPSK7UDGU3O0MSkmWBBm
         TCqZx4JYOVhh3NmdK32W4QKKLQh9P+jqBN/MNdqIghLn9RJ6y45DgaKHumNSsEvCqOpI
         9Ufm6Ysi+HTwqxQZlH+VtwNO5WSniRTxehgGZ4CZuHQYbV/siDvpBmCG9QJ88qUJCBP5
         GSY/LfXtuAsEEdPynr/lnVnp7ByWPpN/H04+FV9wqom/fbeElGIfcbmdWW/11k6mgOrn
         +92A==
X-Gm-Message-State: APjAAAW67pFylI+dW94OUDq7n53UDv+oj0BUuuKvCZ79SJwp+PYKhn9U
        SlFJvsCjdKUeMGuFoAmwTLGpdrC9Bs4=
X-Google-Smtp-Source: APXvYqyegsE2B7QwrEFp0tvZ9uvVnbacqxcsOMYKeQvg/xBpKgKfa4NOyZ39qzN2FBYusL830DdIWw==
X-Received: by 2002:a1c:c5c2:: with SMTP id v185mr93075647wmf.161.1564201062181;
        Fri, 26 Jul 2019 21:17:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p14sm44483037wrx.17.2019.07.26.21.17.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 21:17:41 -0700 (PDT)
Message-ID: <5d3bd065.1c69fb81.fc0d4.1b64@mx.google.com>
Date:   Fri, 26 Jul 2019 21:17:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.1.20-63-gf878628d8f1e
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.1.y boot: 127 boots: 2 failed,
 81 passed with 44 offline (v5.1.20-63-gf878628d8f1e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
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
