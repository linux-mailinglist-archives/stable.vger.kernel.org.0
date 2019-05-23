Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8928D93
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 01:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387877AbfEWXFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 19:05:01 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:45829 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387705AbfEWXFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 19:05:01 -0400
Received: by mail-wr1-f44.google.com with SMTP id b18so7943403wrq.12
        for <stable@vger.kernel.org>; Thu, 23 May 2019 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bPH3BKB6YMkWMTZRYGJlA8guuTm5AAVhzev7JKBdXCo=;
        b=FGOruFjdE9ZeKmzTj8M1wAD1uIQBJFZc2cV/lBpWvQ7PJHjF6p4jUtrdL+ul0endx5
         MXjAExTdMm0uVEpGxsOkf16r+gtCqDWzitKfmFqzzjr+k9zN1UOTI4mDc/AZ/l6k3U1v
         GhUic578FOw5KRejSzkvE4c4kgNrQTmzmwAbTMKHJr/sBwz9mQ9V+RfQqX2Ruws4dJWu
         kw6UI+xi1Bh7KhJi+omn0kgHv13aOV0QCTTVkfxIFiNPvEr0VsB/6UEOec45bC3wywtd
         mHhWczEnfOBMJKlj0ikT419FtO5IdPtZ4LyYisJaBpMGuM87uxXaipWqfRzNKEqLDB+A
         F1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bPH3BKB6YMkWMTZRYGJlA8guuTm5AAVhzev7JKBdXCo=;
        b=ACKtzp9HGz/aND3+80k6OQcpPkCX2wHtFj+V8DCh00Ib9FoVoGVTMBVF03k8wEHaFA
         nsjE5P/NYtp04IBX0isX5zbw7jNwITwv3IRbzeFiKT0DO8wwQBb1gnUuF/qAzq2Ywd2t
         9xRiQJf7/gSaJ8xI4xisGtCZvbZ9iOcFvwVsagtE3XWKKw2Nt0Cvtynneaf9V3b5+C2J
         bA3V8ANqdi69YuHAte8FwTjaHsqGLfxdZHWIW7kDzoL0rUE6qFEB2zGhkxwlICzUdnt4
         OOqgcW+Lt14kP9ZTz7VPQ5kbiFu9WsFZgoQG9ObugPpP5JIt6AGgUvd6bUT2syFe++dc
         xNgg==
X-Gm-Message-State: APjAAAV0h86YQIlOd8lyEsOyxQa8yVzOU9AmUwgMGFtmt5BomF12EY3W
        RjDFDlSAyJZGHb8UeCjl31CFLafkO+lD/Q==
X-Google-Smtp-Source: APXvYqzhVSxExuZ75Zwg3xDrOkHUrdX6AlW925UhksVoq+R3osMpoU6a8uFvUwf8FbBrJWGlMN97pQ==
X-Received: by 2002:adf:e8cf:: with SMTP id k15mr3340187wrn.185.1558652699803;
        Thu, 23 May 2019 16:04:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i27sm1617286wmb.16.2019.05.23.16.04.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 16:04:59 -0700 (PDT)
Message-ID: <5ce7271b.1c69fb81.5e16c.98ae@mx.google.com>
Date:   Thu, 23 May 2019 16:04:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.4-123-gad8ad5ad6200
Subject: stable-rc/linux-5.1.y boot: 138 boots: 1 failed,
 121 passed with 14 offline, 2 untried/unknown (v5.1.4-123-gad8ad5ad6200)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 138 boots: 1 failed, 121 passed with 14 offline=
, 2 untried/unknown (v5.1.4-123-gad8ad5ad6200)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.4-123-gad8ad5ad6200/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.4-123-gad8ad5ad6200/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.4-123-gad8ad5ad6200
Git Commit: ad8ad5ad6200a933bc774415620bb31dd8b2da66
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
