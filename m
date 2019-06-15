Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE75471C5
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 21:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFOTKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 15:10:07 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38458 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOTKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 15:10:07 -0400
Received: by mail-wr1-f53.google.com with SMTP id d18so5813183wrs.5
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 12:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+6ramrIT3rwWn/NiUcfW2+p/nNXLxkODKt7NRo676y8=;
        b=mGnXhG9rP5ISKZ8R5x5TBke1aJusbm4G4JUGlXGeD55xlCC+kbaXI1e6gIufkPQGhY
         033FsY7koswLCqfFTqJGVe7S13cP+Oyn+sT627UJXodCpJAhaOY9Rs6jpUSXixDC19qs
         QHyaiI0vriWPBWdS5msSUvfCCVQ4Jh3OszehDzPH0j/sNwta8xkjsMeJ8Dw8/9DgtW3Q
         2tD7eGe9S5HAdYabBtiNt7rDPKUTaUZWg1haFvvSpy8UVRcNFvQPZXoGfXhmPQi1VXdh
         s2XjoyqJZTgSzpBSWYHPKq0FWXV3hru7faX/mMwYjgHyGWMgzmEKjFnLZpL6Yy+JBBb/
         1ORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+6ramrIT3rwWn/NiUcfW2+p/nNXLxkODKt7NRo676y8=;
        b=mo5w6V7am/GalzbZyx4nstaPrzFVzyEIpftoeozpIa5nggpIExcITM4TlOg9oHkbZj
         aLyWSca00egcDYvppzUc7FEmz/U2rd7IbGiXgGiXfjY6ut4Li3Meb0A8sOcKeOs/o45/
         Y0oyEXkd+umnd7d3mlF03baLmPE6xy+SRXsZUhdqU6ns+5gOXMkXseOIO4hhWi6gv1Mx
         E+VXFgCgIxJ4l7wbD2xdQJPZCtT7ZuSDuTlQ4P57YNjvHiuZatHbUmqPXTBXWdvv07Ao
         Dw4EuZG5G16QVL7kLZXZKr5hEPryy0DwF1dmfPNcdzTPcOUns1Aw3+implM5gX5b8a64
         CUuA==
X-Gm-Message-State: APjAAAV/VRqmMmt1rJpdtL2fKU0yC5qhbYmUcXgWIw45LTimzC/ueZ89
        TSW+tXoID1tbJ/x1FkhGEahivQPXfcwSFg==
X-Google-Smtp-Source: APXvYqwO5wqTQ4tC8gAaYjsdWEmebqIyEhM8lw7DcF8VMLHlwOSABt0P61c/zZUo1rUiiOWyQbbQ0w==
X-Received: by 2002:a5d:6acd:: with SMTP id u13mr23377040wrw.154.1560625801617;
        Sat, 15 Jun 2019 12:10:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r4sm10615433wra.96.2019.06.15.12.10.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 12:10:00 -0700 (PDT)
Message-ID: <5d054288.1c69fb81.75b45.8b8c@mx.google.com>
Date:   Sat, 15 Jun 2019 12:10:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.51
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 110 boots: 0 failed,
 97 passed with 13 offline (v4.19.51)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 110 boots: 0 failed, 97 passed with 13 offline=
 (v4.19.51)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.51/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.51/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.51
Git Commit: 7aa823a959e1f50c0dab9e01c1940235eccc04cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 15 builds out of 206

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
