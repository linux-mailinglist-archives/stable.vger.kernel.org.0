Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9844010DA17
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 20:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfK2TYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 14:24:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54950 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfK2TYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 14:24:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so15164477wmj.4
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 11:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zKFOGVvReS7snIXhjYJa+R5MDyfO8hudxfS0eNKQd7I=;
        b=X8z9MV7nGt7E3lfUKtnBXed9+rw55V4yt+hLoYauXkVTmn/9FApJ95bvzbP82k2cK8
         yzdX5lSp5NkNr1SnG9hGx66+Uf8JdH7zP5yk93nlNR+1OAom0LPZmnbqPyZEiKFPUTVs
         56B44tAywd2Qi6aRPz7SleNgLoccv5kCRD3Mlkyg4sj4VHmC/pNtCmLNB1K00prI7pHz
         LAo8ZtvgDSyKz189jZ5vMa01BQvKrmpQdOvdzYMoNBjahL0zfXe+P2USkrVOBwMDS/WW
         1XHFLCSMp4KTdogDj9QtRdVbpJMmfVOL9kI8UESoSTQEAidu4kLHcAg2JluwAtyo2G+c
         3pQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zKFOGVvReS7snIXhjYJa+R5MDyfO8hudxfS0eNKQd7I=;
        b=BYqKcAQUGmE1G3m9KT5qkFXJr4uBLKqTqOgxKOjKffugvRU4Lq3TgXNk8XeySiKjnb
         taPE8gSB8/Qd2VHC11cN4qDMg1NG+6jlYxNNgzV0KRq9sFLpJOBwdQMRY3SNutkBZgw5
         pGtn9p3w9AUJXOeFgZzBWNMqRw0oEVEDNj0Zxsq2UhmoPEqzJpE2XLjUZIDAbuOk6HLa
         quwceRrXceACXch0ET5cJuGYO7Wm+W/J50RXAHBGN0LU7DGy8VuvnWCGdQVQMUpA5/GX
         ESh9Gy6WX7mKetQLUGHlAT79SkT5XVf9h75GkLh5cfGP/QJDQkV7oNNPHWaNMqSQurLW
         RTOw==
X-Gm-Message-State: APjAAAUTglN2GTtH5OeAH0nQ7jQ7auk5AMqIkdzap9V+pmHuXcp27pJL
        d7Gxs3ZF3jBkMJzZNRcO/bJcSnuiAjlAAg==
X-Google-Smtp-Source: APXvYqydxMc8JxMATR+XZ9MeoPKlKJPOzLZPOIDEi9ltpLKTB1qbChFHb+ZcVAeVKXa+dMF3mX88UA==
X-Received: by 2002:a05:600c:2318:: with SMTP id 24mr16115508wmo.21.1575055484995;
        Fri, 29 Nov 2019 11:24:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w12sm14561300wmi.17.2019.11.29.11.24.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 11:24:44 -0800 (PST)
Message-ID: <5de1707c.1c69fb81.90643.c4b1@mx.google.com>
Date:   Fri, 29 Nov 2019 11:24:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.205
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 90 boots: 1 failed,
 81 passed with 6 offline, 2 conflicts (v4.4.205)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 1 failed, 81 passed with 6 offline, 2=
 conflicts (v4.4.205)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.205/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.205/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.205
Git Commit: 2810f15bcb6e4c1f7663a399488525c219ac45f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.203-133-gd=
7e1aa334904)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.203-133-gd=
7e1aa334904)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.203-133-gd7e1aa334=
904)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
