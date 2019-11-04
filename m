Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA0ED6E0
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 02:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfKDBWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 20:22:55 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44753 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbfKDBWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 20:22:55 -0500
Received: by mail-wr1-f41.google.com with SMTP id f2so6264186wrs.11
        for <stable@vger.kernel.org>; Sun, 03 Nov 2019 17:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SgE+xA8VS98DLNQCkQUn71PZAenzS+KyTShIaRMacRc=;
        b=0uFWBcEYXeGpDPzG+hWGzTV94aJDFSTBnwO+dU8Q4hJSqKRq6jGO7WIyL7nQ8KLEXa
         DJqi7Grdg3w9c/XiHxdyWkihKax83w3L4dI/IcKnUufH0HB/QbET6KkK9cEgei4lCLgW
         K4BdYH9EZ+brJjJZu7cXiaHGyBlfcq/UvjZe0YZRp3OILxWKt094SR3p4ZQrMZPBs0Pr
         1GcIw+n4iWMGn+UVfinl3G5IT6ktf3WogObj9RdyV2pGF7v+oMI/cbkRgrLMpaBMmZKJ
         tNkk3psx0oM83pW73SGDXhoT4QW8+wt/NqYpQSEfwn5Z0BernOjcnVQBFAGG2KV7Uehn
         kFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SgE+xA8VS98DLNQCkQUn71PZAenzS+KyTShIaRMacRc=;
        b=U/ZxVNrN9inb6FXDcOLijEzCrp8gLa32rCg2M7PCTLbdLOWyQL6OopZ3cRY0YVrl7f
         bdrBxpDBZDGvS6Qs7uDVCIGWJqHPFW9nIgp9zsm2hyIV++sQVSRvorUhJoWSa27LXqtZ
         qy3HJYcfdxhM8++3ckdvn5l908Gj6Qgoq2AEmROMG1hyTocCn+X5UGVxzctGrBmNr/qW
         TglOKzk2Au/6w0xwRHo1hOFXEw5tcBnEDxocG+4PXIdprtPSb5WDX7kdAc9nYKiYaeEz
         tuGfYE5DikqvY8icGzn5fE8UZBU/Jnu95Bwy6/RyWo2Yt1xl0+mIjfv3bkgaygY3XRA7
         emXA==
X-Gm-Message-State: APjAAAXKcjAQUhpXNBR3znR8EPtwRACrxF2zmCtWo4KgOuA07qPCYrj7
        o5T3Vv04Ry6IRkQ6bRDTUXW5J2INmBlhag==
X-Google-Smtp-Source: APXvYqx8Mc/qRRea0KFN36Fgq6I3szJ99rMPpf0UjBz2iNtTO0ppDJP9hcD9eM5Ncr3emHWoLN52bA==
X-Received: by 2002:adf:f70f:: with SMTP id r15mr21832359wrp.262.1572830573255;
        Sun, 03 Nov 2019 17:22:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p12sm16818140wrm.62.2019.11.03.17.22.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 17:22:52 -0800 (PST)
Message-ID: <5dbf7d6c.1c69fb81.1ad1a.c7c6@mx.google.com>
Date:   Sun, 03 Nov 2019 17:22:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.8-104-gdfe283e9fdac
Subject: stable-rc/linux-5.3.y boot: 128 boots: 0 failed,
 121 passed with 7 offline (v5.3.8-104-gdfe283e9fdac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 128 boots: 0 failed, 121 passed with 7 offline =
(v5.3.8-104-gdfe283e9fdac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.8-104-gdfe283e9fdac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.8-104-gdfe283e9fdac/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.8-104-gdfe283e9fdac
Git Commit: dfe283e9fdac0fe672e93b085801daea94d65fc1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 25 SoC families, 16 builds out of 208

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
