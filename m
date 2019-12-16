Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7490B121AD3
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 21:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLPUWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 15:22:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54615 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLPUWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 15:22:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so674622wmj.4
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 12:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2vVQXEXfkbrhAr87yBWMtKnGb2uYb8VgiGNwV3n9/JQ=;
        b=O2zca0op1PmNHkaMweWt0coSSt00MGWU7GQv8QmPgDz0KybCwvAjp5+a31s5XAVqv6
         s+eiS+xQJkblxisCf2qa7KLxaDe3M4/Sw4+x140po6uG7lC9yOBdXtskr7a8RWcHvI3x
         1+rnNIVz2Miu2cvgg3z37RA6Xf24j3316zcPsibA6hdjjg9SpK8OyC5FLVpX++s1D3L3
         eGr+6XVWUmTLRIVr2/+vwjbn0OlaiSIwAJ8yTi66q8bopq3/1bhyoS0NEWIASEEQpIUH
         tDTm2xG3IzJ3X+p72wS7oitaoFfI+Ru1ojPjJiPb0e1RC6QBWzfcmvNEet1xQ7AHKjO4
         EEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2vVQXEXfkbrhAr87yBWMtKnGb2uYb8VgiGNwV3n9/JQ=;
        b=uD9iiGJ2lU1959L5liBW6iN/koNilVZBkdT4Vh14jdWeBf7/Ep5NZOFHgcpIaTCBYN
         qKGuK210My5tFDqkFmE1DEgs+54qYd1EBwCXZoZouF1ujtrKLQYXOEQhWxYbqk/zwGJ7
         5/Uk3D2QOCz5I+eikYvlm9btzAJnVY0NMh2LzdIr59NEOGTcxuxQwiMW9QU66KcQF8G5
         6S4ikR2RJH5Gg6khntn9WWmXvqOYhu/pmbU5p7Tzq0XvWalxOiwNueqVP48PjSIzUyyc
         LI3yyBSzm+VgsIu9+BgHuD0oPbiT/yVzxoShLoApzTwi5pbHTDIieKRnbcdSJ5HLsg5C
         WPCw==
X-Gm-Message-State: APjAAAXVjVKF8p+7cNFenc6XvvnIHo357QR4/3h9cY17spPHAJ2Ru6Fs
        AfxSaOHyuWKNSor/F8SSmuyJbsHGN2s=
X-Google-Smtp-Source: APXvYqwA4oZKCj77ueZurBoVYC5AJIgwWluoltkuV5V8KRWsXFKq03SOiAEdW/CmbAja0doVoijD9Q==
X-Received: by 2002:a1c:a702:: with SMTP id q2mr965393wme.6.1576527756985;
        Mon, 16 Dec 2019 12:22:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n8sm22941632wrx.42.2019.12.16.12.22.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 12:22:36 -0800 (PST)
Message-ID: <5df7e78c.1c69fb81.ae3f4.6d04@mx.google.com>
Date:   Mon, 16 Dec 2019 12:22:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-171-ga8d840ecdf49
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 94 boots: 1 failed,
 87 passed with 5 offline, 1 untried/unknown (v4.9.206-171-ga8d840ecdf49)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 94 boots: 1 failed, 87 passed with 5 offline, 1=
 untried/unknown (v4.9.206-171-ga8d840ecdf49)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-171-ga8d840ecdf49/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-171-ga8d840ecdf49/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-171-ga8d840ecdf49
Git Commit: a8d840ecdf494be71075e629ed69594cdb2814a0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 20 SoC families, 17 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

---
For more info write to <info@kernelci.org>
