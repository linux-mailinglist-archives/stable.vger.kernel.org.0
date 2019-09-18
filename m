Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A856DB63FF
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfIRNFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:05:51 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:44243 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfIRNFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 09:05:51 -0400
Received: by mail-wr1-f54.google.com with SMTP id i18so6794108wru.11
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 06:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8yWSaq1SPkhAnGKUElxNjUPCl80FK7UQ5LA6iTbaJZo=;
        b=0HTRpqqfPIUXvuml1DqzmmEpUR8Zwj4m+qm3LLKGOxWXJOEVn4zfPmpr0pvAzJncq/
         Oo7BQwpbrZNASm2HBbV57ACvkvwM9wggw+KToPfdTZTvkgxCutfv4AT7fvw0c7qofnRV
         2GtScMSQS6LcTrYbT6S9+bHT2zmiq31LeekQoKv7uxJo/Qv8f2fT8SmuLxzebQSoWm49
         PeBVLih96Fpg9tRgEQZL77UEi/BAOm/CkjN6EicyPpOSWtCYZgm6RS91P6exHNf5dux3
         xyi3VgN9PEj2gbkdozrMhhhjcNpVBxAoV9RNO7Ysl8UqqOBF4+HHIBov3wTtE0yRR/yi
         Y5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8yWSaq1SPkhAnGKUElxNjUPCl80FK7UQ5LA6iTbaJZo=;
        b=mhQs+BAJlqPGy2oh71D2UnOLM9DF07ubikXgnCs0wSjkZfY4CzvxGT1PSIX6BoOKX/
         Vz1WQOBAUDj89nKKQYyZEN92IxoXLWDSnhHYsIdvBPpl0DwAFS1fqzxBmj+FYuKRzGAD
         fL+79bUkR/lDrLYp+2ImKzg60mt4JPEQoAqgcNlvmXWRwy4YxgOz84mjE/ctvXTDJfB5
         IwmrXYem3EuPbQixTAWgT+D/Xp8hAoDTxQHjDQMDpu/rtR3VLRIld2k9Ctzx94eCtYcA
         Yr5zt5mYeuhl4PrCpdTvg3LRUInV4+cXEuSASp8JyZOBMBQHnkVN+bzwEJJyWv2cbPcb
         jvuA==
X-Gm-Message-State: APjAAAUeleRen7AahwCIPP4Y0QWeKgbprHb1CjxVoY7qGTGO8E3BH/xi
        wjJSVUVp9V0VhbUon4AU4hFaoIW0415Jvw==
X-Google-Smtp-Source: APXvYqzWAm4ibJQgsbMuCk+oc5Fj3Ovtl8uaqpElu/4T3afwIHChAnB7LxfWmrO3O5+lzOLsVbbVIQ==
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr2929958wrx.309.1568811949135;
        Wed, 18 Sep 2019 06:05:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l11sm2318209wmh.34.2019.09.18.06.05.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 06:05:48 -0700 (PDT)
Message-ID: <5d822bac.1c69fb81.983fd.9fc2@mx.google.com>
Date:   Wed, 18 Sep 2019 06:05:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.144-46-g187d767985cf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 131 boots: 0 failed,
 121 passed with 10 offline (v4.14.144-46-g187d767985cf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 131 boots: 0 failed, 121 passed with 10 offlin=
e (v4.14.144-46-g187d767985cf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.144-46-g187d767985cf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.144-46-g187d767985cf/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.144-46-g187d767985cf
Git Commit: 187d767985cf878208592ce3ca667e5021abf2f6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
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
