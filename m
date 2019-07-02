Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F0E5CF56
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfGBMYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:24:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39539 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfGBMYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:24:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so780554wma.4
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q4Ig0pW+JPQytMPCbxS0otGowN43QKWdiQ5Oqax0xMM=;
        b=LfyCAKZ78kk3fu4qPTXukBwgzwaqZ273Kxg7LiEdwD01/VrgYgHYKEx6IAtJCNeatU
         vgyregbCykcTWpT4hQmLW3z3Cp2FfYEi6dNzOkrEDjVe2CUzhyHBSoR/PzdCaYuYmE1L
         WHULL2ciKNC1JRHQNYUBPP18amrxAJLhST7qeuHMf85kRBkHL7vJYR+8wxa3dn3O8E32
         rBpTBNP/eyvRm4A67SYGMF/9nnnvYUhcLWKRlQofsDROgrtKfleJdEckgiVpmotM3vv4
         TjdBRnSzGFUZ7KzzwzIhfghHoDdFPuUiDGPNK31pDGAmtAao1V6Ux1/tJNFnevDeFlp5
         cgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q4Ig0pW+JPQytMPCbxS0otGowN43QKWdiQ5Oqax0xMM=;
        b=UxzvJhU43SK5gTry6QYsHXT5hhg8yYFnEa/k3qunpGWF0Zw8GHKT2oUVoXyXYLkp7U
         F8ULqMQCtNErLR52ogR5mko1vdCLjxDYlgEI3wDQNLn4E5NgMKxfgCj9kw34SESQ//7L
         DFGQCNYvA1skVgxtjHL3ljJ/7JjyctY6Op3FRDsjCEXFfqCVvm/canpctC5bfaMauorq
         MAxTdqZ8bwuqZCCHjGhLQpxNgHoy+B2rFuyxVOFzINLYMy3fFSchG4I8beL7ub6yCBfr
         35/poOzct7lMq0zXwrTDwKXxwnwZ7Tct2pJQvzm63K0icrGJaPs7g/RtQ74WIGj+UzoG
         eKRg==
X-Gm-Message-State: APjAAAXW3CU39p8LdmnxijXcOjwBGLh3IVdLJMUXzaiBJoh55pKcq2LM
        apaTNnkAvtoovyI74j1sfGU3RG40oZK3Pw==
X-Google-Smtp-Source: APXvYqxrNHv8ss34b3ZN2pgT7vcPpZXmlqRZrmFl2rgCpeXYlVsuCFJ7CPmQ1uc6qZ9Vlhvkc5FUvQ==
X-Received: by 2002:a1c:c255:: with SMTP id s82mr3522475wmf.6.1562070258261;
        Tue, 02 Jul 2019 05:24:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h15sm10095786wrp.17.2019.07.02.05.24.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:24:17 -0700 (PDT)
Message-ID: <5d1b4cf1.1c69fb81.a6dea.b3d2@mx.google.com>
Date:   Tue, 02 Jul 2019 05:24:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15-54-g5f67e0e4cdaf
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 137 boots: 3 failed,
 132 passed with 1 offline, 1 conflict (v5.1.15-54-g5f67e0e4cdaf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 137 boots: 3 failed, 132 passed with 1 offline,=
 1 conflict (v5.1.15-54-g5f67e0e4cdaf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.15-54-g5f67e0e4cdaf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.15-54-g5f67e0e4cdaf/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.15-54-g5f67e0e4cdaf
Git Commit: 5f67e0e4cdaf3f59e34417bb2379a2a45e0e49be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 26 SoC families, 16 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
