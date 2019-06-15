Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7D3471C4
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfFOTHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 15:07:42 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35083 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOTHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 15:07:42 -0400
Received: by mail-wr1-f44.google.com with SMTP id m3so5821558wrv.2
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=07ueJjVm4JHaKgjRvTcG1oN8et05ta36rDoS+nOpnYA=;
        b=fCRgymYx4zaLXcxZP5YzOwLDidbzexV8jYYgbL8khMdHcJ1ZF6Cw8OVXfownll+mv9
         mLZgwMBn6RZdhnBrxxWW6TrXmYCkWjq6JYiJSfryCX7gjBEgAAH2vbv2vWn4MErIhg/i
         vzOo/QHYzXkJ31KTL+XejkOJRy+Dx1sBX8plr92HSobbwee/XnIRzGajU1nq9f7jrxhh
         NJZKXYK8CKFTd9zSO/1CuywN5Iq5iel7rYWhH2NCpe8iUtgl4rocwsBXFITI+u5qFrI3
         I6Pw3kBtoIQXt1vlwM//Lz7EQ3eEZYGwS+jLrh1FL/enUVu8DMLQ2sm9isVax2WUgYIs
         mwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=07ueJjVm4JHaKgjRvTcG1oN8et05ta36rDoS+nOpnYA=;
        b=aVKkvjWSGC+Wm0tCvPTXwUTzpGUHswS8SFpKSqzhJ238Mr+Cxau9Vpt3ceSgph4Hrp
         hIuasOzpKeR8vatYc/SVjdri26VuttuhI1Uh2nLh0Pdjppa3c3xq0V5ywYkMTZHw3r79
         j9FWBonWlpzGCCC1U450JfHa7M3oEp84ephz9mgyGX2PvOb+YiybQzhalK+dlVaHpbhR
         xwUuzszFQyR2CTD0usVAcr4562lbs3xnLeHDe4QvXwZE15eINzEf4yVr4M6om2ws5dgH
         XKwmLB7ND+FZCtIJ/1TKmx15ykH9PGF7UbFc3OGgVhoqIr0HNpICEU0AcIwihOCN8xnJ
         q1Rg==
X-Gm-Message-State: APjAAAXLehLiMxpIhr1MI/OHNe82mrXa9CcLENPlZh6n/Y3Urx+6thg5
        JZMgO51HAjpElGzRhdbSmcvJDvcQYIZ90A==
X-Google-Smtp-Source: APXvYqyhdCeP21qAPhBr5iHGyaGN961G58T5PIn9V9t2Cic7pwCzy5wrAz1Rt8VN6mF7xSgC8Q8Cfg==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr56556894wrn.31.1560625659640;
        Sat, 15 Jun 2019 12:07:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j18sm4230394wre.23.2019.06.15.12.07.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 12:07:39 -0700 (PDT)
Message-ID: <5d0541fb.1c69fb81.b6ea.737c@mx.google.com>
Date:   Sat, 15 Jun 2019 12:07:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.126
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 107 boots: 0 failed,
 95 passed with 11 offline, 1 untried/unknown (v4.14.126)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 107 boots: 0 failed, 95 passed with 11 offline=
, 1 untried/unknown (v4.14.126)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.126/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.126/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.126
Git Commit: a74d0e937a3acaea08ec0a7bfa047b8e0a6b6303
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 24 SoC families, 15 builds out of 201

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
