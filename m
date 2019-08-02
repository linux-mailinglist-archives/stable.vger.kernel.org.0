Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B734B7FDA2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbfHBPeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:34:44 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:40911 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387684AbfHBPeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:34:44 -0400
Received: by mail-wm1-f45.google.com with SMTP id v19so66770796wmj.5
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FfkWWRbekNwvbH4JxRHzdSjNqDdXZYC2ZdfZbO8WymI=;
        b=wtusn/+31zVkSKeIaCGkMJ3MuJIjhxFeHF7KJb9sHN0AtMEy/Cq7AUJLuOw8SYnqGa
         ltma+Tui0CbXyQ9zCCXPXMFpm+f95E8ZjIXnShoJiNC0z+rNh4hlA05N582AaBdgtJ91
         E50NFi6DINrB7jr1A83rlI9xhJLoHFqf+BVRaUOqD6xZsoG22Iy3++lEA6q4TlAB0ZyV
         X5oreFm6dfbKwh7pP8bOI13JHIrJ+X272cqtCSggIq4a652yCrAPGEJ+pOx7m5w5xq1f
         x3zdo+y7V8N5BS6bibQqiG/yWOmnBmR24dQ3DlIuUoNEOzkDracDtdUp87ItIjLF8uRb
         kCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FfkWWRbekNwvbH4JxRHzdSjNqDdXZYC2ZdfZbO8WymI=;
        b=LtMAMdP+aNzVGirQAqZnXL6/itHEMiCdsGPU9gToiF0gaI4Zs+2nKbsJwOyMIVD/X1
         QVL/RDCYDl5z0PFlt9+uaxNUSmFS/8TQedcH18rBRGDSc57l5VZ/WBYoTV4fG2GHEPKl
         6AuOksVBLzR7L9KPgtDKpfRBMcXG53QA3mbVaM/qnRKooSItTQ3oh/wwl3ywgELBAoiJ
         vOpnY6JxSWX1D5VJ4zEHQKnEkepuuNHo2xnKTvS/dub5QF1NHaoU0g/quuRFp9XP/RPp
         yIFGWH9SawZKpfkxv/WclvkdtB6jI9ze+tLo8id4WFHk9iJSRJpeBxZ/f/s96tdeUUNH
         oGeg==
X-Gm-Message-State: APjAAAWWhdQz5FpcTGBKpNE1ejm3uVf2L8GmfuB5fn6DYjKyec/uUd0k
        EXe9RQCqCn4yp8tXWpEavI3QnfGLBy4=
X-Google-Smtp-Source: APXvYqwR/WE+mCKeCyU6hn2/CwoAvdjgjYPPg6D906kHf3VGrw4sIMMbtD4cmkiHZByUm67c6TTo/A==
X-Received: by 2002:a1c:4803:: with SMTP id v3mr5059751wma.49.1564760081693;
        Fri, 02 Aug 2019 08:34:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v15sm69906368wrt.25.2019.08.02.08.34.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:34:40 -0700 (PDT)
Message-ID: <5d445810.1c69fb81.cc93b.b58a@mx.google.com>
Date:   Fri, 02 Aug 2019 08:34:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-147-gd60a7ba4ffa6
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 110 boots: 1 failed,
 68 passed with 40 offline, 1 untried/unknown (v4.19.62-147-gd60a7ba4ffa6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 110 boots: 1 failed, 68 passed with 40 offline=
, 1 untried/unknown (v4.19.62-147-gd60a7ba4ffa6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-147-gd60a7ba4ffa6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-147-gd60a7ba4ffa6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-147-gd60a7ba4ffa6
Git Commit: d60a7ba4ffa690b9b83776a64a21409194bf7657
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 27 SoC families, 17 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
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
