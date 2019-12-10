Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18011823E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 09:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfLJIbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 03:31:07 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:33912 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfLJIbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 03:31:07 -0500
Received: by mail-wr1-f41.google.com with SMTP id t2so19011371wrr.1
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 00:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0VxVMNnf1EVx7tPn75NuoJGjQGEiytBJ5K1WSzSMgcE=;
        b=iVOiZFoCLJWeLuLZyCKtDNjle2xs+30o6htp9+niy9Nbkk9YDuZIlLOoEql2nbBFxX
         VH5gXhiqBIVT0G4IKzDIGX/U059WstIE/j95Mt8h2RP0tKWkgLo1XDRqWL6znqW7Rozm
         Jtk9tKefwCBKP2P5+/X0bJRUmKpb0Vkds75K/dzLt5FaZ4j39FCCDmofd0w+7ZSXM2Ja
         Hw/w+9bxMn82lazKrWDn78vzBIApH4vs1pWa8ZOD2/UGquF9zXYaGMctSAqOlf8Hzu3Y
         V5UO7GLa1H60S5k+HxOHLXL9cbHc97bbGQLEVPlb6j2FL29CpAAs5Rw4LE6DbIsKNG5+
         S35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0VxVMNnf1EVx7tPn75NuoJGjQGEiytBJ5K1WSzSMgcE=;
        b=o1K/ND1YwE6UU7IOJU/iZAwAWo7hkfzrazf6hzlir9BNSks+HRP1+wH7u3kQPaY35k
         7tzCZzBJgRoSSqLKhWQTcOp8fHwAMeb3wL61h3OODrGXaIWNdIdAYP18sczJrp1y0EzU
         /3F2azfrzKWdTlH0X+GN+c2pqE0uJuP+uR/7diT4UylpYXOQ0EvwzvOmp7nw99gjKZcZ
         PEhHiDJ20k6rviNMi8Xie9Wj3DfhkJRxH0q+ujvRcDPqo9dLbs2JOp+g41EIkL95o2+p
         EFjW7iUjmqwbJaw/oTsQ8wjOX54pOTt58HD4wg4qkdNOnqdwbNUMEB5x+6uniXXUoR2r
         hEbg==
X-Gm-Message-State: APjAAAXGR9CSatjgpXBXbgb8km9ChJau3HKxFYcJOUMj9hVPIoWIf5nO
        ZYV7fnLL1A5F05MJj8Lnou2wHjX2HBTSKg==
X-Google-Smtp-Source: APXvYqx/uozfuaPYzjRQJunR072KYRnr7PicoR5NZtSVQU0P5GibEKS4v0XMT6wZi3rnTXvP3oXb+g==
X-Received: by 2002:a5d:6652:: with SMTP id f18mr195447wrw.246.1575966665074;
        Tue, 10 Dec 2019 00:31:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p10sm2215229wmi.15.2019.12.10.00.31.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 00:31:04 -0800 (PST)
Message-ID: <5def57c8.1c69fb81.13e3.aa4d@mx.google.com>
Date:   Tue, 10 Dec 2019 00:31:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-151-g68c5d5aca755
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 109 boots: 0 failed,
 102 passed with 6 offline, 1 untried/unknown (v4.14.158-151-g68c5d5aca755)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 109 boots: 0 failed, 102 passed with 6 offline=
, 1 untried/unknown (v4.14.158-151-g68c5d5aca755)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-151-g68c5d5aca755/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-151-g68c5d5aca755/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-151-g68c5d5aca755
Git Commit: 68c5d5aca755b65e2468f09bfb07750e5c3f3d0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 19 SoC families, 15 builds out of 201

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
