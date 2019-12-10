Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A321182D6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 09:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfLJIyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 03:54:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39394 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfLJIyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 03:54:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so19019799wrt.6
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 00:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BOfoDCW6IhZxQsY/LCuCEKfUjd/hQnHW7Nz7QXg9L8Y=;
        b=ZoxNN7quJN3XWDtEJlEyujFPzRNCaahzWrJvxl+htWGGp8EdFNs1PE8X8zFCkTdXGN
         NSMf6UyuYescKYX4Z3uqhKlc4X6Uw5z3HjOmcEuafnXv6aKxyKXxywfUHMB5vQug70nc
         DUV+VSScYbHF2jAlel8D3kaFoGKSagVrvqyMp8xqha1Kl8IK7iGiW0tMsJ0qUa8IErzu
         o8LaQf+s06yEHWBrJUTfA1D/xypqLwufj/stC4wqDegTTbOTO36r/fYTpHI0DXYk8Dkp
         FVjjYtNKUU9Bl6PkdjWmGBrCtGiZ8Lrlp5qe4gbfVdwWnlD+EhD/y+Hf6tSl8OC6+QpG
         chAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BOfoDCW6IhZxQsY/LCuCEKfUjd/hQnHW7Nz7QXg9L8Y=;
        b=UY2LG/iPwJOwd2UBg0z7Ye3Yk3aUxoxNvH25aITA63+BrZ7Mtuv/M24H4ayZZpp6R9
         gLhhJ9alGsAoIonu+zfHrHP3Y1UdruB6qPwrW9ObbfgulO4RUXCH7VaYvwLR70mvYsnw
         VVU2zx/UAhujhXqMZ4Ywn/vczFqpGMvdBe914TLlQZHoAifX1LD1QJ/W2PsL/RQHfsRn
         GUkFTZ5xYVdh26RKY1VhGPtV+uWDJFTY1HMzErvDb46gtHf67hObMEILzkRfFlvF6pbr
         EOHSKLcuboGVugpd+SjiffacbyZCu/s9CiTbd4vl1PlMR3LMsqUwHP30G4dZWSWpqcUd
         HUjA==
X-Gm-Message-State: APjAAAU/0VgbHbH1IaYdkv8NR8kUjmmcZcTs1ZACGe9AzO1jxin0yYRT
        RVJqW+tDaXR+qR26Hg+oTS/ZO7R1kUYUkQ==
X-Google-Smtp-Source: APXvYqyAhcsKD40BQvoaMUR43V+P/1Jx5BT7z0D590rUUFw62EpbcSu4in6QDdaLwcQjaJGdWsWNVg==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr1863237wrm.241.1575968078156;
        Tue, 10 Dec 2019 00:54:38 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z18sm2260673wmf.21.2019.12.10.00.54.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 00:54:37 -0800 (PST)
Message-ID: <5def5d4d.1c69fb81.28f28.b00e@mx.google.com>
Date:   Tue, 10 Dec 2019 00:54:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-69-g9628a01d52e1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 89 boots: 0 failed,
 83 passed with 5 offline, 1 conflict (v4.4.206-69-g9628a01d52e1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 89 boots: 0 failed, 83 passed with 5 offline, 1=
 conflict (v4.4.206-69-g9628a01d52e1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-69-g9628a01d52e1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-69-g9628a01d52e1/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-69-g9628a01d52e1
Git Commit: 9628a01d52e119872be61b54259e482df0f865b3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 16 SoC families, 14 builds out of 190

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
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
