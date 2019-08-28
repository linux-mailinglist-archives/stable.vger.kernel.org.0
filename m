Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960FE9F7C5
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 03:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfH1BVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 21:21:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35372 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfH1BVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 21:21:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so694397wrq.2
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 18:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q1/Ofde3eheBbpcLir1coN0/ebDNsE0zXOWBvpHEjoc=;
        b=PyMOfnoCyzFRkKoQ62ssyTDN+owNRFjaYtEdgISblwnpLLzf4+x2WYY8HxwM1v/I/3
         YEcVusC3ij+9R8lgdK5otFTZQ+ncfBRsQVP9fdSE+qWKaQn0nimj0pEpU9kiy9rMnJqy
         dCQSBu48pOPLcGaR22CKqnaRb+/uOA2NGHVeFIsA4trxDCij5X06B7haX5AnP+ujcu8R
         4ZbBIiiDCqO6KJuq3WGqXP31gJ18iDljRad30dZpHAYIIuYtg0cRPo4LFA+K19c7Feic
         IRu3/cI9EjRsJTvJku2LJY52cAbHEujrPc1QCj8qG7vwzPdfHmQf69gHUZHePUA9h5B+
         SHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q1/Ofde3eheBbpcLir1coN0/ebDNsE0zXOWBvpHEjoc=;
        b=AHUo9nYwyBTjXPyavCcSDLKkJhe10Xal9REzZRwDImGxIwGAullCR0NuP1g62214xC
         ti3GOMtaiNllImXfobnIhHMwbYvv6QPPyTJnm2Xzm1Z+axNESFs9FXswkD5y6NxLcqtZ
         NRcf/kUCLaMfSvAIQfz9Ka2ONxGYM+8ivAqagRxkl8aILt1+hejsa9vIFJAhAdLT19x7
         uTWcZHfRMqEHJDI3oo/kB5ldbOIxJewuhWAY1k6T9BRbPVOgm0mKHmv+vTJ1mPiAR6X7
         bO6qW3loraFUfXkFrMtukTZOKBx3qPn9/5rRWjw2bacDHJajdCzW7Vuh9DRPUB1KQ36X
         PJjw==
X-Gm-Message-State: APjAAAVJnn8WrkCQkqpEiJ6y/uSOlQ/LIjuZdmwBCb1/J6dxAulFgMck
        tV30FDi/KQZqdcPzQiuwXS1FGn1qaABmUQ==
X-Google-Smtp-Source: APXvYqw5RpRe52KqlPv5nosMvhtbDg4i9E/5YOVOxpNVB7b4JPzTdqpmpux154fcLuRAPLAjpr55QQ==
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr533086wri.258.1566955278563;
        Tue, 27 Aug 2019 18:21:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 25sm646529wmi.40.2019.08.27.18.21.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 18:21:17 -0700 (PDT)
Message-ID: <5d65d70d.1c69fb81.5f32e.3684@mx.google.com>
Date:   Tue, 27 Aug 2019 18:21:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.68-99-ge944704d5a79
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 133 boots: 2 failed,
 122 passed with 9 offline (v4.19.68-99-ge944704d5a79)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 133 boots: 2 failed, 122 passed with 9 offline=
 (v4.19.68-99-ge944704d5a79)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.68-99-ge944704d5a79/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.68-99-ge944704d5a79/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.68-99-ge944704d5a79
Git Commit: e944704d5a79f6d6506a872edebd16e2b93cb349
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 25 SoC families, 15 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
