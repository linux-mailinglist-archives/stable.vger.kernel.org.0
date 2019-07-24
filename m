Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE247414F
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 00:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfGXWQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 18:16:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44552 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGXWQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 18:16:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so48530819wrf.11
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 15:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gJesdbZbbF3sI0aCILTJoTvpe7qNeUt3yyP5yfvb9A8=;
        b=W9Bpl3gyOGa4wKBLl7fVRlDlIqkUzENS+nB83GcLxwJhoxhXcjJNo0GFFYPxqodihV
         1yQ+1zLpH2tz0wySkLon75DEAIndYT8JqxkC4TzeAOO8jm8LcDuOp7ppJOxq+Q5Ky7dJ
         McvaQqBPfvBa9QrpIglM9WXyzjKqtfEFDCaws3iCF4QeDPluvRdYrfdgybZpjbRY/+VO
         wPzIS2qIOYaNoJ7RRw4uTwexi6MIiWvDY2m9dYgpqO0eT8rVIyF1Q2yq58yG2Bh4D1Jd
         rwSOtEFuq7Elo2vgY99h+RcX8++cA5MmKJu6qFsoCfp8zRgi4n0/+99OOofcEMLGnanf
         L8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gJesdbZbbF3sI0aCILTJoTvpe7qNeUt3yyP5yfvb9A8=;
        b=MwIchvsBlpIABLWyB0g+TbjQtyq8kiZWz7UpfR4Fl/XoF3fjI8JYIwRuujhiKcDHXh
         MbDTlrptloje0NqVtXUnZN/+Cdou7yNzRB8Pzc+2Zt7FS56WDxqlH9p/u+qNA/Tpchiw
         pQWl228S21BswPjcVJRSXRsw/NQ10waqL9of34vms+yiQPmek4c8Xvu5CbDVOVSGxs/b
         2ewdi18pKhMHDBTvtYyoaOJNBxGSf5tz0qe20zMvHcNr1sOvoBFqYNRHl5KgxtE+zVQL
         vDJK4WkLhMOdWtkCDASqmuZmUpLVHje/o6cgYQ0wJoSdwKRBvCrS+MRRIXBGtaNuU/yg
         EWMQ==
X-Gm-Message-State: APjAAAWkD1aZZoBdsjNWFVSlRWPvVOiRfIy53QVWZQRNXJSubIWPrygI
        cwvissAEA7sPCWuHhegIRavS8Mld15w=
X-Google-Smtp-Source: APXvYqw7jXyosk1xdKolJFGHfHXiJE7N0iyxOcBTxFEh28XLNqjaTHNKHvsIta+6mTlp0hmMOpQRKg==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr86824543wro.60.1564006581605;
        Wed, 24 Jul 2019 15:16:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i66sm76616794wmi.11.2019.07.24.15.16.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 15:16:21 -0700 (PDT)
Message-ID: <5d38d8b5.1c69fb81.a5d88.65e7@mx.google.com>
Date:   Wed, 24 Jul 2019 15:16:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.19-372-g7da17d99564d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 137 boots: 2 failed,
 134 passed with 1 offline (v5.1.19-372-g7da17d99564d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 137 boots: 2 failed, 134 passed with 1 offline =
(v5.1.19-372-g7da17d99564d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.19-372-g7da17d99564d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.19-372-g7da17d99564d/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.19-372-g7da17d99564d
Git Commit: 7da17d99564d84f797e66a578ec5fb34f43fa58f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
