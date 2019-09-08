Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9519ACEE9
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfIHNav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 09:30:51 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:50481 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfIHNav (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 09:30:51 -0400
Received: by mail-wm1-f47.google.com with SMTP id c10so10939786wmc.0
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 06:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VFHq1MzY7IEBTixMHI2zNlCm07EJegEnwTGpPymLwLQ=;
        b=l2KvIvCNeJIL1DE3B04j3KqfnetkrCfDDnHNcOD4Efp/JWbXbVTWU1zDarWS9UVVJR
         ypEbtEfP/6quL30VvbPPTSA8YaPgCnNvBOiJknhb9+tC0SfQ9v1o8Iu6Gx5ymsddjJQD
         eIptZn5WP1Fj2vanTeMWGxl4gjqpNdXfwnk8cEIKaB1zgWcqR+W7kuJ+iLnISNV9MUKw
         xRMYjGLKgMFUTyiiAbd2HiGODfCY9kMW4a+FYNTpZA7YV0ty9Dw/Nvj4WnAxgu47sCBx
         jXVv3Q50tr5VIOhl70H5t7iJgm1wbiOGG/il9SyP/LDusVCkhuIdAjL29CdabWrZWt/S
         t/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VFHq1MzY7IEBTixMHI2zNlCm07EJegEnwTGpPymLwLQ=;
        b=VFiOJhXXHy2HGW5muOmx36tbshXUWzBXW5koOcsY4n5xxU7qL8vKI/4e8ztbZQdtgK
         Mw6yfMBxeiKM7h9DCYnoyOCjzPp4Dcnt2J8XSKyOVgFQdfFrvb9IBnSLIUZf/w9gCpKj
         wCs/6RE/4HzAeInvh74oxm/b+iHHCaB+reSqYhqfvMoVuz/P4QqDcwE+oG4onMFFEu0z
         wZ6M+SNGPkkCOMZWamQBvVCCqL5vuWulG/zzYVEjevho9vUoI/bwkTELchxG+n1bEXiQ
         m3qqqUKxexDameVr1Ya6zCTaCcaHNTiEvCMmRcEoMlebnpuoS5hstwHI+gLVyAyvUFE+
         AoHA==
X-Gm-Message-State: APjAAAUR/bUB/Txo/0r4S4KIItb8WZYnVZ/qKxK/ST+TXF6J8jVT4h0X
        /9EGYsPcv8PW0LRHFgFzSvZlgzn7+Sg=
X-Google-Smtp-Source: APXvYqzPPanK/eM7uxELDc92OlZ1GxBuiohsv4M9wVwbDbPP+uzgWR/Qd26PAeVQDKa8FtF8m5v3Xg==
X-Received: by 2002:a1c:a796:: with SMTP id q144mr15140226wme.15.1567949449218;
        Sun, 08 Sep 2019 06:30:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q10sm21020818wrd.39.2019.09.08.06.30.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 06:30:48 -0700 (PDT)
Message-ID: <5d750288.1c69fb81.f83dc.e1d1@mx.google.com>
Date:   Sun, 08 Sep 2019 06:30:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191-23-gb00ee0021edc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 117 boots: 0 failed,
 107 passed with 9 offline, 1 untried/unknown (v4.9.191-23-gb00ee0021edc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 117 boots: 0 failed, 107 passed with 9 offline,=
 1 untried/unknown (v4.9.191-23-gb00ee0021edc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.191-23-gb00ee0021edc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.191-23-gb00ee0021edc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.191-23-gb00ee0021edc
Git Commit: b00ee0021edc466fda95e460674500dd978e8df0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 14 builds out of 197

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
