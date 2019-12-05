Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F2113A4A
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 04:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfLEDSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 22:18:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43753 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbfLEDSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 22:18:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so1631199wre.10
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 19:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vGCd4KXjLAWzsflIYoEbX/Wkb8hTNj43948EzwaYao4=;
        b=zH2spSFOxMHyTRhGvl8fpt08yEC5KDeXc1VPKwfomWxV+PxuWamvxU47P9QGKGbWhe
         FNNJoKGiwAQwVzhJ1Dt14XYCBW3QroYKm3NJRUhVaUrceTBos6MFLyeW+AZ0ORrfKhQ/
         mrmGfvRm3IJX6DyZr3HqDLsMUKc3kKjdgA2vzyGDf+lxVLSfOuQHamL361naEZlmDaDS
         NYf3q5VQ4AWiQomh8bjhHzaeHPGK/O06ZUj3uOCnPVlwU3Zaaxix/OmDSWrMoO0FkC2Y
         c5i8pF1Lrm6DDMzDG03xF3QIuF85AyrhhkXxbH45TRn3u4g8sCmeaQwV19RToWVHXGRN
         0bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vGCd4KXjLAWzsflIYoEbX/Wkb8hTNj43948EzwaYao4=;
        b=beqsC9xjKmRUKfp+pkors1dIYcSk9I9s03E/SWg+07wmfUwmaWnhgJTY+BI0KQ1ZdM
         kmc5IixhOpZR68AEXyMXM0EO/q3QfLMmMFg/yE789To4s+Jmgqwj9EFgVp9XNyNoq55g
         NV6XRgmUh9jKjtX40OevL7F5+y1q5dGqzPth+6A/sQ5m9n834fERkUGzHY7B6rmJmLfi
         rHeYZy8cJI6fZY48rmxopvlxMOJM6NSOLM2gtZJkNUJL4KRuC7cBtUjYUmyp5NpYor/C
         o9SIMBl6Lg3GIZ+j84kBMJEJHlLlOGn+FNZbjdWRLe6JVpDpO/IZ8elZIrTsxLhVg4gJ
         6NVw==
X-Gm-Message-State: APjAAAXBW01+inbhKjJtEQqElCJyeM9AfxWmjv/3ibyjDP8P/QlfLCc0
        XMHM8oRrZS78k7LdGuOVvy36u5L2pzg=
X-Google-Smtp-Source: APXvYqwQJ+f6KS/ZDdp3FsDlFvFve58wRF/sdRFayya7gLH5rFVjaYipGfPLrqIq/Seo/aPmHzkC5A==
X-Received: by 2002:a05:6000:cb:: with SMTP id q11mr7152617wrx.14.1575515900414;
        Wed, 04 Dec 2019 19:18:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u14sm10296396wrm.51.2019.12.04.19.18.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 19:18:19 -0800 (PST)
Message-ID: <5de876fb.1c69fb81.e9c88.3f4a@mx.google.com>
Date:   Wed, 04 Dec 2019 19:18:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.205-126-geedf6ee6d6cc
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 112 boots: 1 failed,
 104 passed with 5 offline, 1 untried/unknown,
 1 conflict (v4.9.205-126-geedf6ee6d6cc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 1 failed, 104 passed with 5 offline,=
 1 untried/unknown, 1 conflict (v4.9.205-126-geedf6ee6d6cc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.205-126-geedf6ee6d6cc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.205-126-geedf6ee6d6cc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.205-126-geedf6ee6d6cc
Git Commit: eedf6ee6d6ccee71e628b172e33ef860e05e6bb2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 19 SoC families, 16 builds out of 197

Boot Failure Detected:

arm:
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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
