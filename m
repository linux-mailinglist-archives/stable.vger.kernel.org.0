Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D779F908
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 06:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfH1EDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 00:03:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55800 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfH1EDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 00:03:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so1155262wmf.5
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 21:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WZUECIFBeRtT+xP+S9WlDdtALHliIxx1WeADt4yn5yk=;
        b=RWZdKscA4TlUB5xLfSJHpufjPwOhaarC4FvSIOH1Aed9lHO9aHbVosN2QAulYuddZX
         5O5D9pQ+jR+u3/m3uhlzNYkxRdPg8+uA8HXl7uViKDRltZwP2Sk98SJZLtkt4u5yVtc/
         X/T+BD/PklK0lr+UEh4hsZtSuU4UhUODQDQLbYK2waMh3Vk3AAtTT0LPnQd3A4SLTK77
         e8xc+e8PWdQstOmpWYfdPXlZtbXw0mDpdiyIlsRgdRL+zV4Wo98Iji3fafykhLz1JTlU
         R3KXLs4prAm5KjWNEdRw1RaizXWqYeISHNwH4+8h0pX7o2jNaJApKGjUfbpxg/iAt0nf
         QMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WZUECIFBeRtT+xP+S9WlDdtALHliIxx1WeADt4yn5yk=;
        b=D7fMXBJTWiPxUcJ3f32VoYFMSnodrEEgF9mME9IjoeF0HI286Pv+CtVeUtb/dQRFex
         2FCOnga+5PFOt8ZFz6JXRFA4W7aKPWASvlxfMNVO/G0lX9n3MIvfuEQPdPkkFhvVTp9J
         pZKiHDG/pNtPkf5wMcNVRPBHIiMie/rCOIh/6Wh0YNxGxxA1BptKc4nsCp06e3l43nZ4
         2FkjCNiQc9pOALath/v0rPP2/Gth3WSNxtLvqHkch1xFCQVTSc80YFOalObRbXSPnDdk
         v+TwV3MyfvCGY4H0HiYMPPhY4QGFSaUnh5dEyGh/JNx3OO1A8tYn17hnRotPYv83vAjW
         hscw==
X-Gm-Message-State: APjAAAXAKyZnIwZaoIgfc6Os7wMRfGUmeUqqBJvxP+AJDeLLqczg/TZb
        6i/MRHyTyX4a8GPdUzhpWxhxy19ScjdpvA==
X-Google-Smtp-Source: APXvYqzJuq0cirY1ydUK2gKBHxb33IfEkXy5BFFC9HKVxzNZ4cs7T4bIgceYjqKAOafuZuZS1ULlBA==
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr2047055wmk.52.1566964978175;
        Tue, 27 Aug 2019 21:02:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b144sm2089151wmb.3.2019.08.27.21.02.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 21:02:57 -0700 (PDT)
Message-ID: <5d65fcf1.1c69fb81.72c6c.a959@mx.google.com>
Date:   Tue, 27 Aug 2019 21:02:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.140-63-g4e1a19d20000
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 125 boots: 2 failed,
 112 passed with 10 offline, 1 untried/unknown (v4.14.140-63-g4e1a19d20000)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 2 failed, 112 passed with 10 offlin=
e, 1 untried/unknown (v4.14.140-63-g4e1a19d20000)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.140-63-g4e1a19d20000/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.140-63-g4e1a19d20000/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.140-63-g4e1a19d20000
Git Commit: 4e1a19d20000330e767ddc9c64317d7d576a8f31
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 14 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
