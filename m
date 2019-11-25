Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339E710912A
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 16:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfKYPmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 10:42:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52960 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfKYPmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 10:42:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id l1so15948161wme.2
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 07:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lGz91ZnF8AXB8jQPCfD4agQ0YrDEZianIdzKyDVKQnk=;
        b=c4M/bZl+J5zCWC9Da0rMaOmrUoO4q4GcULNZfAk4MRoh9EvZ/jRDYtEI28BbZr5Qr6
         YfC7hOU0bUckGKJTQAWSrph9xpRY6s+L/bdGWgPPqDicM/D73W+9lGH23Y7sgOg5gDTY
         9pSVWV5DXa8hNr9KxhEhk+I50QfEFoPtxdyT+cUWYNhX9kfSmQJiI1sMCVlxKp4vRB/o
         Uzy1MzyXOYQWhU9rv5VJF9PIaG+vcWtbYDrW8d3pBwgs4x9AUNv6q4Og4dJI41q3ueAf
         n7li5/1chNh5/HvIZ8eq/I5F4vwx0hb1DA+XEO/EEE57tB+IYCts92sU96TeBRHygKSM
         vC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lGz91ZnF8AXB8jQPCfD4agQ0YrDEZianIdzKyDVKQnk=;
        b=ZhmiqOWWVZjCFU3vQ62biiYIGDGqPqZp+cZEJwGhjeVVgjTfEYNiGkzG0fKXafglUR
         GdTNewErBKvTuHO/PQsztZJp6axJ4WSGwon+o3ZFTma5Vtbc4y7HBPYFYSfhtbsz1vsr
         lEES8cT4D1pOY65GxpMcbbb1b2gBsPgGA3pwcKwJkwfJmtG6OlJaL5OiqzT3QPJmN2f1
         PvLzc63hnMFvnRCiELBDFyQ0QvGPjdtfMGJOvQp93pEiyBRJKK1+RvPstkYnMJNRVC2i
         JoooZbtFO4M3Uf22DNeGRq4ymjUE6PFhojXM3Q43rl22WmoQOGUm3J8MWAqTHA8ikhKG
         6Xag==
X-Gm-Message-State: APjAAAWKtdldP3/R2qfwCyyVRq/UDkKbJOUlDNOVeS38brO67QSTI1Iy
        l5QF/TdTPPsQa14LlB21dCpJ+O5GwEI4Mw==
X-Google-Smtp-Source: APXvYqxYq6SvqLr6ol9yp2X3rvrWq9njcpEBnwRr1+vLQBZpv8OZeXBijOXeOKX+/6YHmh8AfpYFjg==
X-Received: by 2002:a1c:39c2:: with SMTP id g185mr28656517wma.88.1574696538083;
        Mon, 25 Nov 2019 07:42:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t185sm9230568wmf.45.2019.11.25.07.42.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:42:17 -0800 (PST)
Message-ID: <5ddbf659.1c69fb81.b872f.ee69@mx.google.com>
Date:   Mon, 25 Nov 2019 07:42:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.202-157-g2576206c30b5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 84 boots: 2 failed,
 76 passed with 5 offline, 1 conflict (v4.4.202-157-g2576206c30b5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 84 boots: 2 failed, 76 passed with 5 offline, 1=
 conflict (v4.4.202-157-g2576206c30b5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.202-157-g2576206c30b5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.202-157-g2576206c30b5/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.202-157-g2576206c30b5
Git Commit: 2576206c30b586012e4469b22f4aa3cd04869305
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 17 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.4.202-159-gdbaac4c5=
4573)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
