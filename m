Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144A6D2C33
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfJJOM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:12:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43919 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfJJOM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:12:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so8081832wrq.10
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 07:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e97P5VYhZJp2whDluDK9/6jXXWNOGoGEPSpWOkW3iYQ=;
        b=eR69fM8hrExVaIrrj963Kqf1wtw/E+Y7dU23WCNOviRY5AxtqRSkS7Bmq2100zNTGS
         S7Vqk4X/IdHak3Ocnb9c6cFMcSQJ0Y5uNuNP6tCIYCRHLCbw2vk781oHOGNkgVQbOS2D
         qoq/GMLBmJD71KA2NRCSLCsiFJlOP1CPWzEPSmDB3CBIFWpPJ7G4RyM8FKuG/FiklrXZ
         LX0iRx9mJwGFaX7oYJ4WmWJJMa4QWElAg06P8npMT8+nEt04zbzFYUnGYvFI7LLbAnsf
         51+jHx2c+tkCO6Xbhlgdz+IPSEHIqYK2mR8jC/qoiy0qTTO0Z7QUMiUZp1gyarNGuikY
         hzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e97P5VYhZJp2whDluDK9/6jXXWNOGoGEPSpWOkW3iYQ=;
        b=AKYrCrUfgV9m4NriEGrF961dsFwP74HAPZNlOSLqOuWK/0nx7yz2RidxhE35XZvIq/
         p1XjACJwsmsx0mM/wQJwc05SyI4JdV97b09U+ueoMcC98ia0Q9FLNsSh2P8IvsMKJnhJ
         3fGYYPUGrrtDl1zw049WfRjFBWhRQlGjqCxpfjN2c4vGyWrZyCH9qzRzw2T9RlwWcRzt
         J52s2L0gqPNnjfotSWp0zgiANfgr7uOZLcrGF+iII3S8qvuXODgSvxbz6WucRvMGu2yN
         PLkFALoLhic1k5KXuQCDFXxTV64Pick7iTM2AGSYvsLHMm3GryK1eqAZy1nc+DtAkYtQ
         B4AA==
X-Gm-Message-State: APjAAAXfGKd2NGiwjfBuUOovOhztuIEq4saA54chIBv+G2pCbtYeGumg
        xSmORxnOb6bCOFqQST3Vw3Obs1BH+EHU9g==
X-Google-Smtp-Source: APXvYqweSKEmGLmZ8DsT65ZQMIxJGRN3ibVPYOv0FuwtsbaRKo0yNekfSnfNfmiBk8Ymc+7S7vQC4A==
X-Received: by 2002:a5d:4a0b:: with SMTP id m11mr9358735wrq.287.1570716776676;
        Thu, 10 Oct 2019 07:12:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v20sm5864400wml.26.2019.10.10.07.12.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 07:12:55 -0700 (PDT)
Message-ID: <5d9f3c67.1c69fb81.6ea62.c1e0@mx.google.com>
Date:   Thu, 10 Oct 2019 07:12:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.148-62-g8952ae7352b2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 115 boots: 1 failed,
 104 passed with 10 offline (v4.14.148-62-g8952ae7352b2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 115 boots: 1 failed, 104 passed with 10 offlin=
e (v4.14.148-62-g8952ae7352b2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.148-62-g8952ae7352b2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.148-62-g8952ae7352b2/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.148-62-g8952ae7352b2
Git Commit: 8952ae7352b2ed94c2a5f3c8ac3f5d1c96b43bb5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 21 SoC families, 15 builds out of 201

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
