Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CCEDA202
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 01:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391126AbfJPXQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 19:16:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38363 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729316AbfJPXQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 19:16:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id y18so154613wrn.5
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 16:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DuxaasQDGSmeM5a27TvCaaA03/gc3DVSoWtS/XGOuLU=;
        b=ouLvYVUBIck0BGv7peUbgFG+0ZAzVkNAvUl+r/0qLtMuhl22ty59iahUf1lOXw8iwv
         tsaWW+q1Eu6fV2ONkIT2oJWKtJaTG47CdWqrcUEmKiGM+HcCjPV+I5dEQZqFoqMkvWru
         2O5vks1/6BuAYjaAbJ211OD25oRrIFtZCoGBV0DqMdzXqbZtB5EaEdrkfVvaGnxUPIeS
         eeAmBm0Hz4RoAufivEpJc0koxW3RIUaek02/uttuEOkc84hl4A2dOyqT6nFuUtrz3nIq
         n+t/g6TVCtQCt/8m4GbmHElhB6U/c1Q+ySz4mAtrC9qmeEllWnLEDb4XOudFBe8dbu45
         jYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DuxaasQDGSmeM5a27TvCaaA03/gc3DVSoWtS/XGOuLU=;
        b=cAEEfeE21F+FrHYuMqET+xk9kPtXYkc9J7yGOM6ZV0TY5EsAfrp/SQg/c7tkn8jXgu
         8mTk2ivdJs9B2PqBOiBFg/Ijul18tGZ+zK/KUeF8YHoCdCcdRc/Jr1jdSNPSg1/vCB5K
         /cFUsCiNktzY7NMlOSoxohgFlIFEh/Lu1t/7oHC2c6rwWyEIfv2bozhYAcdLfUBITdU+
         CzjT4+zSHEctKbVIS5E314vW4bTcSBz5/+MgserOUrFqm2DUCnCpT9ip1ifjcB+Tzhsm
         EZB8CRDKM1LiNsWbvfMjF1MomO2ss01CvX3Qp0pbtlcJcMGTT8uX/R0XxGsD8gkFoS9c
         zIEA==
X-Gm-Message-State: APjAAAVRIqIWXZ7Z/XltHHCfhLYsKeLdvuEVmGDhbmQMOMnKQDw+nA4Z
        f3yRn+5Y4LJF5NHo2bVvVX2/4ZcQEfg=
X-Google-Smtp-Source: APXvYqzLiSjp9cXQFFUwBbQilgHscURmx0qZ1fNtJE/l12nQPXFE9Af8mkFcjDCdBNPwJ4ePRJD6Dg==
X-Received: by 2002:adf:e28f:: with SMTP id v15mr272232wri.130.1571267784332;
        Wed, 16 Oct 2019 16:16:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c4sm272526wru.31.2019.10.16.16.16.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 16:16:23 -0700 (PDT)
Message-ID: <5da7a4c7.1c69fb81.82764.13e8@mx.google.com>
Date:   Wed, 16 Oct 2019 16:16:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-79-g7ebd71384564
Subject: stable-rc/linux-4.4.y boot: 69 boots: 1 failed,
 63 passed with 5 offline (v4.4.196-79-g7ebd71384564)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 69 boots: 1 failed, 63 passed with 5 offline (v=
4.4.196-79-g7ebd71384564)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-79-g7ebd71384564/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-79-g7ebd71384564/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-79-g7ebd71384564
Git Commit: 7ebd71384564c11837771110950e23e0c4e4c127
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 17 SoC families, 13 builds out of 190

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
