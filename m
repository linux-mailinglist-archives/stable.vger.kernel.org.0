Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463C0B9644
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 19:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406106AbfITREc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 13:04:32 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:53573 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405909AbfITREc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 13:04:32 -0400
Received: by mail-wm1-f50.google.com with SMTP id i16so3268465wmd.3
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 10:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=usXszBx7C5XuGde2pm1EYENhOmu6nE+AtLlcbpR5kEk=;
        b=NoNn2iuZWCttWyqNatgGNKtM6IHV0JtctZ6uUsSLs6qxF2aoDA0LEm1WL+csLRnLyU
         urarH0hHSog8xD7lKoMRQsO4Xe2v7wkj/qlhrAKqqQfbc2R2DWOwKSDaR4AE8A9EYaZG
         bYQVYsGlFqLqkFx6wxLC8DsHp2/Q2WKJUFXlbRSkc8WfYWm6uUOj7rgKhP1QExTm3OAL
         vaHnGbB9ddGMUiFnzeHpf3v7fJ86rWibcittwB0oaeH01OZP8/uEGeWdM1OEz1oWMrJz
         OUnY6u0iei0HTxJ4jlRoV3CY+OTde+tbPtdztbbyM05Zy0lLY3T7JFqwNCoLfKkKFRcj
         d4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=usXszBx7C5XuGde2pm1EYENhOmu6nE+AtLlcbpR5kEk=;
        b=tFC4gsR7U1/rMYE4e8cd69AH1bagCjVTZoYj4yrSGnCTx9jck3ZQ6ImJiRhxdBiE6y
         V1rCe9qWrsJDKwQVTZy9rU/LooLkYNg6ZnMtmJaf41eXeS0ALCQgpzOzwuh0AtOnnV2I
         NiFfNPPhqFgRtNJI7h81puoUSe9Ty12jIbnxZvqF1zufbfI+TsmCLVhdP4rCciscbQHg
         oF7SmW0e89pcna/QFvgFy3Uz/4QPo7ROEG1CPj+LSz4J8X4xtK6lwbUgGbEgVdoldzSw
         BslKL1ko878mnjxUsAYQhK9j+wp0xF2qbGhWayhkgsyk2F8bP0ohJPtDX1/ki4wlikcv
         BXkg==
X-Gm-Message-State: APjAAAXgRhddWfbNYZ4hT/x8E0Fq3Yx0oG1x+RreaVHiehkYyY4NpOhF
        e0Dwfx9dw8Bt/j+StYNrdnchjhFmMrU3bA==
X-Google-Smtp-Source: APXvYqz2S0GJis/pdpEphEhv/+MBfAHs27B24YLLkoQzPfAz9ASI+TDLJe8drTit7He00OSVIl6u7g==
X-Received: by 2002:a1c:9988:: with SMTP id b130mr4503130wme.164.1568999070249;
        Fri, 20 Sep 2019 10:04:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d4sm2307171wrq.22.2019.09.20.10.04.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 10:04:29 -0700 (PDT)
Message-ID: <5d85069d.1c69fb81.4254f.b070@mx.google.com>
Date:   Fri, 20 Sep 2019 10:04:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.74-80-g588c69101d72
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 0 failed,
 120 passed with 9 offline (v4.19.74-80-g588c69101d72)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 0 failed, 120 passed with 9 offline=
 (v4.19.74-80-g588c69101d72)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.74-80-g588c69101d72/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.74-80-g588c69101d72/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.74-80-g588c69101d72
Git Commit: 588c69101d7233617bbd6c6ab2ed142ac713ac0d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 16 builds out of 206

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
