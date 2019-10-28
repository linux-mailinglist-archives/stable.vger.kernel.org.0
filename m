Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD38E6C00
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 06:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfJ1FdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 01:33:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33047 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfJ1FdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 01:33:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id 6so8719157wmf.0
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 22:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rzLHlZoYGoBkmiTzE56K1uPGO2KAEAPsBpdpBbsSlK0=;
        b=wuo3O4Ff9ViMoNoSLOmmNnEqye+22H+6oIhHdsTRZydsGrM8DaSMlT+PRCP9KBbzIo
         EdftOUsBVFinZpyK8ZYIWolPR6D9TzkZfqozsA9bmFS+vyte2aCdo7wXAkDICWiGuPzv
         c4Tt1sYSmWnpxu1eBE+OF4E+Zi2z+VxbLVRS9aE/He/K9RYl26BmQ1IKBTgxjGUU6ujq
         vGFg/lrWiMKQN8sQA3FZ4Nj2MVDjbDHZmcw2s218DfGrltKUeTvMDkTbIbeHFU8xJWJc
         BZkMwe49OnwqItk7AYCFqWnK6TuWhychsx+sbHJcoZWpoBKKitBba/kw03w/m5gGMdaX
         pVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rzLHlZoYGoBkmiTzE56K1uPGO2KAEAPsBpdpBbsSlK0=;
        b=K3detPxcWYl0ydoab9YRxgEz6yYwgec8MLdEIuP43teUyQMCgFGAjuws779t4A2icW
         JZu+iF6JvocK9jNDZsyDjyQLpDWqU9lga27DSJcQPDE/8vGVJ7f/9IpKvjXybMuwWT3e
         DXO0Bbm+NKInIJsXW/ecivq50Do/VqgEkIiVL1eYGr6H5+7/YvAkdpt1/ERW2fKLzMZg
         BWobwBTZGZe7us6ENHoK422kQgYdd3ka7E0clTdVLIIdloNbEUeKw8nvzyyj8mfEqZPZ
         DQdaWIoj4GAi4x8mYVUBw6G0MULP8jyPqO/c1tm1RKYPOSpADbKvuW8qv/vXHiZoYLAu
         N78g==
X-Gm-Message-State: APjAAAVlj7VJYLn2jiiin+SLnC4rwHiIqv9yS7OE/KcQy/tY3F9HLy2P
        PnKs8rAl1LQURveTikQtHNTYBjnw1tw=
X-Google-Smtp-Source: APXvYqzSEcrK09kqPXI8FGqv+17HVpHUkz6b5BRaFtUIgEx01/xc1x03yWTpgXPajwDjOkTgyoMyOg==
X-Received: by 2002:a7b:c0ca:: with SMTP id s10mr13589258wmh.166.1572240803377;
        Sun, 27 Oct 2019 22:33:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o187sm3977273wmo.20.2019.10.27.22.33.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 22:33:22 -0700 (PDT)
Message-ID: <5db67da2.1c69fb81.68937.3590@mx.google.com>
Date:   Sun, 27 Oct 2019 22:33:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.197-50-g55a89a78f76e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 101 boots: 0 failed,
 94 passed with 7 offline (v4.9.197-50-g55a89a78f76e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 101 boots: 0 failed, 94 passed with 7 offline (=
v4.9.197-50-g55a89a78f76e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.197-50-g55a89a78f76e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.197-50-g55a89a78f76e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.197-50-g55a89a78f76e
Git Commit: 55a89a78f76e92ca9b2045c8dac71ff64e0eb03d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 19 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
