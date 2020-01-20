Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4503A14334A
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 22:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgATVOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 16:14:50 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:50951 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATVOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 16:14:50 -0500
Received: by mail-wm1-f52.google.com with SMTP id a5so801695wmb.0
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 13:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=14lpT6chpmOM/4RFe6OTH3vaax6ahk2dS/hYKCLVHTg=;
        b=BtsjO8HqZxLUIn1Buci4A++XFSWEOffPnL5qVk7igzD4g2tjEUCGOwZxjWDQEIKSR4
         c51BhnMMUiOlUvQ6RTOSuwqYx5O1OItNtvsdx1Ca8G/Y67ZhcKu8WbGbBxX7NNqRlN1a
         oOMeN0iHUtpCCceh2SUHDauLAXal6Z3EXdB6k7gx1dAf71QvcMP/Qt6lkAtLIgxMA0qH
         5nbo7JAbEuufYN0KlW0/ud9ANYsoFyuYnkYl4WTy7gz/bae3Z+tSeg0Ti6QNiw01p6LC
         Y4mBWCW46w9uoAvO0py8WoyKYowvFOMjDK7RNzCqKIjuosGfAYVqY65t4JExU7BqseDG
         YW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=14lpT6chpmOM/4RFe6OTH3vaax6ahk2dS/hYKCLVHTg=;
        b=ESVj6KHeZgcmG4BLWDInVtBV7ciXpPb+mHydThXaui1tRKufX75Q7KnD1SXiuGksJ+
         CFyg8cdqQ50HMxnC03Ci4Tinf3IzLjASt51lf8W73TrfJjAbCwZRO48dOuDCKXr173f3
         ThaoH+SoTx0B4vVF5Q3IspWue8vZ8HMMwlYExjgtERRXEyqzsH5WTKi+0ZsGUPFK6s4K
         cAYKjjFasa0eJj0fSsuNq2K7ZVwzlatHUsQq/M+S7AB9Bav2l197AdgrlZlyBVXxk1IZ
         hkuTlq2Xs84Uty173YXHo3sSxAfzzbv0rhXXGOteuvfSCtQ4GZc6d/hGbrEyhHShA78E
         ij1A==
X-Gm-Message-State: APjAAAU+HFxotd7H0uYG1f4TFJg+ynnGQTMrbIO4aZ0dBEQQu5zoucgO
        oUARwbmIvELofj6rMQmZuMa+DbvPOZVtog==
X-Google-Smtp-Source: APXvYqwoU+NOdp9i29Pp6jdFjk8bf4YPBDxuZjhoYgCoSmdqUvP7ZgoPRKYmRyz6QN5RwRFitUfoeg==
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr709430wms.152.1579554887903;
        Mon, 20 Jan 2020 13:14:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i10sm50002827wru.16.2020.01.20.13.14.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 13:14:47 -0800 (PST)
Message-ID: <5e261847.1c69fb81.48768.7c6e@mx.google.com>
Date:   Mon, 20 Jan 2020 13:14:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.97-66-g6e319a78bc27
Subject: stable-rc/linux-4.19.y boot: 61 boots: 0 failed,
 53 passed with 7 offline, 1 untried/unknown (v4.19.97-66-g6e319a78bc27)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 61 boots: 0 failed, 53 passed with 7 offline, =
1 untried/unknown (v4.19.97-66-g6e319a78bc27)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.97-66-g6e319a78bc27/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.97-66-g6e319a78bc27/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.97-66-g6e319a78bc27
Git Commit: 6e319a78bc278fb8f9173acec4733804333d8416
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 15 SoC families, 16 builds out of 205

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
