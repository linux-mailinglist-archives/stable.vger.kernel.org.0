Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B288123827
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 22:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLQVBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 16:01:38 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:36757 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfLQVBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 16:01:38 -0500
Received: by mail-wr1-f41.google.com with SMTP id z3so5293746wru.3
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 13:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ja+04dw+wijY/8qhE0uhZGMx63QuPG0ocY5G1Po5aWI=;
        b=qkhuCqisD3d9WJT1/T5aKEJOuEkCfwkkMfvYKOECOVMkBCoXAHoIdi1J+AhwdC3Hbw
         lzxMbj4Fk2yLm5hXBTVtvV40t3He27+Z9A4GezJdi1wd8PgQGKya4Px9U5CMIlxRWTnC
         ZG5me75NBdprzExFLUEXZ8IiyZfAgiiTUsfsZ0Gy5cYtHzGXR0DoZVw7WFbdmi57QTE1
         WiP5vh+sSoBaR+inJot6FiZZRnX0xfR+U/kDlylG1EUtUeUSac/96NZCQV12tv9Esc5R
         8a6a69zio5Y5+Vygyg6209mHy41MzIAJLuU1ARFDL72w8mt4XkRzTwhmIa7VwpGw5qr4
         hLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ja+04dw+wijY/8qhE0uhZGMx63QuPG0ocY5G1Po5aWI=;
        b=FrCYL8CwL7V3XQCDC+95CLrlnvLEsTIQw2/MDg96V+8xNBqunoTi9hLNRHVULi4scx
         EnRf7zE12RNgRKaqVGYjuoPlA/YAHsHzV3tM2Ypa4R46Dn1pDXRNbMDk+KJb+xvs8FfM
         V4wjfAqaBda/n1jl/iDn98shNyd1+iTUh1cTt3HxHBY8uYL1rpx34DZswrmVaEfywWCh
         6gwX8DoiQ3fmRnb7UWQKXC6ddZMP7Yhxo1EpozEoF3eoQu4WvmLqOqQcWMuiRa9trsIs
         BpH8Dffym1V1rZpDggF2TIHzKicUauYe44puTwel3mV0mgO65v15vAmOu329qtOBvoBv
         xb4Q==
X-Gm-Message-State: APjAAAVSIKfi6qXTGUytdmpkAd81taCIH+RYroMlU3nVrLClNLDdIGoE
        lN9q4mNC299g+aeZuAntJms12KNQrk3cFA==
X-Google-Smtp-Source: APXvYqwbSYhTDoDmlHHFvKRGIhEim7CreFTaRtjaETboundIzCyPMrxNcGPjynhna7lpanC/Be6AnQ==
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr39492859wrt.381.1576616496214;
        Tue, 17 Dec 2019 13:01:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g23sm55187wmk.14.2019.12.17.13.01.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 13:01:35 -0800 (PST)
Message-ID: <5df9422f.1c69fb81.26289.04c7@mx.google.com>
Date:   Tue, 17 Dec 2019 13:01:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.16-190-g6e31894f1769
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 121 boots: 0 failed,
 115 passed with 5 offline, 1 untried/unknown (v5.3.16-190-g6e31894f1769)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 121 boots: 0 failed, 115 passed with 5 offline,=
 1 untried/unknown (v5.3.16-190-g6e31894f1769)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.16-190-g6e31894f1769/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.16-190-g6e31894f1769/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.16-190-g6e31894f1769
Git Commit: 6e31894f1769bda9dff133b8baeedbc9918b1cdb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 22 SoC families, 17 builds out of 208

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
