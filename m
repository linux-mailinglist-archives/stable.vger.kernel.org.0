Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C21212CB2E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 23:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfL2WiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 17:38:25 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50761 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfL2WiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 17:38:25 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so12702990wmb.0
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 14:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1QD3DP3vzNPfNcy148Xk2nziBNOpYNQGlmQ/0wHU2qs=;
        b=0nB2Ieazrf7nMDqSZkRJ1Cia6zQkld3qXM3P/6ijJ3VavTccBncODRd6UdFHz2C2P4
         nQLnqCBbXXy6xTK+wam3Dt3DqA2M3X87oW7u1JC9NgbUo2VuCW5Dext0C9OGR8HHqS0E
         yUNVEdtC1UIQyPL2uy9TMdKqoqIMA7/IKZ6ZeqoGGeHsmINaxPv5t1qFB1tijjWNiGok
         e6L58gTPD+0kvzUCFe/7r11fdtL03MYgv3O/OcseTARIBBX53LniUDIth9JyAb+zFQaj
         hTVXOYKhtYmfVyWXZzIGKk/LG7RJDEKSFJIJrRxugnDywWupYBQs+bo1Mslf8g+H+u46
         jQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1QD3DP3vzNPfNcy148Xk2nziBNOpYNQGlmQ/0wHU2qs=;
        b=uYLqLwmI/orLNsD3bjhILEWhsxelOqRu1JGI1K2YoRfKzZpfz6fE0Hh2g1mdFoEr+p
         8q6p3GI+3t7ozI2GWZIX/daqsBbDwUjuwEQVDRHIcF1VmUQZdgu5NuezBwh0EVArkJLi
         WSCv700nQr2N4+qGvsvBSNc7mmcqAdmukdlPdRSihZhIMan2xzCxR21qGaifrorQxF1f
         5fNoG6X14qre2kVNEBBynCvaQVtlITd1phs0WOjVQEZGMJkjQKvA1kb6YOciPNrJI/2h
         yKJC+75IiRaEejV81GpkXOUPwKQNA6MAXUc4GvidhouZU04Vs5K42uYsgQ1fzWZxULj/
         IkTA==
X-Gm-Message-State: APjAAAVcZImXsA1W5dLQtHSxo/U7kEpoelVliUZdkDFMwto8XmmYa9pb
        eiAH2KmJ0b1uObvHXgTaEtLWkla9Y0upRA==
X-Google-Smtp-Source: APXvYqwcOiqWWM/RMKp0+1MjOinLaFdok341SI9AooxPBopHJhH0tEuKIuhOmTiKjQhYzskKzDTh3g==
X-Received: by 2002:a7b:cd11:: with SMTP id f17mr31634062wmj.48.1577659102908;
        Sun, 29 Dec 2019 14:38:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e18sm43662412wrw.70.2019.12.29.14.38.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 14:38:22 -0800 (PST)
Message-ID: <5e092ade.1c69fb81.825df.a7f5@mx.google.com>
Date:   Sun, 29 Dec 2019 14:38:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-110-gaf5664cd41c2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 95 boots: 0 failed,
 82 passed with 12 offline, 1 untried/unknown (v4.9.207-110-gaf5664cd41c2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 95 boots: 0 failed, 82 passed with 12 offline, =
1 untried/unknown (v4.9.207-110-gaf5664cd41c2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-110-gaf5664cd41c2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-110-gaf5664cd41c2/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-110-gaf5664cd41c2
Git Commit: af5664cd41c220ec7cbfb604852207264fabe7b0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 18 SoC families, 16 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
7 - first fail: v4.9.207-106-g8425bd2da54f)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
7 - first fail: v4.9.207-106-g8425bd2da54f)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
7 - first fail: v4.9.207-106-g8425bd2da54f)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
7 - first fail: v4.9.207-106-g8425bd2da54f)

arm64:

    defconfig:
        gcc-8:
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
7 - first fail: v4.9.207-106-g8425bd2da54f)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
