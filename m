Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FA779FC5
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 06:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfG3EMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 00:12:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37456 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfG3EMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 00:12:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so55275931wme.2
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 21:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GOyTy8HuahpJzPbYFg1DDbM1pDVrkIWAXB5vGmlXxhA=;
        b=vj+HELBKt1Rcd/HYLduynBZaNZlU/gn7UN1y+x9jgKDCqadhkBEqAAEStts+J48m+g
         jeSAu/7qKsDqUqZW4oB7lbXQqge5CYGelSC7b0/20PzfminsLdQhwkjPG2HRfqZBd+bV
         wwsgj7PFxEV2sBKyXoGPyQFPsAnpwSudhJ6HxQccx/TiUGvYAPQ9p8umMaDcLItc33Mm
         +mndGUNR5o6N36GWWQnY9myGxc8B9i2ZaXg9giwLQOXM5hOrDeBuE5SyeNYiclWAFX+0
         4iPSZSfXexbAXYRrtjMML7LTkH+LN9fI08NY1kxE526jPippaW9PvS85ELaJ3v03HhfJ
         7JtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GOyTy8HuahpJzPbYFg1DDbM1pDVrkIWAXB5vGmlXxhA=;
        b=ftbyJrZ/RQTTCUgOtyJlw/MZwHmplPNgcVqATssfl5nhIFgIN68QtUrUb3FFDrGWnK
         OVzn+sr4WWstLvZEAxQAc03n7zTW2rfKr+dZ1a1/xSUDPWLNjBYIf8GByWnM/ImJiBc7
         bIYW4bxdFZ/Hcm+ueMsewfcF1A+w/ew+3B0zU4O+HzX855t/ZnEbCPi9csSozRzkAb++
         iUvdQemgTcNhI0W516g4tC+crztHOamFeKF1AwVeleG1WF+4ANYvpt+5jKCdTkyzLSyp
         AMz12vI23Drp4t5yUrcPg9zZ/PbtXqp+DWPpDInuHentzkVWtVpfGs7Clh7M+pet6iZ6
         /wWw==
X-Gm-Message-State: APjAAAVpUfdndilzaTXcG1EFhAXQVqMT94LRtBPnUQ8Dp4AwtXRGVoFo
        BcPvx3+SHyE8rCvowDW+PJjLaH9euUQ=
X-Google-Smtp-Source: APXvYqz2SN/KjuuX6dCQfLio5h7+URptEULQz870YqQUpk71+GAxXQT8T0QkC147Pkx5rcjDhRFxQA==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr101926849wmm.121.1564459959153;
        Mon, 29 Jul 2019 21:12:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g8sm66384237wme.20.2019.07.29.21.12.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 21:12:38 -0700 (PDT)
Message-ID: <5d3fc3b6.1c69fb81.a33dd.321d@mx.google.com>
Date:   Mon, 29 Jul 2019 21:12:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-150-g4ff70b6cca1d
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 80 boots: 1 failed,
 46 passed with 32 offline, 1 conflict (v4.4.186-150-g4ff70b6cca1d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 1 failed, 46 passed with 32 offline, =
1 conflict (v4.4.186-150-g4ff70b6cca1d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-150-g4ff70b6cca1d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-150-g4ff70b6cca1d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-150-g4ff70b6cca1d
Git Commit: 4ff70b6cca1d8706cd9ed25bc81b0754223f8210
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 19 SoC families, 14 builds out of 190

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
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
