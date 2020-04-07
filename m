Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA31A1863
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDGWvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 18:51:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42882 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGWvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:51:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id g6so2414635pgs.9
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 15:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ny/c9kdv2CQKS1JzwB/+/xRC48GJg1Jx01zHch9CVbM=;
        b=DJuJdSL28Jep7ynEB9M4iDizya4XVrNRXxKEHVViv9Q+5bYeLWRihe54a8+0w0KfDS
         ZRXVShyUxxrjCpYQ4vMcCVJo82Fd5PAldr72h6IkqMXNmrGXkvDAyprDl405LXpSRsxv
         dBJxaybesmth1iFPMPb9Y8VqU51Zom2W4ASwEDj7y57fIVPUUKR2Nqz2h9zOWm6OGL3J
         wAcD03FTyGPcQp1hzSSv1viqWXiwWVfXkNA44Vvu9yq6koRYXp+Vvu8BO+c/hS/VElow
         vF2ftMI3M8fNvDdNrAE6qo0jJHiWSb83ZYM59ZjO+dGOcMYhKeUwYc6mS4HsMcfHuYC6
         o73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ny/c9kdv2CQKS1JzwB/+/xRC48GJg1Jx01zHch9CVbM=;
        b=M/yWOQsDBwLPRyHpszFKrQt8Ew3iexkw/hdd7hy5ceAaLN32GrEF8tZQFsJeqDGlhj
         AEpK2Ho5S5vVIk7p4BDgLomnDvtgapasm/Vy+9bi1LgmFZoY8okuCtyOn650dQ5PFG6K
         RewdjUx7ShwIdbCMbkZj/OtDg3hgAgwtufhZDea3nSkdnsst52kwrUOxeC8OleM12xqn
         1oCgdIP4TwowUImM2IGaZ2HCykOHkzC9IVQ14wdzpfJud5S7fUhxm/pw2KK1jDHSo0/b
         /nZl37eLmLfU6kktfy5yEOBjCtWpkUv05U5YxPn6updDwLoUAi7NLh07JOTxp2eFp+hk
         AUXQ==
X-Gm-Message-State: AGi0PuYA9kExQDtR27A7LP1thdtZAmJQm6qKAeDx/6Xk4bsmJdoOg2QW
        FxrEhRD4/goySwWjiaLyBJGtMnb2acg=
X-Google-Smtp-Source: APiQypKrlE8cM+3CRsElZaR0KptTe1irSupQvdkXTLcG7Cugxkn6rS6xAx9yt2oUxCRA1yKBRMCBww==
X-Received: by 2002:aa7:94b5:: with SMTP id a21mr4625909pfl.290.1586299908140;
        Tue, 07 Apr 2020 15:51:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19sm14157707pgn.93.2020.04.07.15.51.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 15:51:47 -0700 (PDT)
Message-ID: <5e8d0403.1c69fb81.b86f0.1217@mx.google.com>
Date:   Tue, 07 Apr 2020 15:51:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-16-g7211f92806e8
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 1 failed,
 101 passed with 6 offline, 5 untried/unknown (v4.9.218-16-g7211f92806e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 1 failed, 101 passed with 6 offline,=
 5 untried/unknown (v4.9.218-16-g7211f92806e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-16-g7211f92806e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-16-g7211f92806e8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-16-g7211f92806e8
Git Commit: 7211f92806e8855276594b219c3ac1863473cd8d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.218-14-g15=
9a08ef7209)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.218-14-g15=
9a08ef7209)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-14-g159a08ef7=
209)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
