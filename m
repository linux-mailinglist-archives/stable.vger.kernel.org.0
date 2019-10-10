Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD8ED2CB8
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJJOlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:41:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37803 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJJOlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:41:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so7067846wmc.2
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 07:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=WvpcapkJx8ulBJzj4PJvqG7ZVPifCPQ0JR/mWjZ/O3U=;
        b=ePF0aeJ8i2wRFfX68Bj0lleBItCXI1E7kyXzLaREUNWaIje2xgTAtyy87DEbAU0FXo
         69a121/5zq6kSsNsdfzzntJ6LaR8QbkFaS38rzT/FTwm0uGa6RDvxd0qHy7SKrrbdJsH
         Vx/OTSShDI2hzUPiRMm1NC9tX1qyfBZrmKYHVb7NJ8h2/LTwawjqGXHGHtnut519aL8Y
         ncqH3+7vJOA6d13IFQ2cM9z1sUH3LAIQ7POp8BNzXIzExw6PMp3fTABJGLtu8hfcXBzF
         2jqv0LSny1yWgiuEbke38H2z+7d26tAxTFdZ95V+Q7vLpOs8WiOFzlhP+hIKGm5na6EK
         6oJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=WvpcapkJx8ulBJzj4PJvqG7ZVPifCPQ0JR/mWjZ/O3U=;
        b=oqA0sbcF7trTodrZ7JohyjWBdjYIsyMWM6K4nwFwOkX+7GJugbzAJ7UmbL2gJZkKmZ
         MN+aOw2g63N9iEQ1GtIavpxnvg5lKnkkIzheJ7NsR6RadHolnMC1QTlV3cR3WgxxK9H6
         uMFI13TveI4r1fvxhYRjjT/efU/GfOS6IQhpjG06QZarKAwjZI5tQpeNpLvejGEl+evi
         raUYBNxxlJTmqqAEngki3yq+z0XRm/iG0uZ75CMQzV9uktuGdYXV9V3/wRfeiBguAXMJ
         tlVeeu/Wnw02/1TzZgP9RMeLhMFwlrBczYnOLQUlPniQZpGLtE8G9MNncn4SyN7FOdxL
         gkdQ==
X-Gm-Message-State: APjAAAW8CP07g9pMgcrHxZLcugzcpk2YvM2wbjlbExAg23X4MpmSEevJ
        q0MFZpiC95K8uadB8R1WqU/mAQ==
X-Google-Smtp-Source: APXvYqzUIiSDxzC9sMSlK0uERGT2OaXsOObyUMqZGbyT1xJTSaDjErh3SKgv1hWBPGWSzzFO4YeXig==
X-Received: by 2002:a7b:c4cf:: with SMTP id g15mr7453778wmk.122.1570718497368;
        Thu, 10 Oct 2019 07:41:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y18sm11027830wro.36.2019.10.10.07.41.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 07:41:36 -0700 (PDT)
Message-ID: <5d9f4320.1c69fb81.dd898.69fb@mx.google.com>
Date:   Thu, 10 Oct 2019 07:41:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.78-115-g4d84b0bb68d4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/114] 4.19.79-stable review
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

stable-rc/linux-4.19.y boot: 117 boots: 0 failed, 107 passed with 10 offlin=
e (v4.19.78-115-g4d84b0bb68d4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.78-115-g4d84b0bb68d4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.78-115-g4d84b0bb68d4/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.78-115-g4d84b0bb68d4
Git Commit: 4d84b0bb68d49edd179af2b16d4b912c1568a182
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 22 SoC families, 16 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
