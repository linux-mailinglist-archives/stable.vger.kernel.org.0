Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1921477C2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 05:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgAXEzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 23:55:18 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41853 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbgAXEzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 23:55:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so419586wrw.8
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 20:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TpWT9MH1Gbm1yV8UZOqTxHxkMIiUatwPpm8m861lqgs=;
        b=GjbSTyqlY5gT/6TQHu4vxaCbHH5SnnZY8UY++ZX0yl4Zc/wfi8ZpHcTYoO0TfutF5a
         6lWuoDdKVSY82us3IMEvOwQ4A/xD5Xv9nOWaTOdDzVdmFXi17ICVYKZXgoN7GldK075f
         WAV9mUhCL2VI53Seev6gZpuR4Tm+JN2C6wEr9UqJitLSee4UXvcSEZtEEQ7ckpBhkGNG
         FjaIEFG0lNZ3GQDFjdTL5rJ/6Ku9dZrVzRFWAQQv4fD49+4ZCtTfIu+BZNMnNJc4hlKN
         KC2qubHzBj+29W3IxKsd2IhLrrHBDIoqNMgu9Mt4mask9i/YxJh8sDuc3JqBfuBkSvpS
         0/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TpWT9MH1Gbm1yV8UZOqTxHxkMIiUatwPpm8m861lqgs=;
        b=rEUYvw1d+n0wY7JNnW3HQzU1CsDiY0gzdGE/4VPCKGLTEeA0PUSoNlxJw/hy6ZZpJ6
         PGpDDM7HTmMCYvXCFIUG1Y1Yi+6UGqpwLi3szWRbqKM+ZQkesPk/X5K7AasoYqp81ZO/
         6jeOuAs49YmXLWbnk2ThfYrYkgmu6SpSQaZCRP2Z3aDn5vpuVQ5UnSGUsL2kbEHxapZT
         SlwcaTuAarjvzsxab5sGhybCTVU2xkNVWnFSEcnjHinbZYUmld5nH0xXnAs4cv8IV5n9
         gcGTj+jqfMhOsi57ajRGJzCpl0sh5W4ONhFFddI+jDCgPf6szbTzmt4bHQI+uAjZ2hzc
         xxbQ==
X-Gm-Message-State: APjAAAUPrkm4PDvEQ4H1kziUqq26EbDbLDUduuHFKHH4+l9ugDMeuWfA
        SEb9QJHrNUEGHMEhrMawcJIPKD29/w2/Jg==
X-Google-Smtp-Source: APXvYqyS3zE+qbelshT7TCYzGqnkwcJGhelX8/tlTdUiYSKvhriGOAKieNMIOUGTuIoo4EPs69eBBA==
X-Received: by 2002:a05:6000:12ce:: with SMTP id l14mr1961645wrx.342.1579841716178;
        Thu, 23 Jan 2020 20:55:16 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm5897008wrq.31.2020.01.23.20.55.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 20:55:15 -0800 (PST)
Message-ID: <5e2a78b3.1c69fb81.d6559.7de0@mx.google.com>
Date:   Thu, 23 Jan 2020 20:55:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.211-161-g713610ae3322
Subject: stable-rc/linux-4.4.y boot: 66 boots: 1 failed,
 60 passed with 4 offline, 1 untried/unknown (v4.4.211-161-g713610ae3322)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 66 boots: 1 failed, 60 passed with 4 offline, 1=
 untried/unknown (v4.4.211-161-g713610ae3322)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.211-161-g713610ae3322/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.211-161-g713610ae3322/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.211-161-g713610ae3322
Git Commit: 713610ae3322fee7ac48ce45369049646da01f0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 14 SoC families, 14 builds out of 170

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.210-77-g14fe1f1189=
f5)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
