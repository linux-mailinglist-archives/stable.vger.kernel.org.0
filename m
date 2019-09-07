Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882E2AC4B7
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 07:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394380AbfIGFEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 01:04:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33513 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394250AbfIGFEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 01:04:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so8744686wme.0
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 22:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ko3BcfSfFYbfse+OlIacWcKsACCAyLJlzPDNjPgntms=;
        b=EF8a7S/8dpI7clBiq92d5Rfq9EYnRvfn16cttXgyG7LdcqE53Ok63ESERclCqybbnu
         iYxgZ/E30qwRy2Duhys6PNVybqCziBPJZEqTysg0nGEItYGGy7+HqfcDxCw0gBaMOH39
         dToroiuVpEluwmtCpXDD1wjImcIBVqNHxf4IIxAvI0FZSGwlAhZrQYTORo3+AVx+n6x0
         SfdRkTiDwXvWpuvszET4NiwotKHukmvcip+5BcztKeLvvkTshGND8vLXxG7JJNvHf5/A
         /IcbRrMtQdpCysaKqVKdIe5ncdQMAP9fcB9/vtPUElSxvT4VG6kayfaKNHmbDG3tlMLz
         69dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ko3BcfSfFYbfse+OlIacWcKsACCAyLJlzPDNjPgntms=;
        b=AJY5r5wtpL2C2CPQk53ruEVK9ZNi096MnpLmFZCwIni9Zz1byhzhUKLt1zonqw8eE1
         6fZxhUzmAhn/G8S8mtB1HRiNvbN3q5x7X86zwUEQDgPy7Dv8OqLOonDS3dSoERcU2lkn
         LT0zesrYS63RMTkgdq3snwqLJqJnDoariR5YIVRqjP/s2MjqOWQFHmOKTDUnq2Ui05To
         vzz2yWTOKrdHHmWS45uWtdKlyqyCT5sENvZ8/5VBL446saFUyR3DU+3P1YL02JAvba4F
         /gogIitD+ohj9dEVVHlrxgkvehS5yq8hX3U0gR/2D7rA4yFqcjV119Vt/3ct7hFHyWIb
         +8nA==
X-Gm-Message-State: APjAAAVatcXxhRlkE7MoKPCO60cZF/BwkLAKtGZM0yloBJFJmAd74jcC
        bBiuBL1ICfmVaLhGRZJnaMOI6Y64hL/5Iw==
X-Google-Smtp-Source: APXvYqzx+izWgo5ob8NZ5dCol6VwuZ44UzkKIhh6RhzAcDLnVrd7jb9CiZmKDSBE63VJKJ7bzRbHWg==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr10171018wme.89.1567832683337;
        Fri, 06 Sep 2019 22:04:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j22sm14692304wre.45.2019.09.06.22.04.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:04:42 -0700 (PDT)
Message-ID: <5d733a6a.1c69fb81.48ae2.61e3@mx.google.com>
Date:   Fri, 06 Sep 2019 22:04:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.70
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 138 boots: 1 failed,
 129 passed with 8 offline (v4.19.70)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 138 boots: 1 failed, 129 passed with 8 offline=
 (v4.19.70)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.70/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.70/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.70
Git Commit: 0fed55c248d98e70dd74f0942f64a139ba07f75d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 15 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

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
