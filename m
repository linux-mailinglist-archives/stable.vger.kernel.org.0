Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DCC7D1CE
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 01:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfGaXWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 19:22:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35608 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfGaXWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 19:22:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so61353674wmg.0
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 16:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=warpKx3vjWCVhJLvo1H3p3xyBbFi1045P98FswmUzEY=;
        b=pKEPK2b16v5SsFEzrKq9vdWs7elbQ5j840y9MKqKRLIjLqGsGyy/xVmQtR5ks9FZ49
         FBbN+iVS7IKufE8G8TaAtpgAsKIqPbU9TbT0g1k93YDSUFHj25Toai0n/ra4WEL5vtao
         2Ty6b/IdWYVeUbpTrooyM2hWgb0R1+Gcz02ejjCp/6cR7Vij1xz/XJn/8gpNu2FEaeWF
         raOjkvecYh0/49x+H3QkDYDecRfzAqVpKwN7/kqvP6ukLMlQrlS8Q+BG/J7UNZyOkS91
         X5/aQNzHduwmzt2LCYoC1Zm2LgX9tYAn5ENH0zchAc09+dMJlER4/XITUN4S0jAKk5G9
         LxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=warpKx3vjWCVhJLvo1H3p3xyBbFi1045P98FswmUzEY=;
        b=TJb6MGxdh4FyY5QYCxBGu0kZ6ImEhKPTMy4rLqdm8A1vkJl5BfQ8WFz6Q3yV5n0z6w
         QnCofkqT8kywEzvFnew/WcPXk8KydEtjsVXcNi3XE9/yGtV+R+HaM9/oiABaX4ehjZtL
         KPaJSI7He3cKzXTLW5hurBPdpVCDJULRzJG08DEmRkmH8Qh49QxIjWaBS3+67PjY6Wj7
         tH2JnuSpE7J1EH5wAqrwcs6XLjRH5lb2KCVI1TCV+JvsClvrmLKLb9+Re4nYgJAcZFp9
         dC3Y6wRc40Ayko+6o7IVYuOUKUsge5xCwbpl20I+ZuH75Zj8ULekF/tfQHP3Ne05xBKe
         0WYQ==
X-Gm-Message-State: APjAAAWXD76Ax4lS/8HfVhzqe+WErUDUdvsDUJKce9xg7xvne2FoHlWx
        /a26uhC1/SmumMP+EM1C3DQxVc6Q5ac=
X-Google-Smtp-Source: APXvYqyeBGk6Nkf2gyF9z+YX6Z2MJmf+tyM60QXrY9LbJfutdIfaS+Cnt0zT5tFKVXHPeGfwUJHqeQ==
X-Received: by 2002:a1c:f918:: with SMTP id x24mr11713075wmh.132.1564615341442;
        Wed, 31 Jul 2019 16:22:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm80731240wmf.8.2019.07.31.16.22.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 16:22:20 -0700 (PDT)
Message-ID: <5d4222ac.1c69fb81.85fd7.20b6@mx.google.com>
Date:   Wed, 31 Jul 2019 16:22:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-155-gad906964c00c
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 2 failed,
 56 passed with 32 offline, 1 conflict (v4.4.186-155-gad906964c00c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 2 failed, 56 passed with 32 offline, =
1 conflict (v4.4.186-155-gad906964c00c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-155-gad906964c00c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-155-gad906964c00c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-155-gad906964c00c
Git Commit: ad906964c00c39ecfda2b6822bf62036c855962e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.4.186-152-g312c583f=
6950)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

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
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
