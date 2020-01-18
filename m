Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD41A1416F1
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 11:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgARKKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 05:10:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39555 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgARKKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 05:10:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so24924790wrt.6
        for <stable@vger.kernel.org>; Sat, 18 Jan 2020 02:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lKJ4jYMVIZVklfYRU8bynoA8cYU8iHIoDY8dwy71kN8=;
        b=ss9x+zTgGOjFCNvSDBg9QFn0EyljjAy6oBnGM8GnVXcrRmOhnlOo+zcWEZLRu5FmyR
         bCsrpVtbFMqzqQxJ+BW2owH7ufHr9fWC/ZbQ9S2w9xUs9q9B/zTO/iNvyHGgltAg0VNh
         ti2XrHqzkyh+AsIS8M1uy9lUF6nv6wVER2u4xsNMBKwLq1nKUmPyHDz1mr4GCilrx/Iv
         ElJpm8qrUiijiUk4VwTmDFf+gXysVyxY9B72S578P7YXtwujX239JNCYLXBj/x1pZf4k
         CbUaFRhnztjNvCQ60exVoVOM5aNLqWskXRLEYpZjp1Wv8R5zvKkcq8VCF/kTvimeAFB4
         oEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lKJ4jYMVIZVklfYRU8bynoA8cYU8iHIoDY8dwy71kN8=;
        b=U9O0frEc8uq6IMdXLjjCjtRUogc+5xDMIj5eswaQX9JvQHhjFEE3+EkOrfg3yVaH58
         hUlR2/y1CJ5ztZE6u6bWdKtdGmULSrR9aNY145AWwIwyowZN7warNSK2MODlydqq6M69
         wR+kG7L/FLGHg1ctbH9mMq/k4/kg3Xk4ZzND5yKVlvCyRNy/uxY2Nhlx1UAKhtAI3UOU
         9MHutha4MKX7vSFVjKtRtabzkcXUPD2uiV4ql6SRvGDsQQfxaa+Wo242e95GbzuHVnDe
         ACWLWcqQ47eSPVHCYSDfQjBx0uxVDvRUn6Hsk3T18fxMuVxqtk3sSho+Ajn5SwdJgRWs
         RG4Q==
X-Gm-Message-State: APjAAAVwNy1PKfJBXM/gkydZBUaGbSZuehDzE8sXZR5P8tXC0DwHqF5N
        VDM8mbWF0csdL7SO4AGMsQe4/zVa2E41+A==
X-Google-Smtp-Source: APXvYqwzpt5CJLpZXHu0YdnrxuuAG/CnHHITkZLZbcx+XXSxjzJoS5X8vAMEjQRCGcMRaNDbAAF7sA==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr7598501wrm.223.1579342216791;
        Sat, 18 Jan 2020 02:10:16 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm36583230wrx.25.2020.01.18.02.10.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 02:10:16 -0800 (PST)
Message-ID: <5e22d988.1c69fb81.64514.50b5@mx.google.com>
Date:   Sat, 18 Jan 2020 02:10:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210
Subject: stable-rc/linux-4.9.y boot: 96 boots: 1 failed,
 89 passed with 5 offline, 1 untried/unknown (v4.9.210)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 96 boots: 1 failed, 89 passed with 5 offline, 1=
 untried/unknown (v4.9.210)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210
Git Commit: 36fa7559a1ce29b6fe8bbaa686b1524bfe8f7c77
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 20 SoC families, 16 builds out of 184

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
