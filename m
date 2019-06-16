Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469814757E
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 17:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfFPPYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 11:24:16 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:52015 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfFPPYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 11:24:16 -0400
Received: by mail-wm1-f41.google.com with SMTP id 207so6745033wma.1
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 08:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jbUHQi/+CbUxqlnHkgPH0nJsxHMo5sZPDOW2zXjqprQ=;
        b=BMSaA+VFWKUdedJ9wkxaTe/C3jaq+25qnsrlFMwIjx+tIUwyn4VoB6dNaW8tT9VCga
         zCeTk6Se7vVJqQKizeeUYP79igVqNDfgV4ydWeD4slX9+XNh//JIE6DHIpgJOQzoOteg
         AYmOS8su0hhaNLqjqzYY9ymDsk2J6X6xL92yduzGUdNSBrC/gb4DBFEgkGBH2Jj/akoe
         oBkyxfyYwK0gpP6XfNpNS72LN+JG4VQADQ6vcZGNlvm3VpoQ/05AatwGqtKoLv2uGLNY
         WDoIBwhWOtcSyukyR2zj4cO+qOBLdOeQtBjRQBdWNLXr/aSNZJ/pSGG1RccXZYyqKh6L
         tdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jbUHQi/+CbUxqlnHkgPH0nJsxHMo5sZPDOW2zXjqprQ=;
        b=nHDET8b/rFDY247FGujkw/Keoa4L8jInRAc7l4U+uS59fH0tbSBrDtdOyM+LGb1dWh
         RJxHrKXDR/iksw7oJUUVLLlOi/A2KBBe6vBL60sGrTPvrjoZrFCvJP8HJm418WZ5GuJY
         vGpiWP8XyIX+NNeVn+ic0lWfWY1jUdHuEv5IwQ3zqKK9DDrSVf59iNWTtTkq94YzMsFA
         eouZc0qLWwRw2zK5Mt1pxfGMd8XwM2GP932JzeLVjr2lJX/sqMtH4ap0kEOxu9PAeNLW
         BD75VHbf1reRouX0Q3fseCQOB6ZPb5JSAfKSvJ2jW0wMv28EBI8WaowCJjgE7pqt5+U0
         palg==
X-Gm-Message-State: APjAAAWi1o4H3h1KQMk2PcS9T4pIQz0z86Pyd3nK/IsB2OfPibSg/fBS
        FavxlWdn6KX85zfe1q7+O8gweDcEhSY=
X-Google-Smtp-Source: APXvYqznxH9tAOZm6WDRLIQGm8WQwoqiZ9K3kyn0kivbIO3PY93omlcSgBDs8bUnjkgEGkv21f+w/Q==
X-Received: by 2002:a1c:b1d5:: with SMTP id a204mr7295676wmf.101.1560698654608;
        Sun, 16 Jun 2019 08:24:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j18sm8538232wre.23.2019.06.16.08.24.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 08:24:14 -0700 (PDT)
Message-ID: <5d065f1e.1c69fb81.b6ea.e8d9@mx.google.com>
Date:   Sun, 16 Jun 2019 08:24:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.51-66-g386f89f1c10d
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 89 boots: 0 failed,
 76 passed with 13 offline (v4.19.51-66-g386f89f1c10d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 89 boots: 0 failed, 76 passed with 13 offline =
(v4.19.51-66-g386f89f1c10d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.51-66-g386f89f1c10d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.51-66-g386f89f1c10d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.51-66-g386f89f1c10d
Git Commit: 386f89f1c10de3433c6ba8db1443d0a79eb19653
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
