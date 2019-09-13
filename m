Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D4AB2470
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 18:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfIMQ7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 12:59:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36526 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730160AbfIMQ7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 12:59:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id t3so3522081wmj.1
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 09:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=lzFpEdzJTfJtDcINELB3kb/7PITZ5S/QwoQ5BQ4qJo0=;
        b=JDVGL6bl9tE0gy0gxg/Fx9Hg897528k08RlbZF63141rVcTW9y6J5+rz4+z48fGqK+
         kp6UyAWdMd2yoMwr0pa+9WAqnQurbf1txouVLclE9Oot0xkig2yE2RcbMwCZW60l9Pxs
         ErwHtGRm9HU+ENaEyCjYR2JXhVXLQeEqS1/t+gTzd99KQCMKZ+A7FqjtdOgpAhTsidQs
         A+hCDZmP8u04pPzh01a9UIf5zC6S5Is/v1Krqp4tIe0q91JKWa7LAMA3fgH07fiOfQjT
         X0T/Gdp8DGE4UZrRjsWQUd38UhNAmhALYfzjC899SW8oqk/DoyOtbhoyawh5TRqJn7js
         oXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=lzFpEdzJTfJtDcINELB3kb/7PITZ5S/QwoQ5BQ4qJo0=;
        b=kbzf0887VjzJ6gRbLUNYa+A8jOm8AgaWLezqlaW6VBeO3tc4HUPCu0oL5LvKa5tgcm
         lNmfg235Z4IxqTYcmc4PdcC8E6W+Yw/3lBsFvXLRiGaa0bYnElQYUf7Hm6YaEkCi5RKM
         UzHbgAYdTPGw86Y32rudRyS1+x3F7XL800nyyKUO4E2ftt94M6tn4Yax4HFqQe+OTM0A
         zPEhlIuNB5AGZ3COKFmC/3lOcu+/IzSoruf9BZqkuXkZIFBxZBjyP1QmLJPRD33Nint8
         LW+cRTcjf8UjHBUGEiFqGwzUD7pc46kqV1P8Z3WxtJ67DqdXwI9otw8qw1bvZDApCk/m
         ho5A==
X-Gm-Message-State: APjAAAUx0ECE+Dk2tguVMx0fkB7/ihHeebuTqySvfArrluX/J6sLrIiy
        s56v4QxHQ1Pl8eJQ4gW5Ee2POQ==
X-Google-Smtp-Source: APXvYqwX9u1LBn7QaY7u1MssmhdIDa2JkX91FzjJFdYwZwO2K2l0HmELoBRQh4Cs7kWH5yE9tmAOsg==
X-Received: by 2002:a1c:7d03:: with SMTP id y3mr4117931wmc.71.1568393944275;
        Fri, 13 Sep 2019 09:59:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f24sm2641376wmb.16.2019.09.13.09.59.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 09:59:03 -0700 (PDT)
Message-ID: <5d7bcad7.1c69fb81.db13a.c7b2@mx.google.com>
Date:   Fri, 13 Sep 2019 09:59:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192-9-g160225f8cfe2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
In-Reply-To: <20190913130424.160808669@linuxfoundation.org>
References: <20190913130424.160808669@linuxfoundation.org>
Subject: Re: [PATCH 4.4 0/9] 4.4.193-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 102 boots: 1 failed, 92 passed with 9 offline (=
v4.4.192-9-g160225f8cfe2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.192-9-g160225f8cfe2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.192-9-g160225f8cfe2/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.192-9-g160225f8cfe2
Git Commit: 160225f8cfe282fb0b3ce73c781139b521b4b979
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
