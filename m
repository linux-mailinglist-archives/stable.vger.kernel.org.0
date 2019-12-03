Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9601E110676
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 22:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfLCVYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 16:24:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45558 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfLCVYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 16:24:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so5610656wrj.12
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 13:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=usS59oaD5ICUOCoxvgJitqVyhojAvUpp6xyYehuFNwU=;
        b=Y8gGQ0Bpqlz+aVhf8L82GGQhsE7XJER9prsgkNmBUob/2Wgatqeh8l/Gz7N9uuZBXa
         Bv07eUWTlXzpbafDgIMlgbjChbFqC4MklV/odyc6T4YzXF8xm6ZlB+RnGBaU66HxZdQZ
         RKRq1FDM/qNWgG59cmbXpI44fAklddc+LqLHiIh5DzqwyCOEbbqPQVa4wDwOpiHDZjHJ
         UIr65MReTV1RqmgMVCl+IcLfDTqFTTyITOlS6UmbxoktZCpwbxnFT0uHnxAyWvgYwhe0
         fllU0Xh7AJVHU8pyb5o9hPsUrOYau7BlOFbpNXsXU5fj+1mymL7pEP7zY24Y8XcRktnb
         r4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=usS59oaD5ICUOCoxvgJitqVyhojAvUpp6xyYehuFNwU=;
        b=TsaZHFfdOywtkh3a4DG6EUWt7o+buMc/cg7occHi9+83gauggVNc2WhOO3eg+4TfL4
         IFE42g3g/swviJSp1+BKVTvSnZM7SJZ1TDLwKVF0iN/qZf8oqWSAcrsF3eg3M79b7Ajk
         L2efa8IsTrseSr2ieezWHJlxGcaNyWCWlhZgyowKnp7zQte/sxgbmqaglmEWAaY6oI+F
         H53sn9f0G3c5EfkIJz+ewcmE5+p/kbErJI7/z0ORbOpf/lFovSVKdZY/omVZOFRw39WQ
         nQB91+2DAj7E0r1lw05jZECckCFAZHaRgKsMy7Kvv8Pqeyo75NyIeldFZPjOQfVBnXgy
         7JBg==
X-Gm-Message-State: APjAAAW3oi345JrnxTd9yXRRK+whwbgUQwckc/bfFhcwy3vj4nSnv8qN
        Hel17xQtKquIi2N9QI0Ip7mVjMalqK52vw==
X-Google-Smtp-Source: APXvYqzDjXiF8dG6eEvmRdJCFZwuygG1T2D51DRIYm/WMrTm3YZ9I+tEnRu65fK42VONuE0jsDc0ug==
X-Received: by 2002:adf:ef8b:: with SMTP id d11mr114134wro.45.1575408285591;
        Tue, 03 Dec 2019 13:24:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q15sm5319088wrr.11.2019.12.03.13.24.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 13:24:45 -0800 (PST)
Message-ID: <5de6d29d.1c69fb81.f787e.b9a7@mx.google.com>
Date:   Tue, 03 Dec 2019 13:24:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.157-199-gdd3e96a2c1ec
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 1 failed,
 120 passed with 6 offline, 1 untried/unknown (v4.14.157-199-gdd3e96a2c1ec)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 1 failed, 120 passed with 6 offline=
, 1 untried/unknown (v4.14.157-199-gdd3e96a2c1ec)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.157-199-gdd3e96a2c1ec/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.157-199-gdd3e96a2c1ec/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.157-199-gdd3e96a2c1ec
Git Commit: dd3e96a2c1ec960ee642387b0df8ae96e1fc5405
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 21 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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
