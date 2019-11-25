Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C0E108691
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 03:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKYCrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 21:47:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34399 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfKYCrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 21:47:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id j18so15059876wmk.1
        for <stable@vger.kernel.org>; Sun, 24 Nov 2019 18:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8+Qm3RAquT+Nw21IZ3F0MaZr4RyM4VS5nwKg+nlwUXw=;
        b=UUieV1ubywYJC3UXqzWPYvChfFpqkDnq/lFeH6PqxWojVWiolla30ZwhiDX8jro+fz
         kL7aPpcF3YtQSY9J7PWPlc7+VB1atkhYvISFoirC5zFZB33A3IB2nsvXZzpPttPg3qoe
         GpaT5zZq0A2bB97N9X+7ImFoqLBIS6ttvuW0BMjkD6pyXuBcyx/H07KMSuZgLJIYS8o4
         lw1/LZTUbbo4vXNccSxlKSBC8THLhTTCArBoxJUKMDGXwd2PMtu2Ufy4cE/LSqgZ9Olw
         tzW7b9Qn5cIwjJBCTJRwC6A9bF4ajtZCMcM9wGaHro63XvKWCGOGmJPPIy1kAerjpPR2
         mkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8+Qm3RAquT+Nw21IZ3F0MaZr4RyM4VS5nwKg+nlwUXw=;
        b=KPodqP0TnEfBHsPnn6s+PdbDqsqRtg8OJEN1tq19lyf3vGFN2xVd39AbrA4tcrV40M
         xqq3OX454a80vvIRnhmOIyLe3U2gS+xx9x8J/K3QYPotofTx4HWg1cIzXIg+Bg1S+zcv
         XzxvREwwZlrbSXFSDqeDk1YGTr5ygAbtMHIdtzdGrHZUO2tCq3XzE+3OGCKVZ+lsss9W
         VjA/auqxOV/5nxkjX/Uwna95mZxOKTLrs+Xw94Z+juYVKoghF+7Eh9IxIMnZTMRiaa22
         ZBfmFu2lfsoEpwkhO85ZXQVi0sIj79d2wfELomN0BVc5YuquH+1tasbnpz+UKp5/zvHl
         IHJQ==
X-Gm-Message-State: APjAAAXLmcSQ44hjS7LkG4JuOT/HXiGSeKEG9QD+kLmtrgE+QJv3OYEb
        9q9jCRNAfG3llrPQYcLuI7nIBRkQ39Ntcw==
X-Google-Smtp-Source: APXvYqwFNn1pNVgOoh0o9aJai+sBMx87kEK1uW4OL4yzduSq4eh+UceLaDckYZv/3G64EvyUT71N8A==
X-Received: by 2002:a1c:62c5:: with SMTP id w188mr25859463wmb.77.1574650038302;
        Sun, 24 Nov 2019 18:47:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d18sm9187477wrm.85.2019.11.24.18.47.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 18:47:17 -0800 (PST)
Message-ID: <5ddb40b5.1c69fb81.f75ce.9556@mx.google.com>
Date:   Sun, 24 Nov 2019 18:47:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.156
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 63 boots: 1 failed, 62 passed (v4.14.156)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 63 boots: 1 failed, 62 passed (v4.14.156)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.156/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.156/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.156
Git Commit: 43598c571e7ed29e4c81e35b4a870fe6b9f8d58e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 15 SoC families, 10 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
