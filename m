Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC22109874
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 06:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfKZFSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 00:18:20 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38942 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKZFSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 00:18:20 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so17715442wrt.6
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 21:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uHeKbIudSxtXd80x+XZSEmzb8rWoLTCsOtw7ruFzyHw=;
        b=Eu+hms6RU6KdxV7eGdafDcxyaJvnFu82Q5trgYNKGj38w4ONEcYc6rbu0X+nXRiwK9
         x8ir3CTxTWE/g7Vy8L52LOQE5NAI0lMulATy9wrFY9vnWq1hFVue0cWEhaoWFaF6TVRk
         ffUSBuDx9/jNFI9S/H77FrhFzDzNFmKjR2P7V8cUVw7TFha2i4unY3nkPseS1ViD9u8c
         SwaYmkUgj49ICS2YG3scXTDW2cmJJSnTolETShDv168gyg+Ny4pHbBQTYKw5U6WeVBpI
         BQ/R1XXOrMpehcCLVElfTwSntMKxMubMrGAGAnK0CnDZYVPn1FiMG0I0ZHphKeCZJJ/g
         w5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uHeKbIudSxtXd80x+XZSEmzb8rWoLTCsOtw7ruFzyHw=;
        b=fJ/aEfmCze5Bd0FIbvEHZSA4QLy7Me21YqOvkDwPj0Hq+npfiZyvhYEiQGrIDbaUjG
         MXNhdkT9t7DwQYUdbdrNN+2Mwh+FUFkwH4Lk6F5PIcYXkqNVMni4PaqFECHjQjLbaIFf
         cD2VyOQwduaQENjv/F3ghl141cOHefuLl0eM43Lcyp4De39lX0Gh1Ody5uO6VTvhsbb/
         ZX+rvyUMEVzWEnsUP90tJr9kJRVcOvh6QcB/zmQVzuk6aNJLtEBJ8dQz8RdXOnJfx93M
         PgzNNEb2GJzfRlre2C2sjtW5UMn6lpjAFl8S+UkDTO/xe/1tbWHio0JtaI7T04D4u1cz
         H0yw==
X-Gm-Message-State: APjAAAWUrV5/4iMaCsdDo0EUs2GPBa/mnq4u67LCivgYvOpihbGZaRTG
        r/fTpqWqCyL2nusrJnUX5BI4beJYp7mdJQ==
X-Google-Smtp-Source: APXvYqwJ318rfguQbfqEhfB50fFxpv3PjcmyxpdNjSqouDeqhxoDExVDgQU8+GzL2MConFg6xdyt/A==
X-Received: by 2002:adf:f18c:: with SMTP id h12mr35468155wro.122.1574745496133;
        Mon, 25 Nov 2019 21:18:16 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j67sm1744327wmb.43.2019.11.25.21.18.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 21:18:15 -0800 (PST)
Message-ID: <5ddcb597.1c69fb81.4f944.7ba3@mx.google.com>
Date:   Mon, 25 Nov 2019 21:18:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.203
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 90 boots: 2 failed,
 79 passed with 5 offline, 4 conflicts (v4.4.203)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 2 failed, 79 passed with 5 offline, 4=
 conflicts (v4.4.203)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.203/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.203/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.203
Git Commit: 48a16935fdcdb0926ed5e743a9d8d238bbc9c243
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 17 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: failing since 1 day (last pass: v4.4.202-159-g=
dbaac4c54573 - first fail: v4.4.202-157-g2576206c30b5)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

arm:
    multi_v7_defconfig:
        sun7i-a20-cubieboard2:
            lab-clabbe: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

    sunxi_defconfig:
        sun7i-a20-cubieboard2:
            lab-clabbe: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
