Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC893FAAF1
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 08:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfKMH2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 02:28:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37426 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfKMH2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 02:28:14 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so800950wmj.2
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 23:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IOlUSrIDIC4r0HRi7c8c+Ldaz08xnqUmxl+YCQx0R9U=;
        b=rRe1WChwLZ7d9y4BjPHhvuiQF5mLBcrpjebxceuMa7scP5x30gA9V0JzPSSZIf8D3C
         l9iqhhYiTCepi0WqieTI5Gwckoc0NUb/1AEd9m1HCUIX3/yHMHChzk3DP1Os3+SSDvk9
         xWSjFM5XYGIP6hFLxPLDUSfdJJCuGB86RjYJ9BQkQ6k9Ht1aLqK4jbK+7Ggb+3JZaS+S
         ua/krA8S7iIDXfThEbrxwAl925Nbgm2P96goQRzm/4/G5V0YR4B1nQw7IRIThM4IFJkG
         xtIKZA1T4Qmt8X/gvWUHbfcBeoA0srf3FJb4H/fe4oAFDlBI17G4GEfw80cdGJzCSGQf
         fYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IOlUSrIDIC4r0HRi7c8c+Ldaz08xnqUmxl+YCQx0R9U=;
        b=kLsGaBxCWVLsL3ilOvp7qTdRwRCSk3RcilbWsvpya25PDBFpDI9lA0ivZQbDOS83I0
         Gsv1JHwa06d99dui4fTDap7UnHP7oVd3Q8AHiRQ+PbJD80ph4aJk/W8+eqhSIrsdwIwj
         kCoVInD2rto1waeQGoZ5URoVtRLg4BgoxGEwM8XSZ4yoVusZjGhJx843re5vi+rpe2Jn
         mVHvoijODA+ifDqLRhQdSUJMiwqw/9UsV5ZybliEgpkT2EfPNO0Ks6EuBZIx0xwDiJ2T
         aNMsYzjgYQ14GkD61m1K7WO5aQoAg9V0VZLbskASW2gDc/eAnixlE7uOvlin1bPz7rph
         9c7g==
X-Gm-Message-State: APjAAAWgp/4xUcOWJqJ8m7LPcxWPzh7wNVxuWqfFiC6cRwhA8WTBTMLj
        UT7aWK1jRQRMY0D2CNJ+gyPMsMMbIJ7n0Q==
X-Google-Smtp-Source: APXvYqzr9R3U42Tvg8zZEFaCo8OMljS+8ultMmReLmk8DGy2Jni7d+4LJUa2neapi3xkZIfajsN4tQ==
X-Received: by 2002:a1c:a548:: with SMTP id o69mr1290489wme.31.1573630091897;
        Tue, 12 Nov 2019 23:28:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t12sm1572775wrx.93.2019.11.12.23.28.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 23:28:11 -0800 (PST)
Message-ID: <5dcbb08b.1c69fb81.bd424.66cf@mx.google.com>
Date:   Tue, 12 Nov 2019 23:28:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.84
Subject: stable-rc/linux-4.19.y boot: 119 boots: 0 failed,
 111 passed with 7 offline, 1 conflict (v4.19.84)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 119 boots: 0 failed, 111 passed with 7 offline=
, 1 conflict (v4.19.84)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.84/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.84/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.84
Git Commit: c555efaf14026c7751fa68d87403a5eb5ae7dcaf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
