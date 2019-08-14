Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE998E128
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 01:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfHNXQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 19:16:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42663 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfHNXQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 19:16:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so624791wrq.9
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 16:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=YcOnCRhvASOCE8YHTM3+3xNRALgdjiXsHUDG2PLCBIc=;
        b=MBXOG5zR0vSOnBQd8KhlfxhuDJRdNNhNdQuxq4VR47SeVIK8plGbloHybugYfeC6sW
         sZ0plL2KJc/gBchjIqetxtk59qRutv9NdsPsBxckBXtXuyJTc7lGPAt0wKglFcer9bhw
         NQtp0espcSecKhuE6zHv6HhiIrBVJhz7gmgzPph5RBbR3M4Z9i7zGCJLvwO53uFz0Xxs
         IJEXvQbv607P1qJttaD65eeJcr9msCbGwIPEmcizpWyH7rnrCSdcJ5sP9enTpJeFUTu2
         Y8BVG0Q5xmg1voqbgmm+KSwbTQBEny9txbcUnzZPbCM6cish6GylB4ehi7Ly3DRcYB12
         eNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=YcOnCRhvASOCE8YHTM3+3xNRALgdjiXsHUDG2PLCBIc=;
        b=oGKBIVw87TvOsiZx410cH7btDQgLxGM4MyO9fAU81ySlgIttplzPGOUQKPmDd63fUQ
         Sg+A+bUXQO/VrEgLnvvJkbEDavVjZjZq1eofuwHYAvUE+kK6N7pkSfaG5q4L++/ukq52
         b1o0pRsy8p0x+ABJscxRrYgVQ9Dzsio9dnfkUt6t6LrHrtN0bI7XI9gHWg6LYi0kU7Z8
         QHOvCpsO2Qc2hdLVsk9OJu0WRc4HG7drOF04/PBjqKRv5QgShtXoMgmA8+z32uIElXs5
         55KSNyQVBHPRQBofhifc58KWEP40SsklckvzlZSYTK/RM2zFO6+p4jokxBVeIiQUcXeS
         Btig==
X-Gm-Message-State: APjAAAVjOsr8tO069jGsnMXqyHUGmDMBtgtlGO/HS5Ny2g0AV1glN0Xk
        LBumjhGP+thrHDtdmbWL1Uq1uw==
X-Google-Smtp-Source: APXvYqxGRi9k5bfRHmF+C8w3CIbOc1lfBEBImYS+ceILTAduPDTNYG8oNogTwAyMuUN1kV1rf2s9Ww==
X-Received: by 2002:adf:f507:: with SMTP id q7mr1937660wro.210.1565824578258;
        Wed, 14 Aug 2019 16:16:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 39sm3070962wrc.45.2019.08.14.16.16.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 16:16:17 -0700 (PDT)
Message-ID: <5d549641.1c69fb81.a2cd7.0209@mx.google.com>
Date:   Wed, 14 Aug 2019 16:16:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-145-g2440e485aeda
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
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

stable-rc/linux-5.2.y boot: 134 boots: 1 failed, 119 passed with 12 offline=
, 2 untried/unknown (v5.2.8-145-g2440e485aeda)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-145-g2440e485aeda/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-145-g2440e485aeda/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-145-g2440e485aeda
Git Commit: 2440e485aeda5f36eaf2050eb1bb61be46275b39
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 27 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v5.2.8)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v5.2.8)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
