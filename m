Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344691140F0
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 13:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfLEMnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 07:43:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35111 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbfLEMnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 07:43:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id c20so2062661wmb.0
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 04:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q6e5GfHsnzyNKpJy3pWapxPRsZ0ADogym2y+t7+COWU=;
        b=l/0v+crx8VJ3BDMm5EAQvUA2VDpscw4dzLaZINVbs+PwhK5l7fcJaykaSFURG8gVoz
         fpUhhjLRrRPR8geHkuSCWJ21Xgwvszabhnx4/PISZ/T0lQG6FS+V17es1UdOBf1lXkJX
         QqNGsAHv8AEW0OmZ8tYPBt4Ll5u/foKYLHoidBO+rY1dZtUsj1G9AHlkaYAsZPBUNRqq
         kEbuc1FpHAYl4glZ/U7b24Nh2ZvpoFrO4MjPqyTMLBFjI4Qy1D6B8w9TcmMygdN3hFR8
         rV3o0uBpxlkqT0sezYvpXtY4geRGpM+hXwqXs4tOvwt0mtC20bvs6/U63L2kjJxXDZhT
         d0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q6e5GfHsnzyNKpJy3pWapxPRsZ0ADogym2y+t7+COWU=;
        b=r/EVlLGvehoxuq4caBWyEJLYlHKXpqLzEkDY8+sn1Jc1jDu9GM3xar7YpGlHTojZas
         eyUrkdhmNlfazC6DoK1rmxZqN0shvHZftQoWeVv0Q05BPBBHdvtAYfo2FYAxbEyxWJxB
         6L9B11pGjhl39wxiwykTRht8AS8G0B0HlEtVTEEVdIoQjEaC3w760WetP7yYC8jfwt26
         GlD6Jv0sdI5gG/8LWFDmpfn51mHypxXfs3nt/2ZHL+NubE0/7DsRiKnWqiiPfmG2znLu
         06AFDuLTZnQ6RaOlAU//ZJDU7vEdYEY7fjjMVXvWrSQfOgvVmdvIXIIUTh/oRBVd6NHl
         l/PQ==
X-Gm-Message-State: APjAAAXgJ9YD09GoF7c1nOZX35O2ZCpyInv1GTWiaiVvux8GG01fN3oQ
        Vn1QFMKiaBhdFfqwZoXyHJrNvRAbnOn4nw==
X-Google-Smtp-Source: APXvYqw4WK+gynATByF5BEDu4U9SLjmCPNWF8Fa5Ir8MDCttqMdkTFvzaSWEXeZsMKnmzyBZMleywQ==
X-Received: by 2002:a1c:9d16:: with SMTP id g22mr4833905wme.27.1575549788227;
        Thu, 05 Dec 2019 04:43:08 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r21sm10050010wmh.4.2019.12.05.04.43.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 04:43:07 -0800 (PST)
Message-ID: <5de8fb5b.1c69fb81.42482.54e3@mx.google.com>
Date:   Thu, 05 Dec 2019 04:43:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.157-211-g931b302fee58
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 1 failed,
 124 passed with 6 offline, 1 untried/unknown (v4.14.157-211-g931b302fee58)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 1 failed, 124 passed with 6 offline=
, 1 untried/unknown (v4.14.157-211-g931b302fee58)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.157-211-g931b302fee58/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.157-211-g931b302fee58/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.157-211-g931b302fee58
Git Commit: 931b302fee587ef4650183c05e0853637cf294be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 21 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
