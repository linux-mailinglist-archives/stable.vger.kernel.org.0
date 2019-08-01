Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC967DA73
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 13:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfHALlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 07:41:24 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:52964 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfHALlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 07:41:24 -0400
Received: by mail-wm1-f46.google.com with SMTP id s3so64278979wms.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 04:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xze8HYlWBeGyBPrKOJZON7xiNgSQNpUa+t0GztIGdNk=;
        b=j9KpjK9SvnnSJQrp72UDNB5LIDln8Pz98oCcqhgLFnkdIvWDwSP1YMxXohKZ1CP3me
         xogLRXQ7bDNas1lACev8wXjIUe9bjgpNc3laGksecXRV73o7qsBn5B1tIXcaMXi1gaEk
         WMcYTHxarXhX6dasyGcV4ORNYbRoJ4iFTKCuacdF6Yvaro3jao+1dJ2yz5qkmIAErnW+
         Jw7qxJq4NsQXDUfprVEhvQStiIROGMH/8EIqtSNHJUc8pFZ0JJ2p6ngI5DCQ18CX/kcx
         O6GfPp7RIck2tubAsZlypp5y63/w9HHPKNwsBcmuj1e8PyPknsN8JDdA+gyk4MJxcmE4
         0EEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xze8HYlWBeGyBPrKOJZON7xiNgSQNpUa+t0GztIGdNk=;
        b=NBTdUKX7TclkL6IChKj0XD+cu1OyVrEvY2vW9wIIthCZZgauL4rQqL2km+GYkRLnns
         FB3AXCgLqXECvzjsFnfj1zcTlEm/QcusccfF0NBMtQAYCp6gNGVZ8KcU/rk0E+V6esv4
         OMean88Jprvl6vcBTBvPaY9nNCj2gpwrB0ug/KwAp421R/CjbeBjWPVe3DmSeaXINGXq
         eghUDTH9EJsFpn/pSqsDOtfsArl0MUr89I6m5iJ4QXYnC/eNuaKm/Aq+2eZNCHqYM1T0
         7tUDLB1RNrx6ROYum9eN2gep96tD2kkmUGbhmLNHrYlSaUi/Z70/w/L4URIcjS044318
         A9Ow==
X-Gm-Message-State: APjAAAXzRQfgMttb8JTbL9x+WPV39KF0QHn7aX3z5KOtX+wJcIr0q051
        IroDzngUqy/0ucYOfjqoubpuiPVXSLg=
X-Google-Smtp-Source: APXvYqxTNyA8EtW5Atl2dXUAvN0rWzHWD7t6SZ2z/BFf27J2Bv7RimJ+st8U/ROgdDHnLbsRYdOFnA==
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr106327755wmg.24.1564659682366;
        Thu, 01 Aug 2019 04:41:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h8sm75785560wmf.12.2019.08.01.04.41.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 04:41:21 -0700 (PDT)
Message-ID: <5d42cfe1.1c69fb81.8c392.3214@mx.google.com>
Date:   Thu, 01 Aug 2019 04:41:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.186-220-g80171ce48145
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 100 boots: 0 failed,
 65 passed with 35 offline (v4.9.186-220-g80171ce48145)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 100 boots: 0 failed, 65 passed with 35 offline =
(v4.9.186-220-g80171ce48145)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-220-g80171ce48145/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-220-g80171ce48145/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-220-g80171ce48145
Git Commit: 80171ce48145f3225a40ca256fcf6848de1b8798
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

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
