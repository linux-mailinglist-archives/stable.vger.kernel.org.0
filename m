Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9310596C
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 19:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKUSVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 13:21:47 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38456 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUSVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 13:21:47 -0500
Received: by mail-wr1-f52.google.com with SMTP id i12so5646005wro.5
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 10:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YDyIi72oL+/n0u+G3pcX0mycv2tbAaj9xWueoVZQl48=;
        b=lFsNoSV7QxcqBYvn3e6Tec/3f3YTbGjDf6t6BKr4gguDx+IbcnQUyVDXQaplr++8GR
         g668CgLYhEeckrNXhYJzDNUhA8+9jScVwcb08F+/Y0mtNkAK8/9i0KOcafv2KCm4Boqy
         wBDtvbUOPGa/lVG+D2CoPQxty0eL3VPRNpCWW4VtaGpsyN+53qMfw/CzTBIpQgD9PtKy
         NxhD83QLnqkUwh3WowzDCahsoguS5+UKab6mRsZHHy+UAmrDJZ+JhzT9+f9asVPbGO/5
         y2rTvf8PzezY4WS0DULL2J0ZSP3kAI4USG8/1MXuYZ5jmyzKnI9Ur8cmahR2FBWzpY/U
         A0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YDyIi72oL+/n0u+G3pcX0mycv2tbAaj9xWueoVZQl48=;
        b=MNCfYybBmitWIbTsenveMK/gTkrJinHuN5pj+G4P5rav+D5zwT9G1itPgqfuG41ouN
         Ju1PQ8pz9CnJcq08qcq5Jpb6/j1nFiEo0OsqTywP84b3WsVWxr4h+ZVZadMaNkqB0Uyd
         Jr+ZQp5dQCUEJDl2wqxqIVZCgALIfdquu+uIBYjXAcId+EOazqFsC+S5pyeNEtfH4dH6
         loEC6ohbf52hap/AlOt2X81yS/pNfWKBo3jn2zP3HRTU95pYqpK5W2IOUsimryj4+se2
         BjpgriTj6lm4DHK2oppMafOEh4+0Sf/ZKJcyc1y/Dk48qp9VqoX1DLWf6SP2uLWElv+j
         qs1A==
X-Gm-Message-State: APjAAAXTLL9zMRFmQc7nz5fj4a5IMldm/dpA+GClxHots8QP2nVp2PPb
        7nNJ/P12aO4DG/IRQN6m91DzHA1f6tH1jw==
X-Google-Smtp-Source: APXvYqymFzXr/ryZbQcjD57Rc22P50uu3W39Kscs8jqktkTE3H7fEGMtNOWSw368RFjY9PRQjnvLog==
X-Received: by 2002:a5d:5050:: with SMTP id h16mr13509983wrt.380.1574360505280;
        Thu, 21 Nov 2019 10:21:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 91sm4430807wrm.42.2019.11.21.10.21.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 10:21:42 -0800 (PST)
Message-ID: <5dd6d5b6.1c69fb81.a5313.652f@mx.google.com>
Date:   Thu, 21 Nov 2019 10:21:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.202
Subject: stable-rc/linux-4.4.y boot: 92 boots: 0 failed,
 87 passed with 4 offline, 1 conflict (v4.4.202)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 0 failed, 87 passed with 4 offline, 1=
 conflict (v4.4.202)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.202/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.202/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.202
Git Commit: bc69c961f59512012af64efd4ff20b3cb67c99ce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
