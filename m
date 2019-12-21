Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76538128A37
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfLUPkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 10:40:05 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39662 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLUPkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 10:40:05 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so11975994wmj.4
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 07:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RtAlfm9YcxgU2XQLzDh0XpUMY9kWmsUQLBPf3EKI014=;
        b=eCFIdCBbbd6LdfRZYJFGjxLPnuuI6trNQr4ohOnXO66fcJB0Zjpx+x+/NprFO3+3/S
         5htrl4nZYDLUSlc3GWYsnb/qFh4OzVZFnwVYUe3Ue9n8pOBrX+DfOSNyEBcbsC+E7KuR
         dEQ2M0iSjgTNlxFCR9NOPK9vjjXkyxAojzOsgim0gaagEkeEh3/cxgapMKazsgmN6yu7
         tf15lUQMUWhjloLwNM9F1NGO17k8bxa+eUxOAyJKKI/LZMVoJu08sXbPneGUOL0dySq8
         FVjY3okyleoVHjfgRBXjxqXCWcKusMOHGWXy4+pVh5IXJfeXHzDSYYfakNcBs0Xp+Sf7
         IG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RtAlfm9YcxgU2XQLzDh0XpUMY9kWmsUQLBPf3EKI014=;
        b=CWyemMqzbawYCCeYKMh2DccGlCb+0j3BnSzhntfweyAdsMZtBIV8WFgH+iBBCXWlxS
         4PnCj4WrREecrbz9HCNV38C5EhuSr7AtZ9dkkBGr2xX160Hy4Ykv/kfYLA647rClKyCI
         3FI/EploUjVzQ13aLAeZnQQWPWfHHRaZmi31gMH0S+3Of3w5keYtH8CcRWXhLOwmoWDJ
         z9haUpAvZMwmTtUJXdgUU6ucbj5qULo7SVIpajFSt9fpoXzOgIQkQAOaTAjsF3TVAtky
         Z+sEQEx8fGvrhFt0eUqMp2dhg5mq2Y82bwZOtKRbVqxccW6gtLp75fPtBBaExycUknQK
         RQZw==
X-Gm-Message-State: APjAAAVB7JZFlAObH43A8I60+WVzXNqefjA7E+aNfIpchBS7KvkxQMGT
        Byvs7qTcUGYchiH94gY2mU150KR8UNBQPQ==
X-Google-Smtp-Source: APXvYqyg5MMQZW3F4OU7SyCTM+XlH1cIOBBtWKdprEyqYBHQK+wEWAhZPNrEX5mZMCRxy0udgdNDVA==
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr21918407wmg.144.1576942803296;
        Sat, 21 Dec 2019 07:40:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x14sm13180809wmj.42.2019.12.21.07.40.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 07:40:02 -0800 (PST)
Message-ID: <5dfe3cd2.1c69fb81.6320a.1b67@mx.google.com>
Date:   Sat, 21 Dec 2019 07:40:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 90 boots: 1 failed,
 83 passed with 5 offline, 1 untried/unknown (v4.4.207)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 1 failed, 83 passed with 5 offline, 1=
 untried/unknown (v4.4.207)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207
Git Commit: 45c347668ec580cfb0008ab53a7b4c4242166b2d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 15 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
