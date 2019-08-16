Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F4F90770
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 20:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfHPSFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 14:05:11 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35503 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfHPSFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 14:05:11 -0400
Received: by mail-wm1-f50.google.com with SMTP id l2so4762326wmg.0
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 11:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3wu7M5+oRklCUjOATfOr5D7zrAWojLaiekQriXAK8XA=;
        b=bd3y4La7D6CzPgJlQ+JUpO3HcfzYVgIKTJoVAn5lShbSR+5YmfwL3NjvmXMEY7NCaS
         e02VQm4xAl0d3RWKfh7TZ7sy8WfleX1BH523Muid/TxNS8z/8dItndmX9W1i9Ez8qYpR
         OihkHfg7XELQQRnXm5Qrn5LoHt9QifbU49qYr/kaPwieko1GUAukjpCoLKwesN4z7vhe
         jdrThpJMK/UsIlPmPnfw1guzKE53zGRjzFmxZ05ZgkI2btju9vyvyY6QUOQPPhEqG/Gb
         9XolP6RyWW6IYAuKceeQd9oVgBWV9VZuAysNZpDdmLURPp0Ah0SJgGjFzEImcomsru+Z
         HS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3wu7M5+oRklCUjOATfOr5D7zrAWojLaiekQriXAK8XA=;
        b=DcEHzz8wfwxmBmI3B+C2Qf6EKJpiG4iWtUNZsXck1HIMmjmY0sTOOIEe0fpm3TJOHO
         ZA6uNDHZ1IxfSqR1fyVhPsG76d1Nh48rzAfK+zSePYJh3bF3GnlHcrwlLLJ2lH7zzZPp
         8t70J9VlO48agtcJQIYAYY7Em5EFGsK7UvCf5IOFlZWfgG7M6qrDKAJrRd96NQhodWwN
         Q4jaSiXDLq5i5TwA3IO7+HgZF9Hk6Q0Hsf0ej6pH3tdWv0U80e8sRunarMMPVVFVV6Uc
         PzgAOKGqPvEdiPGBt+bdXpbT0P4dcG80ZXEnBqDp6wL1mq/Bf8sOWJw4ysnnTw4rOExI
         +2IA==
X-Gm-Message-State: APjAAAXFbLUTw1u2mVsImHf8E15Rihudev1shntSxRdFIQb3UZRacw+q
        l3Pi8h45qIWaa6CCXKZlR1GU7HlSqXQ=
X-Google-Smtp-Source: APXvYqwDUyXH8q9AyG9HPmYED/p4LlZHljVhKP7bif+fYvPxzCpjqWXtYB4qNizsf+DAWIX3AQ0hjw==
X-Received: by 2002:a1c:541e:: with SMTP id i30mr8315133wmb.54.1565978709097;
        Fri, 16 Aug 2019 11:05:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b26sm4606324wmj.14.2019.08.16.11.05.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 11:05:08 -0700 (PDT)
Message-ID: <5d56f054.1c69fb81.a83e0.5c8a@mx.google.com>
Date:   Fri, 16 Aug 2019 11:05:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-44-g755768e31f44
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 106 boots: 0 failed,
 98 passed with 8 offline (v4.9.189-44-g755768e31f44)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 0 failed, 98 passed with 8 offline (=
v4.9.189-44-g755768e31f44)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-44-g755768e31f44/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-44-g755768e31f44/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-44-g755768e31f44
Git Commit: 755768e31f44af5c418e8ce04246488639106b8a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
