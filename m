Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088EBDA4CB
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 06:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407720AbfJQEgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 00:36:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33619 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404520AbfJQEgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 00:36:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id b9so668802wrs.0
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 21:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IJlnbnyY5cuX1Hnkfu7X6odyaf/nXbeywPLfKyjn1qM=;
        b=ZXQeUL0kjaxV5lHa/3TNz+QjEXIP5i9KmMch69i8CZsTopyZxW4TLRAAGk1dZILf/b
         kiOLcEYeOvPSoM0vfwpSyuU+fEUWfb6y2w1g0hn+9cyiG/zI7DDEl5Hi/yAqNt9TLqor
         7WMHSjljZ9E8vEceDTc9u9Nh0Rd5ZUt2weIzUiHEa1/KV67U5nEvcKdcqrBehOwN165t
         VctgMjK0G/3TmB0reQVFAvMWBkirKgocQfBcIeEGqgTsoxo9rRrSBokcld2pCZABv+kF
         iHpRisrRdx1063UcApnpYmFph7cCEzhuM2bWDEWNH8lmKxC5UCpmtpYx2sp2TFOx8Wzb
         5FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IJlnbnyY5cuX1Hnkfu7X6odyaf/nXbeywPLfKyjn1qM=;
        b=b7nfoKD/CAkx4aIOHtB21FHL2kUnxMvY8F/5P5vCLHQE9mHbiugPilbnbOaKjHS0pP
         RqLh+lADaBw1l0CM/ss58XiqPVsjrazMJk14WOL5tiip9W8SsrkvqcvueJPMkxzGj4Zt
         kyErSuqKrQjg5lJKkQgsG4lc9tCORbzPwBlbYmj95pLiQZaTyEnY4/ZIcKY+a1x4sSSi
         ifMIx3JH3+0W7eznqPO9JAxlKAdrB+TtNMhPnSQfRWxc8hmeMaU5wRrhAbk1ea0QTiVV
         BLU0IKxqwEqpEJUKf1/pPcIJvBjpu7st04JJ5c6IDUQH0hB4i5dFkGHWo9QMIoSMdf2U
         DH7Q==
X-Gm-Message-State: APjAAAXyB1ILn6L58f8Gnnk070SPPEVW8LOHG/X8MZpwDlbfBxEGDtIs
        hixtaK20kF+l7TGfxOqv/IKJAEI4Sl0=
X-Google-Smtp-Source: APXvYqzDQ2+tcp8qY/TPUVrEz2sBy2dBbwbILRtkKsC/E+GFHHuMp4v9HTWkWWmR5PQ0gc3OtKA0cw==
X-Received: by 2002:adf:f402:: with SMTP id g2mr1146467wro.64.1571286975575;
        Wed, 16 Oct 2019 21:36:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t123sm1164129wma.40.2019.10.16.21.36.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 21:36:15 -0700 (PDT)
Message-ID: <5da7efbf.1c69fb81.86574.5017@mx.google.com>
Date:   Wed, 16 Oct 2019 21:36:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79-82-g99661e9ccf92
Subject: stable-rc/linux-4.19.y boot: 106 boots: 0 failed,
 99 passed with 7 offline (v4.19.79-82-g99661e9ccf92)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 106 boots: 0 failed, 99 passed with 7 offline =
(v4.19.79-82-g99661e9ccf92)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.79-82-g99661e9ccf92/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.79-82-g99661e9ccf92/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.79-82-g99661e9ccf92
Git Commit: 99661e9ccf9206876ca8f509555b7b0d3e45cc13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 23 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
