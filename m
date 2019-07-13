Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72667BE0
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfGMT7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 15:59:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40317 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbfGMT7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 15:59:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so13129977wrl.7
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 12:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=afMgZoebLBGSJTmA37ZWFepFiyp2oYqxkyN+0MKZ+Q0=;
        b=ZSvp3pGnPB/8fXJiBDa5uaydSW+xAGJTc9PBNMquqDtbF9YdtcCYNK8ZJ3+N0VvLvk
         Aj31Bj63NMp+8v1DYQnGaxyqpifiqTsH+w1sIO0nglc4EYlxwgIIfz23SstAaztsJK46
         XGhpT1QT7mAN/yYQHTfa0wUE1OAYzPb0mYKRmC/CfPsLIXYiKEO/h2iezu1uq52LPNZ4
         uz9i4XtpcoMwtAQirJ+1SzViaU9f3bq7TIcN6itiehk1cL2wf/UE1vRXIJ6nFFMJvDo2
         ZITe4sTt9nesIbp0jdspT24eDt9euhygOgKAjRB+jqBOZafi2WGEBZ9MKDWBTALSWQZl
         HxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=afMgZoebLBGSJTmA37ZWFepFiyp2oYqxkyN+0MKZ+Q0=;
        b=qeneclWtdMtdVAda0da/RGA1W/AXsAG78GgYnXfuBCPwJUbWivmoueyc/b5d+wdsAi
         SiZRu4QvPxOyov8q7pnBUxfkbjLPOYzC/FTwvFosk9AloQBB+OquIfFR6qBpRjAipx0b
         m5v8nmvrSqut8dvxdGEHn5FlYg8wSHHxRrN/MxKKpqYvj1vGK2t95FK3iGpOuT2ey7m5
         XgbuSHxAMV/B2Fj9DUeTD/eMbSqw3Flvq1koUDU+pmDKatW8i3ErIWpALWFNGuyzKrDP
         e5R7wcS4B/7uEFnWgdNDUfDYcoCRLGgdDjtlaR17Rrknr5txAb5OEsctCF03IBjgaPF5
         b27w==
X-Gm-Message-State: APjAAAV9kGrmsZnRLSLLZxEti6l4w71YrrrFQ1WIjI8mn29CetGZC3Hl
        DqDxdUQm0ScolfbAz5E/rc9URYPpe7U=
X-Google-Smtp-Source: APXvYqxXGzIh19+mG3HaUEHhQRQYfcrV7OI8b/KTP2igmFRAJZswzEJpMIC4rEX3OzVe74OOBbHbHQ==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr18855958wrn.31.1563047992338;
        Sat, 13 Jul 2019 12:59:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x129sm10899608wmg.44.2019.07.13.12.59.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 12:59:51 -0700 (PDT)
Message-ID: <5d2a3837.1c69fb81.c6489.ee49@mx.google.com>
Date:   Sat, 13 Jul 2019 12:59:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.58-91-g778a2640e781
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 122 boots: 4 failed,
 117 passed with 1 offline (v4.19.58-91-g778a2640e781)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 4 failed, 117 passed with 1 offline=
 (v4.19.58-91-g778a2640e781)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.58-91-g778a2640e781/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.58-91-g778a2640e781/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.58-91-g778a2640e781
Git Commit: 778a2640e78132bbf02b4dce0ae12d23c6bdf8c1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 27 SoC families, 17 builds out of 206

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
