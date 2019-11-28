Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513DE10C31D
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 05:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfK1EAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 23:00:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54979 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfK1EAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 23:00:22 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so9408106wmj.4
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 20:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ClalF4FAvjJe0QwayM/FMZe4aDJbVzSZBuygEitJjZI=;
        b=nnOBy8yoGIlPX9PgNBY5u0cuXoh/z5RrdlAJtwEhe6IKRMO8S/oqybleoYoYMRwSEG
         Ni3lzKX6QIF7O4zoC6tcqq4sRgGWCmqRrdjVGn/ZwXL5YTQiY9Dx24NewHwL2iAly8rd
         ChrjIKHH+Q1c1IO3RVqxvNSXzG+1IdW7ZOy5nAp6oOGipTI1o1IIrVmKBjrEhey1OhBB
         hLaPQxpviPItRLS+V7rYnnEOy7enGjelEhJnXjtm2uN5BdjnskCDy5iSK5wp33uYrxzF
         jSo0GYr33lG8ZBkeELtTcEOxk/dpCGAYqzu9v6n1Jn6a0y/f4kGI6aGRgKEYDgotZLNO
         JyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ClalF4FAvjJe0QwayM/FMZe4aDJbVzSZBuygEitJjZI=;
        b=fl14/SJdgpDYkwEhPLE09Ffw8tfMAqlX/jIsSsgeqDblhN2l1WX+UgmD67tO0EPFx5
         OmUc5Xu8kFf+kHmphGj2xae25K4DXt+hLG8yUOOueszzU6MOOgUr6kOWOzAeGxGh+uY8
         tBRzCA3swOYEqwADN82Ylsxx2PnbBnQ5K4JhTAp2o2hxbTnT2mf/Ja+yX/oGda2asEIZ
         P127YYg/YmO/tQz4tyjWhTKgek9lJg6D2GmTwlCWPky4wjeIOymAF2gwmkFF6ESMkbNa
         /CChlFEw44q7DkmmpkGQFTFB6BTQZhq76LLmLhZR1wEIaKceg9ooLjcXERS6pRbwLqw6
         VjMw==
X-Gm-Message-State: APjAAAWsRWTGJnIhgA9hxaRfGJAojOSF/kzaPTXjWMGzwG4jLwtGMnVK
        zQsNfnC48koRyaGXgY07r9DNadWo8r9FJQ==
X-Google-Smtp-Source: APXvYqzmgURelg8K62MmvnLEUxYASnxQKyvj4DK7RqOQfLyyGPvgRXtkzJxxpYm87WzCEHHEen4WJg==
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr6089526wmj.58.1574913619022;
        Wed, 27 Nov 2019 20:00:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e16sm21730684wrj.80.2019.11.27.20.00.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 20:00:18 -0800 (PST)
Message-ID: <5ddf4652.1c69fb81.b8e13.e9a9@mx.google.com>
Date:   Wed, 27 Nov 2019 20:00:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.203-152-g3bbfc6b1c25b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 104 boots: 1 failed,
 98 passed with 5 offline (v4.9.203-152-g3bbfc6b1c25b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 1 failed, 98 passed with 5 offline (=
v4.9.203-152-g3bbfc6b1c25b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.203-152-g3bbfc6b1c25b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.203-152-g3bbfc6b1c25b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.203-152-g3bbfc6b1c25b
Git Commit: 3bbfc6b1c25b08b1e400515f8a2c333a6bdc7f26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 20 SoC families, 14 builds out of 197

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
