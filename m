Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF710C33A
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 05:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfK1E3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 23:29:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53190 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1E3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 23:29:50 -0500
Received: by mail-wm1-f68.google.com with SMTP id l1so9508880wme.2
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 20:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IjWZqhCfGm2L0w3jz0+7cIdb7q1fWq+KsszHU8dxfWQ=;
        b=GLaMiwSRKv6a6TX9/pXRPjzvWf24EKZ54V8axVTQ9IRys89S92Rtulsm9GlYyfi9VK
         kLFJikKs43IAm3PFFq8I6O3XhqmD+0rcgShkoUe0BRV9ZvVsATOgATRIlMQftbopiFNL
         +uS3CQFA8GduYNMZjZy1FP2yCudWCm9Iat3WCVyvpm/YO+lrb88NJX4JJpDtclB1nRBL
         tziTSDAfZtxm0YTkrtdi84a3pHSVPruUewKfWaiB+76Jcf/TQYSfDQLdt9tnqTUk9bOr
         UUA5gC6dOoSmgCXD2qi8OQZRv5eMKGXSh2SmkCX+u7sIRaJboYgtw3+7LlTSoDz75XCD
         uA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IjWZqhCfGm2L0w3jz0+7cIdb7q1fWq+KsszHU8dxfWQ=;
        b=e0XX1aweOOW2Xd+J4oUYp9Zsi3v6aW1FfWDySC+Cs5O5qjJ9XIzpNGztuf/099LZnn
         Ybvx/Bsuj1wE0HKly2rBmAP64yDPLPD01tbjL0yTl59FuvtJMHz5zN27LpTguK92hTXD
         VkUdv8sGbw5QFVEWA0z1bbHcwPlSmejWTimHKeOb9kyI83udhO+pqXQIqdQaosCMep7d
         U7UehY4kusA2CnSyB0aTX2R5rtfDLVmtUSSQmh3Dd5Kq/MGuum5ndEE2fmETjVoSsyEq
         Nfnu+FGKKdA1gEKqprOxwhB9DtV1HhCHdrx2SlWQxKAypO9E7aRPoqkMUjFl+RQFyPbS
         qIwQ==
X-Gm-Message-State: APjAAAXqY5+RKFJumoemfbDvJ2E2JTef2NK81saoeJ/AoSyifo3cY82j
        iVXpjGMnZrYvtodxz0YgsorH1FIL42kBRQ==
X-Google-Smtp-Source: APXvYqxj5C7X2uq+ohBe5I7BfAKbKyBs6tWpYZbvN9jgMiB2bdrcnk6Foa+uEogPhUkJXj1MJnPjbA==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr7701141wmf.93.1574915387930;
        Wed, 27 Nov 2019 20:29:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a64sm10233799wmc.18.2019.11.27.20.29.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 20:29:47 -0800 (PST)
Message-ID: <5ddf4d3b.1c69fb81.2c6ee.3507@mx.google.com>
Date:   Wed, 27 Nov 2019 20:29:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.203-133-gd7e1aa334904
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 90 boots: 0 failed,
 83 passed with 5 offline, 2 conflicts (v4.4.203-133-gd7e1aa334904)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 0 failed, 83 passed with 5 offline, 2=
 conflicts (v4.4.203-133-gd7e1aa334904)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.203-133-gd7e1aa334904/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.203-133-gd7e1aa334904/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.203-133-gd7e1aa334904
Git Commit: d7e1aa334904482d6133568d82815d712c9705b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
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
