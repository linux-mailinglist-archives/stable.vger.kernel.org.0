Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9A5117BA0
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 00:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfLIXno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 18:43:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53524 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLIXno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 18:43:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id n9so1202228wmd.3
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 15:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=niLtkbWGnKsnnnUXyXNALTAx6rHtG49PFsYL49YXbT4=;
        b=BcV5XWDOtCTpsOFimCF54O/GhM/UQ6CyQwKm/Q4qQ+GG4ajy7VVW4RQooaYfH7WR92
         Kr9NtBafDr2pYWt74R+L7P5e/EJiSo6E8N0vRP1RGdA0mTArmO9M+xjfti3AMt3M5eSz
         ntcWiqI4YFerjnyDLnExqRAFUCger224/txt/XBTdZem2GthjivSkOfsQAhkZdWPPY+Z
         U6eWTqiFTtSzTTJ8kPPb0XkTaychucuK/J6C1Gi+oXrKRtshf2ydoXCTpRZEKV9OrcVz
         n/rmVQidmbGnJa1CX0V1jBA8KEDn9lLiMjYyE0Mfe5v5EgNNidQRcNVA+P6Uw0wJHKfO
         dtmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=niLtkbWGnKsnnnUXyXNALTAx6rHtG49PFsYL49YXbT4=;
        b=DC2073LN6GhLAdKV4hOYQ10oiAX3Xi7iIo/P0jo7KvyaXBl0LFqs1ChtlCYxdxrDII
         zdjYopoT+5aQQIt0WqK48Qoi2//VBCU7ebCCJBHu3uaZoNse9JlbD9Nt6HCS5HpYDSnE
         Do81Pp/nADXWFT4X5YW6MYHfBomJ2UB9FPiSweZMxZCqRS1EVJx1YR35IPOGp0iZmQZo
         3XUCmZTpPdmA2ALMKJcOkSNDK6u+gmXOLDdkcr5MuRz1d3VaFFjVqaT+pXTW1ep/PU3K
         ZBT7co8tTrgnLwIPxSVtIsSv+nJBkt4vijQQ1QL3EUJPaZYrL4VNt7Sql8g441JF297v
         Ff2g==
X-Gm-Message-State: APjAAAWPnhS4xgoDEcqr9eqA0JUrPxjdGnqcKcKl6MWpGjwPnDvboCJX
        yg+FZ9BdO0zRdXPhqy/huP1XGz5OVl+8CA==
X-Google-Smtp-Source: APXvYqxLYpX7uh0YWiv48A2TWT2gD8MuahPbJjU9UYDid5e16aQIydb2CnF6GJo2xc0UA1dAaw85mg==
X-Received: by 2002:a05:600c:257:: with SMTP id 23mr1559787wmj.123.1575935022134;
        Mon, 09 Dec 2019 15:43:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e8sm1173705wrt.7.2019.12.09.15.43.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 15:43:41 -0800 (PST)
Message-ID: <5deedc2d.1c69fb81.252cd.69d7@mx.google.com>
Date:   Mon, 09 Dec 2019 15:43:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88-215-g53fff820f7ce
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 114 boots: 0 failed,
 105 passed with 6 offline, 2 untried/unknown,
 1 conflict (v4.19.88-215-g53fff820f7ce)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 114 boots: 0 failed, 105 passed with 6 offline=
, 2 untried/unknown, 1 conflict (v4.19.88-215-g53fff820f7ce)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.88-215-g53fff820f7ce/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88-215-g53fff820f7ce/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88-215-g53fff820f7ce
Git Commit: 53fff820f7ce39c5c8dc082ca1ee30ef8f312d85
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 17 builds out of 206

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
