Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2162510C8EE
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 13:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfK1MwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 07:52:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55050 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfK1MwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 07:52:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so10794206wmj.4
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 04:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=19VpaSIRyY8Hsi4+WjqNCCIkWKnH9QXbXV81jhBF/nY=;
        b=chJU3U1ZLv40G97GCx79lDrW24bEkmAA5b3j00ex8zdef2uJKgMQKWEz9tjCwS0Ej2
         /2EHroaFrwu69cpS8C4y/LI8q6JLEItiagDFYQWQKtAM1LB2u0EYFBkV9y3Hu6/HADv8
         eTwtNnbBHLoJ2ftnyS4gM/sWvpPOAV3J6RxQuImzPXpSn7rFu1ApW8Vpxm0F6yct2vTQ
         tKxgdpdneup2Vp0ryZOKbVRjXlvKTpY5DFQQPOAt58J8+Hs8knUU+XVI6aJmNbda3fJ1
         T32Y/EzFYjwCU+fsEBae5thc32fU2H9ArZd1gdWV7tBSlZCIMFbCbxWHK7/gMnox4eG/
         xWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=19VpaSIRyY8Hsi4+WjqNCCIkWKnH9QXbXV81jhBF/nY=;
        b=BMzcz4qR3tC22mezKvAZQqyMOegWNPZ4KhBMQd3qHv9Ydztj7zKI3heADE5sHkz/DV
         S9UbX5yRNyDyO6YCBcpPo2CY8Z4O65fNsMvJHi6gGhrWdBCPvQoJvOMnTX7Zzvy6Z+LH
         1Pp+wMWN+Lvqk3pww97nnoL2WW0uvsjFbo1pOHVtZZB1kHHQbsoUiasIsS37a04sbb+w
         31LoVn5Jax2Pt/hlAHQQK2+H20hc9eQEFMGF/RPp/+KRTWYfIApDsp9M6GjthIiPeSzH
         LPVmnkTPenBKpyOXWd9rOiBaJh3O+jEt32W3WfapTAv8ktUwilGJcUGMEyRk7/kRfmPm
         GZZw==
X-Gm-Message-State: APjAAAXAwpe49IWnrhvR6POK2jLPTJoMpI6d/byGjvhX3d5zgYQXi0JU
        zoGBXi2sM24LVWjn7qMOaB165su3Hthd+A==
X-Google-Smtp-Source: APXvYqzZ3Z19rXAU7Mbgh6I+WOeFq1WEpXf/4saVcBhMG/qALiAz2fgSVsBXXvwowfgqayL+aCzsfA==
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr10023379wmh.161.1574945542734;
        Thu, 28 Nov 2019 04:52:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m9sm22299516wro.66.2019.11.28.04.52.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 04:52:22 -0800 (PST)
Message-ID: <5ddfc306.1c69fb81.3ede3.219f@mx.google.com>
Date:   Thu, 28 Nov 2019 04:52:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.156-213-gc9b009c3c595
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 120 boots: 2 failed,
 111 passed with 7 offline (v4.14.156-213-gc9b009c3c595)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 2 failed, 111 passed with 7 offline=
 (v4.14.156-213-gc9b009c3c595)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.156-213-gc9b009c3c595/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.156-213-gc9b009c3c595/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.156-213-gc9b009c3c595
Git Commit: c9b009c3c595d2e2c707af78e63755ac3489db2f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 21 SoC families, 12 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            juno-r2: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

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
