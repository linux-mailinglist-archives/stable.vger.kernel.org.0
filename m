Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8B1BC9EA
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 16:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409717AbfIXOMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 10:12:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50984 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409716AbfIXOMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 10:12:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so305490wmg.0
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 07:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3mzlHkqfa3EKX3lpi6gAzguOdP4PBnhC98ucQ9HaqsU=;
        b=gSPLwB4ZqKniaakSRymDbITUg6Pr4TVtN4iylDiUX1j68nau6MxPYL/TKrz/dHpnG7
         uxAgqa/rBeA3/PaxZGNULZCDFONxL3BpiiCigZfB1924qdOA4g3DdwNizhLjcn+B5tW9
         VS/pNlOW/yIvNjZVeAK0MJCUR+G9/nD6R3bT16wgApCVuUXTRcmjrBlHQ8Up2LBDUDDc
         9QURYGhnamLzORWqD2E2h1P5s1xKw8iHxuBn9njXB3ECzAIrmh9doTLD32a2zmfZ1pGK
         wk8wnuTn0PFtmaFk3jZqq/UBZLzruc1Uazfawuj0UHDGScTc4selUSutWxq5bYB3ftcy
         H3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3mzlHkqfa3EKX3lpi6gAzguOdP4PBnhC98ucQ9HaqsU=;
        b=ba86iqRwkqwcccIGijcwn+EVlqexjsduiKHcDgwS2M5t8KiBBNotNXi9RrTxmCRvRg
         C7g19g7nLiWtdXKjm5rsM8EPa/xNYnr2BkPHQBWPfmiV94MTwbZi/+b4+SSW9SxRdbok
         EDQ9J+BO2DM0BtIHW+nsWMoyFR44cZGw0WobbnGIn4DWXtj8RyJSSuOO6eTS5fTzUNm+
         UP2ivgnLF7FMViw4UR0JVmALVTTyxJbHKIiP/o3lBqGIV4ZJqIgr4Vs2dmfz0gpOrnhD
         B93G+Cj7cJ7E24DAkDROFORpZrUs8YLqWNcalTVbHwPEDRZVsWFDmFNkLmiCPHQ1N6fV
         eJPg==
X-Gm-Message-State: APjAAAVaeNiPXtDTnRd8rWXhQABbA5I6XEFxt1UF6lSupMc6G0x2Azan
        pKh7+FtA3lYb42GNiANnxNYWJ398fnjwdg==
X-Google-Smtp-Source: APXvYqwTdZHfSzMt6Ye4XpxFx1d308cRCejoH9u+d0xyZGGxApgLeCIer6j6bvt/G8Vu6mHudNQ9OQ==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr195387wml.157.1569334350355;
        Tue, 24 Sep 2019 07:12:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x129sm213010wmg.8.2019.09.24.07.12.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:12:29 -0700 (PDT)
Message-ID: <5d8a244d.1c69fb81.2ccad.11da@mx.google.com>
Date:   Tue, 24 Sep 2019 07:12:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.194-7-gf7932ebe1bbc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 84 passed with 11 offline (v4.4.194-7-gf7932ebe1bbc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 84 passed with 11 offline (=
v4.4.194-7-gf7932ebe1bbc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194-7-gf7932ebe1bbc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194-7-gf7932ebe1bbc/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194-7-gf7932ebe1bbc
Git Commit: f7932ebe1bbce6fca57be3b4fd80820e91c1ecaa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
