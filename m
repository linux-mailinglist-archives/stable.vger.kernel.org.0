Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1ABDAC468
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 06:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfIGESI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 00:18:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36559 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfIGESI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 00:18:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so8483728wrd.3
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 21:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iTwOeS0FBzKbdRcSb458XgG8sX60HHytNGq/xOIdA4Y=;
        b=ywRimK5IrsSWVbPEaGG70J0bMyJFSlWXK9X9qP0g0QXIZb8SUKsv09zL5mStmXKWBH
         K8USQB7irxspWeIT9v2n7HGw4tm++NyqO1d6V8KNlDigS4E8nvp4Wq2bVSWwODiuKQrX
         73cZg8HVzDORyWI/H7aaZxLHqo5L6lJ/pAcrEJ1ob+F7FjfDmg4YourGMlOPHiq0cye5
         9eymMXl+/tKSV4VFel2WcWvVD3ReRwFKCZJaP1xM6WmxRBquF7BT5bR34EJWEGccD+vW
         D6rESvrYsjvkoFENZCPTF8MUjSL2J7ktKcth3QV4Gk1/KRtjqHOu8iklUte780XashnG
         rcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iTwOeS0FBzKbdRcSb458XgG8sX60HHytNGq/xOIdA4Y=;
        b=K0Wm2sqgwCBGktsXZPAqfxnkDeWMUsADe4OT+wXoV4X4XgG8+41G4pT+GJy+J55kFW
         zNqB3qqZPoQ1FpKYCnz1bxJH+aHeLnxKUcHmMmtwBqMXonbjnvHucGIKCx1WsItyLgMS
         W9SNxNbxUT48Fl1bqsOQqCQajj2+7zxWbQLneMX95WbXIMQqFYadEwMBCZ6ukl1cZaTs
         RsihaMj313GExQdJbnxHsm/2rWf4fWEa4H4KDjcu4zh3YbnFoCYahOucuRBApkLmj/gA
         iPGpe+d3542hGTdWi4r57w8KPhzUpT2VlgFQa/OdVTH6mq5VoYXCrION/r4qRgKpXpLL
         y1Jw==
X-Gm-Message-State: APjAAAUkMBJfN3d/mXTd9/xgybylTNuHZ14aMHruYKN998ITNPhFeT/l
        MaD44LdrsFzVL7buOU6TT+ugFLBv5kQWfw==
X-Google-Smtp-Source: APXvYqwLZvwVeKWnWPieHForRMsNzR4yACPyPeR03ISxEKoi5GucT6Yg6utXjhDs41jMqGI95VBumw==
X-Received: by 2002:adf:e390:: with SMTP id e16mr10174558wrm.29.1567829885614;
        Fri, 06 Sep 2019 21:18:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 189sm10817586wmz.19.2019.09.06.21.18.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 21:18:04 -0700 (PDT)
Message-ID: <5d732f7c.1c69fb81.7ac43.4fcf@mx.google.com>
Date:   Fri, 06 Sep 2019 21:18:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.12
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 153 boots: 0 failed,
 143 passed with 9 offline, 1 conflict (v5.2.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 153 boots: 0 failed, 143 passed with 9 offline,=
 1 conflict (v5.2.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.12/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.12
Git Commit: 140839fe4e71d4db6a7b342d54cd7165490fd1cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 86 unique boards, 28 SoC families, 17 builds out of 209

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
