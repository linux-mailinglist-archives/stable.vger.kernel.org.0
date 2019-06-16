Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22D54755B
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 16:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfFPO62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 10:58:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37952 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfFPO61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 10:58:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so6524704wmj.3
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 07:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HSWalyWLVPMMiEtDjRUVCvfdBfOuFKUq49VxpjBPf1M=;
        b=HVsH1QlaccJAO8AgdwJgba8vlE2cSsfy2v5FFSChLUWIIXgtiIAjirB9D7lapMA9es
         3mBV08zwrgN/6NYaJh8MKnLYlSK4f26SXnFAkl+gbkfwNkoS8pw/WTSbfH7C7D3ZgcRm
         KkDTj8Rm5M5T0l/kgQAWstW5t2nTx1TOP22ILhBbsFEytn2E1Qd4k2HKY811swJVYhL9
         f8jhbX4KSl10W0QtB1x2HC3dTZ1yLF14HPlkXuHb0TsaxxV2YIsDdHZCoXVbLQevOXe8
         vE7goH1SOcPWgFJ3ek9hy8m5SCK/S80xW/3TnAQWTv9FEwgQikV465ml8IZzsTK/TFX1
         n9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HSWalyWLVPMMiEtDjRUVCvfdBfOuFKUq49VxpjBPf1M=;
        b=Ve2BC9xtz2LhgIhSD88Gq7Rl/aiqLpddrom7nN6zScRRBs7CpYG7FZw7TkTI7NHMi4
         L+xIVewiy0wSEaKChSnNGAYSsXvgtFPgoVz3N/xqg3xUaDrNJLhDzOX3q6FiTmdvfFCC
         +yfj9EPM+G3OLiq+yY9USNL0VF8YDprXAT/HYqJHQ92qh73HLtGgjjStcDLaX/4VIpu1
         cvsAgErgJcW6mkG8nJfYk+vFL90nviwYQS/Xg6NZDsiNBcUjGe3hlYxTGiwedKLGeoFs
         fPR0UxhxkPNM2E5ZTRFVcqF+rV9vQ9pt62myTTpzUicxGk4nRn8wBf08NZHuwQWPRKcv
         FLYg==
X-Gm-Message-State: APjAAAWl6ZZuFB7VJM82lWlP5WAghDsJP3DTKH4FdOxgMvLS3rNjKYam
        klkA7D3L1Lr8tcJcCjL8WwRaOqdh4jc=
X-Google-Smtp-Source: APXvYqwTlUVYdTi8pQp9IVnTHE3w561lNHxWDjpQysnwZyCG8JUNr29UbS8uQ41N1g97ZtQm0ocUDA==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr14868454wmb.119.1560697105540;
        Sun, 16 Jun 2019 07:58:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 139sm10622231wmb.19.2019.06.16.07.58.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 07:58:25 -0700 (PDT)
Message-ID: <5d065911.1c69fb81.c6f33.8671@mx.google.com>
Date:   Sun, 16 Jun 2019 07:58:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.10-104-gc8d95d423536
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 97 boots: 1 failed,
 80 passed with 16 offline (v5.1.10-104-gc8d95d423536)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 97 boots: 1 failed, 80 passed with 16 offline (=
v5.1.10-104-gc8d95d423536)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.10-104-gc8d95d423536/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.10-104-gc8d95d423536/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.10-104-gc8d95d423536
Git Commit: c8d95d423536de7e13f3aaf744cd6c0a79354a72
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 22 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
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
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
