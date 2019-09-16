Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F15B4175
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfIPT7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 15:59:55 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:46497 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbfIPT7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 15:59:55 -0400
Received: by mail-wr1-f49.google.com with SMTP id o18so663568wrv.13
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 12:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7kctulkgXwoVFBl3FxeFNCCtVvBjz15/QcmDWYCGkvU=;
        b=w4P5iK6Tr7HstJDnEwKfEx4A0J5OFPtuAckUeUpU6NLe+WACtB5Ak4x1RBdAIEm5x3
         S6Zy4InIZuFsdiaL7+jXweOztkTIe4COlz8lWMUrTGp6Vl1niqYtPqbHXdvqIMPID3bD
         7vp20Luu5zkKGcrTlARf0aYCL2cY2IkC+wEYImZ8lnMflgFscb3Lc5gWT7aJdUrQGr7/
         mGSelNNlLlvtrJGnVYs2L1mj6wmom03oWA4+1jiRbR5zEZ5YrOR8bnasGxS3c9Jz0sXA
         jU37A1czYMZurswKFiY/K0L2V9h+WKteYvPXduhdWT9Ho9f5djxNR6zKQC/YPQeUNs3H
         KE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7kctulkgXwoVFBl3FxeFNCCtVvBjz15/QcmDWYCGkvU=;
        b=SNojwnl5+bP5nnRWWyd1PAfb/WUsLnMC8JXhjgduhuAcrGnYFCOQEaRss7xhVK4Ehh
         iYPzCM7jBD61S65qesJPjnuP4InX0sKinwsFBSs6jqePyMHTjoz9TDfCvpCxCfgn1h68
         6urWiq40DXPsWtrn+DUBShAl5bopdVzaqbXhkAakM5ijUzHlrvojGJkYKMj+mVSW0hol
         C6rRVZIfIt3vX1MggPl3svegivDAzY9jzuWYGf+qFuFp32H1QB6crUPDTKRSKUSv50K5
         y9rcwq1YHUtxPQgv/1QUOrbMEa8M/MlKqM2m3WenGwiTQN7ekTu4KraVXjCWSHEbKkn0
         p3tg==
X-Gm-Message-State: APjAAAXlfLp+LdB5W6YmED0q8zAkc655awkskH8yj3PEhOqyCWhUUcrT
        YoCLd4/Tpx76zLGhS86MsVQ93S8DtNGF4A==
X-Google-Smtp-Source: APXvYqzPdWg3LpCs9sLuMapq6ZwaCvFbGj3mOB6+37j/TTZWRoyxpuw5JAE5OsHUzkEWu/JvtYBawA==
X-Received: by 2002:a05:6000:12d1:: with SMTP id l17mr63659wrx.91.1568663993145;
        Mon, 16 Sep 2019 12:59:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s19sm58348929wrb.14.2019.09.16.12.59.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 12:59:52 -0700 (PDT)
Message-ID: <5d7fe9b8.1c69fb81.b1d8a.5a58@mx.google.com>
Date:   Mon, 16 Sep 2019 12:59:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.144
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 125 boots: 0 failed,
 114 passed with 10 offline, 1 untried/unknown (v4.14.144)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 0 failed, 114 passed with 10 offlin=
e, 1 untried/unknown (v4.14.144)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.144/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.144/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.144
Git Commit: 968722f5371ad5deee23fc20269fdc44c23014b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 13 builds out of 201

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
