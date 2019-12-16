Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5F121B82
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 22:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLPVHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 16:07:20 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36400 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfLPVHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 16:07:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so1459742wru.3
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 13:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xhgZcZc1yX2+6+srL4o4r3s7VPJLjWEauQVs5rOx604=;
        b=s+LLM3BciBc30RAmdmFbsz2WOsYRuJi04TDLnTYCe2PAsFx29zl2dDTA1OCwFntBpX
         UF27sWBbeBxeaMkCKl2KCpsLgqOnjq59u5Cke0xhwMVj1hMX1c8vZr/a4zrVIYNW6MkL
         7urSx2ANtnkQEA4KIAAwzrwBH3EE9yXhyuorTZDeqXl7SQWUy6c7PrF8b3uj3NXj4292
         kjelKV9/D4xYqhUsPE/yjOKf4vG6rvWM0KebTGq7QHlRdgpWfQfhsKDnAQQxvSr1xDhR
         olxqxstddZWjABEgmscmONKKV6APtqsUxyZc1K5JJqI+qrdVkygV69wMhwdI13SAhKcq
         tELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xhgZcZc1yX2+6+srL4o4r3s7VPJLjWEauQVs5rOx604=;
        b=EOmQPOKFq+VmHjEAb6yrfqCqAAqLrLiTt5LuujenumEdTodYTxBu4Rq1b3y/KIoVvj
         1rQdv5ZwU/4cDAFo7ACORBTbMpgQKP52Fv30qiIx7J9wU/xQa/NFJwXpr3UWitGzZgmH
         xnds/NhBmhSkOc4YENRhzzRge4wq9QLStKmzdokmAhiZNgmXS5nVk/8alCbbSdo+fo6O
         mcmeiVXwMxtA/zmB9CgIDq4n94rgGRppn3hpQ/+aPLPPv28aXLvgI6DtiAgXPxbzaq81
         ZTvvvMHkph1D1fFzNqnqPD4KTWJ0AlcFhkpqB1zTGFj/ICzX82FonYFX+WLFHACJoeFB
         JtDA==
X-Gm-Message-State: APjAAAVyxRIgwgHjEocx9l/eBY9zeTjMkaA3lA/EKMxyw4eWWnXOK+Hb
        Pbp6Z0lDd9cpkp3/Act4U3vOM1+VqFI=
X-Google-Smtp-Source: APXvYqxWh8aPAmodlrtI65FnH1/W5G/czbK1ccBELCkhSaCX3DXkKdYcc1MFNxu7xvii8UzIvK7u4A==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr32919501wru.296.1576530437470;
        Mon, 16 Dec 2019 13:07:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm23201780wrv.34.2019.12.16.13.07.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 13:07:17 -0800 (PST)
Message-ID: <5df7f205.1c69fb81.7392d.980c@mx.google.com>
Date:   Mon, 16 Dec 2019 13:07:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-266-g3f59458a600c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 61 boots: 2 failed,
 57 passed with 2 untried/unknown (v4.14.158-266-g3f59458a600c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 61 boots: 2 failed, 57 passed with 2 untried/u=
nknown (v4.14.158-266-g3f59458a600c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-266-g3f59458a600c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-266-g3f59458a600c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-266-g3f59458a600c
Git Commit: 3f59458a600cd4b0918649f4de9b5c5ea63eb2b8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 15 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.14.158-160-g8d615e6=
5ba28)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.14.158-160-g8d615e65=
ba28)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.158-160-g8d615e6=
5ba28)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
