Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B14B8008D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 21:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbfHBTAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 15:00:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38137 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfHBTAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 15:00:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so78202400wrr.5
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 12:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gpxAjLEs0ClgP3+zNQhx3NAnLVtdeDxevkYSjcWyk4w=;
        b=iBVhTAjIH9jTS1oi3AEFCo4mbIWZwEk1h7EB2E4Y/UnEGXt3cv1tltOtPWOXjHvwKV
         Wf+a6MX5L7iKTQwb01aISjKiX28HCY9Zchg3nkTLt+wpPtoyigL4usXPQPKgCRutdQAw
         hShccbe+GFge0Wctzr6bj8uYwWIu0ugtTCiczGwNZiUlyxBijBjGmTb2NXwqXK49PkAM
         Z9jC+i3Ao6pyE2bPcWHyTfGS3Wqbo3wQHQaBwl0QVTgXYH3QUP9Oaga3Q92Idox6LY9q
         YICnJIhZcylV++yngTBefTeGoeqPIe1geN7X3jpsW9DMoL2MFeSN/3Hw63NOoNwQyoMY
         2mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gpxAjLEs0ClgP3+zNQhx3NAnLVtdeDxevkYSjcWyk4w=;
        b=VTHjTZW5ckeTeShd/jBSkBXUKMcvxpEWPFjTNJZdrM8SIEXt0DhXnqqdR4pac3IRhS
         MbLr7lScC5VN47/X9bV1k1f+djq9Q6HFTUqdcD+imV+Stih0QYtKby+tlOJ/gZZ5KdVi
         gKnQkcQQplXcOJnHPJqVZR5MUK1OA6uFOefo/VXf0GolB5PQg7+0iLRoL3crg6A6SzNk
         lBlc/xti8Mu7Yy9WLCdKHFdF8W9c+U0qn4OkRJBiSIjXVyYE3undz1KaKhMZPDkxeCSZ
         Q6ZCE5SbZijszvFhZdj+MuujdjxPv5iF4jAFQiOdINntLtEouuKbKZ26Zhfmjgj3S0XD
         pxAg==
X-Gm-Message-State: APjAAAWk3K11nLc6yZDb+zQ9ua++H8PdPaMepzH78btUjNIGbFPDFCLC
        m7bg4HRXGV2ozNcXIGfXniQ3wZ3M6j0=
X-Google-Smtp-Source: APXvYqxyGwoK6UFhCZbgtnsgL10MqJ+gAA7yHrltKgcLV+/NAmI8c3nqeKb9WqECizygWLKlCtE87Q==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr37834763wrp.149.1564772413225;
        Fri, 02 Aug 2019 12:00:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g19sm137674541wrb.52.2019.08.02.12.00.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 12:00:12 -0700 (PDT)
Message-ID: <5d44883c.1c69fb81.e1be2.6d9d@mx.google.com>
Date:   Fri, 02 Aug 2019 12:00:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-159-g26f755a0d3e0
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 92 boots: 1 failed,
 58 passed with 32 offline, 1 conflict (v4.4.186-159-g26f755a0d3e0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 1 failed, 58 passed with 32 offline, =
1 conflict (v4.4.186-159-g26f755a0d3e0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-159-g26f755a0d3e0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-159-g26f755a0d3e0/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-159-g26f755a0d3e0
Git Commit: 26f755a0d3e0884934f21afabbc52ed37a071e95
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

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
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
