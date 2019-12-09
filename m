Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D2117B59
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 00:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLIXTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 18:19:16 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:55600 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 18:19:16 -0500
Received: by mail-wm1-f49.google.com with SMTP id q9so1149493wmj.5
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 15:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KdzN3FtImJKTPyTdKWMXT2s2XKFx7L3OJ54mrj35Tu4=;
        b=LhAsmW6BebljOc2ZICIqc9tMdtn08YgXuJUP6K77DGqgsbGO0vNnAWWHEWAMfI8v8b
         vzKGC4Xwb6tHupoe0wojuM3mvns9CXrMBmHbCnSeCNRTR1Ms3gSF1CHYMr9RrtyLiZC0
         RVfOmKfP8+d/wiNQqceMkWX7T77sOTuFimz0BiAdTYtcOyuZiVX/C5dvH/Rif53X4QN+
         YkNr9adpoOLNxwol4IHMzQFh5fj00zrstOkCXY2BNYea0dbGKiT6MQcOWqSmN5uBhBRp
         Q49KuZjYlkm0sJM7BWtiX/CnEcZGeenke8RTAFOJe9JOk9lPvmL9U1+1M/68+WYN8sFT
         6FDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KdzN3FtImJKTPyTdKWMXT2s2XKFx7L3OJ54mrj35Tu4=;
        b=afetgkCORAzJfiAE9uCY5Y5YQQluNTJnLx4kA+Vq7DMOYaIFphXqsgEjDnxGRRJFgL
         nBw8DaavTOwLGbT0zDHplTjJm6ddjVeyloSYiCS7kFKK1NeBRltK7y76uTNM9wVKo6S8
         dPzASWns5ZlYPO2yjxUFlZ93w9kxjXrxPax4li/8YR8dtX3KoxrENhJ8DVqCXypZQHmG
         ndf4cJnA089yb7FXIO8njahWeN/AlqL3A23R7NcPIBGvTrkdhZcaBGEehP231o+h40m+
         FftQFJ+lVQoA0sV3mWHAP4SYDEnpL+NTxjlILQapA5eN2ixJRXUTZuuV4sie2+Qv8QDe
         1W1A==
X-Gm-Message-State: APjAAAWzxgnry63lWvXyXdVHLQdzfUDMTFSP3wdr7PtVn2rO2sck9aFU
        k2sfCk8P34rPesXyjEb1eSOB9BnhHx01nw==
X-Google-Smtp-Source: APXvYqz2jMvS5SqLtOf+x20eYGQW7EfQIiQFp6H/Ka+ZEn7aG4VFBpwTpjpOHB9TzxluWS51EXarfA==
X-Received: by 2002:a05:600c:d7:: with SMTP id u23mr1409911wmm.145.1575933554411;
        Mon, 09 Dec 2019 15:19:14 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i8sm1092813wro.47.2019.12.09.15.19.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 15:19:13 -0800 (PST)
Message-ID: <5deed671.1c69fb81.339ea.65c5@mx.google.com>
Date:   Mon, 09 Dec 2019 15:19:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-57-gcdaea81dec08
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 94 boots: 0 failed,
 89 passed with 5 offline (v4.4.206-57-gcdaea81dec08)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 0 failed, 89 passed with 5 offline (v=
4.4.206-57-gcdaea81dec08)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-57-gcdaea81dec08/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-57-gcdaea81dec08/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-57-gcdaea81dec08
Git Commit: cdaea81dec08b3ede4a5b242b0537e1b02c33a13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 14 builds out of 190

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
