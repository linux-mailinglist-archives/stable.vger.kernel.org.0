Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD81BB5E8
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 07:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgD1FeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 01:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1FeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 01:34:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B955DC03C1A9
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 22:34:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c21so7082644plz.4
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 22:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6i2T4Ax7MGE8alPtxskG/YrcCeoEjd9LFaUlKkqvEcY=;
        b=iMtuS2cOwWgb906Zb3wBgpQt2WwTC1ElpTPDxASIlz/frKSb+oz9+C8bS4YehfU1hk
         Wf32G3bWLkWso0/YpgxBfBySQBEO+24FTR7pYh2oRnDaHEW7EREiJlMQQBfqgDyVW/0k
         30aIJyNAyrFWYphDx25xSXD4o6opyzjOY5STRpGxH8pno9z2If7Zen5o3cVNeIsofSpu
         ba3ZLJruUtzeZMyv5lpad4/P15xF9R3HcNHIhCnS+Ub9As84oyAfaU6xV5gg6I7kWPi+
         dvDxipHkIZOcsrslgWMhXqTl5n8diep01rYqWuyjkpT5AetvyOK0ihkBpa/k0C3gv+ji
         GBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6i2T4Ax7MGE8alPtxskG/YrcCeoEjd9LFaUlKkqvEcY=;
        b=TONfGvy+x1JPh/l6epunhrISjYcBxfvhdnnPxHmOCrQIe/akkWY1J3kqyGZRYTNcil
         yr167Ge/DISeEWgb7bzVyulZK6LzxSrSJ/1eJ479AOYeribDO0tyCoQ/cJ7kpxi2DEXd
         TH90zlOKqdN0wH0iTmlgqA+RnicWduo2yOtn4UanSUeslo/NWlO/ijkgwuZFFOsoLcRR
         Aw85kf8M7UCJOy0G7or42MOYFt9jOIK4qUVzbAFE8Fl3Z6ByWNvgKoLjS+lgr47o9U71
         pc1YGpjIFEGcjp83mmqD3B2CE5UtCdgZQ5SOYIYv2r7Ff+zOfITg2gNbDtW558BvwHAQ
         ISzg==
X-Gm-Message-State: AGi0PuYuAZFTgLXiA4jY9cgzIMp142aC6Y30OmL7UMot49YgLeynpf3f
        rRHZIM4YfR1X2ltNMucRmrDaJHvPoNA=
X-Google-Smtp-Source: APiQypJoRPa72uUzPlWZRE7bFbv0xQB8ckB6iIhRSPGkvfRyEM7sKa/e4XuGFqbmwuc4FsCo3UVozw==
X-Received: by 2002:a17:902:ec04:: with SMTP id l4mr27170324pld.6.1588052042767;
        Mon, 27 Apr 2020 22:34:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm14006519pfo.67.2020.04.27.22.34.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 22:34:02 -0700 (PDT)
Message-ID: <5ea7c04a.1c69fb81.854fd.b5c3@mx.google.com>
Date:   Mon, 27 Apr 2020 22:34:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.220-59-gc20ade302372
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 115 boots: 3 failed,
 98 passed with 9 offline, 5 untried/unknown (v4.9.220-59-gc20ade302372)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 3 failed, 98 passed with 9 offline, =
5 untried/unknown (v4.9.220-59-gc20ade302372)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.220-59-gc20ade302372/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.220-59-gc20ade302372/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.220-59-gc20ade302372
Git Commit: c20ade302372573d691ca4acb962b8a04958a5cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 19 builds out of 188

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.2=
19-125-g01b8cf611034 - first fail: v4.9.220)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.2=
19-125-g01b8cf611034 - first fail: v4.9.220)

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.220)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 79 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.220)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.220)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.9.220)
              lab-collabora: new failure (last pass: v4.9.220)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
