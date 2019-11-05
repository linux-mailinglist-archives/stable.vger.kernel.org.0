Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83B7EF593
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKEGlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:41:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36932 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEGlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 01:41:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id t1so13981117wrv.4
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 22:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ge6l2wugI+HpW3cmm4l4KwSbM//6kk4BzpL/5Zay1uY=;
        b=esMOZFSbdCoV14bn5xxoFwOCdBj3zNBktNFPiKciWamT8hE+V/ZdeXAJGlnObknFnZ
         J6XBbVE64LnOr6L0REnAg/R8g3VmgAdoEwInm7ZsZcgjNxBk9mlAKUk0LeUNgweuLyz2
         ohF5IncoOPTAz42l/967iyRQtjTS/cw950TX7joHGpnEoue+6Tc8V0YnYqLuSoFYGwaT
         j841WThSiRl/vWiPafLG31EP7qa7lM2q5WXMLo1sJiBEv2vzivLoE8eYfg/ZYHlF50uD
         o22vxMd4acUSCOmhvmGa1EsIZUNcIONiyzTJGdvy4zLNxsV9h7GPlwL6JFEJLhXlrxJb
         8zhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ge6l2wugI+HpW3cmm4l4KwSbM//6kk4BzpL/5Zay1uY=;
        b=SQOCGKBlK0b2NWmmULWm1Lr156oX6bEkHzg+GUVNT62fOMArnnVnb06Jv+TSw4hEos
         nYsmsGmjJYP7RPX8opEO8t6r5A6e8VzwT9A7NJeIlTL0/dR81BsppoUUHnBa6Z8lc8lq
         4iIzq9uQffTBM/5wVIuUsfhlZ8HrGCRaOm3DEpD8WrWg7uCsDiuzc47MPYdPLYVVzgJv
         LsP87EShmRRhBJ7YRB5sQXpOR/OvVqqdHg5uYHfulPi9i9VvAKBnqRjuuxwlSEisfWiB
         /TB7jDh1HR52vf5dCamWLz7ygQVtoxMyuEUvBVHiUg/b9lGPsE3iIbvTWDYxEhiaTsK6
         NM8w==
X-Gm-Message-State: APjAAAUp98ZeQGykjI3BitawFD8/Bowba8YImELVpWNhiYCNN1Uu+3xC
        0grEcyTWxLZF45Z7TKuFNRlqDzHSmhWiFg==
X-Google-Smtp-Source: APXvYqyXsRvTSmLjaTjDJAJX3ieUjHWlvTTvgmd9tXAoFqHpnwVFxixW4Xn8ju0Tg0JRzZY78Hox1g==
X-Received: by 2002:a05:6000:11d2:: with SMTP id i18mr27760152wrx.109.1572936104842;
        Mon, 04 Nov 2019 22:41:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 36sm39836173wrj.42.2019.11.04.22.41.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 22:41:44 -0800 (PST)
Message-ID: <5dc119a8.1c69fb81.eefc7.cf93@mx.google.com>
Date:   Mon, 04 Nov 2019 22:41:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.198-47-g1e0d280e1f8d
Subject: stable-rc/linux-4.4.y boot: 80 boots: 0 failed,
 70 passed with 7 offline, 1 untried/unknown,
 2 conflicts (v4.4.198-47-g1e0d280e1f8d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 0 failed, 70 passed with 7 offline, 1=
 untried/unknown, 2 conflicts (v4.4.198-47-g1e0d280e1f8d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.198-47-g1e0d280e1f8d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.198-47-g1e0d280e1f8d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.198-47-g1e0d280e1f8d
Git Commit: 1e0d280e1f8dbd21a713507c208e2ed524c18257
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

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
