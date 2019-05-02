Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57646124EA
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 01:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfEBXFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 19:05:08 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:43842 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfEBXFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 19:05:08 -0400
Received: by mail-wr1-f49.google.com with SMTP id a12so5499662wrq.10
        for <stable@vger.kernel.org>; Thu, 02 May 2019 16:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0E50fivlvhtJbA/C1wWaK+JHqMSweUK9UeAr3comb18=;
        b=IouR9mO8ERem4ujwt9AKiAEB7JhUgdz6jsR7l8nEhiun+7QiqAnckCzegJZCS+mEHU
         324hDbYx6ercsXVAqApFQfA4GFiDHaRL08BnD7Fpmj2INdA/8c2rxYJkvfUqvfJHNHcM
         rOKkr5NKSiCFoCHDYTk17VMfUGUfCjE3Oxtwrkz6ZD3GdLijDZ4ZrdDKoiHezBVEuKn5
         oNYdcq/WCJAVoNTwlyoJlvRCy3Ik7o5g8GYXaVA0C02BB9sSWYv/NO+iykmwGzTLI8r9
         N4Gq/yhHikL3VFfEjEaxTOcQZS4qQKmzzf6UkL/sOhE/omonz7U858igRc6O3F/wKUM9
         cjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0E50fivlvhtJbA/C1wWaK+JHqMSweUK9UeAr3comb18=;
        b=N1UzQ8L5/oq2G2IZKrWJC/UxY/DIKvd/UgTfPka2PyAdr9TtIRemUM8iqFxY4Jtz2d
         8+ZfE+bEQc8gA03o4PBahQrG3kRGSGL/QOn+UelJMMiH/WMGFd/+AWj6C/DopuitCt5u
         Tj5qr0eIYNi01LtkVwBvknZvzARf+CQGfBdeApddY2rIiXPGpdpCN2dOklsTMvZz/+AG
         laZWv2elSX4oT0SH6cKGDv5Bpc+BcpvTtPG4sZsKZswKwj2FUzk/NlTh6oS8JgftkAiz
         FQYLYeO6IrlhC+xEfAAHOspOfiwH2JyYbr/b5eifTmQ9+MddLE63VM+M1qTzT/VlWJhC
         VBCw==
X-Gm-Message-State: APjAAAXGg0eEZxz5oDw6oVX3COVeRCyhS1z0ilPV5nS1Q1NsXn4i8Pf0
        uFGRv+01v++MpwKcXjerH4mr0O/fmYsYZg==
X-Google-Smtp-Source: APXvYqxHaqcZci6ETBSZ8xxZdwuBz3yHNwDEJnSJL0PAFvdMWPNPdalmcfReihFDZkHnhrMuiJBLfg==
X-Received: by 2002:adf:ba93:: with SMTP id p19mr4807826wrg.195.1556838306031;
        Thu, 02 May 2019 16:05:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q24sm576758wmc.18.2019.05.02.16.05.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 16:05:05 -0700 (PDT)
Message-ID: <5ccb77a1.1c69fb81.1fd33.3a70@mx.google.com>
Date:   Thu, 02 May 2019 16:05:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.172-33-gd35bcd092304
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 104 boots: 2 failed,
 99 passed with 3 offline (v4.9.172-33-gd35bcd092304)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 2 failed, 99 passed with 3 offline (=
v4.9.172-33-gd35bcd092304)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.172-33-gd35bcd092304/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.172-33-gd35bcd092304/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.172-33-gd35bcd092304
Git Commit: d35bcd0923041bd98c18947041f8929b2fb12674
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-7:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.9.172)

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.9.172)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-7:
            exynos5250-snow: 1 failed lab

    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
