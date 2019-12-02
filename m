Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75310F1D7
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 22:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfLBVDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 16:03:32 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37400 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfLBVDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 16:03:30 -0500
Received: by mail-wm1-f46.google.com with SMTP id f129so1097319wmf.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 13:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1HFZG1vZArjZE40uLxxpg4TNLR09yXED4Ipq67+iwrc=;
        b=Yo3T4jdTNTs/gFyahT47YcLagh4pjxeqSSYxHLqzTlsGIdSNGs0/Y0bigIb687fRR6
         LOTgis+qdLohNvyMLkYBwYjL3Zg0fnUs8aXwGEdMxHbE2RT9eQhWbXoYKo+W+BG7MiTE
         O2R6vPnFeFuEOJt3W81CqE67KoN2nL2ukh1C1ZqVrxGsxkDC55Sgbv+XoECnoudkfFTS
         zXjoWeLAjDMAjLvpViK+Y7nR8FQIDd2MiLCw/cDWE4/PWuWhpvh3dJVUftKywyhpvGNR
         mchqIiObN0ymz/IS4HbAWaL8sA+NSU28ldEdVMxIL9IBL2LG9mAw+YLl8zE59e75YePE
         an4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1HFZG1vZArjZE40uLxxpg4TNLR09yXED4Ipq67+iwrc=;
        b=GKuA8oO3ljQQ1/mfzB70aI1624qiVDqmQlxr8+ArhKg80Uw1UqljYRA3O72+9CLV0k
         fngIVM2lF/ObpnAXA+7TFuEinAECyEYvqVjUWdazQKpRUni0WAPkt8+QjM6l7jHNgxLH
         fUcztzKyLd7Imx+Hi2JciP7DUNWII08Yuh0cImlYjeuUyAdsBjTZQOtFATob4m2zCVOG
         yky1JZSx+RmnNUfZdTpudKPMUtjohsUPl9iqJZX0Bw31kU+KpjoY/QTmOynqwEkVey6l
         PTvMYodicp2aVDM7/eJOH+VZyKifyYCaCFZqA1gYs3SNNQSnjqL8sfSJWILO//nIYxq4
         M2nw==
X-Gm-Message-State: APjAAAUiZ5YUMtDiLBNZ+DtpVsjMU9gfBgVOxkG7/IQvTYR4rcvqTTzR
        pLTrQ2YC+MBHX6FRXkPuNUixrJEKn3FH0g==
X-Google-Smtp-Source: APXvYqwOszPkp5IEMIGolXcDJHcYR1rXrYQ32xOkkaPmJw3nsvLNaa7vRNiDQAxOKzjUZK/BMy2GtQ==
X-Received: by 2002:a1c:46:: with SMTP id 67mr32588963wma.51.1575320607985;
        Mon, 02 Dec 2019 13:03:27 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b63sm585489wmb.40.2019.12.02.13.03.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 13:03:26 -0800 (PST)
Message-ID: <5de57c1e.1c69fb81.9c0f4.3649@mx.google.com>
Date:   Mon, 02 Dec 2019 13:03:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.87
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 142 boots: 0 failed,
 134 passed with 7 offline, 1 untried/unknown (v4.19.87)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 142 boots: 0 failed, 134 passed with 7 offline=
, 1 untried/unknown (v4.19.87)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.87/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.87/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.87
Git Commit: 174651bdf802a2139065e8e31ce950e2f3fc4a94
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 23 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.86-299-gc=
c82722f8f1b)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.86-299-gc=
c82722f8f1b)

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
