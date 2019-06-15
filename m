Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA76B47020
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 15:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfFONHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 09:07:01 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:54876 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFONHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 09:07:01 -0400
Received: by mail-wm1-f41.google.com with SMTP id g135so4956928wme.4
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 06:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mk9TFA7Hoz7tQp7HAZAaNcCyPjhyVWPmwwgTDMaz3uE=;
        b=yJmn1xokn3cGL+uwExff1NxumDspMjz/2S5raQhFmXnDnXRA/ET1gN8w7jYTNIOyDd
         B6lJYFh8p4E94vr+iJ1XmaTS/Fo4KjYB6jAnpSM6simyUBKwJl9U7AG354qXETMKC/DY
         diYbJKBhij9l9R3hHowYZa9nvEopiI8OEawDJGCHrWaQHQz9/5cCRqU8xbG/EOXPONP4
         F1J2liExQN9BLsh5xZNVyk6dSeC8VZQUnx2IuqHu58i2V4j1vigufy2jPPLttNrgwH2Z
         GW6wQiclMxAcJi6bP+4gTy3vtv7BzzWc0sF/bkd4X91iFTla683dO79nj5pp39M0Zluc
         I+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mk9TFA7Hoz7tQp7HAZAaNcCyPjhyVWPmwwgTDMaz3uE=;
        b=WSYr+CoVdXy5po8iPxN4rSbvzZFRwyp226G9QksA7u2HZGrHoKi72RDjrUIoMhXfmG
         3snZg2WljjwW091syQdubUKfOAGZLtovSDqBDKLizgLbQ1LFEZa9O2XIMabqK82c2gov
         SWOBk3RZS90d7IhMfNLHkd9m+oLEctZuezzp6oRYndbv48Bd9cJgGP46krRlUamgZbNn
         WnH1dZb6SdZ8IjwNhsE72uWDxhmdKkevqFiNvAi7XsjvJEMjeURqFULF0DK7ZugO2sHC
         SocbSyS/JOK0E062gvxX++Hu0mqSNFAM2oybyUIPQDy8XJPZgEtj9f216Z2dAfVSAI43
         x4Rg==
X-Gm-Message-State: APjAAAU3hOjgXpDUxSPRdGI8I7EENnMR54rApXxzH+3D2tafc91aF+OD
        Nqso3aJxPq/lMkVxbq5ZWOW4OVGlSWGTSg==
X-Google-Smtp-Source: APXvYqzjej0mIflnkV+EvXA0YuFtgBIow4SQyNr8N8al1tkRH0XQZdDvDHd3Vop/hBBqGjjVo+oX1Q==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr10053269wmc.128.1560604018610;
        Sat, 15 Jun 2019 06:06:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x3sm7694693wrp.78.2019.06.15.06.06.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 06:06:57 -0700 (PDT)
Message-ID: <5d04ed71.1c69fb81.df15.93f0@mx.google.com>
Date:   Sat, 15 Jun 2019 06:06:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9-157-g7c76cc252262
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 105 passed with 12 offline (v5.1.9-157-g7c76cc252262)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 105 passed with 12 offline=
 (v5.1.9-157-g7c76cc252262)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9-157-g7c76cc252262/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9-157-g7c76cc252262/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9-157-g7c76cc252262
Git Commit: 7c76cc252262ecf0d9cd4e391b63106423694fcb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
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
