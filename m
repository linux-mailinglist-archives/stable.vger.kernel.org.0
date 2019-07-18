Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E36CB45
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 10:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfGRIuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 04:50:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41746 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfGRIuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 04:50:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so24536773wrm.8
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 01:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FP+8MKZl6bBsMebQTvPHr2idtDJEkibUdB9rKGWQNOA=;
        b=kvGW2Nfm54Ciwa+SRjVM3yC3jOz1OaAEJd4Dm9ZZCDwldWmpqefQCvQguJpc48cIOy
         RlPsBTzvU2BGAquzF5xVMjUFlj9JRTUPtlcAE0LOtdAM7qE+PdZr7ptBjuJst8oKNj0j
         A7cBuYSsD6R448ZSocYfUUWGZVdmbhM4I8EgI+/4y0B/9aYtwBCjilSfYK/ne1AWLwtP
         gmwDmFBUoXRj5tXIj38hvhbbKQUHDfUGx4eXYK7kxuPnaZljjNE703K7MoI2BPPJ15VB
         vawFYgoRK88WsNnfHzo8PLJqwaFzfueC35Mci0PKL1CMfusXKifUm2iZUPQaLq7pnCWH
         CjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FP+8MKZl6bBsMebQTvPHr2idtDJEkibUdB9rKGWQNOA=;
        b=jdsHFnwi3JVgmxfdaU4lXNc+uwV5D4Aq3Bf76TAVjEPM+Mu92L7hErt3XtV46tPnQX
         rA70ifENDLP9cwgXi6OhlJ+NyKpm4XAa7CX/akjfw8tObNIpRK74zkfG/iYb5Iw7PSgY
         EHKWgPSDoJkYvj+IF8kD4uiULxKAROgSwepdITr3hg7vlEfM9ljY5LE0vHI4BPi6g1Pq
         2AtKFjTru6LyXnOtmW+IHt82ePOlELoBxijMo/ItnKPjTXCAF/09jRNq7/Tz+mGbrX4f
         cx9kgaMa+lCG81V8Y80DMIjyYK4r9d17CRc27aJLXp+gjz1A3Szf5dlPyfmnjYrSi1P7
         ZgWg==
X-Gm-Message-State: APjAAAX3iAqQLYT4RQ/Kj3I1v1GN/eUulWtCYCmePOvBekTOca1GYg/F
        ajhBbXLeoyKtU7TwWkoUiPcVMZ9gt38=
X-Google-Smtp-Source: APXvYqwZZU8Bkjnbw/XI00YLE1bPbb2Vde7uITkve90Q/9jFCDH8k5PT4ETQqg++dx6GZ134d2nMig==
X-Received: by 2002:adf:f050:: with SMTP id t16mr45455443wro.99.1563439837270;
        Thu, 18 Jul 2019 01:50:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r11sm30319744wre.14.2019.07.18.01.50.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:50:36 -0700 (PDT)
Message-ID: <5d3032dc.1c69fb81.7b0a2.cc88@mx.google.com>
Date:   Thu, 18 Jul 2019 01:50:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.18-55-gf7d61f5b654e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 135 boots: 2 failed,
 131 passed with 1 offline, 1 untried/unknown (v5.1.18-55-gf7d61f5b654e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 135 boots: 2 failed, 131 passed with 1 offline,=
 1 untried/unknown (v5.1.18-55-gf7d61f5b654e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.18-55-gf7d61f5b654e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.18-55-gf7d61f5b654e/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.18-55-gf7d61f5b654e
Git Commit: f7d61f5b654edb3890d2a2a2c0a9769ba92acd6f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v5.1.18-54-ga80425902cdb)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
