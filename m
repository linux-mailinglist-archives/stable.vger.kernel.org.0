Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BEF107D4B
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 07:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfKWGhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 01:37:00 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45387 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKWGhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 01:37:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id z10so11160870wrs.12
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 22:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yKUfq+g6QHq1ruh2+Ak/9FpYSW1wbWX2u5i25e8aGjc=;
        b=PbXlGNvA/YYVcyVr2SGQJY7h1EpNjbVXzLy6X644gdRaoPdSAXrpBC+GejO1kfwxYI
         EYXUXvLo7HslKnPHi+8huweylSk/of2PtAHf3OqqSOw9ijOzCd/EuyCSdQRrC8gbTBT9
         8pn8f/GA5/8dz9sqHYhZubSo57e3iDcREGajHlsQ6msf9LuEaeDQdZYlkcxy/CvQa5QP
         kUjFZwA+2VDQOyxt/7r4IH3ZCkWrAHZ7FJ9rPSwkwY72y7W6VHeAoKTHwjDUrWUhd6ul
         Y4ey+jt2K1TCi3Gxh6HwhQ8SHy5c95l1bL2cQlzz430B/7A+DJC2pG5FMStcB4H5sJVC
         aNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yKUfq+g6QHq1ruh2+Ak/9FpYSW1wbWX2u5i25e8aGjc=;
        b=pzkp0lchG7UPwDV5kGJnvKAkK9hdpnIMYLChHxL3XxPhJlyxS40YoOnc0A+wiKpktG
         xZd6IOg1JEpLS7+2GGtJ1CRn43/CRFX+XghH5PZqDSKMIikedx+RohCDzzBQ8zABo02x
         cdIFR0Sk986Lu6yGZK0sTi0zfyGsmUujK3D1IDVH4yisIaSb/RVsC7cKTn9NAJcqWvVI
         0oHDbLw+bqVanSnNq/ueLyQ1b6jB6CTjRHEWmaVHTy7ntmlNT9MbETywoPqYCBjzxV7Q
         KDAn4gLwCqPoX64e6kAON6ggM7LAKGEy7wamFTed1rxEAc9DD6KdTknT7cXgkM31ElIm
         s77A==
X-Gm-Message-State: APjAAAVZm++enHbpHztTwjO93gdN9TLF2euMLPatFDWC+YRWCOU645rJ
        6Z78ZsilksKfnyvLOXG2xhhCLpAvIFWLeQ==
X-Google-Smtp-Source: APXvYqxeAK0DI8PwOdauVHgCU/CU7scExdWORQV67uinewPXpjnzAv5J9mbTAOrHAaX/mHflQfsM8A==
X-Received: by 2002:adf:b193:: with SMTP id q19mr20082900wra.78.1574491018246;
        Fri, 22 Nov 2019 22:36:58 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l4sm807902wme.4.2019.11.22.22.36.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 22:36:57 -0800 (PST)
Message-ID: <5dd8d389.1c69fb81.a8774.30c5@mx.google.com>
Date:   Fri, 22 Nov 2019 22:36:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.155-123-gd40687ee9ee0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 90 boots: 1 failed,
 84 passed with 5 offline (v4.14.155-123-gd40687ee9ee0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 90 boots: 1 failed, 84 passed with 5 offline (=
v4.14.155-123-gd40687ee9ee0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.155-123-gd40687ee9ee0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.155-123-gd40687ee9ee0/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.155-123-gd40687ee9ee0
Git Commit: d40687ee9ee01c874516a9a510f5d6a56311bd83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 19 SoC families, 13 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
