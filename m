Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690437FDD9
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387653AbfHBPzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:55:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40849 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733006AbfHBPzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:55:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so77652602wrl.7
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 08:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Lv7QFpyym32Y81fdJu6NtFzt1x5OEGeU7A8SCvtyPV8=;
        b=2FFXm8I4VD5uaQN81j1OMi5u0WnGE8PTuWf5JAiJObC4EnSBHuad/ez/QFFa5Z7hew
         oizk+WxcDAsLURnD91ZgNQagiecbUR6WuLoE0vQFtm61XYyGVMMnELNCP8InkBB7aH0/
         CYAOPOj2Gpz8oLI3BmjPaVSddfAKRxDhSwKzQkLaQXoBFh+4lAh68IKv03Pw/CRFnI6O
         lpT3W+WFGYwT5juPs2JuNFYRnAPY5B4XHzktaZif3RU/eDiDL45QllhH28hIPhR7s4dm
         jKH2la6XA6Nzri3ablBBzf/ew5YDdErYimQ6FAgpmBk8Ge13jaXWu6sykmtPQgxRcB7D
         XcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Lv7QFpyym32Y81fdJu6NtFzt1x5OEGeU7A8SCvtyPV8=;
        b=KkiNZY/ciTj17xvycL+YBHdTuw73jlfVOEa3VWlc7UcieBULduFK/FQNOTpcXkoBid
         ZHp28o0W/MOVGA4eL/xvXYJKnTjw4BtLrHd38xHI3Ql8/01t3rDRyvv+x+ru844+64H1
         zlOWNGU+GANsuOBZXzuyKmXYSddWHBwXJBnlRy3EAJBNwm05x3dv50UQhIe+mwg+nll7
         b4xLHVXamdydprDrV/Ferta1jci1Byv3rHU4OUqVfytJQ5iHxsYl0OjTdP5jUP8J8Aao
         HXr4/HbfXFpC48D0ykHrDFI7Q8+J87C8/fkMFcP3buV3d/Z+hn+H20YVHMlZnaa1rQEn
         9n6A==
X-Gm-Message-State: APjAAAWy7iLlIw1sipTfOmHjbUsRfHV/qiL/aetRSIX7aP9nYhu6GMXZ
        5MEBKSSplb2s93b1cykVLBY=
X-Google-Smtp-Source: APXvYqylL0rKZCAV/G/jL13mt//zVAvsHbc1xM+R450FX7x1CBo+F3awrZdbYcjPVPsJaUHEm8HCkQ==
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr55392866wrn.37.1564761298369;
        Fri, 02 Aug 2019 08:54:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x11sm53685384wmi.26.2019.08.02.08.54.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:54:57 -0700 (PDT)
Message-ID: <5d445cd1.1c69fb81.714e6.c928@mx.google.com>
Date:   Fri, 02 Aug 2019 08:54:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-159-gc4286991ea44
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
Subject: Re: [PATCH 4.4 000/158] 4.4.187-stable review
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

stable-rc/linux-4.4.y boot: 92 boots: 1 failed, 59 passed with 32 offline (=
v4.4.186-159-gc4286991ea44)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-159-gc4286991ea44/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-159-gc4286991ea44/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-159-gc4286991ea44
Git Commit: c4286991ea44309c9b2dcf717fd7d04270809eae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm72521-bcm97252sffe: 1 offline lab
            bcm7445-bcm97445c: 1 offline lab
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
