Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9878E13B8B
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 20:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfEDS2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 14:28:09 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:40687 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfEDS2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 14:28:09 -0400
Received: by mail-wr1-f47.google.com with SMTP id h4so11888840wre.7
        for <stable@vger.kernel.org>; Sat, 04 May 2019 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KPACyaSmM7SH7Z/mR6C52rw+ki7LFPR7iQQVajdcVW4=;
        b=R42f0u9TTaQRTe17DWPIl65LhFLcI/EukLxQ3oDcoh+vQ2wmodlzfUxesKhmYar67U
         xweaBoSc3O0sqg5U5yxphcIF5Ef0A6tByOgdMcY6j3CYg+Sf4SakJxUhxk3dGojzKndc
         +p3ujhbooKH4WNF7m7LpNLaZX3l1aXDu40AHap5JUG+dEam0922nAqlSxbd2A5FX1tLU
         hF3iMP/pfNfxDJpGA1zDjhHP1TIXSjcRSRfGMhx20HlZP+dgX02IjvgJAJsOPr7Yhbwn
         DwPUKRqWbD2cF7rmaN9UDL6sPm41usz6Udq5AI7VhKs9Ic3S8uT0PUdoSx1byzBBlMqU
         Et2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KPACyaSmM7SH7Z/mR6C52rw+ki7LFPR7iQQVajdcVW4=;
        b=QcIzDZZGGc3Gp8p+oIzh7658BRiDHrRCqbF739MTu92YzIOn5/ggqQhr8Y4CyLCrvX
         keh15uNJr2qURrQK+/tXcznIoGbT0InvwkfErGpjctZuKhit/ZW+mXWv/AB/s0jNtxJ9
         pOIYuWGSYFldl2/X+ZCMss3XWBakLnVPBu29joTKiCORyxrKcsBSRmim5bWqDtBDTb7j
         Gvm3kWntFHiXeDeq8WJXPqTs782ajaxJVO6AGHrfMBchC52tJP5lRTrQJbTnCChxS+Et
         wVqHP+noFsaTBhephi15kw706wByiRN5r+gb9oFdtcZs/xAiDDnmOStRShbuLTE0aIE/
         fj4w==
X-Gm-Message-State: APjAAAVs8oFwlWYX268cxcDDdPcv31qbn9rDuAoLyPCz7OZPcC7Cchnw
        CdCHO1WYvkTKKXJlL9lN8RSDBiv4uXw=
X-Google-Smtp-Source: APXvYqzUJzhr7YmVyMOP84EnzgmNGSgTAXISJP3PP8NVOO1E8AhTDbOHKVG9v84DiSUc/BytQd9EYQ==
X-Received: by 2002:a5d:4dc1:: with SMTP id f1mr12037615wru.300.1556994487486;
        Sat, 04 May 2019 11:28:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z140sm9022294wmc.27.2019.05.04.11.28.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:28:06 -0700 (PDT)
Message-ID: <5ccdd9b6.1c69fb81.8ab47.2b5c@mx.google.com>
Date:   Sat, 04 May 2019 11:28:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.39-24-gb0d6421bd855
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 128 boots: 0 failed,
 123 passed with 4 offline, 1 untried/unknown (v4.19.39-24-gb0d6421bd855)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 0 failed, 123 passed with 4 offline=
, 1 untried/unknown (v4.19.39-24-gb0d6421bd855)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.39-24-gb0d6421bd855/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.39-24-gb0d6421bd855/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.39-24-gb0d6421bd855
Git Commit: b0d6421bd85515e878edcf33121a818666df7749
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
