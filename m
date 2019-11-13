Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B39FAC2B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 09:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKMIlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 03:41:01 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:55043 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMIlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 03:41:01 -0500
Received: by mail-wm1-f54.google.com with SMTP id z26so1016908wmi.4
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 00:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M+Gy+E+UonMqkprjeBisBwHKHvmAYi+pxBN/4cqyPU4=;
        b=cIphCOc1t1kTxgqYiDdlqDZiG0k6h05NDUQCQA9EOpJdBhGRn50bdHaFQNH4sBlxx7
         wHZizRz29EZC2doIb9it5HqeHa7MBfQ9/xEyo+dSGkrVrjnMWTUP2mqyHMLRjX6N+p3D
         sxQegWt38j8XuY+X1q6KwrhKeTiUjYdn1RxgFIHUHsP9ICR8VDOUDJvmgtmQcFm3lTjl
         G48wOH7t87jyxNB2bg+xHUBEMhz3be1UeOM8P+QtI+Mykgr0RSputniausI46C7AB42H
         S1N1P3SEq5UTE7OV1Xdu8IWyfSCMz+XIOY4N1mC9D1TXRhgTOJh2wK0iO4ViujdI/AcO
         kW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M+Gy+E+UonMqkprjeBisBwHKHvmAYi+pxBN/4cqyPU4=;
        b=GWy22rKah9mf9vI1MgYYuXq+i2z+dX5P0HcdCksj6E7l0jleT5YEozDUabQSXrT58v
         EA+w8HxV5pGDe49XlMsW1iYQ5sQxd4XK1XSEU0ly98hEphA7vuGdpH5oJKh52RGYUogr
         keFv7gCJVN7JyMtMXl0WVNUZUfhAFb9FiYhSTwQG21VlXBymUvsZ0rsjIENhsYddo94Z
         SKMN61cka0YK0OStG0SiMDgzLhFHDc2vcwDPb/IwvvF4lxHbDucNUxaYxp8pEtkWHXcb
         sOxdBuNKftnvwyekdlIcmZkxJebzRvivb2iZTrGgRI0Uc4dBhqdkwQszh/7Azjnzi0aO
         U/kw==
X-Gm-Message-State: APjAAAUaK/jzbdxVy7J+x3SMUfToyPcARSSjrZgweS23hfgOAWTwTXyI
        rZeIOZsqL8ZETccLkhIP/OGfwdl1pEeWzw==
X-Google-Smtp-Source: APXvYqzXzsaKUH/IKZ/tu5o9t8hfMcU1ZtqIkS1mQvPqypVeGAWU38xdhjf7yoxQyojhN9nte43crw==
X-Received: by 2002:a1c:7709:: with SMTP id t9mr1610397wmi.80.1573634459173;
        Wed, 13 Nov 2019 00:40:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h16sm1803880wrs.48.2019.11.13.00.40.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 00:40:58 -0800 (PST)
Message-ID: <5dcbc19a.1c69fb81.81a70.7bf2@mx.google.com>
Date:   Wed, 13 Nov 2019 00:40:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.154
Subject: stable-rc/linux-4.14.y boot: 108 boots: 0 failed,
 101 passed with 7 offline (v4.14.154)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 108 boots: 0 failed, 101 passed with 7 offline=
 (v4.14.154)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.154/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.154/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.154
Git Commit: 775d01b65b5daa002a9ba60f2d2bb3b1a6ce12fb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 13 builds out of 201

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

---
For more info write to <info@kernelci.org>
