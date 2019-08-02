Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6082D7FDC9
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbfHBPtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:49:36 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:34226 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfHBPtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:49:36 -0400
Received: by mail-wr1-f54.google.com with SMTP id 31so77703032wrm.1
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 08:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lv7QFpyym32Y81fdJu6NtFzt1x5OEGeU7A8SCvtyPV8=;
        b=HI4aAb+LUm8AsXkNrb0UjWZC2EOxMabI85PHlaVfe5QrEUv5+xpSAH9dPiWo0HELs0
         MCxefsWHLEJHeCApLjiVXiNN4gKe0Ip47nTyZYFlHnrxP+xghx/+n/kVjbRDvxIT2JvI
         DRkCmYy+KptKlN5vOdx93Vu4dz0JyWIfPIF1n7h9h9EmhFXRb/ZY+jLpbnaBID+5H8hH
         VGV0c3Ce1ee4lbz7Ie/rO0jxe4xp7Lm1NYEIIiWF53hh7R62ALZ1mCWW4JnrnBoNAdto
         iyQeQthu7t8McThQOg1h/rrkFlH6/8Wcky2FGRpZ3X+PGbQ7mtvoGBVK/bINKaLfWam0
         ixxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lv7QFpyym32Y81fdJu6NtFzt1x5OEGeU7A8SCvtyPV8=;
        b=mtfCmbVLnYHByp7wwI+GSL1Gph7xKNGXaKEacUmJ62g/41hKlIIl6QN3yLCnGndqyB
         xP1rFrQ7TGrpyyMjRQAx94WJDovL0SbjDExvChdYrdVQBzwzZVQnqrFuOBwQjK7xU6Ya
         8fQPuG05zDfCAI9dSarb2eWs03A2EFa+Fd46dhU/B2eVk16VtTNwvFP2bSZh7Raoap1d
         xrPq78J2Bh6v0/tKrYzQZGebjXKCO6EuM4lv/JkMB76jZFVz35EK5sVvT7MCWHsmvoNF
         1TcJSMZi7AjafpYh43bdHU3n/7dCFSONCDzXlfzXFJwGKVnhx29bl+l0orzRZ2RCFN/r
         w3Xg==
X-Gm-Message-State: APjAAAVhRR1PEcXWs4QAUJKyodPYsQLepB5SkTKAXqUlxzO0Hx/wSqxg
        LfdXzSS7xSbVtOfMPIDbKRXK+wdUT9k=
X-Google-Smtp-Source: APXvYqyMlPB5ruluXgFgLXuvqKdT/x0tT6JRNvZq/3hHrJru8LO23updj9EkorAmrXQLaXac9HfG0g==
X-Received: by 2002:adf:f94a:: with SMTP id q10mr12872589wrr.341.1564760974456;
        Fri, 02 Aug 2019 08:49:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e3sm89589816wrs.37.2019.08.02.08.49.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:49:34 -0700 (PDT)
Message-ID: <5d445b8e.1c69fb81.ede47.aabe@mx.google.com>
Date:   Fri, 02 Aug 2019 08:49:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-159-gc4286991ea44
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 92 boots: 1 failed,
 59 passed with 32 offline (v4.4.186-159-gc4286991ea44)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 1 failed, 59 passed with 32 offline (=
v4.4.186-159-gc4286991ea44)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-159-gc4286991ea44/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-159-gc4286991ea44/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-159-gc4286991ea44
Git Commit: c4286991ea44309c9b2dcf717fd7d04270809eae
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

---
For more info write to <info@kernelci.org>
