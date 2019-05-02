Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7402E124EC
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 01:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfEBXGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 19:06:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34521 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfEBXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 19:06:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id b67so7587346wmg.1
        for <stable@vger.kernel.org>; Thu, 02 May 2019 16:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=0E50fivlvhtJbA/C1wWaK+JHqMSweUK9UeAr3comb18=;
        b=yCeZj3621KuN4oceXlPvAU0hpwT3SAzPwE/LsTRc8wgpNDpP17Iq/2bg9HxaUk5tub
         JIMm5qFTFG8yy5eVKtF3BQq1cGQq4V2McQI6K+6wHqFE5UMp1P/ZC1cRI2NLQSCe+myc
         FTm0ui66nwopkjz+vxP30XLAfbgB2pJUk05dUidId4vVxV6vm9nzgLOdoDRetgby2Tyz
         OVxx5ASBK/xcfD9o+DKwtyP6bHibnHJsQTnvrXUqNAre1muUdJmz5NqchN4NX2hEUEsp
         Ht0Lj76lvSfi5EA0jAQ6RFUFp0ME37reQwPz2iCVRbtKL12GFjPR697RWf3uMDxGzsZy
         HAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=0E50fivlvhtJbA/C1wWaK+JHqMSweUK9UeAr3comb18=;
        b=PhBzvq60C7XzYXOim1URkW+oEiTUZ+UgWeMy9PFzADPHi6wQPE83IUCvlEL5JrBp0U
         b841OQvKzP1VmvaBl8AfQBKPPyfii8IMs7grAszSLsa58lxxpjT+QmcHA1d5Ym3VOb2d
         jf44gfgnxZdkHou8ALLbcXan9FKlpLvTJ4Xb6B1GsntwQnzjd9AZPwnXaVEw6M+c5M1Z
         mqlfbFgPtz70rHUteiK/wCHNtmSbEw+MYH7ZPynUnV1UH9BcN9UrKyQjeN9m92yYOmYZ
         GahTLVCT9vSf6/u6BqZxy85LwDrsP2CNvYWBeLy/kaMciP4mLYPOIkE8J2+UTM7K6hMh
         wTaw==
X-Gm-Message-State: APjAAAVGQYWeZcT+k4/HLIEPkooRVzjEHH4JBGCNFpWOnHmWFRQK6+OK
        jUnb3JuzPH8u1VkKWKGXjbNaIA==
X-Google-Smtp-Source: APXvYqx/LYGheLToLCWG1PrctCZkgw0sgdA0aFsSXmkQUQpa9E4GkeLsY67rMgbfN0lOKS2XwOf6ww==
X-Received: by 2002:a1c:7005:: with SMTP id l5mr4068452wmc.149.1556838389957;
        Thu, 02 May 2019 16:06:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s17sm906627wra.94.2019.05.02.16.06.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 16:06:29 -0700 (PDT)
Message-ID: <5ccb77f5.1c69fb81.aa068.57b6@mx.google.com>
Date:   Thu, 02 May 2019 16:06:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.172-33-gd35bcd092304
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
References: <20190502143314.649935114@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/32] 4.9.173-stable review
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

stable-rc/linux-4.9.y boot: 104 boots: 2 failed, 99 passed with 3 offline (=
v4.9.172-33-gd35bcd092304)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.172-33-gd35bcd092304/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.172-33-gd35bcd092304/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.172-33-gd35bcd092304
Git Commit: d35bcd0923041bd98c18947041f8929b2fb12674
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-7:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.9.172)

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.9.172)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-7:
            exynos5250-snow: 1 failed lab

    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
