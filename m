Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1641786EEF
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 02:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbfHIArK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 20:47:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46115 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403901AbfHIArK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 20:47:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so96628393wru.13
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 17:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cYhAT8o1cDrRi0HvLS0O3wiC93WJuICHNxPKc9R5E7I=;
        b=sSm2fcxrZDLgXTDYvQKvWJTXTZ1ribyLahaBkuwvTI7Nm+Kd+22F9Ti2l3Kzen1E5d
         r7UeNJJuYC7YsBziJPJ6dShR3Gqr5+dkv2Lk4VrnSnTTHHaOp4sm4n8PXhMQ39acJlxE
         F4+mqeteyUU98NfcI5aYGZIQDiCxvhkNSX7fG4DGO8M0XPwNnX6pyVTYwn9RAjjiCx6v
         FAvUnpxKgl/Afqks2D9NhX3uDrt2qvVqt9+PSabE7A5gbV7L9qpS2YTjLokrnO000/1o
         3/f0PaqpNldko2IkSq6ndzA4jSIHMyNTNnbI1CvjIGTPHeZcnbE93nRZ1YQOE83lN1Nn
         sE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cYhAT8o1cDrRi0HvLS0O3wiC93WJuICHNxPKc9R5E7I=;
        b=F8scsY5x19XpNzb5H/jGpNCtgiBoSdO1LnuHnF56WcfMSS8NUuKJOJoOTCRYpZ1hqu
         uf8B6bvRBhmk0CzDpMMP591kUwYx4exPmZGXwsj/nUHYVqrbwihcwZRriHe9+qrYoPD0
         E2sNgcGNzjBMSfphGujQY8nFffbEh4NGNCZ0aTGh/xl34FvZm8qFIDfRb13jrpjfXOUo
         LDWlY5dv052vC3wp4jjkDDlcfTJ+3R6Q8cuk4AuACd3+bus1qQc2QF6TyByRw0+JnL8v
         UIFbQE/u6Jt6QbtufoeS6WaoL8+tNWGY1Rnk/YEPuaQdjYNXyI4E2hj4H5TPosjMuxMZ
         xXeQ==
X-Gm-Message-State: APjAAAVl+vq9YwGPif3JGMwBs8NczCTq37IzbNRVIh6JG97uu/4SlrG9
        rlPcAXpLFZm9O8tPioTf7lS/bmP6YOapEA==
X-Google-Smtp-Source: APXvYqziDm4gs9aHTxZ8+lFA0GHaNv40U86gR+oac3Gd8ewx1w4iOXisHCK2iLus1UfVqYSZfmqByw==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr13324706wrs.82.1565311627724;
        Thu, 08 Aug 2019 17:47:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm7301613wmg.8.2019.08.08.17.47.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 17:47:07 -0700 (PDT)
Message-ID: <5d4cc28b.1c69fb81.fd2f6.5c19@mx.google.com>
Date:   Thu, 08 Aug 2019 17:47:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.6-195-gbd703501e2df
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 137 boots: 1 failed,
 120 passed with 14 offline, 2 untried/unknown (v5.2.6-195-gbd703501e2df)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 137 boots: 1 failed, 120 passed with 14 offline=
, 2 untried/unknown (v5.2.6-195-gbd703501e2df)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.6-195-gbd703501e2df/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.6-195-gbd703501e2df/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.6-195-gbd703501e2df
Git Commit: bd703501e2dfb5d3a64222f9a9a9921ac1c96b6d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
