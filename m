Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA246F5C96
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 01:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfKIA5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 19:57:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53736 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfKIA5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 19:57:54 -0500
Received: by mail-wm1-f67.google.com with SMTP id u18so259731wmc.3
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 16:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=HbWqXty6cqaMv/LTlNURbDS2LNWnKiEuBM4m7cwJBAg=;
        b=SyCVq7X9ieCdrPryVtlnFYXexpfacg+gw3W/PADRgLVOJrGIY4nCVsjTqE9QpkODhy
         NJHZXn0rc9WA/cgmsxxDVSsLfLTV7deM1iCLvCYmaF6CxPkOUb4KIPotXLe5sVlpifDl
         r2Nx1qYp7Yn2pkW6zC5Jcabgsg+j1kaJDE/G5ezZBxSqebVoAhQ3YhinSTcbVX13Zkac
         M3KOwEA5/Z77eui02usZuZ5B/CnAx2ArFTQ/3sl42YTCvlQtz+14I/PdFLOMEeY49tzJ
         MN1NMZW6rpa5ojvJr13dTWIebLY6ejmlVUMitW9N6c5TKYtrx5EatwV/4bmlgAGU5LPo
         4RSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=HbWqXty6cqaMv/LTlNURbDS2LNWnKiEuBM4m7cwJBAg=;
        b=LOUYWBZOnxa7Pi3mQontT3P0KzCF7r2LSMUI99WTephS9j1OCIUcJZ0RNwWU2DLWwb
         UG9Px6HiagYIpAo0r/ZljULjthwkuk5Qou03uIMi8PLkkMZ9HxxHtihID0xoIN/F8VVp
         LuEf7kUWpuRdH8YaDKWV/318r4C5u2fK0MBz+wZUYzbYzPVjm//11dVTYZLTAGCLGoRX
         ckuLbMjl2sd2N4DtFNYW7r7aiNxqoHoIcIBSsFWy2o2HzdOVu3w5LCvjJhiRctWubRwq
         eHsgU0zeTiHGesdXvTexriUmZWB2ju0x5f7gSKy1ZtRUcwmwnOhRysMbcCG/Tvt8gKiW
         eTjQ==
X-Gm-Message-State: APjAAAXy/xx3dKBK8D2OO27NV0MaNxhTHG2wCA8VR0Vu12mZVEazrBl3
        6W+zNxK3aGDUxJ7okiM2fpD37A==
X-Google-Smtp-Source: APXvYqz0n9giLMoXtTtDedUDpoufMk2XRurLwAdoFDhRH5zOSF8pIBLi4A3Vw32Hg6pi4yerB8y7fQ==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr9964280wmc.49.1573261071890;
        Fri, 08 Nov 2019 16:57:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a6sm89530wrh.69.2019.11.08.16.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 16:57:51 -0800 (PST)
Message-ID: <5dc60f0f.1c69fb81.58bde.04c0@mx.google.com>
Date:   Fri, 08 Nov 2019 16:57:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.199-35-ge0ad85ece397
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/34] 4.9.200-stable review
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

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.199-35-ge0ad85ece397)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.199-35-ge0ad85ece397/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.199-35-ge0ad85ece397/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.199-35-ge0ad85ece397
Git Commit: e0ad85ece3979aa8efb65ef7e22c924cd63dc859
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 20 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
