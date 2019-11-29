Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F5C10D91B
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfK2Rdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 12:33:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38519 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK2Rdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 12:33:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so36208791wro.5
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 09:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbhC3Y5JNyfZJkmDWH9aPioiA1vFOc+GWL2XXmuR5l0=;
        b=f5vzNVf55GcZawhhsN1p6MINI9aOC0IkxBs+ehSecsI9dVyV2F5qOoZ1xjceYvrttN
         CjImVBmbpdn/MCNj+/xpO+FeFtdoZz+bveqRREzF0nliUOxJrlc/KbWFRPEiZy5ADj+D
         Px+XYLMeVjCtCpOf8YRh8wXsjU4Tm/PI4D6kYqBTCPVF2zaBe1mJZ65vOzhPldeX7Nye
         HLsqf0tFgUrMfgEhgouRgGmeJZqw2dosU6ikiTu/khjvSUPYrlco/X4QNC2wMkbVCxwh
         v+XKmXZPHtjjEK78/387kurIV7OpGcfldHZRzuZrtvCYxhQwV8fqTy56yXj2JLpIGgaD
         1oqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbhC3Y5JNyfZJkmDWH9aPioiA1vFOc+GWL2XXmuR5l0=;
        b=fFXvN1mBgIYedxk1NIPfW9dRYUUuPu039fTSlBvOyrpZvsjHqPGoZ9LrYPwXvCzMDD
         YqvGi+Kg1hi4AsZ4HcpbytI0qm0TQmCgGmwmjeXGzzEEOzAka4CFqTzJTAdcNkiMI7ma
         aIdKGAVT9U6BbiZRbTE5uumBVXhEYBzmrWcDz/OkUSCJFrdtO+Waa9uaj8FUteYs+5Ii
         hewNIcggTHzEb9110uoiNR6tqJnsYQyJWgLgVSR4uaqdXJ6j0rMmuM0I8W0DRp9sg3Ui
         hM/Ur9lj/HwqTbrlSO/oVQWILTaFeyRHsQxoWmUV4mQ/pbMBfDMBnkamDzRjwV1/v0+r
         245g==
X-Gm-Message-State: APjAAAU/A1K8zU6XOVe/qvaSJv0vWupaXqMm1cHbC8ZSBA+af+RU6x/H
        9yQlsxPPz2mJDKeNZDJ/0QtYRZe0A0ZnpQ==
X-Google-Smtp-Source: APXvYqw63KlF1obYl+v/dIY4OhYJMAQqynVdmoxtpWTv2mF6bwxSILjwSXJZ4fIfvlPdDiItVqr8YQ==
X-Received: by 2002:adf:e550:: with SMTP id z16mr32362049wrm.315.1575048821759;
        Fri, 29 Nov 2019 09:33:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s8sm13443374wmc.39.2019.11.29.09.33.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 09:33:40 -0800 (PST)
Message-ID: <5de15674.1c69fb81.73684.5a8c@mx.google.com>
Date:   Fri, 29 Nov 2019 09:33:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.14
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 151 boots: 1 failed,
 142 passed with 7 offline, 1 conflict (v5.3.14)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 151 boots: 1 failed, 142 passed with 7 offline,=
 1 conflict (v5.3.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.14/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.14/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.14
Git Commit: b8e167066e85c9e1e9c5d27b82a858d96e6ba22c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 89 unique boards, 26 SoC families, 17 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
