Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D89FB3F37
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfIPQsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 12:48:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39521 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390140AbfIPQsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 12:48:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id v17so87618wml.4
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TxsiRtqlZxXJxEjh0Vyv7B1mmGnVTP7fThp1xdwmH68=;
        b=PVd5WcS+LONmnhmFXSy9viHGBE27lHUscMNX8i36Fzz6JksGDceHDP8rtdWO2d7LSz
         kYvVsLuTXh69mwC+AY4F1aEtPyJDUMsByt1fBx/u5FBmVLpqnGgWTd7KBtU/GRYy/2bo
         xPlQUcq27cN/DMFM2EmPfGcWHxrnbf20l+Ob8A9SUA0hxWWiJAbBcJB4nE9wShj8BEox
         VmrFDQscGmsYuRIGH3lsnjh03hnQq15W9QqfpVqjAD/8mBWwDeXCKZeV78qxrySajEke
         E5s2czSPQuHOGKDpOilq36MAYVI4ARbhuwUJZ1qGpbWxnI0uDSXF6+YxLvnSWUbEEH3R
         89tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TxsiRtqlZxXJxEjh0Vyv7B1mmGnVTP7fThp1xdwmH68=;
        b=moECMHf5ItII+CDSzKGzO3ZFvNTPMYssZJcqVb45MA7DLQQLwoBQzzFR5NuK3+WFqy
         KDsdePy2zwwjPlbsFZVsQpHAStdF8nVpsiZ7mSTVVQgqnos908w/2IHw7Ekcryfk2JRw
         /YKJ+JhsoZbPyEP799eJWB/ejCn2rpxnOTvdOT1PR9SBPuOO7eyQdqwud8IIn2TXJcyS
         OSYNmJilgcH7P5ZkwltxneLak8pm/CRai8Tt+pCu2fKOj4tjd/lt60pPkhNLMQ4paBwB
         zUsMgdovyTJGC4ImeLnAh77oNdUD63ssCF/jP8jyDTmOfilfxPB7OZWzupSfw+hr4h1p
         t4kw==
X-Gm-Message-State: APjAAAWlb+eszlAhC21sY8BYluV2T4SABkif3KpilJXi0Y1nWEJyFPpl
        JC3sIlfys0mAMbvxN9nzwXQqspX3+9Noew==
X-Google-Smtp-Source: APXvYqwJufQXhb9JsR6ga2EA9sxZfzN0WEfFAvZKx2x9BXqL0JFrCs+gVkWfBuVyL4EI6jNRf5JZ7A==
X-Received: by 2002:a1c:d183:: with SMTP id i125mr100690wmg.1.1568652517972;
        Mon, 16 Sep 2019 09:48:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x2sm10005357wrn.81.2019.09.16.09.48.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 09:48:36 -0700 (PDT)
Message-ID: <5d7fbce4.1c69fb81.50305.be13@mx.google.com>
Date:   Mon, 16 Sep 2019 09:48:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 153 boots: 4 failed,
 139 passed with 10 offline (v5.2.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 153 boots: 4 failed, 139 passed with 10 offline=
 (v5.2.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.15/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.15/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.15
Git Commit: 6e282ba6ff6bb52afa545d4a29a45bd2eb8a7f4c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 87 unique boards, 28 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v5.2.14-37-g4a69042627=
aa)

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v5.2.14-37-g4a69042627=
aa)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
