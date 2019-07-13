Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD1567A37
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfGMNKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 09:10:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36007 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfGMNKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 09:10:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so12595616wrs.3
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n8GWkgYICwo1hajKWp/BW7u5FeeAcWAg3939a0aAOO0=;
        b=Ae/Z6b6SkpCXeUfm/69l97uyPejcmBMn8y8t21XzbJ7nIoOM37LfvYbAKhkCT2u6h5
         TZeYw7bGru0aPiM27UysgpFDC1LyNrnEy4fp1QiCB/fdmkOFIR3s40OPqtQp2KM773wN
         +KfJkdQTrffpHTmSfuk+SE2wSZCOsd+kIN4LkA0rHlDr3KOaK819lpDhkh80uyuhjVNm
         luY900mPAEoBuTxN6vL7Ma7g6HJ8wUf1HmXKiD2Ry4K9lHQWRJnf20UJWqJlQUPHTKNF
         sN5qzC/rtumnEJCNKVmLzwp4DDxJ2KK6dI4HlHrNNzvx7zE2QvkvvR6h5zXBoRO85les
         5vXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n8GWkgYICwo1hajKWp/BW7u5FeeAcWAg3939a0aAOO0=;
        b=SJSacgsGGsrSPnf+rPO8fZkMJjWBHrJAOzAV+/eP3lLGc7rmnt1FC/jVjXBF+KpCUK
         0KZuNB1AlJpiTbw/LxM1mNr81Rd3UZHqNG88GKYuYCS73wJGh9Z376JyeFPPhojr1Y+U
         9pnCGPxiRGcwaSRbheymOg3xtCJzAlO7ry8/EVZgmWne2AInjjLlGMNKI4CBioTaZLdn
         KiTY39W9gigWcYSKhOKsprc6V1Qa0/T4v4PnV96lpKzdjqSE9nbvwX4/z0RyWyMOZtVE
         7dpGzABwqLvMlapyY+CiGGlFuYgKUWLn2Pwlq/1+sKKzJv502IsGa7hdIORlmFc7fOPn
         EWJA==
X-Gm-Message-State: APjAAAXYBbavTypM9K5aPWN6v+vKPlfEYhymEUACmNzAF39onSx4k0oD
        QYQecdvFBtlNdoW+o8J2wFRHA7pfFiw=
X-Google-Smtp-Source: APXvYqxlIey7E6+ed5KYSTZEd1+pwoAFXfV6uA3zxsde30/5O7aCowJ/GUafTM4HwB2LQND3v0eDEA==
X-Received: by 2002:adf:ef49:: with SMTP id c9mr18546414wrp.188.1563023420179;
        Sat, 13 Jul 2019 06:10:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i18sm12467944wrp.91.2019.07.13.06.10.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 06:10:19 -0700 (PDT)
Message-ID: <5d29d83b.1c69fb81.d3010.906d@mx.google.com>
Date:   Sat, 13 Jul 2019 06:10:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.17-137-gb7ba12926cd2
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 91 boots: 1 failed,
 88 passed with 2 offline (v5.1.17-137-gb7ba12926cd2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 91 boots: 1 failed, 88 passed with 2 offline (v=
5.1.17-137-gb7ba12926cd2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.17-137-gb7ba12926cd2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.17-137-gb7ba12926cd2/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.17-137-gb7ba12926cd2
Git Commit: b7ba12926cd2710813f1dde2a29c433399128f33
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 17 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
