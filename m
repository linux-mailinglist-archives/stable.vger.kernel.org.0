Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8971567763
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 03:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGMBIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 21:08:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33470 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbfGMBIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 21:08:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so11642229wru.0
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 18:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oD5HsBSgSAQ5jap20FR831CoyJP8raEaz9mnvE61WXE=;
        b=0UrC00/8NYtd1hE3K9rf0ZzI7dHcy62c217a45hj/nv2bZy2BDarXl1nRon9UOmuCt
         JntfDeL01Z0kWd3w7B2ScMIjZqHaderQXsQvmKkJmP/BCfd2nO23bbbvvwWwFsvB+ljd
         GCLqIRAhogyXttlkgNdeic1lw6W5bXKL8g36YYZQzuRJW54Zn2v2XolZ6oqJx0JHGWGU
         OmPVaCPjsxP+fpDEnyMlA/7NKfQks32ULHwG4ScUJUYmcpzf8IzT5ZbBakwAKKmHFB1Z
         x+q4FCo3f+cBylVqjvpQCIeCgRydEJxIe3IISkKtJqoe9jK6oqaAFlO6ba5EvX/WIVAr
         hXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oD5HsBSgSAQ5jap20FR831CoyJP8raEaz9mnvE61WXE=;
        b=q2D5GEHhnJs5oPq+qwsyhGydqkTw8l/xXHmbecDBr5kQQZ3yE6NYXR4gVAXPPEclM0
         xwrzlh1sZngaJ6dHdQ9DjQ9ZwwP34TX3pAHgmIae1fIw82yj/PVfDJyaXFIXk5ooX0XN
         UsTt4X3Ty/fitYxtZNhjuGZQlMXXZisAygmL9iCD1f55xNvEk/OiGCwacsrdR509o8tW
         FpgWr9axW3REBKa0SU9hZTs713dyhuA2rEbPlXrgLZoVRyY3RJJC5l0AEzduMkOAdTFk
         M/PEKQYKD/ZVUKw+K5ziaZYCJZD0/7w737adQsXFXkyQaI5Pd+G6hiJUgQ5EuEb0v8P2
         daIA==
X-Gm-Message-State: APjAAAV5JJa3ICE1M4sRTBmn04VfDwqvEth/lZVFl+DUVX+RV+IuXYQ/
        pqyxFNQUJJnrb+mxMZmQbPqK8Uyrce4=
X-Google-Smtp-Source: APXvYqxe4WdLXazZLfT0rvsVVPL23v4plSjBezKesMf+H1N59Y5yvz5JAFXWtsTUMl3YS5SI2GeLMQ==
X-Received: by 2002:adf:c803:: with SMTP id d3mr14612333wrh.130.1562980102517;
        Fri, 12 Jul 2019 18:08:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c1sm17648679wrh.1.2019.07.12.18.08.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 18:08:22 -0700 (PDT)
Message-ID: <5d292f06.1c69fb81.f6d50.6e87@mx.google.com>
Date:   Fri, 12 Jul 2019 18:08:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.133-57-g6186c2589718
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 119 boots: 4 failed,
 115 passed (v4.14.133-57-g6186c2589718)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 4 failed, 115 passed (v4.14.133-57-=
g6186c2589718)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.133-57-g6186c2589718/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.133-57-g6186c2589718/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.133-57-g6186c2589718
Git Commit: 6186c2589718f95a376bc65d24797f4c9cdb0819
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

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
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
