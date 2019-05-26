Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95FD12A773
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 02:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfEZAW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 20:22:58 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39785 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfEZAW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 20:22:58 -0400
Received: by mail-wm1-f43.google.com with SMTP id z23so8377946wma.4
        for <stable@vger.kernel.org>; Sat, 25 May 2019 17:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BdEwkpzSlo9MYztY/x/28wJM0PuNhvoVd20TWzmnnzo=;
        b=Hqa6LNY3sUIT0Tm8AxUxpvtgcjrpe4DAPLbrulUo6pIfw5lnhYcbKV5SiFmPLL1FDE
         8+6bkZ8rFiFjLf+oHs5Lg41npXvFv7e+61FJDq1hYRgPmj0OEWI58420q++1LICVkhQx
         TZQOWD3rKov8F0XsXj21vBceyC94W2l7+K4yJHUpPiuUSsEh9b05VEXENAQewbvIFGN5
         Kl5ym70++8BCTgBYwnsk+uylLk9ME5zPvvcZyZakHrLmuKbg6tNgosqlYMHhZTJ6/tm/
         JyGOoYUSDNfwil4hNSQkcXDfmdcO3zGbcIGmy1w/9FBYDUNjB8WMj0BvOOFvTyGe75Iq
         OgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BdEwkpzSlo9MYztY/x/28wJM0PuNhvoVd20TWzmnnzo=;
        b=Geq5fbCSruWDJpVq1oCsEiFQBnCrMlvtFsCJ03gXrbDkKr1QqLu/VVJJKCzTcUKEwX
         j0CHsMe22FB/iy4F+v0nL111DDYorDSjV9e2EtjcRxdI8InphOIRbIp6PVUohEdmLVms
         31XrqFhGOMkZtDbnIDrM2mJAzFOzVX6EbnuGu2wRRgbsMwTYfH5KCzHryfYEIm0o4fAP
         sk2oB5kjHZNKTQyumc5RDXtEoX+/PGrPHys/3VVPfgWn8sI+tb39FF9SAEIRT/T225Io
         ABdrARQdUnS+jft8+HIKR/DYsL9L5YU8xbaRU8p++rXrsZV2CkuWsEpXTk7bJAKK7lkb
         lfpQ==
X-Gm-Message-State: APjAAAWYrevrkeBGBYC9ANTHFe5ECymW6DdKBvhenBOsr9ZR0PvBWQef
        O9ntLZZvviWAxvV+xcxdtHcw1MoCqHg=
X-Google-Smtp-Source: APXvYqyOYI30s0EjVyI75zaYit98hN+1jbVMGYwpFPKX3Azx6yOiLnDv3G7/aTbPzrcyKvy5jV0Heg==
X-Received: by 2002:a1c:c907:: with SMTP id f7mr318105wmb.142.1558830175961;
        Sat, 25 May 2019 17:22:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j123sm12557493wmb.32.2019.05.25.17.22.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 17:22:54 -0700 (PDT)
Message-ID: <5ce9dc5e.1c69fb81.6e6f3.6e6b@mx.google.com>
Date:   Sat, 25 May 2019 17:22:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5
Subject: stable-rc/linux-5.1.y boot: 129 boots: 1 failed,
 114 passed with 14 offline (v5.1.5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 129 boots: 1 failed, 114 passed with 14 offline=
 (v5.1.5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.5/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.5
Git Commit: 835365932f0dc25468840753e071c05ad6abc76f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 14 builds out of 209

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
