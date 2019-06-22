Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D913C4F83F
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 22:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfFVU7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 16:59:16 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37411 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVU7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 16:59:16 -0400
Received: by mail-wm1-f47.google.com with SMTP id f17so9704707wme.2
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 13:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y+l9HBPveD5XTL0Ep6YRxboivnnpjDN3M2s+pVlWJGM=;
        b=bWV+oG3lM+tsnexj3fzkWDd+lCp0DXapWqhHT3dirD7JjaL4UEHd6MKr3PfxD/HZQg
         ZKts+glCakq9QBe71ZkyLYcQ2Z3PvAzjtqOv4kIr/GvKaIkQsWLgvKFdFnI3/gTUAw/W
         bq31slccxA98LQGeIAdLCumZ4a9zkEEvQ0AdcWVgfnFnXMPMGAclteGx6pVO+XgE3fFQ
         T0aTkpt604H6e4hAEbS6s7uRzrsWJewEJ/8Ot2H01M3tf8dhmTSNZ38g9mey5qN0mZ0r
         8tVidgSDss92CVZ0N3rS4DFsZnVp2jhR00pNWHUK4Zf6Ge+ah6FRSU5Xdp/G7zT0slOV
         xv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y+l9HBPveD5XTL0Ep6YRxboivnnpjDN3M2s+pVlWJGM=;
        b=L21RnBwFFwvTZMGqFwGvOLVCEQwfEO/PMsKpOLK1VW/tsvDiCWWO+HH6NJyDwqkIoz
         Rj57t6v60ZecSNjcS64OxHftNzDuEmO7vWwix/CFMZg/nTWw3LW9AAdeNcOhBSKQovr1
         OQnzZWnDfA6icfUyGZjOUs/Yxtzi+K97jBJJ7S3x6iCuyxKYJSvhpIeuiHwzB89/2423
         388wd+FylrjHaIjEYDrEQfqDg+x+v4dbXsUfGNahnNJR+PMmER1/Cndx6jUwC7vAywRV
         n5jDeEZa0GMyyxnmOGTIfd3f49dz2rsJhw5911Wm0SKvcQ9+jryzK/4dgXOtTLF8tfwp
         7Zqg==
X-Gm-Message-State: APjAAAVVp06+Pie78rdekjzTL+6nBgSFuqZ96scJG8KuMvczGmda3S3N
        z++2+72AZo9xlsAsaRgZl2ouMRSdsVk=
X-Google-Smtp-Source: APXvYqzu+/AnuGh50Kl62q77Dt5emE398Wh0aI+FA9q6u96fzrZFTUHJFG1ZwRkIBZ1eiWabeW5IsA==
X-Received: by 2002:a7b:c310:: with SMTP id k16mr8392270wmj.133.1561237154185;
        Sat, 22 Jun 2019 13:59:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g19sm4273195wmg.10.2019.06.22.13.59.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 13:59:13 -0700 (PDT)
Message-ID: <5d0e96a1.1c69fb81.c94b5.729d@mx.google.com>
Date:   Sat, 22 Jun 2019 13:59:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14-2-g967fa416ba98
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 130 boots: 1 failed,
 122 passed with 7 offline (v5.1.14-2-g967fa416ba98)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 130 boots: 1 failed, 122 passed with 7 offline =
(v5.1.14-2-g967fa416ba98)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.14-2-g967fa416ba98/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.14-2-g967fa416ba98/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.14-2-g967fa416ba98
Git Commit: 967fa416ba9886e67cfe2d9c147d2743c55a6475
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
