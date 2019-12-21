Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2564128A4D
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 17:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfLUQHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 11:07:20 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36708 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUQHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 11:07:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so12313538wru.3
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 08:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JkuxCwnKXGQdvV5n5ysDFfy21o6pXkH+n/JP1j0/XRw=;
        b=xl2t9GGSwxXGZnyq01KskgwOPRWP/JVko3zfS+NaxEJfFnkigeYRXISstx0tWlXSff
         CwL+tHWnVWjG4Y7So/HZDr3I/TBtxk52mIEkCMxJQDgsae6oWBSk0OSKqkCzm86jMloV
         xY/pcj88FL+TEGP/Pr9X3M2aBGZpljucom6C3mkXoFdGzpapvUxw70PJ3r7xA2AkslFj
         8DKrXYXTo4k9RkpUnbPdBjJbfBHtFSzspmDyjuKLr0vAvdjidP1TyVPlyanKKHH8Mh91
         hVdwHmNmfg2Z6IMA9tPGZiJepWxuhNGLJcqwaNjEj2S0u7z4aQFfqET8yCk2XdX7yyu7
         2QEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JkuxCwnKXGQdvV5n5ysDFfy21o6pXkH+n/JP1j0/XRw=;
        b=Il0VMrXrmlCHNOHFZakyAZm6XJY8J50ZGjefmOXH98kSmnW7VO7aGFUyKj+aF90CxP
         2mpkXy3DBGO/b8IFh9SXoU+Pw64DY95sdEJNEIw5LNBfZEXbrk2IoCC23UL8KYHlPAjR
         bgt26za3c3x7tzMdaNYR10OciR+YE6NhRRLLkh/v167z9BiU8wstrAUYo0yNWKip1wAh
         sa3cA9h0WYilT8aXeW96eDBBJYQjPTY32vAYNHykX8iAh8z0jYwv0/m82rD9+beQbAST
         gIcNcW5OI9bYRmSOK3QgNorLGGeb5zks+NDgzKOp/0woSaiua/2tEAu57v5PTF6Tx7Il
         88wg==
X-Gm-Message-State: APjAAAUpQYCsHzj3C07tDiUc6a1qW4DqX+kLPBcIVMJCd7fXGt5EmRpL
        gwXuxZImc+eBSE+pUmyYlG1U48G1JCepnQ==
X-Google-Smtp-Source: APXvYqwUfLS88YQRxqpCGTm7Ch/+dLnVdyjZQtSW5DyFr0aEsN9GDvgsMd6kxqmwQ+U6e5k80R8MJA==
X-Received: by 2002:adf:e5ca:: with SMTP id a10mr21071970wrn.347.1576944437671;
        Sat, 21 Dec 2019 08:07:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t81sm14385790wmg.6.2019.12.21.08.07.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:07:17 -0800 (PST)
Message-ID: <5dfe4335.1c69fb81.fc0cc.7c2a@mx.google.com>
Date:   Sat, 21 Dec 2019 08:07:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.91
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 131 boots: 3 failed,
 122 passed with 5 offline, 1 untried/unknown (v4.19.91)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 3 failed, 122 passed with 5 offline=
, 1 untried/unknown (v4.19.91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.91/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.91/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.91
Git Commit: 672481c2deffb371d8a7dfdc009e44c09864a869
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 22 SoC families, 16 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
