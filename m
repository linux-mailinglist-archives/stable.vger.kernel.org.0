Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F4828FB4
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387714AbfEXDsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:48:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52925 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387703AbfEXDsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 23:48:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id y3so7819267wmm.2
        for <stable@vger.kernel.org>; Thu, 23 May 2019 20:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=v34blGR1BOyMj6mXuwgkwlptJtpxjWKG4dytKI5nL7Y=;
        b=qSkxOpDnzNaN5Txt6l2nZBuG9L0SIjfowxHHxRLtPgAxq5mJTJAiqoLy4wv6ELdz2D
         vdmDx8fRQoP68c08RNMlWIucGQpkXJNm5oShk1ykp0I/37HIb6EStrc70G1i/N928GZe
         ei7F2/AUKX7lQyPuwf+/21fLnCByVKQl8aF7G8THupEIrnVEnPUkmSO5Wdr9Ffjs/YGs
         L1V9eNIwSwdkcutpR/p1ZuH2MTfXFIP5fQn3OlnSOfJrCKKMi8ZgaQBGuKh/9Q0YcPLQ
         jGqNbA2/ZpS9vb/ulkX6uQ5bpZIjHCUefmaf28u4xlR/Z/LQu7YACK3bmyQVAGQOujWI
         jJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=v34blGR1BOyMj6mXuwgkwlptJtpxjWKG4dytKI5nL7Y=;
        b=CEt6uybgJisLTPOSd4W0+XoWJD7Psaau6Mz0OUHBQqLcNVqjKR0aKB3Ze+bmUGJffV
         0xAXX7oE9eCWJXHYWuE1CAvEAumuau8gaHuVlnxAqyrCSglufHiLPaCD9FMF7F/LUV5f
         Zs4ZEVeS9HiAuaBwvmgoz+CyNdPCOagCLI0LWUgp+aNwZsAP6YSxP+vLKB8SB2UfdahQ
         ygE6bviHN8THocMyTXkbbw6OTnk1bJKvSuZUbQHPFNC+bfwb243DMG+J/iDiDtMLIFLv
         wYd6ul+0M83z420AsMxe9/gqplVVTqOj//nsSyRESqvoXPXpwHLw3C0H2zHF83JBAXdY
         OktA==
X-Gm-Message-State: APjAAAWRCMTUdOHir61rDiSS2ODuTLXVNmPzPzd69MJ2cantsBBVUd28
        21sBdDiyZd8Um3Azt0CAwWNJxQ==
X-Google-Smtp-Source: APXvYqxG4ZsNU/Eh3hsaRQusLj6+eGT7GlYIFrpKh/1q3mMdeeLE5/ucFTpIpIbkzu6SAql8zIjshA==
X-Received: by 2002:a05:600c:2116:: with SMTP id u22mr13830470wml.58.1558669712978;
        Thu, 23 May 2019 20:48:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y12sm696389wrh.40.2019.05.23.20.48.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:48:32 -0700 (PDT)
Message-ID: <5ce76990.1c69fb81.2d6ca.3775@mx.google.com>
Date:   Thu, 23 May 2019 20:48:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.45-115-g071ff9cc9849
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/114] 4.19.46-stable review
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

stable-rc/linux-4.19.y boot: 125 boots: 0 failed, 112 passed with 13 offlin=
e (v4.19.45-115-g071ff9cc9849)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.45-115-g071ff9cc9849/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.45-115-g071ff9cc9849/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.45-115-g071ff9cc9849
Git Commit: 071ff9cc98498f489abc097471549b19933ba3e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
