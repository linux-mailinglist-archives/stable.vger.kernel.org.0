Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF41270E6
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 23:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLSWuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 17:50:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33461 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfLSWuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 17:50:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so7632990wrq.0
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 14:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EPlbGEFJk4SRkc8E/07NodYIEgL8YuQuZXWm+TrpU5A=;
        b=LY1BF9cnu2AxmM2b4lGkWYdD71iacaSkVeKaiDrB4kV9JaTqTiGYnvjNrv6tHVMibe
         sEcrs25iYHajV2UQfYmVp+KlM2P2I5/7oiZgT+ftZdfcfRPHZ47pCubooXeYPZKNBBVy
         clUQs4VXGpJngTwLvE6iAgOO7OwEWcqlPPfH9tu3hazkc4cfJD7jEHi+pTbBiixNyC//
         Dc0fykez09G8ar8aOS0h1BCXrTbUJ/5EvtZJwiMJClJocDcL+sMrM1iAEkrcLTsncj6z
         CGWed5NbSVbpQ80dkDr0bMgi+F/oBIvRqZ6C3exfTyT9Qrj7XALmgz1jvEwutnE/OZVl
         RlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EPlbGEFJk4SRkc8E/07NodYIEgL8YuQuZXWm+TrpU5A=;
        b=rbJS/VC0P3DML8ElVdfWBljRopr5OWoe46HkV892fuj5BQ1i0FhFZxF/s//BJ8nk0w
         iMXPELHyO7tQSkTy6uqfJQ7WO5mOCv+FAcsugbCDBrtfB7kMac5PBBzlxQZc3iFmBy3l
         JAvY2H3BajeUiTP59BBPN/DhOUCP1Wy8MUzM7vkERPw4F0pN4n+D7mVpUMnevlq62R8I
         dtju0+bgVCoCuXkSdULu+ICHHdSEzpSqVUh+K2cVN39fhCWR9VSuXpcLdE13ChlPDzY/
         RvEGGslpToGYXjpJ4DXUvD7JfFWrJXDqwRLjUQ2o3y1ds6GSrYfMuc67gw92bSbtzWJc
         BHJw==
X-Gm-Message-State: APjAAAVBAPLz+UYqc2ZDBd1U6fRgfVm5FJrd0HMt+I85gApZrmgNwUwV
        r6byj48F7Z6UyD/9K+7Ram7tNfkSEXlsyw==
X-Google-Smtp-Source: APXvYqwk3a+G+FkLd75eKiE2eFYD9z4MmXl3C9rneXFA95mvWBIKf7s5C2BfrBCLTOsRs05LMW8gVg==
X-Received: by 2002:adf:f990:: with SMTP id f16mr12026323wrr.185.1576795800290;
        Thu, 19 Dec 2019 14:50:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o129sm7850519wmb.1.2019.12.19.14.49.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 14:49:59 -0800 (PST)
Message-ID: <5dfbfe97.1c69fb81.f49aa.86f3@mx.google.com>
Date:   Thu, 19 Dec 2019 14:49:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.159-37-g5f381a956c02
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 114 boots: 2 failed,
 104 passed with 5 offline, 2 untried/unknown,
 1 conflict (v4.14.159-37-g5f381a956c02)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 114 boots: 2 failed, 104 passed with 5 offline=
, 2 untried/unknown, 1 conflict (v4.14.159-37-g5f381a956c02)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.159-37-g5f381a956c02/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.159-37-g5f381a956c02/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.159-37-g5f381a956c02
Git Commit: 5f381a956c024d78be56814f10b1dee4c973ea8c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 16 builds out of 201

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
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
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxl-s905x-libretech-cc:
            lab-baylibre: FAIL (gcc-8)
            lab-clabbe: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
