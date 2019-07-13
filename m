Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF63367BE2
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 22:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfGMUAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 16:00:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37766 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbfGMUAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 16:00:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so13177971wrr.4
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 13:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q1gzucgfupvITWHPgCXvtO0UMzoJfRPrg1I/a0kwlOE=;
        b=tTvMWaKc2Dz6zBJBlq9TvmgoqjRW1/IvviKOa3yJJrRCNsIF036L4ELxbUsCLBiCAZ
         BH401PntKo+9uWmVethG2yw5CjK0DtcJtyoyckMFyDpllylf/Zuvv8TR1GfjaHq631u2
         qCMIBMF/ygTxCDWOWeQnYCLtGlFVuQlWLi4KwGzxoTRi1QDOI9rOtQmE8zzB9S/AMqst
         G57DP8E9lTODCHvvmRiTM9NapS9oq0+2WPTp61YYuJPsaeGgAp9a8tTBOjuML0WCbY1m
         s4YabfxK8EUTaqQD23X6L86f7SyLpyWWoutcKLe/cLz8yh3Q0klPlpwE7OkQMuKl6mv/
         //IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q1gzucgfupvITWHPgCXvtO0UMzoJfRPrg1I/a0kwlOE=;
        b=pAF29rz3KnoC0BrOrB7JfEvqh1mtddD/r8q2/YNxtPVPFT1kObU3O5D1E6ZEXQJWRC
         FQoNfSqvjT+XVYzA3n/Xtx2LD5s+nC9kZdDE5FM50T/gxERN9kXWskYkkccgMraUvT7d
         HfkhE03vzkmDbqmPGfIn0E/4Ab2Vrq4XhIMR4kC3qWwKf3Av2SZyM+zyiADzBtpYiuCs
         iECEFi2jsiAdCHUT5vvmiOvAQGkm/rZguPKzVxAS4ZgujFkQ0AHxta3jDV1wct/1kF6s
         BHI2dmRdRRTkm7ZWI/d/paV82mr7ZqTJb84JEfaw5lUjVCMnhOEvRC3DfzBBsFOCxa4w
         2O1A==
X-Gm-Message-State: APjAAAVSD1ST7D9o8hby5PM1K3y+8IkaLD+cVeTqW/dS7nM76JLU56Hg
        yClWNRTfdIrFciUyNDu01MUmdAPuJes=
X-Google-Smtp-Source: APXvYqwtCV4ltN/FKVgm2oZv13a79h+KUt72NHcCb3kQ7qzYNrpoh/s4SPyW34Ye2GnVpnwUpWufsw==
X-Received: by 2002:adf:eb49:: with SMTP id u9mr13270170wrn.215.1563048003073;
        Sat, 13 Jul 2019 13:00:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x129sm10899908wmg.44.2019.07.13.13.00.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 13:00:02 -0700 (PDT)
Message-ID: <5d2a3842.1c69fb81.c6489.ee52@mx.google.com>
Date:   Sat, 13 Jul 2019 13:00:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.185-28-gf3c4a0019cd6
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 91 boots: 4 failed,
 87 passed (v4.4.185-28-gf3c4a0019cd6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 4 failed, 87 passed (v4.4.185-28-gf3c=
4a0019cd6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.185-28-gf3c4a0019cd6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.185-28-gf3c4a0019cd6/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.185-28-gf3c4a0019cd6
Git Commit: f3c4a0019cd6a0376023e41777bfa6d08ee2ea50
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
