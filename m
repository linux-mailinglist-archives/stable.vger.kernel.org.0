Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2219712CB05
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 22:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfL2VuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 16:50:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54816 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfL2VuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 16:50:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so12610066wmj.4
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 13:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P6m110nJX7/dBCHpkJRX9xx6DWZACFgL7m+tY6sAWec=;
        b=d7I81PJvBYHoLx1e9xovmUCN/X23EpFMM+8jtG6ZlJ09u4NCs49tOHgx6A5NNUq98o
         gu/j21X7UMdYxIH6jdexU/wBgOppjsb4mXCpxPyPELnai6M1uY7WIIaPqZQWxsLTulrt
         0taGw4WupBp50aZiqavr6MPEoTqGKujDhATN/qlOwKndTOsxnAbwqGSmoafcnTAa/lg/
         SbfpVsYGQY4njeO3ZYh/yiKFLxDrai2jyMgsXN+dfz8n2/F/N9SYI0cLmUkufI7q/EdT
         LMxujSU2tq1YQWobRG2lnh4KRwr6RxpWlPrjrPuLt0dxEovnDLanTbAJZtl+KTckvwvB
         JtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P6m110nJX7/dBCHpkJRX9xx6DWZACFgL7m+tY6sAWec=;
        b=OJGURDtyoI3vyiFqIdXbgTU1YB6L9tUhpoLNIAxSBB/EMHwThkNr68nJDZtQwcjMQz
         siHPtejgSCGFLbJ4ddfFm9vRGTRQfdstutjoO8CjPcza9jesZRS6FoEwgfczDx0Nx+qX
         p3iQrSvH4lLksjw0nKdsiD8B7kOj7zr0tCuZinxxXydXik1tJhfItrmzfYy+Wb7SGsrY
         xk/mfz87WLu5+47Yw5f6PFqqstXBtZFf6xTxqX/fzf57Fe2GDGae///+1sPpEnY1cTGP
         rt8LMzRySdgVVglmALY3ayYB5Z/gDrX2MKnm2cvW3HmOSkg/jOmxg1qEowLI2x3klBjU
         q6GA==
X-Gm-Message-State: APjAAAXMxNCRdTtfLWx00LBfAg+67yT5/lOCBpSCpYUG0gytLT6ztK2f
        f3DT+0JAgHCfSznHr7Qdi7wgDhaBVNmRVg==
X-Google-Smtp-Source: APXvYqyvKiH9v/BLOZEJJtk4phFNNw9fcresN29Kbglp5o3pel9zAPPr+LV4wbJPPZ+uRUYrd5YQdQ==
X-Received: by 2002:a1c:488a:: with SMTP id v132mr29446439wma.153.1577656222696;
        Sun, 29 Dec 2019 13:50:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o7sm18354147wmh.11.2019.12.29.13.50.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 13:50:22 -0800 (PST)
Message-ID: <5e091f9e.1c69fb81.e256d.0a4c@mx.google.com>
Date:   Sun, 29 Dec 2019 13:50:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.91-220-g798b10a6009d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 121 boots: 0 failed,
 108 passed with 12 offline, 1 untried/unknown (v4.19.91-220-g798b10a6009d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 121 boots: 0 failed, 108 passed with 12 offlin=
e, 1 untried/unknown (v4.19.91-220-g798b10a6009d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.91-220-g798b10a6009d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.91-220-g798b10a6009d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.91-220-g798b10a6009d
Git Commit: 798b10a6009db6f4b1baf1b3f76b844b46bfee32
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 22 SoC families, 17 builds out of 205

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.19.91)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.91)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.91)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
