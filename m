Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99261137E1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 23:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfLDW4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 17:56:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55782 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfLDW4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 17:56:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so1523505wmj.5
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 14:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U2xHVaAYB4O/I5BPplmZWgswacRYycOcDUvXSeWm2Gs=;
        b=qeqDXtkMWf8NDt/sOOdvo8Hee5Gho3QBNnhfeBK/0lGDDDu6oWK1579Bm9BVxxSntz
         ptIlrjC7BBO4UG4rd/C6r53ErEOrKZdHCwtqdlfZjo0JMHYjb+xFm1yEYgDutE8zxz/3
         kTGVqRBR6pAE65g3qNKpJ8QhprfDFmIltE8AX2ZpnClIneqUMqjgYommOuH9377CwOEi
         aMbKs7lVtMwmZXs1IXRJo2krtOt7gWGyEXY8BnCHtFWE3pFe9VnG2yG+0V8QM6oXk7Pr
         UDkDcFgeme3nIVyseLgN+bt1190OtxArISrYWRcU4hoH3P7iUI/bjY5Q3vE7/eYdxPyq
         NL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U2xHVaAYB4O/I5BPplmZWgswacRYycOcDUvXSeWm2Gs=;
        b=kz5Hvqed+LEpDXy7u503lmX8PaM6eUEm2HO/05U61GWFUpu2Pqw5GYjjmE2ENQI5aJ
         v/Yw1jFlYpungFzX49tOOOlcQ1PrNkwwk5HKSUkXc1ImK5R0qbfCnlMaAda7ibXTJckJ
         +azfcRHSF4SeZ3Cv8QnXefYV1vunr79yq6VxRUDOTImAtD/oYiWIBadf+iXVS3Kceb6+
         NSNnsY+zddRzLUO6m/XR5ErKClaM/0lGailFz8q+kQZPrs6fthufst4r8OSsHHSN2q7O
         ha/LTgUAA79qSpocG5LTe+i3IxpVyjVe6MkoppkDw0/4Z+Mn/CcOgihMcgI9riKvprxX
         x5GQ==
X-Gm-Message-State: APjAAAUiPif+9CoKmSfOFF1JE9XzhQc1obpEd6O4tIZjR5THNWK86jxU
        W3A5sBmS05u0tveVCEykupECRfeC67E=
X-Google-Smtp-Source: APXvYqz59Knsd69LsL+DJc6T0EVaDehhqRRI0Rez8afGlUDhk+OtAP3CpNOUfaepkIs75gtOTM+g5A==
X-Received: by 2002:a1c:cc01:: with SMTP id h1mr1892061wmb.172.1575500169428;
        Wed, 04 Dec 2019 14:56:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b2sm9977325wrr.76.2019.12.04.14.56.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 14:56:08 -0800 (PST)
Message-ID: <5de83988.1c69fb81.82fe2.289b@mx.google.com>
Date:   Wed, 04 Dec 2019 14:56:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.157-210-gce267d7b1d71
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 2 failed,
 119 passed with 6 offline, 1 untried/unknown (v4.14.157-210-gce267d7b1d71)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 2 failed, 119 passed with 6 offline=
, 1 untried/unknown (v4.14.157-210-gce267d7b1d71)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.157-210-gce267d7b1d71/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.157-210-gce267d7b1d71/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.157-210-gce267d7b1d71
Git Commit: ce267d7b1d71f10d722fd3c8a729ccca53830262
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 21 SoC families, 15 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-q200: 1 failed lab

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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
