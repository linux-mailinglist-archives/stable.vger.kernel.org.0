Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB1E9A20C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390389AbfHVVRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 17:17:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41775 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393056AbfHVVRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 17:17:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so6697586wrr.8
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Tl2/TXQtNTaDtW4k+V57ocrASJdTn6tXhvANUGDEdBM=;
        b=1/EL71Nzdr7CPWYHp5TJvWRgtsLBn9Jhk9xQuQZplwCVD4w/RjeAJxW3gRtwawX8lA
         ti8FWE876MSyvYOObO/UX7ntxoBnAIOD8WI/vdENAQkP8hBYjmLsBi29HTs12PeVpCWO
         uCG5uAkz5cHEb0OyYU/VQgwjwHRJwDZ4nZhQJUXJu2snibuaJLLKGFHdr2im/tAvdCl6
         EFJVNcSKMTzKQFJX6CrlZzMFjxHPm1RzMKntKC7WManksFXWnh344Q+rWkDgtLAPXRML
         uZwHH22TTkZAzVvI1pjvtH8Jzc8XzPHXKPNCp4MPRuVoCl2afS1mCoguBdE23uq4e3XS
         JOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Tl2/TXQtNTaDtW4k+V57ocrASJdTn6tXhvANUGDEdBM=;
        b=jTPdjRLzzNN+1e8brPU+mehghSTPxWRdj8l6yeDvg0kfHcVumfWz46CuX2ggDtaKWA
         0v3G0tTv3sHXA1hwXE9V2fweYLSNMp9E19YH8+b46GRngV/1NuVXsgBQHZI+yazjPKij
         MZnZAX068gNoKfhM5vvqgSYaz/zt+wlZz2lHEn8J1f/DAvTzIlHiDnegUpJTOl53JEHg
         wb3cvftjcwf2WObfkxyBFVPndsHnlCGbxxEpeK8CuQttheaGKWvz1joDTah/4poBzh+/
         /GLOUY5ihqnFnhqBmkgBzARxAUun9q0ZINNTbicATANCyxR62lLXM2UGTxAQ3Hj5LoK3
         3Xaw==
X-Gm-Message-State: APjAAAUG+Zez18+QM5WyB3xyPw2SfoeePkOBwZaRX6Bzxhg463ulQlXh
        b9qqCL8zCgnQG+s+ebaSb2RxWQ==
X-Google-Smtp-Source: APXvYqzbp/w9DH1HMrxDMdA6/XhvSCB1VYw/VefNMkOP+Oyk88+U/gMDKQw/27oxJlbS908c4i2CdA==
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr987753wro.215.1566508622524;
        Thu, 22 Aug 2019 14:17:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm1745503wre.44.2019.08.22.14.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 14:17:01 -0700 (PDT)
Message-ID: <5d5f064d.1c69fb81.ab35c.8cfd@mx.google.com>
Date:   Thu, 22 Aug 2019 14:17:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139-72-g6c641edcbe64
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/71] 4.14.140-stable review
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

stable-rc/linux-4.14.y boot: 124 boots: 2 failed, 106 passed with 16 offlin=
e (v4.14.139-72-g6c641edcbe64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.139-72-g6c641edcbe64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.139-72-g6c641edcbe64/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.139-72-g6c641edcbe64
Git Commit: 6c641edcbe649a2aa866356ffd24f595edb17bea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.14.139-62-g3=
f2d1f5446a4)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.14.139-62-g3=
f2d1f5446a4)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
