Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE084756C
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 17:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfFPPK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 11:10:57 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51428 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfFPPK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 11:10:57 -0400
Received: by mail-wm1-f44.google.com with SMTP id 207so6728234wma.1
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 08:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sDDjTPbaP0GhglCP35i5rAu9AhYwpHApbcCZQv76AI4=;
        b=0riCLYmiHhdoL+buzwrSy9wBrtZQJ764BnRgjvr6xR8mGeZ3AuVL+KSAPVOsHQqUXL
         0eJkWW4292hQR9y8kos5kTjBMxvRlP9AytBEoNTPc0yOyjFNqXZb0GBa3L+Nre+yG/d4
         kGRGUOmMosdvZ/bHzIDEiIGmSsPLT2ad27f4lQuinB7ke54/8In9bPl/06tJjRpxeHkg
         eM/pRag54kXdungSoNocgHr1kOXgq9n6ODQKfNPMWnbfZYMmf4RAa+KzI8bUDd94hw9M
         nb75zyzaXoUUgSDDkukW8TNeXYNJCqe30UHb/w9exb7hmw+2DcGu3Oy6oVSWmvwS8gIl
         UFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sDDjTPbaP0GhglCP35i5rAu9AhYwpHApbcCZQv76AI4=;
        b=kqCYVQZHsWOaauIedyr5ix2lAhdu2zPDz0/266ciolzo1lTV6VYso3thyzq3z43Wg3
         ECWT0gy/S5m3vWH449xwA9XiGSNTPkPd68IxZ7/zvDsBf4W3ZJGnnN8JhuSOOH3G59g6
         zaqVDyqs6fu4DnR4JKpucFtU+OrogJdvAgIHe1Zg8xq7ZiXPDo4Y76qAAr/UBBu09iRq
         oFzDJIrTXAhMov8z5oyoB108Lz0fb+SSzPLi0opA1huCb/ari/X54eL6r2+UPKflnBvg
         vv3AD6FMfHpH8zHb9jDnO2VYjZ38bgCaHyr3lUVMALtvAX0XsQoWuwQiTduf6ntgrJJR
         roGQ==
X-Gm-Message-State: APjAAAVPc47f819NTm976fz0TSF+DLYqpKRA3kt4xki5gkDyP8WMIo7p
        PMdadpS++bv10ZcpToXkDzhyX33TBBA=
X-Google-Smtp-Source: APXvYqykkykDgRAW3tYYFztRRxYXmKNLPTRE4qbNdKh1AWTrV/6y4IIh28PLb+7CCtwQ6xyYDRCVVw==
X-Received: by 2002:a1c:6545:: with SMTP id z66mr15094448wmb.77.1560697855478;
        Sun, 16 Jun 2019 08:10:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm11965677wro.65.2019.06.16.08.10.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 08:10:55 -0700 (PDT)
Message-ID: <5d065bff.1c69fb81.24352.166a@mx.google.com>
Date:   Sun, 16 Jun 2019 08:10:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.126-50-g576dfeb705e7
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 92 boots: 0 failed,
 81 passed with 11 offline (v4.14.126-50-g576dfeb705e7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 92 boots: 0 failed, 81 passed with 11 offline =
(v4.14.126-50-g576dfeb705e7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.126-50-g576dfeb705e7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.126-50-g576dfeb705e7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.126-50-g576dfeb705e7
Git Commit: 576dfeb705e789417a1ceccb310cc7c5bdc96873
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 22 SoC families, 15 builds out of 201

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
