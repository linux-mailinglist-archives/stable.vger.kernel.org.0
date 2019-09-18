Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C78B6262
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 13:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfIRLoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 07:44:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51241 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbfIRLob (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 07:44:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so2250412wme.1
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 04:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9zxBa5PNLWVAEpdd9mhwHREEiAX1/dgUaL7rv2IAgNA=;
        b=Cv3pk1AVFsQ12d4TBW4gw//OAQCXLF5X11EJBTDvYmjm1xqGSHyZYXyxUGNaY2Ijnk
         J2lQItEz46Qyc5A/Qx6mKVeVMtb/Lfl6BaPgyxAcV3JBtD6u8GvGuxrr1+eesH8Drqno
         8l7sY557Kgoi5yjn+UxvPmrAJZjYb4M18zTTCLyV28WtRrEKJTVdrJYV3v0NOKDY9C3l
         u+U2g52Ohn+tMbNbhUudEWoh544VkkKKDgemXFx71q4+7veZEY/SFN7EVRauPfJ64Y4v
         NoNBY6x2S7IbJ2aetwdU/gc0FJX49721qs6vAKBFoeCON3ULkZ0Cu2bYQ8ak6x2eGnaM
         kOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9zxBa5PNLWVAEpdd9mhwHREEiAX1/dgUaL7rv2IAgNA=;
        b=TrgFDlO08q84srloDOBi0KvMWz2qG2bknauvHAxoPP0wcCkPSwYo1eJ2orTysRIm6g
         Pu/zP61Gzk1s9sDhHvgQWdigKlbxqWEw0N3E0E4dedzcSnyS1m+9MJNcKolrv84pMx7H
         hdx9tktRUEKKQrxpGvyZtwC50dQkTCdph2xa5cjgSD3XTyUVxXTNeR6rImGNfyPdZ+qr
         5Cu93VVOmjZZsjVIouYBV0ArmYdRnkc6HdMWn20uZHt0PxwU02hdEt2494xVmJrRbNk7
         4yTJaJNVv9ylXZZwuLn733OL5HuNAlMresHFC+vGL1u8zM9gcJpev1PJmmCpkCVbS/5O
         S3vw==
X-Gm-Message-State: APjAAAVc77aczVAoZCaD7GaXyHtof2tfnAPwbN2FwXvW/k+XTHonxtlv
        q1R5r93DG7JxkLPbaUJqv/Gjt3u9oWjUQA==
X-Google-Smtp-Source: APXvYqyVBZhKT4ln3Cc/kQeRE4CdYJyZ6si4mq7kdHqM051x1XMloQsFrD3uXPlkm/dMHPS7XzpkHw==
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr2670966wmd.130.1568807069488;
        Wed, 18 Sep 2019 04:44:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f3sm3989722wrq.53.2019.09.18.04.44.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:44:29 -0700 (PDT)
Message-ID: <5d82189d.1c69fb81.4a051.142c@mx.google.com>
Date:   Wed, 18 Sep 2019 04:44:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.193-25-g5a8375350d04
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 104 boots: 1 failed,
 92 passed with 10 offline, 1 conflict (v4.4.193-25-g5a8375350d04)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 104 boots: 1 failed, 92 passed with 10 offline,=
 1 conflict (v4.4.193-25-g5a8375350d04)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.193-25-g5a8375350d04/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.193-25-g5a8375350d04/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.193-25-g5a8375350d04
Git Commit: 5a8375350d044b3c456bba7827cf3b233cac0308
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
