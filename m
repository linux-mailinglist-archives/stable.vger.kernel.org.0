Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EBA9A208
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 23:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389823AbfHVVRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 17:17:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36048 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390389AbfHVVRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 17:17:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so6716783wrt.3
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 14:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=f9ICOaMhf+P4t1loD+/kpbQ/JtjZEmiIQ2pu2dEnJS0=;
        b=kzbhCWnyqzAcD+gNk6AZnNVqEWg1hHzW1+Qc34y2gbhPdm6IVzRz0KtnPMyaV+YsKx
         lwWIUeruS4SDR9ybB071zTmHSs1wQ43DU2nk/RUJePvCk47k1WP8wCZvr4VKHkLPB6qO
         BsJgksDcX4DYEzFl/gZxC6l3DWh4MkZnGS6/Os6BkCjEbbnkPqjzfO25hUCNH+5D3t4I
         rxcHUQFETBZSoWPpy/bzjnPXsYjK1dbZKiofy6snyImnyOs4brq+0zXjw8cYQ8V5Ytnr
         FkQXXW4uJEsTjcPJbTEllANzfjtG2vesF46FCHm20M4V6moeQFFvfZvQWdlfU2Yb17SN
         /O0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=f9ICOaMhf+P4t1loD+/kpbQ/JtjZEmiIQ2pu2dEnJS0=;
        b=oCZIPnu/S91X8tytQsfFPIcRBL2HiOo7GF6eRMpnE2bSxDrnWwR0i3SDlDshV9sfJ3
         ygPaChcNboX0hHURzu2cVlcfQHsmtJLG5jnmLpEk4u+rXBC4ODG2M0my+HonNRYwOx+d
         WqY2cUOHjjcYh3z9uHWvyO8uLgVDsr4oJ2BONKvfUmm8d+eMysUklsHRHS21xh301wr/
         y0FIfdRDnbiNO2loC1SoCIAQsv7IljlPaq8nqlhXH78cm1NuH6LnvX7zg7gdiuIDO5V4
         DmGJ83uBTMNqnUzR12k81iZDawSa99qofCmoBXTZTwlQtcW7WdjG3vkxvDpKoD3Hm4y2
         /yGg==
X-Gm-Message-State: APjAAAWaI2ox2FncP1nT6vU5iUdCQF3H06FLSft05SnpFWB1KKdEmDTG
        1fxOOg+5xFNiFzrp0/9VV28Qvw==
X-Google-Smtp-Source: APXvYqydMJiO4jzTgJknfGy2vbRU54hClz3sUzY1YfNZOs0Ulf3wSdiriec7mAKxnPwFIRdfC9Dzow==
X-Received: by 2002:a5d:66c5:: with SMTP id k5mr1025506wrw.304.1566508621282;
        Thu, 22 Aug 2019 14:17:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u130sm1401577wmg.28.2019.08.22.14.16.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 14:17:00 -0700 (PDT)
Message-ID: <5d5f064c.1c69fb81.e96ef.73f5@mx.google.com>
Date:   Thu, 22 Aug 2019 14:17:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-79-gf18b2d12bf91
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
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

stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 84 passed with 12 offline,=
 2 untried/unknown, 1 conflict (v4.4.189-79-gf18b2d12bf91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-79-gf18b2d12bf91/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-79-gf18b2d12bf91/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-79-gf18b2d12bf91
Git Commit: f18b2d12bf9162bef0b051e6300b389a674f68e1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

    multi_v7_defconfig:
        gcc-8:
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.4.189-80-gae3cc2f8a=
3ef)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
