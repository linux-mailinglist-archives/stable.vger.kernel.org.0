Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52E512736F
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 03:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLTCVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 21:21:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40332 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTCVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 21:21:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so7890585wrn.7
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 18:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wlk1JZFf1nnobCwe28xC4Tmhos92uYlacA0tb8DXqNc=;
        b=HbRIAnYd7cpMK/7LtL+e7rSiiB4MB6a5U/UCRTMv1i7abuJU35S6j0qqAhp+mqlzl1
         duX7XcoRu/t+cnEKZVPoXpN3IrgVh8i1u1mOhMggxqNBGd9KLrG/+l2E+huax/Br4qt1
         uEPd5149QGK9aj/DPmmbEej58cl9AT6qoBDedUkN5Zrx0qtFZBC9OebrXy4CAKGugNX/
         gZo7CDNSEK2JfYoAMUG7l9UpUy6yuTSSwz2vj1ETrjbnvKyIGnr92KuQ7bIxZyKbXFhh
         u1s+EzVjTSniteKh23DNXrz/bqBvgIvnImHUG2ojzHoMIMeMkb/l8CkCNZTFAlxNkdTI
         pGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wlk1JZFf1nnobCwe28xC4Tmhos92uYlacA0tb8DXqNc=;
        b=G60syE5rWpzRtvzunsP2ZOj3h3OmCVhxoWHDGIEGvLnXdiDJNRKiV3tZQCA7TRTITe
         zuN+iwLmTxMaYLMIpMSQjzSbJgBBbn5T41xrzjlAJF0z5k2umtDIXkY5UhG/YY/JJqeq
         1tuqtNhY6d1rsFq+ZrO3rI6zhDAlzXydiMy8LuH825WMY2yyey7h0pXdUUBO7SNtyL9S
         VT7D7XSMtKQF2uqy8rmYfES5NRk0XMFrF1/Do0K7Pp8uNERyTbtR9Pcl7UFSU6jUSnmS
         ILKdvIYD/lQUFevne4mBqGHSoMfg2WVh3Hw3yHsz7HQ+a2e3KHrVmevySTZFdIDg1GiK
         oEEQ==
X-Gm-Message-State: APjAAAXBjAAhEpwqEZUvjY2SQDxU626F7PkbCf9fIwMfLEkHFq6jmUkq
        h6khc2SxjFaTXS/n2K6dbgX+b3eZQ31Jag==
X-Google-Smtp-Source: APXvYqwSpp4ekjDMcov0HPVUvYgIS1GIbLrtUTVZYYf/Hbb/YDnvzzWOe7yBj2AAoI1TSh8FSkRMBQ==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr11760598wrx.253.1576808093836;
        Thu, 19 Dec 2019 18:14:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j130sm8587174wmb.18.2019.12.19.18.14.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 18:14:52 -0800 (PST)
Message-ID: <5dfc2e9c.1c69fb81.ef3af.c0d9@mx.google.com>
Date:   Thu, 19 Dec 2019 18:14:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-200-gc87cf1424991
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 93 boots: 1 failed,
 85 passed with 5 offline, 1 untried/unknown,
 1 conflict (v4.9.206-200-gc87cf1424991)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 1 failed, 85 passed with 5 offline, 1=
 untried/unknown, 1 conflict (v4.9.206-200-gc87cf1424991)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-200-gc87cf1424991/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-200-gc87cf1424991/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-200-gc87cf1424991
Git Commit: c87cf142499122d38d7dc3cb92c9e9072d646591
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 19 SoC families, 17 builds out of 197

Boot Failure Detected:

arm:
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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    tegra_defconfig:
        tegra124-jetson-tk1:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
