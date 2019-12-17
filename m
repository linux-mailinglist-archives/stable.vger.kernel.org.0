Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52413122144
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfLQBGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:06:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45864 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfLQBGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 20:06:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so5278670wrj.12
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 17:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Aqwe0XrZwEIDl/aIy8vAUrOIrgca4SXyTX9kvpUKiZo=;
        b=nNdZ5FPOh2eCAR9nX3oh1A9ujMCVkcTS6eUByTKf5pF9a7GjoNc458TJCIBkZqk7t7
         c2NyGwAu4wsuZh2LLOnh4KFR6VMiSa+rK7U6bIyHup9hBJx3kHuFssG1XVDqoXwiVFtQ
         W0FPZdC9h72rfRwgmtaypYtOgkSh7sdcoy9iVCvbf9tSYIbUpz8MpUtSBp7ff3ECo85X
         zJJyiiiNgR835XNuqCBvmbwmvNr5U1k5nTQ2hkX8rSbAJAZ2FM1SZ63WBURiHTCMHpTc
         cFKeF9RboU9OHdu0EsQFbhp+TOKxZbOqINLmaZiaa6D7vtsgBEcmf3QBA0tL9mKs4jpX
         X/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Aqwe0XrZwEIDl/aIy8vAUrOIrgca4SXyTX9kvpUKiZo=;
        b=bAPoOqDPnL7pQXv4REVQWXMYUQpmnXafxrv6PP57WmzhWc7xk30GpAvJ3C6kgP0ubH
         eSW1XFoO4mVLiDPCwyK/MJxHgQ+wui9a5C6lzelzNF/SedheLIOd5gaqCJubic1VLNl4
         RZJrsZt2Ys/npSuch+undwjP/59tRSFLHH6bt6GWVCrE0P4eNunk6sxAetVba1fg50o8
         tb7ttdJfECurRxtunB9l+gNADU61gc/Wk7yrxvWlBBUpU1p4quKZ+XFtMCF0J5l9VNny
         bkrQ+e8w6L69k5Ecx68uA+ETk0V3OnBxvY3I5Se+HJTStvuT4zsDUa0/63/ouKbgt6wX
         9qDg==
X-Gm-Message-State: APjAAAVLs9F9mwUz3LBuorJv+4bgzIS52HfXD3nXryKgTosMRD8IQ3UR
        HxILra057A2l61CfFrPfgFYcxsqGO+M=
X-Google-Smtp-Source: APXvYqxoUmJx7DbzSWaZz1PsloAz0z0mGRUlOZdGtudw3deGGT4QiB1HbRLz1Dj9ZvbuWjLK+H0swQ==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr35391424wru.6.1576544767572;
        Mon, 16 Dec 2019 17:06:07 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p17sm23584620wrx.20.2019.12.16.17.06.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 17:06:07 -0800 (PST)
Message-ID: <5df829ff.1c69fb81.2b3a8.a36e@mx.google.com>
Date:   Mon, 16 Dec 2019 17:06:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-170-gff21b0f1e5d1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 96 boots: 2 failed,
 88 passed with 5 offline, 1 untried/unknown (v4.9.206-170-gff21b0f1e5d1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 96 boots: 2 failed, 88 passed with 5 offline, 1=
 untried/unknown (v4.9.206-170-gff21b0f1e5d1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-170-gff21b0f1e5d1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-170-gff21b0f1e5d1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-170-gff21b0f1e5d1
Git Commit: ff21b0f1e5d195d3cd7ef385f64919802f0f6ee8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 20 SoC families, 17 builds out of 197

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
