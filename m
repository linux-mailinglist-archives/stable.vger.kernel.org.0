Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751A111BD8B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 20:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfLKT7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 14:59:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32921 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKT7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 14:59:06 -0500
Received: by mail-wm1-f67.google.com with SMTP id d139so1957371wmd.0
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 11:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3ZSl8V1SN8sjIbos2odrJfB9t1q0YMeEhn5aljt6DLc=;
        b=Yck3fJSI3VCQgdW25U4SkjLx3/+VlpEYc2DtVP3nmLYAS3svBNFYPkD7BNlRgNBXcc
         xsqxBCWxu6m5rBJ6cQYKkPh33UEE5vd/xnG7jr6YM38BQ82XOb4DIfGAH8HKvRnt9hpP
         U8C9IzWk+Ev8IuoDY8AH4879iZc7N64t1QAzyjSn3uUHFBtjtpg45zekDUD/40rsHYfB
         T7Oem1LXi7ccUJZZWL0lWcUPENyFFzGDgb3hv5NFiIrtrbp/GVeHshV29e39F3Goyg+d
         YMwOuehLpoEKXF6pH9Pg3U9ppcw0CimbPZlqXOG55gjkBj4GmF+Cx0DmyEz+WtY1kCcZ
         qBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3ZSl8V1SN8sjIbos2odrJfB9t1q0YMeEhn5aljt6DLc=;
        b=iSfe98NAFE6qrLXUfxDompkZxCaN50EJt4R/0X3BI7HC1mAeQylphwhUmbdqjNvzxl
         aC8FCltT7QJuOy9C7RNMom9T8R5mFtQ4S4Occx1hrBZ7ici5th138vX3+8VYI6MIeVIs
         uVwjoVxNK/aFTFd1hHRWiikN/VpCOzzo+ntFr9iKZBf2ofanBLrsEWvk8jcgFCuZLuAO
         D0p2pTjsU/Qn9bmijREwmaXZCPYmnQGai6gH2LOJXU9dAdwOyBme1lmhorOVj9thsoU6
         dgRt5IbiFet2KrzWH49WOCLkKXYR/BDM6upKl7d+NRBOqm6sU8r6DPnko6+4hytYQ24+
         ZwWg==
X-Gm-Message-State: APjAAAVw9bPgXjCxW/ELK+moRpV+dVVjvwrFkdaG+aeadiU57MMpBWjr
        vkUz2OJswaJe7RmQmy2T6l7vF56npDk3Fg==
X-Google-Smtp-Source: APXvYqywct4HBCLTdBI/xn98uNy+1YFwh8dfWbWRzmPYhltAQVBAiMfLl3lhRMSvwbbSglPST9qzfg==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr1666477wmb.99.1576094343859;
        Wed, 11 Dec 2019 11:59:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w22sm3278143wmk.34.2019.12.11.11.59.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 11:59:03 -0800 (PST)
Message-ID: <5df14a87.1c69fb81.74f09.0ca9@mx.google.com>
Date:   Wed, 11 Dec 2019 11:59:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-150-ge9bb958445c9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 127 boots: 2 failed,
 118 passed with 6 offline, 1 untried/unknown (v4.14.158-150-ge9bb958445c9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 2 failed, 118 passed with 6 offline=
, 1 untried/unknown (v4.14.158-150-ge9bb958445c9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-150-ge9bb958445c9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-150-ge9bb958445c9/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-150-ge9bb958445c9
Git Commit: e9bb958445c98e731963dbd0ef605da30bb8d834
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 21 SoC families, 15 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 2 failed labs

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
