Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A75D11300E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 17:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfLDQbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 11:31:23 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:41324 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfLDQbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 11:31:23 -0500
Received: by mail-wr1-f45.google.com with SMTP id c9so2948118wrw.8
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 08:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0BcnPWhEvpShuDEu+EzcyfmGLkL5UJvkZ7Ys4xUeUCE=;
        b=vNdA40tXJxpSEr2GIEhHHlrsmo9U7eTfFcnqnS/DgHSZ0p23TCiO3PAXrZmthm+5H4
         Rx8hoRzXSg2weoE7k5Swc5Fl/2UGRWPcIJshZvMBFyrHpVO7mwUQ2umsBh7JsCYaC4GN
         oXgo9u2TbE9SKvXyvE1a2JlBc9eIEf9l6Ct6l4P/qnbdA5V3iCLLqvGqwNSyYY09WtLy
         SOLikFloIr8MjTFYaaXz0wx9Ip2XYojyDkwgWjn5BX5fubZ5HpElR8ZAV0K4zuELO9kR
         uKPuDcjMTAnFf/dXTRnWOlgLCDYkQ4KuOfXj7uR4QMpvTu9p9MX0nOnw8FwziINxzV+p
         XBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0BcnPWhEvpShuDEu+EzcyfmGLkL5UJvkZ7Ys4xUeUCE=;
        b=rNeJZbWWYVeVGXsnFfOem5yBVwpn0/F+KYLrvKmi0wE0ih7n/MudlfKI4NeBf80ATV
         LDjtYrXyF0UrdC9mKIlw7oQji07ceZ9QG+n9xpspz9h/nAgzRBFHKcDvABzZCHd7bO7q
         BQzIZ5lpPJxPSGOTsUg65QVjKNMKKpNbOfAol+0eGSg8F8oppn4ZRUsjdP/aQWhUF/IY
         74a/h9sxUOepHREiyOHcQTNhWDoAl4q/8I5OczHmGlGHeGI/fF1g0ElL2dy6ZQVMNYyk
         E4dYZ1YZPjhTvXMB5n761QN5m1zdTUQHfUgTugvPrxvAEQZeDuZtsS4V9G9+AKgeFQXY
         FmdQ==
X-Gm-Message-State: APjAAAU9kh481FgwCqRuMFksS4B9veT+Ly4/DS1PXg/0tVt9PMpq/5Et
        Ih5mBcFdat11Xm2nWmV/VJDSlUluB18=
X-Google-Smtp-Source: APXvYqyetGoNopaPlu05xh2YhieP1nJhPpk4SxxH2IXYFXLV/BUA4Iu3dIAIhh9t+hhcOx/w810NQw==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr4878732wre.332.1575477081517;
        Wed, 04 Dec 2019 08:31:21 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v188sm7698933wma.10.2019.12.04.08.31.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 08:31:20 -0800 (PST)
Message-ID: <5de7df58.1c69fb81.f9fad.6e10@mx.google.com>
Date:   Wed, 04 Dec 2019 08:31:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.87-322-gba731ec12c66
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 101 boots: 0 failed,
 95 passed with 6 offline (v4.19.87-322-gba731ec12c66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 101 boots: 0 failed, 95 passed with 6 offline =
(v4.19.87-322-gba731ec12c66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.87-322-gba731ec12c66/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.87-322-gba731ec12c66/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.87-322-gba731ec12c66
Git Commit: ba731ec12c667db0f1f85e4bfe11387587feb243
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 20 SoC families, 17 builds out of 206

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
