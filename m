Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D625F10EFF5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 20:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfLBTYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 14:24:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38884 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfLBTX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 14:23:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so728912wmi.3
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 11:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+1GICoZF9e3oerl86lWVR/V+LsXg75vesTpqBqI3k0A=;
        b=dM0gbZ+5V1lTGUlzfdviATvOLhU7dzW93meCydz65OuMMG75MIWJjqdSd/z6tZ1UBW
         5jcOKoruaZUjC1fm97nFXSeeWw+rBMqENA8WOW5XSr6H7nI9Bv0bmM2bmIXVjzcTK0CG
         1xmU5Tbed1kV3yMfkJX9gjDFjI1hB2cs0UlANzrkpp5MvLqyvPMy1OgPtIsEvIKQutaE
         Ta1ySz5gldnus1cixk6DptTPEWv9MpMg68BZPccg4BX2orVOs5x8+luf5FhbKGOYeLe6
         2LryP6hny2wgZD+nQKz31kqnUZr+lEQMTEqhruspeRQwbrFWRS+36T1yhuLTi4TC1l6B
         h4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+1GICoZF9e3oerl86lWVR/V+LsXg75vesTpqBqI3k0A=;
        b=pMnkKWb0M/KERDSPogw1txbZqSqj/c2cebMIbpy5B0qqqmGGmIuMYj5p+y5KYakaNR
         MpIPDDPmeXKjbsX2AKhPCAw5G/F3M2aEunIXgBIkLaGM90C6VRePTM9kF9wNBdKAhlxG
         Mxg4j+VMx1ighXrAD9ZAOpntYlJOTV0P4e2m4qSQewORTker3TQSkOQ4hRA5LNl7NeVM
         E4kpZdhNVuCsY9Suj9mh/hy9csHs3IeD5vKQ4PXQNIbU8kNbG81dgQoew8oa3Tq7jXR5
         ZsLKn233ze8A/aRy4sVF6XMDdtP3imPIxlPFrgxgFIhhc1ad7vvlAwB/9Ugt4YArTlnB
         KXAA==
X-Gm-Message-State: APjAAAXLpN3WU4n3ctmbEYs6bC8MOHEvUVuTUfIXQmaGQgWD1Ff30q0e
        2GTjqtu09S9Am+pVqGjvvyDWzK1a6+1KhA==
X-Google-Smtp-Source: APXvYqzuCF/1MQustPse47r+wXukTpNOuhHIQjm+AN1rFWU1RVe4Oo/k0pfCRRW/xsf/8trtKuhPAw==
X-Received: by 2002:a05:600c:218f:: with SMTP id e15mr11880116wme.124.1575314637534;
        Mon, 02 Dec 2019 11:23:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v17sm401942wrt.91.2019.12.02.11.23.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 11:23:56 -0800 (PST)
Message-ID: <5de564cc.1c69fb81.6edb3.2782@mx.google.com>
Date:   Mon, 02 Dec 2019 11:23:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.157
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 2 failed,
 120 passed with 6 offline, 1 untried/unknown (v4.14.157)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 2 failed, 120 passed with 6 offline=
, 1 untried/unknown (v4.14.157)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.157/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.157/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.157
Git Commit: fbc5fe7a54d02e11972e3b2a5ddb6ffc88162c8f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 21 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
