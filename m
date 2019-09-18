Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D86B643B
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbfIRNTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:19:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46862 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbfIRNTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 09:19:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so6838027wrv.13
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 06:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=8yWSaq1SPkhAnGKUElxNjUPCl80FK7UQ5LA6iTbaJZo=;
        b=VJ3XXKhY5Aw2z+D4yk/YHnjv1QX4QXrcPX5ZYFOW3nKaK5h3r5Ve95yzGQFnxSiEhA
         xR09LirpYG7hNKi7xVD5XHbDQM0NLh1r+Ej33ncGU0Q6vCsywkbKQAneSMjqMn64DU+3
         T+y0+r+Q5EPLArptumYr90CfWPqwWxTdHGVY56RsTNVr/eVSvdUCDW+JiW8LBZNk3L79
         UU0+ak/HU9r+O5r/o+vharVGWAZvglZXr0yg+2hNN/h4rKvuTVIy3yrfIE2Z8eT3r36i
         XwY/HDom/W0q1aesJjGtvR8vLgDbb5TqQxONcx9k+SbtOAKc9il03VA2gk9wef/dWSPM
         GSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=8yWSaq1SPkhAnGKUElxNjUPCl80FK7UQ5LA6iTbaJZo=;
        b=VwBOGqBMuYnajD4DBWyzTYhjCdle/WEjmVjUJ9HRqAp/CYt8PcPYzTDThaVMWIpix8
         T+z6r3SpvhdhkJrqJIo60dTWYbdcLiqr0DuyDeSb/AXw2DlD/xf7O/VmYT3tCDPDXUZt
         k2nbfbtod1arEAPkUKmBnhlhCL/SUszc8IL8ZYGsSpBqw0EB7BMUdSzghE2Ai1pbICyp
         M78MI2ObRSBzYI1mGFzCpjeQBiCfP+tFjOv5fjcevXgHglRBVfu4Fov4jm0iMtD4nNpb
         in+BkboHN8h3YUV3rf6tPuFdZtAVFvNVf19XlS3H1CZ14IEwrAglkBw4rrXe1q//HliI
         RyQA==
X-Gm-Message-State: APjAAAX53FYqsrqMz/6RTYHbsFM1qlqGoG0uQkFKcoOT+4hHlQ7gKVca
        L8HJq+PTxTaEaRReU4ohLk+WXA==
X-Google-Smtp-Source: APXvYqzJjheHXn4H9Pi/aVsdA/2XvIBwrDIHXOMM/+4tXFXAPcqqhMQelVjfgXCH5omPtGuWxmHKRw==
X-Received: by 2002:adf:a350:: with SMTP id d16mr2970112wrb.326.1568812772484;
        Wed, 18 Sep 2019 06:19:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y72sm3124512wmc.26.2019.09.18.06.19.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 06:19:31 -0700 (PDT)
Message-ID: <5d822ee3.1c69fb81.464de.db03@mx.google.com>
Date:   Wed, 18 Sep 2019 06:19:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.144-46-g187d767985cf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/45] 4.14.145-stable review
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

stable-rc/linux-4.14.y boot: 131 boots: 0 failed, 121 passed with 10 offlin=
e (v4.14.144-46-g187d767985cf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.144-46-g187d767985cf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.144-46-g187d767985cf/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.144-46-g187d767985cf
Git Commit: 187d767985cf878208592ce3ca667e5021abf2f6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
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
