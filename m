Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F7ACA96
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 06:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfIHETT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 00:19:19 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:38546 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfIHETT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 00:19:19 -0400
Received: by mail-wm1-f50.google.com with SMTP id o184so10987267wme.3
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 21:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lSU6x6Gul+zDoaNYwQQGBrfziibT2JSXQKwOJ9+CBaY=;
        b=ZGTX3QK4X7gHUbvlLZb1Q+BCpOB4iMTeB5Suj/yTza/R2miPgaw9LpNGol6XCjiKXY
         psHmb89MprY7CfIrmmphXvj6HUed5IwjMjejYgfM3XCkRviZWDznTiBau1FF5M7CoDom
         eWvF6YIWL4sYzqZV2lYTkA/ZiGfQsnZl5wl4gwkL9KMkvmjzawvl071IqVur5kDDGhsS
         0Zf4XfVVsoYJDCBL0sG42Zz4Qkho2PiDpsv2tansbNe7Jn3jaMc860RrISPKc7XmBvuT
         I/gnPkh1qnSmiQOzr5elaH+brQxVImIt94aaBUBAVNB2n1hizybewEjE/wGzUE9fcjt6
         VgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lSU6x6Gul+zDoaNYwQQGBrfziibT2JSXQKwOJ9+CBaY=;
        b=azZbSGYJB9OJj8Vy9ig8paQ60H1qc8/HaJKJZlFePSYRVJDelZrYoPyKJC+hZ0tZ4G
         KPymzN/0wIEbCJQyA+eUnF3uBed+2MSqb+C91cjPmPii9LKfBxhANItcAPjHNxYRqAO/
         xS0hcw2vlP2lX87oVnSF4QvuDOyEQfJuYwpC6LNRD0bR24hxvelBjPAM23jo+3LJOnWQ
         0NWvzZGdDOIaP2lGZGrlQy0qTVl3L2PZwh34v8t92H4McNV6zp1bkd4r2Ci1U+gklvmD
         RIyTdqv9cphGoYJBlDZmsdAS6p4570DZk3Zo4ajIPSHU8FxnTCoJjfefdsP66i4xqdtN
         m7zQ==
X-Gm-Message-State: APjAAAXirfhc0O///dlUOG+Zxn4IYlTkqIAga5yVdB1Ucd9zOJtxF338
        1GgR+9tShqgEOWaTfEdCp0em4wyhFn8=
X-Google-Smtp-Source: APXvYqwp55A88xE3mHeJbsxsAP4R5MZUXyQhoQ60xQ5V1gPHlrhD/WJ1MQ3V4SbKF7JQMu9RaPJoVA==
X-Received: by 2002:a1c:4946:: with SMTP id w67mr13315107wma.131.1567916357431;
        Sat, 07 Sep 2019 21:19:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c132sm12857105wme.27.2019.09.07.21.19.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 21:19:17 -0700 (PDT)
Message-ID: <5d748145.1c69fb81.92b25.b606@mx.google.com>
Date:   Sat, 07 Sep 2019 21:19:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191-23-g4594b499606a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 0 failed,
 107 passed with 8 offline (v4.9.191-23-g4594b499606a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 0 failed, 107 passed with 8 offline =
(v4.9.191-23-g4594b499606a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.191-23-g4594b499606a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.191-23-g4594b499606a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.191-23-g4594b499606a
Git Commit: 4594b499606aaf21122bb4af7136fb338c3e91f5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 14 builds out of 197

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

---
For more info write to <info@kernelci.org>
