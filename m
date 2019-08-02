Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB807FEA6
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 18:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbfHBQfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 12:35:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41823 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730196AbfHBQfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 12:35:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so74591879wrm.8
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 09:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=8jC0z1URQ1H0xyCXJDkfPMve8cjcGKBfDhT0uA7E2TE=;
        b=NNFWM0oiXe3g6Tvx832q3/DBNG02GtBddw+kxX1llCJb6LxKU1n/Z12IJayyJmwQh+
         ioSvXI2JhwCCpA+Bac8E8FCRPFVXcM2ynwZt3JBpWummRyWWVxNcD/kPgWBuT08TI2uR
         37bP/6Kwn/b/ZawR10nz2Q/4B35trsqTn/YvPDYJPq5iWXyPsXkmk/iBKAzttuT8JtJl
         PbAV96hUimt9te6/4ZgsVl9enJolBKcBVsURes7sQCsGB0BVwAi0180ZKO1bb2PHVysr
         8r/gjoUrp0RgADrvQVTHWstLp94XuCRCRAghBCeRIwRj7+m2Cfdft/Lh4cfp2g+zFf+J
         JVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=8jC0z1URQ1H0xyCXJDkfPMve8cjcGKBfDhT0uA7E2TE=;
        b=MZ9Xg0NdjqQVkhry0EZQa09PvkYZVvl0feSbuHv3FnTfE+KrrLbRp/CdhdzvSsejFF
         so0FlykmyysOpjSlvuapjdxc7pWF26GUYiifxG63bB4fkmZE5TNBnHjBqkgxyXGHzB8l
         AEbiB6iIeBDEvYJXY9SEjphlrlWQ2xqkcs3XKqDg/BRqxx+RGVr5pIg6mYxohbwAS3pM
         r25ZbgS3p4IwanRFojH1o6qgtsE0Y5ULBDRIcZzshYTXApfBAMZnQd0Nj/vCge6UGNeg
         blO+9bNQzw4EJmVAR50MkwU6tfXqOocLNV42U/H9BQiu+26yRpt0Jn21pfH8JXR1rpmw
         eaUw==
X-Gm-Message-State: APjAAAV8XqnuIhaVFJWhYqZTsF2aNoSYGQlYJu1jVePoAL6flpk+eC6D
        UT+0pEiNeqtR0NGMwK60Y04=
X-Google-Smtp-Source: APXvYqyWWjzH2TRcQ0z7dDiznv1D2CaqThzDnGFdT7KCn0cU0KREvikpfdYkHrnSYM1MoarafBqWjw==
X-Received: by 2002:adf:b195:: with SMTP id q21mr3999407wra.2.1564763698721;
        Fri, 02 Aug 2019 09:34:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j10sm134938738wrd.26.2019.08.02.09.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 09:34:58 -0700 (PDT)
Message-ID: <5d446632.1c69fb81.e9bbc.28ff@mx.google.com>
Date:   Fri, 02 Aug 2019 09:34:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.186-224-g5380ded2525d
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
Subject: Re: [PATCH 4.9 000/223] 4.9.187-stable review
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

stable-rc/linux-4.9.y boot: 101 boots: 0 failed, 66 passed with 35 offline =
(v4.9.186-224-g5380ded2525d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-224-g5380ded2525d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-224-g5380ded2525d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-224-g5380ded2525d
Git Commit: 5380ded2525da1be5103e3f0f33129dcbffa3add
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

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
            imx7s-warp: 1 offline lab
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
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
