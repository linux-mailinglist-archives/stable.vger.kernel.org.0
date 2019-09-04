Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35651A9700
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 01:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfIDXVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 19:21:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51166 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIDXVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 19:21:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id c10so560922wmc.0
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 16:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+cQEKFH8HrxoD2GgI2D5PxiBEsa3yF83dOCqARH/zII=;
        b=S4oJWO1PMfBRzk7oy4VHfcgwiDLWYy/221RQkqd9glW/RbYZl4yaxblwgxOdxyZGlQ
         r+B4/Xw+RoMyD2eQwn+ClAThJcsQXvPRKiAFDbMWFHTxFCyvsVIuW3dqyeGk3bLRG5UA
         6ZMUsalgICax4w8KLSRsseClHvtNJRBG/ZLdA9AQyam0NrUIiJSt9JycC238lKuT+ga/
         kHhf5SbEWiRfuMeZOB6w51fKyaVFbxGD3EKNdUQuCjXCln1LrI3kAYe+SL/gilFClH+K
         0eY0CSvA7zz6FwrJBVK5RdLwzt8asDjClkLBfF54ZZEeI20M7KmW6KLp6p2/BSD2e4Yo
         kk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+cQEKFH8HrxoD2GgI2D5PxiBEsa3yF83dOCqARH/zII=;
        b=FNu0/ZnuviFM1BJRF+7zyAtaLvjHRf6mwSOt3Dnmy/sbFB3+60ZNrYnsMUqHeCoLGI
         9QhlPOgFu7o98JA72m1gWveMFiOMNtKtGeFWTew9CpyVd+fZcPZ8XV/AWg0KX5/Y5/oo
         2ZazxGUrdnsqz6q1HSDFU44ZqFm0szyJudsGqzPuENPnslRboRkRXjvw/CD55VKTL/DH
         yVWj2LppBcVG6vLV3F+9BwAZ4vfT9anPOCWHnUVn6M0ITKO39+G5F9EEfmGeabVTd240
         2bR2zVgWEz18u/1zbg09VMYHvtSF6hmppS2WXf01OaW+UPXi44ZQfJG2MqVDK6EkDTeL
         5msQ==
X-Gm-Message-State: APjAAAWxzNT66pVe9xnvl6tkaofEskvUaxfO+FhZ4zzgzYn7qcYNiI7p
        6namvZRzc+ch1vTmSt+sarbKI52aVb0X4A==
X-Google-Smtp-Source: APXvYqzYl0JSWwqIRCud/Bg6f2o2bea8+8ev4jo8fNxMCFnrd8e07BzTy8cnJvswJM9Ddby2nRzRKQ==
X-Received: by 2002:a1c:f101:: with SMTP id p1mr498874wmh.62.1567639267163;
        Wed, 04 Sep 2019 16:21:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y13sm679573wrg.8.2019.09.04.16.21.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 16:21:06 -0700 (PDT)
Message-ID: <5d7046e2.1c69fb81.7c68.3235@mx.google.com>
Date:   Wed, 04 Sep 2019 16:21:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.11-144-gb6eedcb8cf66
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 157 boots: 4 failed,
 145 passed with 8 offline (v5.2.11-144-gb6eedcb8cf66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 157 boots: 4 failed, 145 passed with 8 offline =
(v5.2.11-144-gb6eedcb8cf66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.11-144-gb6eedcb8cf66/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.11-144-gb6eedcb8cf66/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.11-144-gb6eedcb8cf66
Git Commit: b6eedcb8cf6670234e137d277a5ae1cdf5cd141c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
