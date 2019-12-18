Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95802124493
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 11:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLRKai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 05:30:38 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:32812 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRKai (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 05:30:38 -0500
Received: by mail-wm1-f53.google.com with SMTP id d139so4301410wmd.0
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 02:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IGHIuKu5f4STC0uxHU0zFD8ipcb5xUwkOE9KkraFSR8=;
        b=14lsxAHIppK1IY+40fRajF0AORJCmRzpoaHIfrYXeNiml4OblgvtRdqNMxjEvN1OhI
         2tumTmVBPGyw/iccY4y23opPPEKqZ4u5aylbcvKVQY+FPZs5uhwztvyPK6cE5o3VvS7+
         s6Y6aTZR5ZF9+sc1OKdriySoV/hShSbB3bgDdZIzM4zbmbt6bZjeAaiJps5TuStEeXqU
         yAEfbh6cjdU+fY0Hul8mEL16lNPOa98e2P97VYVF4VZrypPFhMv+lq3mTSE52q14PsJ3
         JKeZnN6XJMQIw/W5lzLKNP0bhVWDa6j+id13wT3MMB1P2ifm5mAnJ4sMaHM9UjRxXmyj
         yisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IGHIuKu5f4STC0uxHU0zFD8ipcb5xUwkOE9KkraFSR8=;
        b=HcMMqE2BE0LJsP2JrEnd+po+0mnp3ChYUZLj21kqz5BaY/J9j8JRiVa9awi17AHyRS
         t3vF3RP7tFkKjSc29Rgn54OaRRuOggDr93K+5r13j1bYuKaGzs/6TxoLce3MuxQg6cVW
         80TmxqMCv5kHtuapMzg+JEhxgxNw5oaREz3HG96YEdUtr68tzCoNEIQ69gJ4HytKe54u
         zi1Tx1n7kWd5DVSmjuGwiv+ex4pc5EIHwICNN9dXkZXkbUKle+zaunfZtQPkCIQBI7rb
         RYuSTuNBOo3k3gB9U3ZEeDvnd85Zjdy1k+rYq6vAea2ukWF8bIGms8o+iuHYrYptGmc0
         lCiQ==
X-Gm-Message-State: APjAAAUTnpOz/faehPP9CJ5PULYbjf903KR/0DztfswNd34rVVgw/Xjj
        EppDNsL7TtVE/m3gFdyCEWSdJtwzShVjUg==
X-Google-Smtp-Source: APXvYqwbLZby5M5xyPw3PTkJPfgviQ8YOfxp4Hf8b5LyDzbc65nIQKCbTFsTxAi59995RtbigjkM/Q==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr2389912wmc.21.1576665036370;
        Wed, 18 Dec 2019 02:30:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a9sm1989300wmm.15.2019.12.18.02.30.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:30:35 -0800 (PST)
Message-ID: <5df9ffcb.1c69fb81.66e53.915f@mx.google.com>
Date:   Wed, 18 Dec 2019 02:30:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.16-216-g0763039c4844
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 127 boots: 0 failed,
 120 passed with 6 offline, 1 untried/unknown (v5.3.16-216-g0763039c4844)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 127 boots: 0 failed, 120 passed with 6 offline,=
 1 untried/unknown (v5.3.16-216-g0763039c4844)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.16-216-g0763039c4844/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.16-216-g0763039c4844/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.16-216-g0763039c4844
Git Commit: 0763039c48446b647d8619afe0624d6e5c62e4c0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 23 SoC families, 17 builds out of 208

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
