Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF811108FCB
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 15:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfKYOZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 09:25:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34375 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbfKYOZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 09:25:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id j18so14857wmk.1
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 06:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8t+oDQwF+Y3ge2Ix33klKVpdPD0nVfwj33ScKonpl6k=;
        b=o/nKgL5OAuZIz3UQPUCxJgLqVNTYrB3//jp/cJxB1oNF3YihV1Lrc7QrSv/sLC44OQ
         wOZ+Kvr3pASGNRhkJHZMri0W+u/qTZgG6MO0r2o/fx6O3EOnBS5jbsr6MWEsbv9tE2xt
         LC8O1DsLL8rcKbtMc8lj8qj1ndXUTbtYmHU6+0CIoJ61nCR/ezZd3d39ay7Y7dTfUV9k
         J/tMwz5erC5Ss12YirUWNEeYTjIBwTujh5ApM6JvKUFCaOw0KzVb3MYhTveztDxcNBIy
         6+KsEDEoUdkB8+YIV9uNz+PYXJNX3m1cxuPXEjyRoG8VGW4LHenFrzH6GT+cf2dyrI2F
         HsdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8t+oDQwF+Y3ge2Ix33klKVpdPD0nVfwj33ScKonpl6k=;
        b=VvottO1/jRibO16XR/Z5me+ulDzByemF089KYuaU+s3jONvnIzlwEZ1dkIEDjyzyBC
         RaYEwaa0R2V9Jx1Zz0dscPP4GulF3353SgqirTXEIsWPrB9FOe4Ab5FZDMjRS2pGwTxX
         ikC53YWHCdcsSm4C1tEUXuwAMhwrOj9SGS9PioMOAAunK50IUpbs2GpSXm9e+02vyNvO
         PyMWIdMJmb7dUqRjr2VL1S2kHnpEFkPY3ERTTLXoRqnnJvABRnsXQYR+7JfixmmjFikO
         ztzWubYE/Y8D3fH/pcy9sB2Lx4R178wL2Xarxouvz6I1RDEyPpmewyL1SSsZNxYp+SZB
         L9qw==
X-Gm-Message-State: APjAAAWMB475MfdK4+aXiu164RluQoAWr+h48g19jFw0f1JXMyY1HCLI
        YeZHL2GFQoIy86IrKHpZnPoV5fDHrb3Qzg==
X-Google-Smtp-Source: APXvYqylxieHVnTUIwVMBBDNHLZcj8r2cZ2ZjB7DUPqznZatYh5LNhBCb1r3aqTFYdFgMauB2L54Mg==
X-Received: by 2002:a1c:4c15:: with SMTP id z21mr27501282wmf.132.1574691906818;
        Mon, 25 Nov 2019 06:25:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z4sm9011913wmf.36.2019.11.25.06.25.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:25:06 -0800 (PST)
Message-ID: <5ddbe442.1c69fb81.e3675.cb14@mx.google.com>
Date:   Mon, 25 Nov 2019 06:25:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.86
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 128 boots: 1 failed,
 121 passed with 6 offline (v4.19.86)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 1 failed, 121 passed with 6 offline=
 (v4.19.86)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.86/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.86/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.86
Git Commit: 14260788bbb9c94b0e36abc17294266b69dd46e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.19.85)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
