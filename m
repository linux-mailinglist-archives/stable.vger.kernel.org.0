Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C441222A9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 04:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLQD0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 22:26:55 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37984 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLQD0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 22:26:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so1433389wmc.3
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 19:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NoO2MqcLf3CJdIQPMydb7XwU31Yl8UFJH5J5924RBWs=;
        b=HFibry9AdK2G9haMjeK18DJ9qFl2jNd2TNIEdEnMvrU/s+CnB4bM8o5LsVVPPM/6U3
         gzjZLOP/p5QFhtiNc6LzCrLPXhPeNT38aYQaHT2mtA/1rFbu3Mm70sFldY6jbIfmEz4U
         BcMMwJ2HB5xNC/RtNMMHBiz0WGwZCdyqLstfCfzrnMksq0nlVlMgsfVVA3hl7Bxmzisj
         nUCGEiaaWJBzSiXXZBhCGb0RHlB6IN8QRLo1Kx1EiQBtH5BE2C6vQHiH4arqvyAKpkS+
         EAv8s5KknRTwf2cSnzzdCEmttlY/sIWJ7gdwUKAIa0MfhmEYokogEAJylde2vC+oxmAh
         tsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NoO2MqcLf3CJdIQPMydb7XwU31Yl8UFJH5J5924RBWs=;
        b=dMM9gb/vNWZh76jqffTgnhHL/HVnlNBWmJGjzFTGW6Cfe6SobSgC3TMieHv3RWpm8I
         7+iBcQgI+epkA6RR1SCl7Wn6NKxMzCozobxt3VGLzyH5bnVcZpLLZ2H6ntz4rj5GUbFH
         J3vw0BTT5552oL8LFWkx1M2urNcU7xoLj1MtimgWtftGp6T19iHxTIeLxR0+VXeXoapm
         9lnVQYNmHz+ZzdEhHnqKkW2q79qb8vFaayQpk6SBPgif7z18LZZ+WFFx3KvkpK1pPAT7
         oBXAtxNlRraBXr5QxZ6p5d07X1qn0QuEeMIqL17uSjDSs1lFLfr0n+hfmPqNK85G/g6S
         vvdQ==
X-Gm-Message-State: APjAAAX+SkQ7iJPAtVgLXvh1/Rf5aRQCCds67OXDzFJXaedPTlN1REN9
        s0MNT8lceyas+PGuzT+7LpTuNAXSzdU=
X-Google-Smtp-Source: APXvYqys+7IjOb2tIlmtrRDyx1PQRnzDIlrUUN4Z0BKBzqHurC+hbLdPNGLL9H5qT9JEuvZ/SXdzZQ==
X-Received: by 2002:a1c:9d81:: with SMTP id g123mr2633697wme.29.1576553213161;
        Mon, 16 Dec 2019 19:26:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 16sm1426865wmi.0.2019.12.16.19.26.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 19:26:52 -0800 (PST)
Message-ID: <5df84afc.1c69fb81.1ec6b.7c71@mx.google.com>
Date:   Mon, 16 Dec 2019 19:26:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-267-g4ff2fa667b42
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 121 boots: 2 failed,
 112 passed with 5 offline, 2 untried/unknown (v4.14.158-267-g4ff2fa667b42)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 121 boots: 2 failed, 112 passed with 5 offline=
, 2 untried/unknown (v4.14.158-267-g4ff2fa667b42)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-267-g4ff2fa667b42/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-267-g4ff2fa667b42/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-267-g4ff2fa667b42
Git Commit: 4ff2fa667b420dd87cd8f38d0faaf0c574c93a2c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 22 SoC families, 16 builds out of 201

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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
