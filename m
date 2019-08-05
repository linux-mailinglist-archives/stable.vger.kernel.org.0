Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BEA8240F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfHERfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:35:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40484 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHERfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 13:35:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so73831802wmj.5
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 10:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=voIGteRKzC/qSuQGdpeb7TWmnO42XbJGR9gOLDIKzNg=;
        b=D0/nb0ynp0+/NN/I31H2GkdmcTcSLMkZuFcSQE0HqexTJkfxbM0I1Ils5kaRDo7tiP
         Drr1zsaeA6rcO71KQtE97knYSx8gUpS3s/3GoH30zQl+6sZtnjRRYsRacygHOVI+SxtY
         vse6ZeQhrh+CxUtOsItv5XOgbXkUxPbkVCUyUFtQf3U8XOxlnwZ6Bp909jZF7Kslm7c/
         vxEZf09KzU0oNRsTOOtufFG1eCvagJPnrw3QnTbO+a5hnIxm3IMD8r+sMn8McZxntCLh
         zqFrtiiQa3c7iO48VElFeapRmqG0ElwPJLt2LDIXSWSzsAFLogj2wB3IYaiiZcntMD6q
         qa4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=voIGteRKzC/qSuQGdpeb7TWmnO42XbJGR9gOLDIKzNg=;
        b=B8tdwHKdbL3pzDE2grZm7iiawuQFNeiYDHMB5/fyvmZ+z/5vFLAEs8mjUGbXfWBnRo
         PcMHZHShNjGyUiz0wbm+Ip2gmSLQFI4GaEMv9soA0SuXfyh2yFp/KwWaQNbnsGLyKnAu
         ziBFlmf21IJ7y38Xybi1BN42H5vW3rx2FSyOdXjkJQ+1KHxsRaELOG69GqBQ6fWRCncV
         XtJHIUdKCKPnmXElBRAokOwmhMYMVfhOv0kdGH9pcm6OMXzesx3mzZ6g0KsImllMN5eN
         HxLarQBuPcbySYA/QhucjGUhrdqyOZG5LXgY6zfoGZ+iqStjHQVg1RDkUBJ/N0plEqOP
         kBzg==
X-Gm-Message-State: APjAAAXA3zQnLzMltPcdUGF9np6qI4l+zjnBcFwu+YjkUlpE+W3My8A2
        w3rfyeRg66I6c3R2gJ1Yy9I=
X-Google-Smtp-Source: APXvYqxODCJB13Jawwu8Mg5f2yTFS25pDZ23H3dWl07Uw97SQr/4vepa5Q7IoGpVnOMZk6ZwTgg/Bw==
X-Received: by 2002:a1c:d185:: with SMTP id i127mr20260159wmg.63.1565026518788;
        Mon, 05 Aug 2019 10:35:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x24sm81228244wmh.5.2019.08.05.10.35.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:35:18 -0700 (PDT)
Message-ID: <5d4868d6.1c69fb81.684ee.334f@mx.google.com>
Date:   Mon, 05 Aug 2019 10:35:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.187-23-gb9a28e18ca89
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
References: <20190805124918.070468681@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/22] 4.4.188-stable review
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

stable-rc/linux-4.4.y boot: 93 boots: 1 failed, 54 passed with 38 offline (=
v4.4.187-23-gb9a28e18ca89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.187-23-gb9a28e18ca89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.187-23-gb9a28e18ca89/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.187-23-gb9a28e18ca89
Git Commit: b9a28e18ca89602f69c795d8e0438f59d92cbf7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
6-157-gd9815060e3ec - first fail: v4.4.187)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
6-157-gd9815060e3ec - first fail: v4.4.187)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
6-157-gd9815060e3ec - first fail: v4.4.187)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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
            bcm4708-smartrg-sr400ac: 1 offline lab
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
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
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
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
