Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79E67BE4
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 22:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfGMUOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 16:14:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33938 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfGMUOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 16:14:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so11475203wmd.1
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PuwASwEZK41xHIPmUtgpjCtuXcwvRxjbklRlz0Wd8rA=;
        b=jlSOwuAROXmwtSOhKzvJMaG7Xj8SPxFvdzFkfh24jxmYWi8i6IriwnrqpjnvNrl9sz
         b3uFyjI+oalrmLjU4G2JoCEd1Y7rKy5P5XH+QFarlT4UyxyHWP3+ql+9YF8hpJjOb47m
         gKwAqi72TDvWji/ONAucXBFxzdKUrqf62jAdhE3+Ls6HPiHocXCHSnLAahSQA1bN4M8r
         J99PkWGb1z1YGqDMu/cEQZt6AHKpM/CQ2n9UCRrLu/kK//R2kajWEt/Oxcu2nqyAvX1C
         s6TmidGIMi4/K773cY5ZmOMDxHKDLTDB4OfrVzDdeLV/XPFWE20EoqDO4AtbrT59PM/i
         1e4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PuwASwEZK41xHIPmUtgpjCtuXcwvRxjbklRlz0Wd8rA=;
        b=Tt7qkfJ/S6ZZpxPvRUntG6sozehzPtOZb5sM3V/ESVkXCKm7FW/+/4WDUADxkknFSN
         zywWSHjIfgWUyzeIMFH6pDt46RWUrNGsQg+YZxXZ243jHJL/0ourbSo3kDlS/bJFUDvq
         BPyKaXUPb2b1SqrwhG97NNAouKVDAmkJhTOGADXmTMJ8zczfwYN95SX+HBC1UVk/bTiy
         599x0A4EgVFFRvRDCfD4A+W94gP0ZIkC949deto6J/rryCzSL79OfT/2avFG230DBMnk
         iQawYrpae0HEm2DSJBfE1hL4wkJ8RUz1q3WbARw3jn797SfxFDeAHSPj+w2gP6K1+b9b
         LfoQ==
X-Gm-Message-State: APjAAAXNS0IZRpnT+L3j6h8tm+QsSHvmrUZ4gxf8V4d9/pz34Qqc6LC6
        J2AvCpjGP40ylR9I0nKB1IheY6xjTeQ=
X-Google-Smtp-Source: APXvYqzgDtmpsJSPBToPwbbRELmSVlfppgBOr8J80/3xp8/tIr/sNEMhC45hKNvCGrbMKkJQKv9RJQ==
X-Received: by 2002:a1c:480a:: with SMTP id v10mr15617516wma.120.1563048873310;
        Sat, 13 Jul 2019 13:14:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g10sm10417023wrw.60.2019.07.13.13.14.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 13:14:32 -0700 (PDT)
Message-ID: <5d2a3ba8.1c69fb81.9104.b280@mx.google.com>
Date:   Sat, 13 Jul 2019 13:14:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.17-134-gd68c746af314
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 130 boots: 4 failed,
 125 passed with 1 offline (v5.1.17-134-gd68c746af314)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 130 boots: 4 failed, 125 passed with 1 offline =
(v5.1.17-134-gd68c746af314)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.17-134-gd68c746af314/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.17-134-gd68c746af314/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.17-134-gd68c746af314
Git Commit: d68c746af314bccd9dc7232c6a4a3521189073f5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

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
